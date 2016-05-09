//
//  PhotoBrowserCell.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/5/9.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

class PhotoBrowserCell: UICollectionViewCell {
    
    var imageURL : NSURL?{
        didSet{
            imageV.sd_setImageWithURL(imageURL!) { (image, _, _, _) -> Void in
                self.setupImagePosition(image)
            }
        }
    }
    
    func setupImagePosition(image : UIImage){
        let size = displaySize(image)
        //判断高度是否大于屏幕高度
        if size.height < UIScreen.mainScreen().bounds.height{
            //小于 表示短图
            imageV.frame = CGRect(origin: CGPointZero, size: size)
            //居中显示
            let y = (UIScreen.mainScreen().bounds.height - size.height)*0.5
            scroller.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
        }else{
            //长图
            imageV.frame = CGRect(origin: CGPointZero, size: size)
            scroller.contentSize = size
        }
    }
    
    func setupUI(){
        contentView.addSubview(scroller)
        scroller.addSubview(imageV)
        scroller.frame = UIScreen.mainScreen().bounds
    }
    
    private func displaySize(image: UIImage) -> CGSize
    {
        // 1.拿到图片的宽高比
        let scale = image.size.height / image.size.width
        // 2.根据宽高比计算高度
        let width = UIScreen.mainScreen().bounds.width
        let height =  width * scale
        
        return CGSize(width: width, height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- lazy
    lazy var imageV : UIImageView = UIImageView()
    lazy var scroller : UIScrollView = UIScrollView()
}
