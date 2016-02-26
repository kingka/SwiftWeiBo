//
//  QRCodeController.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/2/26.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

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
    }

    @IBAction func close(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
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
}
