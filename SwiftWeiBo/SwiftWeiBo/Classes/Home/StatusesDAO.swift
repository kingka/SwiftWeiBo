//
//  StatusesDAO.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/5/30.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

class StatusesDAO: NSObject {
    
    /// 清空过期的数据
    class  func cleanStatuses() {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = NSLocale(localeIdentifier: "en")
        
        let date = NSDate(timeIntervalSinceNow: -60)
        let dateStr = formatter.stringFromDate(date)
         print("dateStr:\(dateStr)")
        
        // 定义SQL语句
        let sql = "DELETE FROM T_Status WHERE createDate  <= '\(dateStr)';"
        
        // 执行SQL语句
        SQLiteManager.shareSQLiteManager().dbQueue?.inDatabase({ (db) -> Void in
            db.executeUpdate(sql, withArgumentsInArray: nil)
        })
    }
    
    class func loadStatues(since_id: Int, max_id: Int, finished:(dicts:[[String : AnyObject]]?,error:NSError?)->()){
        
        //1 读取本地DB data
        readCacheStatuses(since_id, max_id: max_id) { (list) -> () in
            if !list.isEmpty
            {
                //2 如果有 直接返回
                finished(dicts: list, error: nil)
                print("缓存读取~~")
                return
            }
            
            //3 如果没 从网络获取 返回
            print("网络加载~~")
            let url = "2/statuses/home_timeline.json"
            var param = ["access_token":UserAccount.loadAccount()!.access_token!]
            // 下拉刷新
            if since_id > 0
            {
                param["since_id"] = "\(since_id)"
            }
            
            if  max_id > 0
            {
                param["max_id"] = "\(max_id - 1)"
            }
            
            NetworkTools.shareNetworkTools().GET(url, parameters: param, progress: nil, success: { (_, Json) -> Void in
                
                let list = Json!["statuses"] as! [[String: AnyObject]]
                //4 缓存网络数据
                cacheStatuses(list)
                //5 返回
                finished(dicts: list, error: nil)
                
                }) { (_, error) -> Void in
                    //加载网络数据失败
                    finished(dicts: nil, error: error)
                    
            }

        }
        
        
        
    }
    
     class func readCacheStatuses(since_id: Int, max_id: Int, finished:([[String : AnyObject]])->()){
        
        // 1.定义SQL语句
        var sql = "SELECT * FROM T_Status \n"
        if since_id > 0
        {
            sql += "WHERE statusId > \(since_id) \n"
        }else if max_id > 0
        {
            sql += "WHERE statusId < \(max_id) \n"
        }
        
        sql += "ORDER BY statusId DESC \n"
        sql += "LIMIT 20; \n"
        
        //执行
        SQLiteManager.shareSQLiteManager().dbQueue?.inDatabase({ (db) -> Void in
           let result = db.executeQuery(sql, withArgumentsInArray: nil)
            
            var dicts = [[String : AnyObject]]()
            while result.next()
            {
                //把字符串转换成字典
                let statusText = result.stringForColumn("statusText")! as String
                let data = statusText.dataUsingEncoding(NSUTF8StringEncoding)!
                let dict = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [String : AnyObject]
                dicts.append(dict)
            }
            
            finished(dicts)
        })
    }
    
    class func cacheStatuses(status : [[String : AnyObject]]){
        
        //缓存字段 ： statusId（每条微博的id） statusText(网络返回的微博数据) userId（当前登陆的微博用户id）
        let userId = UserAccount.account?.uid
        
        let sql = "INSERT INTO T_Status(" +
        "statusId,statusText,userId) " +
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
                    print("插入失败,回滚")
                    //如果插入数据失败, 就回滚
                    rollback.memory = true
               }else{
                    //print("\(statusId)"+"insert success!")
                }
            }
        }
    }

}
