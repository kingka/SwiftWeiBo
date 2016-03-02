//
//  QRCodeController.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/2/26.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeController: UIViewController,UITabBarDelegate {

    @IBOutlet weak var chongjiTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scanLineView: UIImageView!
    @IBOutlet weak var customTabbar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTabbar.selectedItem = customTabbar.items![0]
        customTabbar.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        startAnimation()
        startScan()
    }

    @IBAction func close(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func startScan(){
        //1 判断是否能够讲输入添加到会话
        if (!session.canAddInput(deviceInput)){
            return
        }
        //2 判断时候能够将输出添加到会话
        if (!session.canAddOutput(output)){
            return
        }
        //3 将输入输出添加到会话
        session.addInput(deviceInput)
        session.addOutput(output)
        //4 设置输出能够解析的数据类型
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        //注意: 设置能够解析的数据类型, 一定要在输出对象添加到会员之后设置, 否则会报错
        //5 设置输出对象的代理，只要解析成功就通知代理
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        //添加预览图层
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        //6 告诉session 开始扫描
        session.startRunning()
    }
    
    func startAnimation(){
        //让约束从顶部开始
        self.chongjiTopConstraint.constant = -self.heightConstraint.constant;
        print(self.chongjiTopConstraint.constant)
        //强制刷新
        self.scanLineView.layoutIfNeeded()
        
        //动画
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            self.chongjiTopConstraint.constant = self.heightConstraint.constant
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.scanLineView.layoutIfNeeded()
            }) { (_) -> Void in
                
        };

    }
    //MARK:-UITabBarDelegate
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag == 1 {
            print("二维码")
            self.heightConstraint.constant = 300
        }else{
            print("条形码")
            self.heightConstraint.constant = 150
        }
        
        //停止动画
        self.scanLineView.layer.removeAllAnimations()
        //重新开始
        startAnimation()
    }
    
    // MARK: - LAZY
    private lazy var session:AVCaptureSession = AVCaptureSession()
    
    private lazy var deviceInput:AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do{
            let input = try AVCaptureDeviceInput(device: device)
            return input
        }catch{
            print(error)
            return nil
        }
    }()
    
    private lazy var output:AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
    
}

extension QRCodeController:AVCaptureMetadataOutputObjectsDelegate{
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        print(metadataObjects.last?.stringValue)
    }
    
}
