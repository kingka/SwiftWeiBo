//
//  MyQRCodeCard.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/3/4.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

class MyQRCodeCard: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置标题
        navigationItem.title = "我的名片"
        let imageView = qrcodeImageView
        imageView.backgroundColor = UIColor.redColor()
        view.backgroundColor = UIColor.whiteColor()
        // 添加imageView
        view.addSubview(imageView)
        // 布局imageView
        //这句很重要
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageViewCenterX = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let imageViewCenterY = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let imageViewWidth = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 300)
        let imageViewHeight = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 300)
        view.addConstraint(imageViewCenterX)
        view.addConstraint(imageViewCenterY)
        imageView.addConstraint(imageViewWidth)
        imageView.addConstraint(imageViewHeight)
        // 创建二维码
        let qrcodeImage = createQrcodeImage()
        // 把二维码装进imageView
        imageView.image = qrcodeImage
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func createQrcodeImage()->UIImage?{
        //1 创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        //2 还原滤镜默认属性
        filter?.setDefaults()
        //3 设置数据
        filter?.setValue("Imanol".dataUsingEncoding(NSUTF8StringEncoding), forKey: "inputMessage")
        //4 从滤镜中取出生成好的图片
        let ciImage = filter?.outputImage
        let bgImage = UIImage(CIImage: ciImage!)
        //5 创建一个头像
        //let icon = UIImage(named: "")
        //6 合成图像
        //let newImage = createImage(bgImage,icon: icon!)
        //7 返回图像
        return bgImage
      
       

    }
    
    private func createImage(bgImg:UIImage, icon:UIImage)->UIImage?{
        return nil
    }
    private lazy var qrcodeImageView:UIImageView = UIImageView()
}
