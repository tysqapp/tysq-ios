//
//  SQBannedComentsCell
//  SheQu
//
//  Created by iMac on 2019/9/3.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit
import SnapKit


class SQForbinCommentListCell: UITableViewCell {
    
    
    var title:String? // 标题
    
    lazy var tags = [String]()//标签数组
    
    var btnClick:  (()-> ())? //修改按钮回调
    
    static let cellID = "SQForbinCommentListCellID"
    
    lazy var titleLabel:UILabel = {
       let label = UILabel()
       label.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
       return label
    }()
    
    lazy var noCommonLabel:UILabel = {
        let label = UILabel()
        label.text = "禁止在以下模块评论"
        label.font = k_font_title
        return label
    }()
    
    lazy var btnEdit:UIButton = {
        let btn = UIButton()
        btn.setTitle("修改", for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.backgroundColor = UIColor.init(red: 89/255, green: 140/255, blue: 241/255, alpha: 1)
        btn.layer.cornerRadius = 10
        btn.tag = -1
        btn.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var tagsView: SQTagsView = {
        let tagsView = SQTagsView()
        tagsView.btnH = 30
        tagsView.tagCornerRadius = 5
        tagsView.btnHMargin = 15
        tagsView.tagFontSize = 14
        return tagsView
        
    }()
    
    @objc func buttonClick(){
        if(btnClick != nil){
             btnClick!()
        }
    }
    
    
    lazy var gapView:UIView = {
        let view = UIView()
        view.backgroundColor = k_color_bg_gray
        return view
        
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(noCommonLabel)
        addSubview(btnEdit)
        addSubview(tagsView)
        addSubview(gapView)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {

    }
    
    func setTitle(title:String) {
        self.titleLabel.text = title
    }
    
    func setupLayout() {
      
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(15)
            make.top.equalTo(self.snp.top).offset(15)
            make.height.equalTo(30)
        }
        
        noCommonLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.top)
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        btnEdit.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalTo(self.snp.right).offset(-20)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        
        tagsView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.bottom.equalTo(gapView.snp.top)
        }
        
        
        gapView.snp.makeConstraints { (make) in
            make.height.equalTo(10)
            make.bottom.equalTo(self.snp.bottom)
            make.left.right.equalTo(self)
        }
        
      
    }
    

}
