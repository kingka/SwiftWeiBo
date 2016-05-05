//
//  picViews.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/4/26.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit
import SDWebImage

let collectionCellIdentifer = "cellIdentifer"
let KKPopPhotoBrowser = "KKPopPhotoBrowser"
let KKPhotoBrowserIndexKey = "KKPhotoBrowserIndexKey"
let KKPhotoBrowserURLKey = "KKPhotoBrowserURLKey"

class picViews: UICollectionView {

    var statuses : Statuses?{
        didSet{

            reloadData()
        }
    }
    
    var picLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    func calculateSize()->CGSize{
        
        // 取出配图个数
        let count = statuses?.picURLS?.count
        // 如果没有配图zero
        if count == 0 || count == nil
        {
            picLayout.itemSize = CGSizeMake(1, 1)
            return CGSizeMake(1, 1)
        }
        //如果只有一张
        if count == 1
        {
            // 取出缓存的图片
            let key = statuses?.picURLS!.first?.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key!)
            // 3.2返回缓存图片的尺寸
            picLayout.itemSize = image.size
            return (image.size)
            
        }
        //如果有4张
        let width = 90
        let margin = 10
        if count == 4
        {
            let viewWidth = width * 2 + margin
            picLayout.itemSize = CGSize(width: width, height: width)
            return CGSize(width: viewWidth, height: viewWidth)
        }
        
        //如果是其他张数
        // 列数
        let colNumber = 3
        // 计算行数
        //               (8 - 1) / 3 + 1
        let rowNumber = (count! - 1) / 3 + 1
        // 宽度 = 列数 * 图片的宽度 + (列数 - 1) * 间隙
        let viewWidth = colNumber * width + (colNumber - 1) * margin
        // 高度 = 行数 * 图片的高度 + (行数 - 1) * 间隙
        let viewHeight = rowNumber * width + (rowNumber - 1) * margin
        picLayout.itemSize = CGSize(width: width, height: width)
        return CGSize(width: viewWidth, height: viewHeight)
        
    }

    
     init() {
        super.init(frame: CGRectZero, collectionViewLayout: picLayout)
        setup()
    }

     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    func setup(){
        registerClass(collectionCell.self, forCellWithReuseIdentifier: collectionCellIdentifer)
        dataSource = self
        delegate = self
        picLayout.minimumInteritemSpacing = 10
        picLayout.minimumLineSpacing = 10
        backgroundColor = UIColor.clearColor()//UIColor(white: 0.8, alpha: 0.7)
    }
}

extension picViews : UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionCellIdentifer, forIndexPath: indexPath) as! collectionCell
        cell.imageURL = statuses?.picURLS![indexPath.row]
        //cell.backgroundColor = UIColor.greenColor()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statuses?.picURLS?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //print(indexPath.item)
        let info = [KKPhotoBrowserIndexKey : indexPath,KKPhotoBrowserURLKey :statuses!.largePicURLS!]
        NSNotificationCenter.defaultCenter().postNotificationName(KKPopPhotoBrowser, object: self, userInfo: info)
    }
    ///MARK: - 内部类
    class collectionCell : UICollectionViewCell
    {
        // jie收外界传入的数据
        var imageURL: NSURL?
            {
            didSet{
                imageView.sd_setImageWithURL(imageURL!)
            }
        }
        
        func setupUI(){
            
            contentView.addSubview(imageView)
            imageView.snp_makeConstraints { (make) -> Void in
                make.edges.equalTo(contentView)
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        lazy var imageView : UIImageView = UIImageView()
    }

    
}


