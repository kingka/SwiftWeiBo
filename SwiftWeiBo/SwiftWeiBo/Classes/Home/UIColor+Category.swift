//
//  UIColor+Category.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/5/9.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

extension UIColor
{
    class func randomColor() -> UIColor {
        return UIColor(red: randomNumber(), green: randomNumber(), blue: randomNumber() , alpha: 1.0)
    }
    
    class func randomNumber() -> CGFloat {
        // 0 ~ 255
        return CGFloat(arc4random_uniform(256)) / CGFloat(255)
    }
}
