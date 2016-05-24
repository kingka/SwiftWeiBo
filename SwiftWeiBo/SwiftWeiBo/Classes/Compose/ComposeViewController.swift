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
    var photoViewHeightCons : NSLayoutConstraint?
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if photoViewHeightCons?.constant == 0
        {
            textView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.whiteColor()
        setupNav()
        setupTextView()
        setupPhotoSelectorView()
        setupToolBar()
        
        //obser keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardFrameChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        //将表情键盘控制器添加为当前控制器的子控制器
        addChildViewController(emoticonVC)
        //将图片选择控制器添加为当前控制器的子控制器
        addChildViewController(photoSelctorVC)
    }
    
    func keyBoardFrameChange(notify : NSNotification){
        //print(notify)
        //adjust toolBar layout
        let keyboardEndFrame = notify.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue
        let frame = keyboardEndFrame.CGRectValue()
        
        toolBarBottomCons?.constant = -(UIScreen.mainScreen().bounds.height - frame.origin.y)
        
        // update UI
        let duration = notify.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        /*
        当点击emotion 表情切换键盘的时候，工具条回弹是因为执行了两次动画, 而系统自带的键盘的动画节奏(曲线) 7
        7在apple API中并没有提供给我们, 但是我们可以使用
        7这种节奏有一个特点: 如果连续执行两次动画, 不管上一次有没有执行完毕, 都会立刻执行下一次
        也就是说上一次可能会被忽略
        
        如果将动画节奏设置为7, 那么动画的时长无论如何都会自动修改为0.5
        
        UIView动画的本质是核心动画, 所以可以给核心动画设置动画节奏
        */
        
        //取出键盘动画节奏
        let curve = notify.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        UIView.animateWithDuration(duration.doubleValue) { () -> Void in
            //设置动画节奏
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve.integerValue)!)
            self.view.layoutIfNeeded()
        }

        //let anim = toolBar.layer.animationForKey("position")
        //print("duration = \(anim?.duration)")

    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func setupTextView(){
        view.addSubview(textView)
        textView.delegate = self
        textView.alwaysBounceVertical = true
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
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
    
    func setupPhotoSelectorView(){
        view.insertSubview(photoSelctorVC.view, belowSubview: toolBar)
        
        //layout
        photoSelctorVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.photoViewHeightCons = NSLayoutConstraint(item: photoSelctorVC.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0)
        photoSelctorVC.view.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        photoSelctorVC.view.addConstraint(photoViewHeightCons!)
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
        let params = ["access_token":UserAccount.loadAccount()!.access_token!,"status":textView.emoticonStr()]
        NetworkTools.shareNetworkTools().POST(path, parameters: params, success: { (_, json) -> Void in
                SVProgressHUD.showSuccessWithStatus("发送成功")
                self.cancel()
            }) { (_, error) -> Void in
                SVProgressHUD.showErrorWithStatus("发送失败")
        }
    }
    
    func selectPicture(){
       // print(__FUNCTION__)
        photoViewHeightCons?.constant = UIScreen.mainScreen().bounds.height * 0.5
        view.layoutIfNeeded()
        textView.resignFirstResponder()
    }
    
    func inputEmoticon(){
        //print(__FUNCTION__)
        // 结论: 如果是系统自带的键盘, 那么inputView = nil
        //      如果不是系统自带的键盘, 那么inputView != nil
        //        print(textView.inputView)
        
        //1 close keyboard
        textView.resignFirstResponder()
        //2 set new inputView
        textView.inputView = (textView.inputView == nil) ? emoticonVC.view : nil
        //4 show keyboard
        textView.becomeFirstResponder()
    }
    
    //MARK: -LAZY LOADING
    lazy var photoSelctorVC : PhotoSelectorViewController = PhotoSelectorViewController()
    
    // weak 相当于OC中的 __weak , 特点对象释放之后会将变量设置为nil
    // unowned 相当于OC中的 unsafe_unretained, 特点对象释放之后不会将变量设置为nil
    lazy var emoticonVC : EmoticonViewController = EmoticonViewController { [weak self](emoticon) -> () in
        
        self!.textView.insertEmoticons(emoticon)
        
    }

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
