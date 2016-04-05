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
        return cell
    }
}

class NewfeatureCell:UICollectionViewCell {
    
    var imageIndex:Int?{
        didSet{
            iconView.image = UIImage(named: "new_feature_\(imageIndex!+1)")
        }
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
        //mask
        iconView.translatesAutoresizingMaskIntoConstraints = false
        let IconLeft = NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)
        let IconRight = NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0)
        let topCon = NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        let IconBottomCon = NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        contentView.addConstraint(IconLeft)
        contentView.addConstraint(IconRight)
        contentView.addConstraint(topCon)
        contentView.addConstraint(IconBottomCon)
    }
    
    private lazy var iconView = UIImageView()
    
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

