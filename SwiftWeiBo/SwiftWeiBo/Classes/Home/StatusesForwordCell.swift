//
//  StatusesForwordCell.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/4/27.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

class StatusesForwordCell: StatusesCell {

    override func setupUI() {
        
        super.setupUI()
        
        //addSubview
        contentView.insertSubview(forwordButton, belowSubview: picView)
        contentView.insertSubview(forwordLabel, aboveSubview: forwordButton)
        
        //setting autoLayout
        forwordButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(context)
            make.right.equalTo(context)
            make.top.equalTo(context.snp_bottom).offset(10)
            make.bottom.equalTo(bottomView.snp_top)
        }
        forwordLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(context)
            make.top.equalTo(forwordButton).offset(10)
        }
        
        picView.snp_makeConstraints { (make) -> Void in
            //make.top.equalTo(forwordLabel.snp_bottom).offset(10)
            make.left.equalTo(context)
        }
        
        widthConstraint = NSLayoutConstraint(item: picView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 150)
        topConstraint = NSLayoutConstraint(item: picView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: forwordLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        heightConstraint = NSLayoutConstraint(item: picView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 150)
        picView.addConstraint(widthConstraint!)
        picView.addConstraint(heightConstraint!)
        contentView.addConstraint(topConstraint!)
    }
    
    //MARK:- lazy loading
    lazy var forwordLabel : UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        label.text = "just for test!"
        return label
    }()
    
    lazy var forwordButton : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(white: 0.8, alpha: 0.7)
        return btn
    }()
}
