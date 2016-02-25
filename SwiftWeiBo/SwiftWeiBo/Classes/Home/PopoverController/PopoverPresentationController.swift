//
//  PopoverPresentationController.swift
//  SwiftWeiBo
//
//  Created by Imanol on 2/24/16.
//  Copyright © 2016 imanol. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class PopoverPresentationController: UIPresentationController {

    var presentFrame = CGRectZero
    
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    
    //即将转场时调用
    override func containerViewWillLayoutSubviews() {
        //1 修改被展示的视图
        //        containerView; // 容器视图
        //        presentedView() // 被展现的视图
        if presentFrame == CGRectZero{
            
            presentedView()?.frame = CGRect(x: 100, y: 56, width: 200, height: 200)
        }else
        {
            presentedView()?.frame = presentFrame
        }
        //在容器下面添加一个蒙版
        containerView?.insertSubview(coverView, atIndex: 0)
        
    }
    
    //MARK: - LAZY LOADING
    private lazy var coverView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.frame = UIScreen.mainScreen().bounds
        
        //添加监听事件
        let tap = UITapGestureRecognizer(target: self, action: "close")
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    func close(){
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
