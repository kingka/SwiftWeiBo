//
//  ComposeViewController.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/5/12.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {
    
    var toolBarBottomCons : NSLayoutConstraint?
    
    override func viewWillAppear(animated: Bool) {
        //textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        textView.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.whiteColor()
        setupNav()
        setupTextView()
        setupToolBar()
    }
    
    func setupTextView(){
        view.addSubview(textView)
        textView.delegate = self
        textView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
            make.height.equalTo(300)
        }
        textView.font = UIFont.systemFontOfSize(15)
        
        textView.addSubview(textViewTip)
        textViewTip.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(textView).offset(5)
            make.right.equalTo(textView)
            make.top.equalTo(textView).offset(8)
            make.height.equalTo(18)
        }
    }
    
    func setupToolBar(){
        view.addSubview(toolBar)
        //autoLayout
        toolBar.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(44)
        }
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        self.toolBarBottomCons = NSLayoutConstraint(item: toolBar, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        view.addConstraint(toolBarBottomCons!)
    }
    
    func setupNav(){
        
        // left
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel")
        //right
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: "send")
        navigationItem.rightBarButtonItem?.enabled = false
        //titleview
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        navigationItem.titleView = titleView
        
        titleView.addSubview(titleLabel)
        titleView.addSubview(titleName)
        
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(titleView)
            make.right.equalTo(titleView)
            make.top.equalTo(titleView)
            make.height.equalTo(17)
            
        }
        
        titleName.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(titleView)
            make.right.equalTo(titleView)
            make.bottom.equalTo(titleView)
            make.height.equalTo(15)
            
        }
        
    }
    
    func cancel(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func send(){
        let path = "2/statuses/update.json"
        let params = ["access_token":UserAccount.loadAccount()?.access_token,"status":textView.text]
        NetworkTools.shareNetworkTools().POST(path, parameters: params, success: { (_, json) -> Void in
                SVProgressHUD.showSuccessWithStatus("发送成功")
                self.cancel()
            }) { (_, error) -> Void in
                SVProgressHUD.showErrorWithStatus("发送失败")
        }
    }
    
    func selectPicture(){
        print(__FUNCTION__)
    }
    
    func inputEmoticon(){
        print(__FUNCTION__)
    }
    
    //MARK: -LAZY LOADING
    private lazy var toolBar : UIToolbar = {
        let toolBar = UIToolbar()
        var items = [UIBarButtonItem]()
        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "selectPicture"],
            
            ["imageName": "compose_mentionbutton_background"],
            
            ["imageName": "compose_trendbutton_background"],
            
            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
            
            ["imageName": "compose_addbutton_background"]]
        for dict in itemSettings
        {
           let item = UIBarButtonItem(imageName: dict["imageName"]!, target: self, action: dict["action"])
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolBar.items = items
        return toolBar
    }()
    
    private lazy var titleLabel:UILabel = {
        let title = UILabel()
        title.text = "发微博"
        title.textColor = UIColor.blackColor()
        title.font = UIFont.systemFontOfSize(15)
        title.textAlignment = NSTextAlignment.Center
        return title
    }()
    
    private lazy var titleName:UILabel = {
        let titleName = UILabel()
        titleName.text = UserAccount.loadAccount()?.screen_name
        titleName.textColor = UIColor.darkGrayColor()
        titleName.font = UIFont.systemFontOfSize(13)
        titleName.textAlignment = NSTextAlignment.Center
        return titleName
    }()
    
    private lazy var textView:UITextView = UITextView()
    private lazy var textViewTip:UILabel = {
        let title = UILabel()
        title.text = "分享新鲜事..."
        title.textColor = UIColor.darkGrayColor()
        title.font = UIFont.systemFontOfSize(15)
        return title
    }()
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ComposeViewController : UITextViewDelegate
{
    func textViewDidChange(textView: UITextView) {
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
        textViewTip.hidden = textView.hasText()
    }
}
