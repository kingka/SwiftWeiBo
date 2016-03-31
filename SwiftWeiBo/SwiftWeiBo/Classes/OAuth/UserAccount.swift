//
//  UserAccount.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/3/23.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit


class UserAccount: NSObject,NSCoding {

    var access_token : String?
    var expires_in : NSNumber?
    var uid : String?
    
    override init() {
        
    }
    init(dict : [String : AnyObject]){
        super.init()
        access_token = dict["access_token"] as? String;
        uid = dict["uid"] as? String;
        expires_in = dict["expires_in"] as? NSNumber;
        
    }
    
    override var description: String{
        // 1.定义属性数组
        let properties = ["access_token", "expires_in", "uid"]
        // 2.根据属性数组, 将属性转换为字典
        let dict =  self.dictionaryWithValuesForKeys(properties)
        // 3.将字典转换为字符串
        return "\(dict)"
    }
    
    /// 用户是否登录标记
    class func userLogin() -> Bool {
        return loadAccount() != nil
    }
    
    //MARK: - 保存授权信息
    static let accountPath = "account.plist".CacheDir()
    
    func saveAccount(){
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.accountPath)
    }
    
    static var account:UserAccount?
    class func loadAccount()->UserAccount?{
    
        if account != nil
        {
            return account
        }
        
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(UserAccount.accountPath) as? UserAccount
        
        return account
    }
    
    //MARK: - NSCoding 归档 解档
    ///  归档，aCoder 编码器，将对象转换成二进制数据保存到磁盘，和序列化很像
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
    }
    
    ///  解档方法，aDecoder 解码器，将保存在磁盘的二进制文件转换成 对象，和反序列化很像
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
        
    }
    

}
