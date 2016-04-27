//
//  HomeTableViewController.swift
//  SwiftWeiBo
//
//  Created by Imanol on 1/11/16.
//  Copyright © 2016 imanol. All rights reserved.
//

import UIKit

let HomeReuseIdentifier = "HomeReuseIdentifier"
class HomeTableViewController: BaseViewController {

    //设置 中间的 view
    let btn = TitleView()
    var models : [Statuses]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    //缓存行高
    var cacheRowHeight : [Int : CGFloat] = [Int : CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 判断登陆状态
        if isLogin{
            setupNavigationBarBtn()
        }else{
            visitView?.setupVisitInfo("关注一些人，回这里看看有什么惊喜", imgName: "visitordiscover_feed_image_house", homePage: true)
            return
        }
        
        //监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "change", name: PopoverAnimatorWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "change", name: PopoverAnimatorWilldismiss, object: nil)
        
        // 注册一个cell
        tableView.registerClass(StatusesNormalCell.self, forCellReuseIdentifier: HomeReuseIdentifier)
        
        //已经通过计算的方式得到了rowHeight,并且缓存了，就不需要预估
        //tableView.estimatedRowHeight = 200
        //tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //加载数据
        loadData()
    }
    
    func loadData(){
        //2 load statues
        Statuses.loadStatuses { (list, error) -> () in
            if error != nil
            {
                return
            }
            self.models = list
        }
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

extension HomeTableViewController
{
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return models?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier(HomeReuseIdentifier, forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(HomeReuseIdentifier, forIndexPath: indexPath) as! StatusesCell
        
        cell.statuses = models![indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //是否已经存储过对应微博id 的行高.有的话直接返回
        let status = models![indexPath.row] 
        if let rowHeight = cacheRowHeight[status.id]
        {
            //print("from cache:\(rowHeight)")
            return rowHeight
        }
        //没有的话，先取出cell, 然后计算，存储，再返回
        let cell = tableView.dequeueReusableCellWithIdentifier(HomeReuseIdentifier) as! StatusesCell
        let rowHeight = cell.rowHeight(status)
        cacheRowHeight[status.id] = rowHeight
        //print("caculate rowHeight:\(rowHeight)")
        return rowHeight
    }
}
