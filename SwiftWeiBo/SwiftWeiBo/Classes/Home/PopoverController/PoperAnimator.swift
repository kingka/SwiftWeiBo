//
//  PoperAnimator.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/2/25.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

// 定义常量保存通知的名称
let PopoverAnimatorWillShow = "PopoverAnimatorWillShow"
let PopoverAnimatorWilldismiss = "PopoverAnimatorWilldismiss"

class PoperAnimator: NSObject,UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning{
    
    var presentFrame = CGRectZero
    /// 否是展开
    var isPresent: Bool = false
    //实现代理方法, 告诉系统哪个对象负责转场动画
    @available(iOS 8.0, *)
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?{
        let poperVC = PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
        poperVC.presentFrame = presentFrame
        return poperVC
    }
    
    // MARK: - 只要实现了以下两个方法, 那么系统自带的默认动画就没有了, "所有"东西都需要程序员自己来实现
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        NSNotificationCenter.defaultCenter().postNotificationName(PopoverAnimatorWilldismiss, object:self)
        isPresent = false
        return self
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        NSNotificationCenter.defaultCenter().postNotificationName(PopoverAnimatorWillShow, object:self)
        isPresent = true
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
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
