//
//  statusBottomView.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/4/25.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit


class statusBottomView: UIView {
    
    func setupUI(){
        
        commentBtn?.snp_makeConstraints(closure: { (make) -> Void in
            make.width.equalTo(self.snp_width).dividedBy(3)
            make.height.equalTo(self)
            make.left.equalTo(self)
            make.top.equalTo(self)
        })
        
        retweetBtn?.snp_makeConstraints(closure: { (make) -> Void in
            make.width.equalTo(commentBtn!)
            make.height.equalTo(self)
            make.left.equalTo(commentBtn!.snp_right)
            make.top.equalTo(self)
        })
        unlikeBtn?.snp_makeConstraints(closure: { (make) -> Void in
            make.width.lessThanOrEqualTo(retweetBtn!)
            make.height.equalTo(self)
            make.left.equalTo(retweetBtn!.snp_right)
            make.right.equalTo(self)
            make.top.equalTo(self)
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(commentBtn!)
        addSubview(retweetBtn!)
        addSubview(unlikeBtn!)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var commentBtn : UIButton? = {
        let btn = UIButton.createButton("timeline_icon_comment",title:"评论")
        return btn
    }()
    
    lazy var retweetBtn : UIButton? = {
        let btn = UIButton.createButton("timeline_icon_retweet",title:"转发")
        return btn
    }()
    
    lazy var unlikeBtn : UIButton? = {
        let btn = UIButton.createButton("timeline_icon_unlike",title:"赞")
        return btn
    }()
    
    
}