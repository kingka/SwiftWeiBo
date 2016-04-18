//
//  UILabel+Category.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/4/18.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

extension UILabel{
    
    class func createLabel(color: UIColor, fontSize: CGFloat) -> UILabel
    {
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFontOfSize(fontSize)
        return label
    }

}