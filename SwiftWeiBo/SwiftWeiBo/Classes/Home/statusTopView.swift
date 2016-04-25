//
//  statusTopView.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/4/25.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

class statusTopView: UIView {

    func setupUI(){
    
        iconImageView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(10)
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


    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconImageView)
        addSubview(userType)
        addSubview(name)
        addSubview(date)
        addSubview(sourceFrom)
        addSubview(mbrankImageView)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///MARK: - LAZY LOADING
    lazy var sourceFrom : UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 13)
        return label
    }()
    
    lazy var date : UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 13)
        return label
    }()
    lazy var mbrankImageView : UIImageView = UIImageView()
    
    lazy var iconImageView : UIImageView = UIImageView()
    lazy var userType : UIImageView = UIImageView()
    
    lazy var name : UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        return label
    }()
}
