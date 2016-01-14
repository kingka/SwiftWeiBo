//
//  HomeTableViewController.swift
//  SwiftWeiBo
//
//  Created by Imanol on 1/11/16.
//  Copyright © 2016 imanol. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if isLogin{
            setupNavigationBarBtn()
        }else{
            visitView?.setupVisitInfo("关注一些人，回这里看看有什么惊喜", imgName: "visitordiscover_feed_image_house", homePage: true)
        }
        
    }
    
    func setupNavigationBarBtn(){
        // 1.添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButton("navigationbar_friendattention", target: self, action: "letBtnClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButton("navigationbar_pop", target: self, action: "rightBtnClick")
        //设置 中间的 view
        let btn = TitleView()
        btn.setTitle("Imanol", forState: UIControlState.Normal)
        btn.addTarget(self, action: "titleViewClick:", forControlEvents: UIControlEvents.TouchUpInside)
        btn.sizeToFit()
        navigationItem.titleView = btn
    }
    
    func titleViewClick(btn:UIButton){
        btn.selected = !btn.selected
         print(__FUNCTION__)
    }
    
    func letBtnClick(){
        print(__FUNCTION__)
    }
    
    func rightBtnClick(){
        print(__FUNCTION__)
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

}
