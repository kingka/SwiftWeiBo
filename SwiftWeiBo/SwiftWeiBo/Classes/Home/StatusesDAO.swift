//
//  StatusesDAO.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/5/30.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

class StatusesDAO: NSObject {
    
    func loadStatues(){
        
        //1 读取本地DB data
        //2 如果有 直接返回
        //3 如果没 从网络获取 返回
        //4 缓存网络数据
    }
    
    class func cacheStatuses(status : [[String : AnyObject]]){
        
        //缓存字段 ： statusId（每条微博的id） statusText(网络返回的微博数据) userId（当前登陆的微博用户id）
        let userId = UserAccount.account?.uid
        
        let sql = "INSERT INTO T_Status(" +
        "statusId,statusText,userId)" +
        "VALUES" +
        "(?,?,?);"
        
        SQLiteManager.shareSQLiteManager().dbQueue!.inTransaction { (db, rollback) -> Void in
            for dict in status
            {
                let statusId = dict["id"]
                // JSON -> 二进制 -> 字符串 , 把字符串存DB
                let data = try! NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
                let statusText = String(data: data, encoding: NSUTF8StringEncoding)
               if !db.executeUpdate(sql, statusId!,statusText!,userId!)
               {
                    print("插入失败")
                    //如果插入数据失败, 就回滚
                    rollback.memory = true
               }else{
                    print("\(statusId)"+"insert success!")
                }
            }
        }
    }

}
