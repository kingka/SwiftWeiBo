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
    
    init(dict : [String : AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    /// 用户是否登录标记
    class func userLogin() -> Bool {
        return loadAccount() != nil
    }
    
    //MARK: - 保存授权信息
    static let accountPath = ( NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("account.plist")
    
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
