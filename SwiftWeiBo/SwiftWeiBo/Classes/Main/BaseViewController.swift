//
//  BaseViewController.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/1/13.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {

    let isLogin:Bool = false
    var visitView:VisitView?
    override func loadView() {
        isLogin ? super.loadView() : setupCustomView()
    }
    
    func setupCustomView(){
        
        visitView = VisitView?()
        view = visitView
    }
}
