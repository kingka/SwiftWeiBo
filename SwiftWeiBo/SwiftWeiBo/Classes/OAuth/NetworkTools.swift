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
    
    func sendWeibo(text : String, image : UIImage?,successCallback:(status:Statuses)->(),errorCallback:(error:NSError)->()){
        
        var path = "2/statuses/"
        let params = ["access_token":UserAccount.loadAccount()!.access_token!,"status":text]

        if image != nil
        {
            path += "upload.json"
            NetworkTools.shareNetworkTools().POST(path, parameters: params, constructingBodyWithBlock: { (formData) -> Void in
                //将图片转为二进制
                let data = UIImagePNGRepresentation(image!)
                // 上传数据
                /*
                第一个参数: 需要上传的二进制数据
                第二个参数: 服务端对应哪个的字段名称
                第三个参数: 文件的名称(在大部分服务器上可以随便写)
                第四个参数: 数据类型, 通用类型application/octet-stream
                */
                
                formData.appendPartWithFileData(data!, name: "pic", fileName: "all.png", mimeType: "application/octet-stream")
                
                },progress:nil, success: { (_, json) -> Void in
                   successCallback(status: Statuses(dict: json as! [String : AnyObject]))
                }, failure: { (_, error) -> Void in
                   
                    errorCallback(error: error)
            })
        }else{
            path += "update.json"
            NetworkTools.shareNetworkTools().POST(path, parameters: params, progress: nil, success: { (_, json) -> Void in
                
                successCallback(status: Statuses(dict: json as! [String : AnyObject]))
                }, failure: { (_, error) -> Void in
                    
                    errorCallback(error: error)
            })
        }
        

    }
}
