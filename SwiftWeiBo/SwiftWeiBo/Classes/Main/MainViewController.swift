//
//  MainViewController.swift
//  SwiftWeiBo
//
//  Created by Imanol on 1/11/16.
//  Copyright © 2016 imanol. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.grayColor()
        
        //模拟从server 获取json,例如已经获取到
        //1 得到json 路径
        let jsonPath = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil)
        //2 加载json
        if let path = jsonPath{
            let data = NSData(contentsOfFile:path)
            //3 序列化json
            do{
                let dictArray = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                
                for dict in dictArray as! [[String:String]]{
                    addChildViewController(dict["vcName"]!, imageName: dict["imageName"]!, title: dict["title"]!)
                }
            }catch{
                
                addChildViewController("HomeTableViewController", imageName:"tabbar_home", title: "")
                addChildViewController("MessageTableViewController", imageName: "tabbar_message_center", title:"" )
                addChildViewController("DiscoverTableViewController", imageName: "tabbar_discover", title: "")
                addChildViewController("ProfileTableViewController", imageName: "tabbar_profile", title:"" )
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //MARK:- 通过String 动态生成 Class
    private func addChildViewController(childControllerString: String,imageName:String,title:String) {
        // 1 动态获取NameSpace
        let nameSpace = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        // 告诉编译器暂时就是AnyClass
        let cls:AnyClass = NSClassFromString(nameSpace+"."+childControllerString)!
        //告诉编译器真实类型是UIViewController
        let vcCls = cls as! UIViewController.Type
        // 实例化控制器
        let vc = vcCls.init()
        
        //初始化
        let nav = UINavigationController()
        nav.addChildViewController(vc)
        addChildViewController(nav)
        vc.tabBarItem.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName+"_highlighted")
        tabBar.tintColor = UIColor.orangeColor()
        vc.navigationItem.title = title
        print(vc)
        
    }
/*
    private func addChildViewController(childController: UIViewController,imageName:String,title:String) {
        let nav = UINavigationController()
        nav.addChildViewController(childController)
        addChildViewController(nav)
        childController.tabBarItem.title = title
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: imageName+"_highlighted")
        tabBar.tintColor = UIColor.orangeColor()
        childController.navigationItem.title = title
    }
*/
    

}
