//
//  TitleView.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/1/14.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit


class TitleView: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
        titleLabel?.font = UIFont.systemFontOfSize(17)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        //不要忘记这句
        super.layoutSubviews()
        titleLabel?.frame.origin.x = 0;
        imageView?.frame.origin.x = titleLabel!.frame.size.width + 3
    }
}