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
    }
    
    lazy var bgIcon:UIImageView = {
        let icon = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return icon
    }()
    
    lazy var homeIcon:UIImageView = {
        let icon = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return icon
    }()
    
    lazy var textLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var registerBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("注册", forState: UIControlState.Normal)
        return btn
    }()
    
    lazy var loginBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("登陆", forState: UIControlState.Normal)
        return btn
    }()
    
    
}
