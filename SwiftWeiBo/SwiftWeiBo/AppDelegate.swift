//
//  AppDelegate.swift
//  SwiftWeiBo
//
//  Created by Imanol on 1/11/16.
//  Copyright © 2016 imanol. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let vc = NewfeatureCollectionViewController()
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

}

