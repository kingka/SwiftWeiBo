//
//  UIButton+Category.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/4/18.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

extension UIButton{
    
    class func createButton(imageName:String , title:String )->UIButton{
        
        let btn = UIButton()
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: UIControlState.Normal)
        
        return btn
    }
    
}