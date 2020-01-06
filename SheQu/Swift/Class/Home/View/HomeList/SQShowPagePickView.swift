//
//  SQShowPagePickView.swift
//  SheQu
//
//  Created by gm on 2019/10/14.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    static let aniDuration: CGFloat = 0.4
}

class SQShowPagePickView: UIView {
    
    static let contentViewH: CGFloat = 300
    
    private lazy var pageCount = 1
    private lazy var selPageCount = 1
    
    private var callback:((Int) -> ())?
    
    
    static let sharedInstance: SQShowPagePickView = {
        let instance = SQShowPagePickView.init(frame: UIScreen.main.bounds)
        return instance
    }()
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = UIColor.black
        coverView.alpha = 0.5
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(cancelBtnClick))
        coverView.addGestureRecognizer(tap)
        return coverView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor.white
        return contentView
    }()
    
    lazy var finishBtn: UIButton = {
        let finishBtn = UIButton()
        finishBtn.setTitle("完成", for: .normal)
        finishBtn.setTitleColor(k_color_normal_blue, for: .normal)
        finishBtn.titleLabel?.font = k_font_title_16_weight
        finishBtn.contentHorizontalAlignment = .right
        finishBtn.addTarget(self, action: #selector(finishBtnClick), for: .touchUpInside)
        return finishBtn
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(k_color_normal_blue, for: .normal)
        cancelBtn.titleLabel?.font = k_font_title_16_weight
        cancelBtn.contentHorizontalAlignment = .left
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        return cancelBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line_light
        return lineView
    }()
    
    lazy var pickView: UIPickerView = {
        let pickView = UIPickerView()
        pickView.delegate = self
        pickView.dataSource = self
        return pickView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverView)
        addSubview(contentView)
        contentView.addSubview(cancelBtn)
        contentView.addSubview(finishBtn)
        contentView.addSubview(lineView)
        contentView.addSubview(pickView)
        addLayout()
        layoutIfNeeded()
    }
    
    private func addLayout() {
        coverView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.bottom.equalTo(snp.bottom)
            maker.top.equalTo(snp.top)
        }
        
        contentView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(snp.bottom)
                .offset(SQShowPagePickView.contentViewH)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(SQShowPagePickView.contentViewH)
        }
        
        lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentView.snp.left)
            maker.right.equalTo(contentView.snp.right)
            maker.height.equalTo(k_line_height)
            maker.top.equalTo(contentView.snp.top).offset(49)
        }
        
        cancelBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentView.snp.left).offset(20)
            maker.top.equalTo(contentView.snp.top).offset(14)
            maker.height.equalTo(16)
            maker.width.equalTo(100)
        }
        
        finishBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(contentView.snp.right).offset(-20)
            maker.top.equalTo(contentView.snp.top).offset(14)
            maker.height.equalTo(16)
            maker.width.equalTo(100)
        }
        
        pickView.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentView.snp.left)
            maker.right.equalTo(contentView.snp.right)
            maker.bottom.equalTo(contentView.snp.bottom)
            maker.top.equalTo(lineView.snp.top)
        }
    }
    
    @objc private func cancelBtnClick() {
        hidden()
    }
    
    @objc private func finishBtnClick() {
        if (callback != nil) {
            callback!(selPageCount)
        }
        hidden()
    }
    
    
    
    /// 显示分页选择view
    /// - Parameter selPageCount: 当前选中page
    /// - Parameter pageCount: 总page
    /// - Parameter handler: 返回选中page
    func showPagePickView(_ selPageCount: Int,_ pageCount: Int, handler:@escaping ((Int) -> ())) {
        self.removeFromSuperview()
        UIApplication.shared.keyWindow?.addSubview(self)
        self.selPageCount = selPageCount
        self.pageCount    = pageCount
        self.callback     = handler
        pickView.reloadAllComponents()
        pickView.selectRow(selPageCount - 1, inComponent: 0, animated: false)
        UIView.animate(withDuration: TimeInterval.init(SQItemStruct.aniDuration)) {
            self.contentView.snp.updateConstraints({ (maker) in
                maker.bottom.equalTo(self.snp.bottom)
            })
            self.layoutIfNeeded()
        }
    }
    
    @objc private func hidden() {
        UIView.animate(withDuration: TimeInterval.init(SQItemStruct.aniDuration),
                       animations: {
            self.contentView.snp.updateConstraints({ (maker) in
                maker.bottom.equalTo(self.snp.bottom)
                    .offset(SQShowPagePickView.contentViewH)
            })
            self.layoutIfNeeded()
        }) { (isFinish) in
            if isFinish {
                self.removeFromSuperview()
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension SQShowPagePickView: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pageCount
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "第 \(row + 1) 页"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selPageCount = row + 1
    }
}
