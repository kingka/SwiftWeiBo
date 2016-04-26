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
    
    var widthConstraint : NSLayoutConstraint?
    var heightConstraint : NSLayoutConstraint?
    var statuses : Statuses?
        {
        didSet{
            context.text = statuses?.text
            topView.statuses = statuses
            picView.statuses = statuses
            let caculateSize = picView.calculateSize()
            //picView的总体大小
            widthConstraint?.constant = caculateSize.width
            heightConstraint?.constant = caculateSize.height

        }
    }
    
    func rowHeight(status : Statuses) ->CGFloat{
    
        //为了计算行高
        self.statuses = status
        //刷新 cell
        self.layoutIfNeeded()
        //返回底部最大的Y值
        return CGRectGetMaxY(bottomView.frame)
    }
    
    func setupUI(){
                
        topView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.top.equalTo(contentView)
            make.height.lessThanOrEqualTo(100)
        }
                
        context.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topView.snp_bottom).offset(10)
            make.left.equalTo(topView).offset(10)
            make.right.equalTo(contentView).offset(-15)
            
        }
        
        picView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(context.snp_bottom).offset(10)
            make.left.equalTo(context)
        }
        
        widthConstraint = NSLayoutConstraint(item: picView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 150)
        heightConstraint = NSLayoutConstraint(item: picView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 150)
        picView.addConstraint(widthConstraint!)
        picView.addConstraint(heightConstraint!)
        
        bottomView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(contentView)
            make.left.equalTo(contentView)
            make.top.equalTo(picView.snp_bottom).offset(10)
            make.height.equalTo(35)
            //make.bottom.equalTo(contentView.snp_bottom).offset(-10)
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
        
        contentView.addSubview(context)
        contentView.addSubview(bottomView)
        contentView.addSubview(picView)
        contentView.addSubview(topView)
        //bottomView.backgroundColor = UIColor.grayColor()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    ///MARK: - LAZY LOADING
    lazy var topView : statusTopView = statusTopView()
    lazy var context : UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        return label
    }()
    lazy var bottomView : statusBottomView = statusBottomView()
    lazy var picView : picViews = picViews()

}



