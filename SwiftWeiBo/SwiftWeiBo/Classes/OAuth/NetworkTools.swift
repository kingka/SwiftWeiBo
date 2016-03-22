//
//  NetworkTools.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/3/22.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkTools: AFHTTPSessionManager {

   static let tools:NetworkTools = {
    
        let url = NSURL(string: "https://api.weibo.com/")
        let tool = NetworkTools(baseURL: url)
        //设置AFN能够接收得数据类型
        tool.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as! Set<String>
        return tool
    }()
    
    
    class func shareNetworkTools()->NetworkTools {
        return tools
    }
}
