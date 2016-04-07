//
//  WelcomeViewController.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/4/7.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit
class WelcomeViewController: UIViewController {
    
    var bottomCons: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.add subview
        view.addSubview(bgIV)
        view.addSubview(iconView)
        view.addSubview(messageLabel)
        
        // 2.layout

        bgIV.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        
        //iconView
        iconView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(100, 100))
            make.centerX.equalTo(view)
            
        }
        
        let iconBottm = NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -150)
        bottomCons = iconBottm
        view.addConstraint(iconBottm)
        
        
        //messageLabel
        messageLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(iconView).offset(0)
            make.top.equalTo(iconView.snp_bottom).offset(20)
            //make.width.equalTo(100)
        }
        
        
        // 3.设置用户头像
        if let iconUrl = UserAccount.loadAccount()?.avatar_large
        {
            let url = NSURL(string: iconUrl)!
            iconView.sd_setImageWithURL(url)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        //bottomCons?.constant = -UIScreen.mainScreen().bounds.height -  bottomCons!.constant;
        // -736.0 + 586.0 = -150.0
        //
        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            // 头像动画
            self.bottomCons?.constant = -UIScreen.mainScreen().bounds.height -  self.bottomCons!.constant;
            self.iconView.layoutIfNeeded()
            
            }) { (_) -> Void in
                
                // 文本动画
                UIView.animateWithDuration( 2.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    self.messageLabel.alpha = 1.0
                    }, completion: { (_) -> Void in
                        print("OK")
                })
        }

    }

    // MARK: -lazyLoad
    private lazy var bgIV: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome Back~"
        label.sizeToFit()
        label.alpha = 0.0
        return label
    }()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
