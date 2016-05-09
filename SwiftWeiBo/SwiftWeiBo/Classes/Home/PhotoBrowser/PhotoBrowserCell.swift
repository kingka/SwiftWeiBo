//
//  PhotoBrowserCell.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/5/9.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

protocol PhotoBrowserCellDelegate : NSObjectProtocol
{
    func photoBrowserClose(cell : PhotoBrowserCell)
}

class PhotoBrowserCell: UICollectionViewCell {
    
    var photoBrowserCellDelegate : PhotoBrowserCellDelegate?
    var imageURL : NSURL?{
        
        didSet{
            //1 重置
            reset()
            //2 start activity
            activity.startAnimating()
            //3 加载图片
            imageV.sd_setImageWithURL(imageURL!) { (image, _, _, _) -> Void in
                //4 stop activity
                self.activity.stopAnimating()
                //5 调整图片位置
                self.setupImagePosition(image)
            }
        }
    }
    
    //因为重用cell 的问题，如果不reset scroller 和 imageView , 会出现被重用的cell的大小，位置等方面不正确
    func reset(){
        scroller.contentInset = UIEdgeInsetsZero
        scroller.contentOffset = CGPointZero
        scroller.contentSize = CGSizeZero
        
        //取消形变
        imageV.transform = CGAffineTransformIdentity
    
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
        contentView.addSubview(activity)
        
        //点击图片关闭手势
        let tap = UITapGestureRecognizer(target: self, action: "close")
        imageV.addGestureRecognizer(tap)
        imageV.userInteractionEnabled = true
        
        scroller.frame = UIScreen.mainScreen().bounds
        scroller.delegate = self
        
        activity.center = contentView.center
        
        scroller.maximumZoomScale = 2.0
        scroller.minimumZoomScale = 0.5
    }
    
    func close(){
        if ((photoBrowserCellDelegate?.respondsToSelector("photoBrowserClose:")) != nil)
        {
            photoBrowserCellDelegate?.photoBrowserClose(self)
        }
        
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
    lazy var activity : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
}

extension PhotoBrowserCell : UIScrollViewDelegate
{
    //告诉代理，缩放的是哪个view
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageV
    }
    
    //缩放结束后调整位置
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        //这里view!.frame.width 之所以不用bounds, 是因为变形后，bounds 也是不变的
        var x = (UIScreen.mainScreen().bounds.width - view!.frame.width)*0.5
        var y = (UIScreen.mainScreen().bounds.height - view!.frame.height)*0.5
        
        //当放大到一定程度，x, y 会变成负数
        x = x < 0 ? 0 : x
        y = y < 0 ? 0 : y
        
        scroller.contentInset = UIEdgeInsets(top: y, left: x, bottom: y, right: x)
        
    }
}
