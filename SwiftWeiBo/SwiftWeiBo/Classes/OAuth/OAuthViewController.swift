//
//  OAuthViewController.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/3/15.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {
    
    let App_Key = "2638616959"
    let App_Secret = "0a061664749e4678e9040cf7de67cba3"
    let redirect_uri = "http://weibo.com/jk54"

    
    override func loadView() {
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //设置导航栏
        navigationItem.title = "Imanol WEIBO"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        
        //加载
        let strUrl = "https://api.weibo.com/oauth2/authorize?client_id=\(App_Key)&redirect_uri=\(redirect_uri)"
        let url = NSURL(string: strUrl)
        let request = NSURLRequest(URL: url!)
        
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - PRIVATE
     func close(){
        dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    //MARK: - lazy
    private lazy var webView:UIWebView = {
        let webView = UIWebView()
        return webView
    }()

}
