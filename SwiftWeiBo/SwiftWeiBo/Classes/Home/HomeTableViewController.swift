//
//  HomeTableViewController.swift
//  SwiftWeiBo
//
//  Created by Imanol on 1/11/16.
//  Copyright © 2016 imanol. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseViewController {

    /// 否是展开
    var isPresent: Bool = false
    
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
        //1 弹出菜单
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        //2 设置转场代理
        vc?.transitioningDelegate = self
        
        //设置转场样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom;
        presentViewController(vc!, animated: true, completion: nil)
        
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

extension HomeTableViewController:UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning{
    
    //实现代理方法, 告诉系统哪个对象负责转场动画
    @available(iOS 8.0, *)
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?{
        return PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting);
    }
    
    // MARK: - 只要实现了以下两个方法, 那么系统自带的默认动画就没有了, "所有"东西都需要程序员自己来实现
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresent = false
        return self
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresent = true
         return self
    }
    
    //动画持续时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return 2
    }
    
    /**
     告诉系统如何动画, 无论是展现还是消失都会调用这个方法
     :param: transitionContext 上下文, 里面保存了动画需要的所有参数
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
    
        // 1.拿到展现视图
        
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        // 通过打印发现需要修改的就是toVC上面的View
        print(toVC)
        print(fromVC)

        
        if(isPresent){//展开
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            toView.transform = CGAffineTransformMakeScale(1.0, 0.0)
            //将toView添加到容器上
            transitionContext.containerView()?.addSubview(toView)
            //设置锚点
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            // 2.执行动画
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                //清空上方transform 设置的压扁状态
                toView.transform = CGAffineTransformIdentity
                }, completion: { (_) -> Void in
                    //必须要通知执行完毕
                    transitionContext.completeTransition(true)
            })
            
        }else{//关闭
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            // 注意:由于CGFloat是不准确的, 所以如果写0.0会没有动画
            // 压扁
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                fromView.transform = CGAffineTransformMakeScale(1.0, 0.000001)
                }, completion: { (_) -> Void in
                    //必须要通知执行完毕
                    transitionContext.completeTransition(true)
            })
        }
    }
    
}
