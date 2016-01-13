//
//  VisitView.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/1/13.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

class VisitView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        addSubview(bgIcon)
        addSubview(homeIcon)
        addSubview(textLabel)
        addSubview(registerBtn)
        addSubview(loginBtn)
        
        //布局
        bgIcon.translatesAutoresizingMaskIntoConstraints = false
        let bgIconCenterXCon = NSLayoutConstraint(item: bgIcon, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        let bgIconCenterYCon = NSLayoutConstraint(item: bgIcon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        //HOMEICON
        homeIcon.translatesAutoresizingMaskIntoConstraints = false
        let homeIconCenterXCon = NSLayoutConstraint(item: homeIcon, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        let homeIconCenterYCon = NSLayoutConstraint(item: homeIcon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        //TEXTLABEL
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let labelWidthCon = NSLayoutConstraint(item: textLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224)
        let labelCenterXCon = NSLayoutConstraint(item: textLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: homeIcon, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        let labelTopCon = NSLayoutConstraint(item: textLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: bgIcon, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10)
        //REGISTER
        registerBtn.translatesAutoresizingMaskIntoConstraints = false
        let regBtnLeftCon = NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: textLabel, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)
        let regBtnTopCon = NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: textLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 15)
        let regBtnWidthCon = NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 100)
        let regBtnHeightCon = NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 35)
        registerBtn.addConstraint(regBtnWidthCon)
        registerBtn.addConstraint(regBtnHeightCon)
        
 
        addConstraint(bgIconCenterXCon)
        addConstraint(bgIconCenterYCon)
        addConstraint(homeIconCenterXCon)
        addConstraint(homeIconCenterYCon)
        textLabel.addConstraint(labelWidthCon)
        addConstraint(labelCenterXCon)
        addConstraint(labelTopCon)
        
        addConstraint(regBtnLeftCon)
        addConstraint(regBtnTopCon)
    }
    
    
    lazy var bgIcon:UIImageView = {
        let icon = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return icon
    }()
    
    lazy var homeIcon:UIImageView = {
        let icon = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return icon
    }()
    
    lazy var textLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "那那付款的减肥啦但是会计法拉德斯基发大水了开发甲氨蝶呤；看风景ADSL分；阿的说法代理商"
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(14)
        label.sizeToFit()
        return label
    }()
    
    lazy var registerBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("注册", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        return btn
    }()
    
    lazy var loginBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("登陆", forState: UIControlState.Normal)
        return btn
    }()
    
    
}
