//
//  VisitView.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/1/13.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

protocol VisitViewDelegate:NSObjectProtocol{
    
     func registerDidClick()
     func loginDidClick()
}

class VisitView: UIView {
    
    weak var delegate:VisitViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupVisitInfo(message:String,imgName:String,homePage:Bool){
        textLabel.text = message
        homeIcon.image = UIImage(named: imgName)
        if homePage{
            startAnimate()
        }else{
            bgIcon.hidden = true
        }
    }
    
    func registerClick(){
        delegate?.registerDidClick()
    }
    
    func loginClick(){
        delegate?.loginDidClick()
    }
    
    func setupUI(){
        addSubview(bgIcon)
        addSubview(homeIcon)
        addSubview(maskBgView)
        addSubview(textLabel)
        addSubview(registerBtn)
        addSubview(loginBtn)
        
        //布局
        bgIcon.translatesAutoresizingMaskIntoConstraints = false
        let bgIconCenterXCon = NSLayoutConstraint(item: bgIcon, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        let bgIconCenterYCon = NSLayoutConstraint(item: bgIcon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        //mask
        maskBgView.translatesAutoresizingMaskIntoConstraints = false
        let maskBgIconLeft = NSLayoutConstraint(item: maskBgView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)
        let maskBgIconRight = NSLayoutConstraint(item: maskBgView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0)
        let maskBgIconCenterYCon = NSLayoutConstraint(item: maskBgView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -100)
        let maskBgIconBottomCon = NSLayoutConstraint(item: maskBgView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)

        
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
        //LOGINBTN
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        let loginBtnLeftCon = NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: registerBtn, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 20)
        let loginBtnTopCon = NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: textLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 15)
        let rloginBtnWidthCon = NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 100)
        let loginBtnHeightCon = NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 35)
        loginBtn.addConstraint(rloginBtnWidthCon)
        loginBtn.addConstraint(loginBtnHeightCon)
 
        addConstraint(bgIconCenterXCon)
        addConstraint(bgIconCenterYCon)
        addConstraint(maskBgIconLeft)
        addConstraint(maskBgIconRight)
        addConstraint(maskBgIconCenterYCon)
        addConstraint(maskBgIconBottomCon)
        addConstraint(homeIconCenterXCon)
        addConstraint(homeIconCenterYCon)
        textLabel.addConstraint(labelWidthCon)
        addConstraint(labelCenterXCon)
        addConstraint(labelTopCon)
        
        addConstraint(regBtnLeftCon)
        addConstraint(regBtnTopCon)
        addConstraint(loginBtnLeftCon)
        addConstraint(loginBtnTopCon)
    }
    
    func startAnimate(){
        let animate = CABasicAnimation(keyPath: "transform.rotation")
        animate.toValue = 2 * M_PI
        animate.repeatCount = MAXFLOAT
        animate.duration = 20
        animate.removedOnCompletion = false
        bgIcon.layer.addAnimation(animate, forKey: nil)
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
        btn.addTarget(self, action: "registerClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    lazy var loginBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("登陆", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "loginClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    lazy var maskBgView:UIImageView = {
        let icon = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return icon
    }()
    
    
}
