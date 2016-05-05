//
//  PhotoBrowserController.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/5/5.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

let PhotoBrowserControllerIdentifer = "PhotoBrowserControllerIdentifer"
class PhotoBrowserController: UIViewController {
    
    var index : Int?
    var urls : [NSURL]?

    init(index : Int , urls : [NSURL])
    {
        self.index = index
        self.urls = urls
        super.init(nibName: nil, bundle: nil)
    }

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        collectionV.dataSource = self
        closeBtn.addTarget(self, action: "dismissController", forControlEvents: UIControlEvents.TouchUpInside)
        collectionV.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: PhotoBrowserControllerIdentifer)
    }

    func setupUI(){
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(collectionV)
        collectionV.addSubview(iconView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        closeBtn.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view).offset(10)
            make.bottom.equalTo(view).offset(-10)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        saveBtn.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(view).offset(10)
            make.bottom.equalTo(view).offset(-10)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }

    }
    
    func dismissController(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK:- LAZY loading
    private var closeBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("关闭", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        return btn
    }()
    
    private var saveBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("保存", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        return btn
    }()
    
    private var iconView : UIImageView = UIImageView()
    
    private var collectionV : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PhotoBrowserController : UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("urls.count = \(urls?.count)")
        return urls?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserControllerIdentifer, forIndexPath: indexPath)
        cell.backgroundColor = UIColor.greenColor()
        return cell
    }
}