//
//  NewfeatureCollectionViewController.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/4/5.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

class NewfeatureCollectionViewController: UICollectionViewController {

    var layout:UICollectionViewFlowLayout = NewfeatureLayout()
    let page:Int = 4
    
    //这里不用写overide 是因为 init（）方法不是默认的构造方法，默认的构造方法是带参数的那个
    init(){
        super.init(collectionViewLayout: layout)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.registerClass(NewfeatureCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return page
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! NewfeatureCell
        cell.imageIndex = indexPath.row
        cell.startButton.hidden = true
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        //1 拿到index
        let path = collectionView.indexPathsForVisibleItems().last
        //2 拿到对应的cell
        let cell = collectionView.cellForItemAtIndexPath(path!) as! NewfeatureCell
        
        if path!.item == page - 1
        {
            //3 执行动画
            cell.startButton.hidden = false
            cell.startBtnAnimate()
        }
        
    }
}

//如果类里面有按钮需要监听点击事件，那么该类不能生命为 private
class NewfeatureCell:UICollectionViewCell {
    
    var imageIndex:Int?{
        didSet{
            iconView.image = UIImage(named: "new_feature_\(imageIndex!+1)")
        }
    }
    
    func startBtnAnimate(){
        
        startButton.transform = CGAffineTransformMakeScale(0, 0)
        startButton.userInteractionEnabled = false
        //UIViewAnimationOptions(rawValue: 0) 相当于OC 的 knilOptions
        UIView.animateWithDuration(2.0, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            self.startButton.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
              self.startButton.userInteractionEnabled = true
        }
    
    }
    
    
    func startBtnClick(){
        //跳转页面通知
        NSNotificationCenter.defaultCenter().postNotificationName(weiboSwitchRootControllerKey, object: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(){
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        
        //iconView
        iconView.translatesAutoresizingMaskIntoConstraints = false
        let IconLeft = NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)
        let IconRight = NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0)
        let topCon = NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        let IconBottomCon = NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        contentView.addConstraint(IconLeft)
        contentView.addConstraint(IconRight)
        contentView.addConstraint(topCon)
        contentView.addConstraint(IconBottomCon)
        
        //startButton
        startButton.translatesAutoresizingMaskIntoConstraints = false
        let startCenterX = NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        let startButtonBottomCon = NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -100)
        contentView.addConstraint(startCenterX)
        contentView.addConstraint(startButtonBottomCon)
        
    }
    
    private lazy var iconView = UIImageView()
    private lazy var startButton:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "new_feature_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), forState: UIControlState.Highlighted)
        btn.hidden = true
        btn.addTarget(self, action: "startBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
}

class NewfeatureLayout:UICollectionViewFlowLayout {
    
    //准备布局
    //调用顺序：1 获取多少个cell 2 准备布局  3 返回cell
    override func prepareLayout() {
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0;
        minimumLineSpacing = 0;
        scrollDirection = UICollectionViewScrollDirection.Horizontal

        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
    }
    
}

