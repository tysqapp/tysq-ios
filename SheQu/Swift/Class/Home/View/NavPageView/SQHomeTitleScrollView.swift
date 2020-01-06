//
//  SQHomeTitleScrollView.swift
//  SheQu
//
//  Created by gm on 2019/6/25.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
typealias Level1SelCallBack = (_ selIndex: Int, _ infoModel: [SQHomeCategorySubInfo]) -> ()

class SQHomeTitleScrollView: UIScrollView {
    static let viewH: CGFloat = 30
    private static let textSelColor = k_color_black
    private static let labelSelFont = UIFont.systemFont(ofSize: 18, weight: .heavy)
    private static let textColor = k_color_title_gray_blue
    private static let labelFont = k_font_title_weight
    
    var selIndex = 0
    var isFirst  = true
    var callBack: Level1SelCallBack?
    var infoModel: SQArticleInfoModel!
    
    lazy var viwwW = k_screen_width - 120
    lazy var centerX: CGFloat = viwwW * 0.5
    lazy var selBtn = UIButton()
    
    var titleArray: [SQHomeCategoryInfo]? {
        
        didSet{
            weak var weakSelf = self
            let selId = UserDefaults.standard.integer(forKey: k_ud_Level1_sel_key)
            selIndex  = titleArray!.firstIndex(where: { (model) -> Bool in
                return model.id == selId
            }) ?? 0
            if weakSelf!.callBack != nil {
                if weakSelf!.selIndex >= titleArray!.count {
                    weakSelf!.selIndex = 0
                    UserDefaults.standard.set(-1, forKey: k_ud_Level1_sel_key)
                    UserDefaults.standard.synchronize()
                }
                weakSelf!.callBack!(weakSelf!.selIndex, titleArray![weakSelf!.selIndex].subcategories)
            }
            
            
            
            var btnTemp = UIButton()
            let btnH: CGFloat = 20
            let btnY: CGFloat = (30 - btnH) * 0.5
            for index in 0..<titleArray!.count {
                let model = titleArray![index]
                let btn = UIButton()
                btn.setTitle(model.name, for: .normal)
                btn.setTitleColor(SQHomeTitleScrollView.textColor, for: .normal)
                let btnX = btnTemp.maxX()
                let btnW = model.name.calcuateLabSizeWidth(font: SQHomeTitleScrollView.labelSelFont, maxHeight: btnH) + 10
                btn.tag   = index + 1
                btn.setTitle(model.name, for: .normal)
                if index == selIndex {
                    selBtn = btn
                    btn.setTitleColor(
                        SQHomeTitleScrollView.textSelColor,
                        for: .normal)
                    btn.titleLabel?.font = SQHomeTitleScrollView.labelSelFont
                }else{
                    btn.setTitleColor(SQHomeTitleScrollView.textColor, for: .normal)
                    btn.titleLabel?.font = SQHomeTitleScrollView.labelFont
                }
                
                btn.frame = CGRect.init(x: btnX, y: btnY, width: btnW, height: btnH)
                btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
                btnTemp   = btn
                addSubview(btn)
            }
            
            contentSize = CGSize.init(width: btnTemp.maxX(), height: btnH)
           scrollToCenterX()
        }
    }
    
    
    @objc func btnClick(btn: UIButton) {
        updateSelBtn(btn: btn)
        selIndex = btn.tag - 1
        selBtn   = btn
        cacheSelIndex()
        scrollToCenterX()
        if callBack != nil {
            callBack!(selIndex, titleArray![selIndex].subcategories)
        }
    }
    
    func scrollToCenterX() {
        if selBtn.centerX() <  centerX{ //如果是在左边
            setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }else{//如果在右边
            setContentOffset(CGPoint.init(x: selBtn.centerX() - centerX(), y: 0), animated: true)
        }
    }
    
   private func updateSelBtn(btn: UIButton) {
        selBtn.setTitleColor(SQHomeTitleScrollView.textColor, for: .normal)
        selBtn.titleLabel?.font = SQHomeTitleScrollView.labelFont
        
        btn.setTitleColor(SQHomeTitleScrollView.textSelColor, for: .normal)
        btn.titleLabel?.font = SQHomeTitleScrollView.labelSelFont
        selBtn   = btn
    }
    /// 跳转到指定的item
    ///
    /// - Parameter row: 需要跳转到的item
    func scrollToIndex(_ id: Int) {
        
        selIndex = titleArray!.firstIndex(where: { $0.id == id}) ?? 0
        guard let btn: UIButton = viewWithTag(selIndex + 1) as? UIButton else {
            return
        }
        
        updateSelBtn(btn: btn)
        scrollToCenterX()
        cacheSelIndex()
        if callBack != nil {
            callBack!(selIndex, titleArray![selIndex].subcategories)
        }
    }
    
    func cacheSelIndex() {
        let itemModel = titleArray![selIndex]
        UserDefaults.standard.set(itemModel.id, forKey: k_ud_Level1_sel_key)
        UserDefaults.standard.synchronize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSize(size: CGSize.init(width: viwwW, height: 30))
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator   = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
