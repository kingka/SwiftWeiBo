//
//  HomeRefreshControl.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/4/29.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

class HomeRefreshControl: UIRefreshControl {

    override init() {
        super.init()
        setupUI()
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    func setupUI(){
        
        addSubview(refreshView)
        
        //setting autolayout
        refreshView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(175)
            make.height.equalTo(self)
            make.center.equalTo(self)
        }
        
    }

    /// 记录是否需要旋转监听
    private var rotationArrowFlag = false
    /// 记录当前是否正在执行圈圈动画
    private var loadingViewAnimFlag = false
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        //print("frame:\(frame.origin.y)")

        //过滤不必要的
        if frame.origin.y >= 0
        {
            return
        }
        
        // 判断是否已经触发刷新事件
        if refreshing && !loadingViewAnimFlag
        {
            //print("圈圈动画")
            loadingViewAnimFlag = true
            // 显示圈圈, 并且让圈圈执行动画
            refreshView.startLoadingAnimation()
            return
        }
        
        if frame.origin.y >= -50 && rotationArrowFlag
        {
            //print("翻转回来")
            rotationArrowFlag = false
            refreshView.rotationArrowIcon(rotationArrowFlag)
        }else if frame.origin.y < -50 && !rotationArrowFlag
        {
            //print("翻转")
            rotationArrowFlag = true
            refreshView.rotationArrowIcon(rotationArrowFlag)
        }
        
        
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        
        // 关闭圈圈动画
        refreshView.stopLoadingViewAnim()
        
        // 复位圈圈动画标记
        loadingViewAnimFlag = false
    }
    
    lazy var refreshView : HomeRefreshView = HomeRefreshView.refreshView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


class HomeRefreshView: UIView
{

    @IBOutlet weak var tipsView: UIView!
    @IBOutlet weak var loadingView: UIImageView!
    @IBOutlet weak var pullRefresh: UIImageView!
    
    class func refreshView()->HomeRefreshView{
        return NSBundle.mainBundle().loadNibNamed("HomeRefreshControl", owner: nil, options: nil).last as! HomeRefreshView
    }
    
    func rotationArrowIcon(flag : Bool){
        var angle = M_PI
        angle += flag ? -0.01 : 0.01
        UIView.animateWithDuration(0.2) { () -> Void in
            self.pullRefresh.transform = CGAffineTransformRotate(self.pullRefresh.transform, CGFloat(angle))
        }
    }
    
    func startLoadingAnimation(){
        
        tipsView.hidden = true
        
        let animate = CABasicAnimation(keyPath: "transform.rotation")
        animate.toValue = 2*M_PI
        animate.duration = 1
        animate.repeatCount = MAXFLOAT
        //默认为true , 表示完成就移除动画
        animate.removedOnCompletion = false
        
        loadingView.layer.addAnimation(animate, forKey: nil)
    }
    
    func stopLoadingViewAnim()
    {
        tipsView.hidden = false
        loadingView.layer.removeAllAnimations()
    }
}