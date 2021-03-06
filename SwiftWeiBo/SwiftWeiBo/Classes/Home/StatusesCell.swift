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
    ///topConstraint是用来控制当没有配图的时候，去除顶部的10像素约束
    var topConstraint : NSLayoutConstraint?
    
    var statuses : Statuses?
        {
        didSet{
            context.attributedText = EmoticonPackage.changeText2AttributeText(statuses?.text ?? "")
            topView.statuses = statuses
            //计算配图尺寸
            picView.statuses = statuses?.retweeted_status != nil ? statuses?.retweeted_status :  statuses
            let caculateSize = picView.calculateSize()
            //picView的总体大小
            widthConstraint?.constant = caculateSize.width
            heightConstraint?.constant = caculateSize.height
            topConstraint?.constant = caculateSize.height==1 ? 0 : 10

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



