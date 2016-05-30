//
//  AppDelegate.swift
//  SwiftWeiBo
//
//  Created by Imanol on 1/11/16.
//  Copyright © 2016 imanol. All rights reserved.
//

import UIKit

let weiboSwitchRootControllerKey = "weiboSwitchRootControllerKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //create db
        SQLiteManager.shareSQLiteManager().openDB("weibo.db")
        
        //clean outdate 
        StatusesDAO.cleanStatuses()
        
        //add notification obser
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchRootController:", name: weiboSwitchRootControllerKey, object: nil)
        
        let vc = defaultController()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        setupApprence()
        return true
    }
    
    func setupApprence(){
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
    }
    
    func defaultController()->UIViewController{
        if UserAccount.userLogin()
        {
            return isNewUpdate() ? NewfeatureCollectionViewController() :  WelcomeViewController()
        }
        return MainViewController()
        
    }
    
    func switchRootController(notify : NSNotification){
        let value = notify.object as! Bool
        if value{
           window?.rootViewController = MainViewController()
        }else{
            window?.rootViewController = WelcomeViewController()
        }
        
    }
    
    func isNewUpdate()->Bool{
        
        //1 获取当前version
        let currentV = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        //2 获取以前版本
        let oldVersion = NSUserDefaults.standardUserDefaults().valueForKey("CFBundleShortVersionString") as? String ?? ""
        //3 比较
        if currentV.compare(oldVersion) == NSComparisonResult.OrderedDescending
        {
                NSUserDefaults.standardUserDefaults().setValue(currentV, forKey: "CFBundleShortVersionString")
            
                return true
        }
        return false
    }

}

