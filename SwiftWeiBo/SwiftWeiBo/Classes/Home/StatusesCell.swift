//
//  StatusesCell.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/4/18.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit
import SDWebImage

class StatusesCell: UITableViewCell {
    
    var statuses : Statuses?
        {
        didSet{
            context.text = statuses?.text
            name.text = statuses?.user?.name
            iconImageView.sd_setImageWithURL(statuses?.user?.avatarURL)
            userType.image = statuses?.user?.verifiedImage
            sourceFrom.text = statuses?.source
            date.text = statuses?.created_at
            mbrankImageView.image = statuses?.user?.mbrankImage
        }
    }
    
    func setupUI(){
        
        iconImageView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(10)
        }
        
        userType.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.bottom.equalTo(iconImageView.snp_bottom).offset(5)
            make.right.equalTo(iconImageView.snp_right).offset(5)
        }
        
        name.snp_makeConstraints { (make) -> Void in
            //make.width.equalTo(100)
            make.left.equalTo(iconImageView.snp_right).offset(10)
            make.top.equalTo(iconImageView)
            
        }
        
        mbrankImageView.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(name.snp_right).offset(10)
            make.top.equalTo(name)
            
        }
        
        
        date.snp_makeConstraints { (make) -> Void in
            //make.width.equalTo(100)
            make.left.equalTo(iconImageView.snp_right).offset(10)
            make.top.equalTo(name.snp_bottom).offset(5)
            
        }
        
        sourceFrom.snp_makeConstraints { (make) -> Void in
           // make.width.equalTo(100)
            make.left.equalTo(date.snp_right).offset(10)
            make.top.equalTo(date)
            
        }
        
        context.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(iconImageView.snp_bottom).offset(10)
            make.left.equalTo(iconImageView)
            make.right.equalTo(contentView).offset(-15)
            //make.bottom.equalTo(contentView.snp_bottom).offset(-10)
        }
        
        bottomView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(contentView)
            make.left.equalTo(contentView)
            make.top.equalTo(context.snp_bottom).offset(10)
            make.height.equalTo(35)
            make.bottom.equalTo(contentView.snp_bottom).offset(-10)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(iconImageView)
        contentView.addSubview(userType)
        contentView.addSubview(name)
        contentView.addSubview(date)
        contentView.addSubview(sourceFrom)
        contentView.addSubview(context)
        contentView.addSubview(bottomView)
        contentView.addSubview(mbrankImageView)
        //bottomView.backgroundColor = UIColor.grayColor()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    ///MARK: - LAZY LOADING
    lazy var iconImageView : UIImageView = UIImageView()
    lazy var userType : UIImageView = UIImageView()
    
    lazy var name : UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        return label
    }()
    
    lazy var context : UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var sourceFrom : UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 13)
        return label
    }()
    
    lazy var date : UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 13)
        return label
    }()
    
    lazy var bottomView : statusBottomView = statusBottomView()
    lazy var mbrankImageView : UIImageView = UIImageView()

}

class statusBottomView: UIView {
    
    func setupUI(){
    
        commentBtn?.snp_makeConstraints(closure: { (make) -> Void in
            make.width.equalTo(self.snp_width).dividedBy(3)
            make.height.equalTo(self)
            make.left.equalTo(self)
            make.top.equalTo(self)
        })
        
        retweetBtn?.snp_makeConstraints(closure: { (make) -> Void in
            make.width.equalTo(commentBtn!)
            make.height.equalTo(self)
            make.left.equalTo(commentBtn!.snp_right)
            make.top.equalTo(self)
        })
        unlikeBtn?.snp_makeConstraints(closure: { (make) -> Void in
            make.width.lessThanOrEqualTo(retweetBtn!)
            make.height.equalTo(self)
            make.left.equalTo(retweetBtn!.snp_right)
            make.right.equalTo(self)
            make.top.equalTo(self)
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(commentBtn!)
        addSubview(retweetBtn!)
        addSubview(unlikeBtn!)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var commentBtn : UIButton? = {
        let btn = UIButton.createButton("timeline_icon_comment",title:"评论")
        return btn
    }()
    
    lazy var retweetBtn : UIButton? = {
        let btn = UIButton.createButton("timeline_icon_retweet",title:"转发")
        return btn
    }()
    
    lazy var unlikeBtn : UIButton? = {
        let btn = UIButton.createButton("timeline_icon_unlike",title:"赞")
        return btn
    }()
    
    
}
