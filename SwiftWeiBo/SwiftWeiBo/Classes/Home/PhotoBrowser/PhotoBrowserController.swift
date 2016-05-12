//
//  PhotoBrowserController.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/5/5.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit
import SVProgressHUD

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

   //滚动到指定的cell
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        let indexpath = NSIndexPath(forRow:index!, inSection: 0)
        collectionV.scrollToItemAtIndexPath(indexpath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        collectionV.dataSource = self
        closeBtn.addTarget(self, action: "dismissController", forControlEvents: UIControlEvents.TouchUpInside)
        saveBtn.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        collectionV.registerClass(PhotoBrowserCell.self, forCellWithReuseIdentifier: PhotoBrowserControllerIdentifer)
        
    }

    func setupUI(){
        
        view.backgroundColor = UIColor.blackColor()
        
        view.addSubview(collectionV)
        collectionV.addSubview(iconView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        collectionV.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        
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
    
    func save(){
        let index = collectionV.indexPathsForVisibleItems().last
        let cell = collectionV.cellForItemAtIndexPath(index!) as! PhotoBrowserCell
        let image = cell.imageV.image
        UIImageWriteToSavedPhotosAlbum(image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
        //// - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    }
    
    func image(image:UIImage, didFinishSavingWithError error:NSError?, contextInfo:AnyObject){
        if error != nil{
            SVProgressHUD.showErrorWithStatus("保存失败")
        }else{
            SVProgressHUD.showSuccessWithStatus("保存成功")
        }
    }
    //MARK:- LAZY loading
    private var closeBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("关闭", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.backgroundColor = UIColor(white: 0.8, alpha: 0.6)
        return btn
    }()
    
    private var saveBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("保存", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.backgroundColor = UIColor(white: 0.8, alpha: 0.6)
        return btn
    }()
    
    private var iconView : UIImageView = UIImageView()
    
    private var collectionV : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: PhotoBrowserLayout())
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PhotoBrowserController : UICollectionViewDataSource,PhotoBrowserCellDelegate
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("urls.count = \(urls?.count)")
        return urls?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserControllerIdentifer, forIndexPath: indexPath) as! PhotoBrowserCell
        cell.photoBrowserCellDelegate = self
        cell.imageURL = urls![indexPath.row]
        cell.backgroundColor = UIColor.blackColor()
        return cell
    }
    
    func photoBrowserClose(cell: PhotoBrowserCell) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

class PhotoBrowserLayout : UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.pagingEnabled = true
        collectionView?.bounces =  false
        
        
    }
}