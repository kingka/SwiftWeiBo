//
//  StatusesNormalCell.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/4/27.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

class StatusesNormalCell: StatusesCell {

    override func setupUI() {
        super.setupUI()
        
        //布局picView autoLayout
        picView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(context)
        }
        
        widthConstraint = NSLayoutConstraint(item: picView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 150)
        heightConstraint = NSLayoutConstraint(item: picView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 150)
        topConstraint = NSLayoutConstraint(item: picView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: context, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        
        picView.addConstraint(widthConstraint!)
        picView.addConstraint(heightConstraint!)
        contentView.addConstraint(topConstraint!)
    }
}
