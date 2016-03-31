//
//  BaseViewController.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/1/13.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController ,VisitViewDelegate{

    let isLogin:Bool = UserAccount.userLogin()
    var visitView:VisitView?
    override func loadView() {
        isLogin ? super.loadView() : setupCustomView()
    }
    
    func setupCustomView(){
        //初始化visitView
        visitView = VisitView()
        visitView?.delegate = self
        view = visitView
        // 添加 导航按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "registerDidClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "loginDidClick")

      
    }
    
    func registerDidClick() {
        print(__FUNCTION__)
        //print(UserAccount.loadAccount())
        print("hehe".CacheDir())
        print("hehe".TmpDir())
        print("hehe".DocumentDir())
    }
    
    func loginDidClick() {
        print(__FUNCTION__)
        let oauthVC = OAuthViewController()
        let nav = UINavigationController(rootViewController: oauthVC)
        presentViewController(nav, animated: true) { () -> Void in
            
        }

    }
    
}
