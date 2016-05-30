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
    var pullupRefreshFlag = false
    var models : [Statuses]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    //缓存行高
    var cacheRowHeight : [Int : CGFloat] = [Int : CGFloat]()
    
    override func didReceiveMemoryWarning() {
        // 清空缓存
        cacheRowHeight.removeAll()
    }
    
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "popPhotoBrowser:", name: KKPopPhotoBrowser, object: nil)
        // 注册2个cell
        tableView.registerClass(StatusesNormalCell.self, forCellReuseIdentifier: statusType.normalCell.rawValue)
        tableView.registerClass(StatusesForwordCell.self, forCellReuseIdentifier: statusType.forwordCell.rawValue)
        
        //已经通过计算的方式得到了rowHeight,并且缓存了，就不需要预估
        //tableView.estimatedRowHeight = 200
        //tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        refreshControl = HomeRefreshControl()
        refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        
        newStatusLabel.hidden = true
        
        //加载数据
        loadData()
        

    }
    
    func popPhotoBrowser(userinfo : NSNotification)
    {
        guard  let indexPath = userinfo.userInfo![KKPhotoBrowserIndexKey] as? NSIndexPath else{
        
            print("no indexPath")
            return
        }
        guard  let urls = userinfo.userInfo![KKPhotoBrowserURLKey] as? [NSURL] else{
            
            print("no urls")
            return
        }
        
        let photoBrowser = PhotoBrowserController(index: indexPath.item, urls: urls)
        
        presentViewController(photoBrowser, animated: true) { () -> Void in
            
        }
    }
    
    func showNewStatusLabel(count : Int){
        
        newStatusLabel.hidden = false
        newStatusLabel.text = (count == 0) ? "没有刷新到新的微博数据" : "刷新到\(count)条微博数据"
        
        UIView.animateWithDuration(2, animations: { () -> Void in
            
            self.newStatusLabel.transform = CGAffineTransformMakeTranslation(0, self.newStatusLabel.frame.height)
            
            }) { (_) -> Void in
                UIView.animateWithDuration(2, animations: { () -> Void in
                    self.newStatusLabel.transform = CGAffineTransformIdentity
                    }, completion: { (_) -> Void in
                        self.newStatusLabel.hidden = true
                })
        }

    }
    
    func loadData(){
        
        //默认当作是下拉来处理，因为since_id 和 max_id ， 必须有一个为0
        var since_id = models?.first?.id ?? 0
        var max_id = 0
        
        if pullupRefreshFlag{
            max_id = models?.last?.id ?? 0
            since_id = 0
            pullupRefreshFlag = false
        }
        //2 load statues
        Statuses.loadStatuses (since_id,max_id: max_id){ (list, error) -> () in
            // 接收刷新
            self.refreshControl?.endRefreshing()
            
            if error != nil
            {
                print(error)
                return
            }
            // 下拉刷新
            if since_id > 0
            {
                
                self.models = list! + self.models!
                self.showNewStatusLabel(list?.count ?? 0)
            }else if max_id > 0{
                self.models =  self.models! + list!
            }
            else
            {
                self.models = list!
            }

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
    
    deinit
    {
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    //MARK: - Lazy
    private lazy var poperAnimator:PoperAnimator = {
        let p = PoperAnimator()
        p.presentFrame = CGRect(x: 100, y: 56, width: 200, height: 350)
        return p
    }()
    /// 刷新提醒控件
    private lazy var newStatusLabel: UILabel =
    {
        let label = UILabel()
        let height: CGFloat = 44
        label.frame =  CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: height)
        
        label.backgroundColor = UIColor.orangeColor()
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        
        // 加载 navBar 上面，不会随着 tableView 一起滚动
        self.navigationController?.navigationBar.insertSubview(label, atIndex: 0)
        
        label.hidden = true
        return label
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

        let status = models![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(statusType.cellID(status), forIndexPath: indexPath) as! StatusesCell
        
        cell.statuses = status
        
        let count = models?.count ?? 0
        if indexPath.row == count - 1{
            print("上啦加载")
            pullupRefreshFlag = true
            loadData()
        }
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier(statusType.cellID(status)) as! StatusesCell
        let rowHeight = cell.rowHeight(status)
        cacheRowHeight[status.id] = rowHeight
        //print("caculate rowHeight:\(rowHeight)")
        return rowHeight
    }
}
