//
//  HomeTableViewController.swift
//  SwiftWeiBo
//
//  Created by Imanol on 1/11/16.
//  Copyright © 2016 imanol. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseViewController {

    //设置 中间的 view
    let btn = TitleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isLogin{
            setupNavigationBarBtn()
        }else{
            visitView?.setupVisitInfo("关注一些人，回这里看看有什么惊喜", imgName: "visitordiscover_feed_image_house", homePage: true)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "change", name: PopoverAnimatorWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "change", name: PopoverAnimatorWilldismiss, object: nil)
    }
    
    func setupNavigationBarBtn(){
        // 1.添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButton("navigationbar_friendattention", target: self, action: "letBtnClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButton("navigationbar_pop", target: self, action: "rightBtnClick")
        
        btn.setTitle("Imanol", forState: UIControlState.Normal)
        btn.addTarget(self, action: "titleViewClick:", forControlEvents: UIControlEvents.TouchUpInside)
        btn.sizeToFit()
        navigationItem.titleView = btn
    }
    
    func titleViewClick(btn:UIButton){
        //
        //1 弹出菜单
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        //2 设置转场代理
        vc?.transitioningDelegate = poperAnimator
        
        //设置转场样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom;
        presentViewController(vc!, animated: true, completion: nil)
        
         print(__FUNCTION__)
    }
    
    func letBtnClick(){
        print(__FUNCTION__)
    }
    
    func rightBtnClick(){
        let sb = UIStoryboard(name: "QRCodeController", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        presentViewController(vc, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    //MARK: - Lazy
    private lazy var poperAnimator:PoperAnimator = {
        let p = PoperAnimator()
        p.presentFrame = CGRect(x: 100, y: 56, width: 200, height: 350)
        return p
    }()
    
    //MARK: - 通知事件
    /**
    修改标题按钮的状态
    */
    func change(){
        btn.selected = !btn.selected
    }
}
