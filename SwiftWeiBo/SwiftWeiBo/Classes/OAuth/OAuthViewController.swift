//
//  OAuthViewController.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/3/15.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {
    
    let App_Key = "2638616959"
    let App_Secret = "0a061664749e4678e9040cf7de67cba3"
    let redirect_uri = "http://weibo.com/jk54"

    //MARK: - Lifycycle
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
        
        webView.delegate = self;
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

extension OAuthViewController:UIWebViewDelegate{
    
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.showInfoWithStatus("Loading....")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        
        //print(request.URL?.query)
        
        //获取未授权的token返回的url：https://api.weibo.com/oauth2/authorize?client_id=2638616959&redirect_uri=http://weibo.com/jk54
        //登陆后 url:https://api.weibo.com/oauth2/authorize
        //授权 url:http://weibo.com/jk54?code=b3d1eeee480ca72b7501c774d6efebad
        //取消授权 url:http://weibo.com/jk54?error_uri=%2Foauth2%2Fauthorize&error=access_denied&error_description=user%20denied%20your%20request.&error_code=21330
        
        let absoluteUrl = request.URL?.absoluteString
        //判断是否授权回掉页，不是的话就继续加载
        if(!absoluteUrl!.hasPrefix(redirect_uri)){
            return true
        }
        
        let codeStr = "code="
        //如果有code 表示授权成功
        if(request.URL!.query!.hasPrefix(codeStr)){
            let code = request.URL?.query?.substringFromIndex(codeStr.endIndex);
            loadAccessToken(code!)
            close()
        }else{
            close()
        }
        
        return false
    }
    
    func loadAccessToken(code:String){
        let networkTools = NetworkTools.shareNetworkTools()
        // 1.定义路径
        let path = "oauth2/access_token"
        // 2.封装参数
        let params = ["client_id":App_Key, "client_secret":App_Secret, "grant_type":"authorization_code", "code":code, "redirect_uri":redirect_uri]
        networkTools.POST(path, parameters: params, progress: { (_) -> Void in
            
            }, success: { (_, JSON) -> Void in
                //2.00aY6iACDo3ZsCf33b0623aelanWND
                
                // 创建userAccount model
                let userAccount = UserAccount(dict:JSON as! [String : AnyObject])
                print(userAccount)
                // 归档userAccount
                userAccount.saveAccount()
                
            }) { (_, ERROR) -> Void in
                print(ERROR)
        }
    }
    
}

