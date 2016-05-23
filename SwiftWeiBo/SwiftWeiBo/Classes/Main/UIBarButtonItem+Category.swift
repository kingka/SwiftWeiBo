//
//  UIBarButtonItem+Category.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/1/14.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
   class func createBarButton(imageName:String, target: AnyObject?, action: Selector)->UIBarButtonItem{
    
    let btn = UIButton()
    btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
    btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
    btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
    return UIBarButtonItem(customView: btn)
    
    }
    
    convenience init(imageName: String, target: AnyObject?, action: String?){
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        if action != nil
        {
            //自己封装action
            btn.addTarget(target, action: Selector(action!), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        btn.sizeToFit()
        
        self.init(customView: btn)
    }

}