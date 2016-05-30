//
//  SQLiteManager.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/5/30.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

class SQLiteManager: NSObject {
    
    static let manager : SQLiteManager = SQLiteManager()
    
    //MARK :- 单例
    class func shareSQLiteManager()->SQLiteManager{
        return manager
    }
    
    var dbQueue : FMDatabaseQueue?
    
    func openDB(DBName : String){
        // 1.根据传入的数据库名称拼接数据库路径
        let dbPath = DBName.DocumentDir()
        
        // 2.创建数据库对象
        // 注意: 如果是使用FMDatabaseQueue创建数据库对象, 那么就不用打开数据库
        dbQueue = FMDatabaseQueue(path: dbPath)
        
        //创建表
        createTable()
    }
    
    func createTable(){
        // 编写SQL语句
        let sql = "CREATE TABLE IF NOT EXISTS T_Status( \n" +
            "statusId INTEGER PRIMARY KEY, \n" +
            "statusText TEXT, \n" +
            "userId INTEGER, \n" +
            "createDate TEXT NOT NULL DEFAULT (datetime('now', 'localtime')) \n" +
        "); \n"
        
        //执行
        dbQueue?.inDatabase({ (db) -> Void in
            if !db.executeUpdate(sql, withArgumentsInArray: nil)
            {
                print("创建table失败")
            }else{
                print("创建table成功")
            }
        })
    }

}
