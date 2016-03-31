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
    var expires_in : NSNumber?{
        didSet{
            expires_Date = NSDate(timeIntervalSinceNow: expires_in!.doubleValue)
            print("expires_Date\(expires_Date)")
        }
    }
    var uid : String?
    var expires_Date : NSDate?
    var avatar_large: String?
    var screen_name: String?
    
    override init() {
        
    }
    init(dict : [String : AnyObject]){
        super.init()
        //直接在init构造方法里面 这样直接赋值，是不会调用 上方 didSet方法
//        access_token = dict["access_token"] as? String;
//        uid = dict["uid"] as? String;
//        expires_in = dict["expires_in"] as? NSNumber;
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        print(key)
    }
    
    override var description: String{
        // 1.定义属性数组
        let properties = ["access_token", "expires_in", "uid","expires_Date","avatar_large","screen_name"]
        // 2.根据属性数组, 将属性转换为字典
        let dict =  self.dictionaryWithValuesForKeys(properties)
        // 3.将字典转换为字符串
        return "\(dict)"
    }
    
    //加载用户信息
    func loadUserInfo(finished: (account: UserAccount?, error:NSError?)->()){
        let url = "2/users/show.json"
        let param = ["access_token":access_token!, "uid":uid!]
        NetworkTools.shareNetworkTools().GET(url, parameters: param, progress: nil, success: { (_, json) -> Void in
            if let dict = json
            {
                print(json)
                self.avatar_large = dict["avatar_large"] as? String
                self.screen_name = dict["screen_name"] as? String
                finished(account: self, error: nil)
                return
            }
            finished(account: nil, error: nil)
            }) { (_, error) -> Void in
                finished(account: nil, error: error)
        }
       
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
        
        if account?.expires_Date?.compare(NSDate()) == NSComparisonResult.OrderedAscending
        {
            // 已经过期
            return nil
        }

        
        return account
    }
    
    //MARK: - NSCoding 归档 解档
    ///  归档，aCoder 编码器，将对象转换成二进制数据保存到磁盘，和序列化很像
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
    }
    
    ///  解档方法，aDecoder 解码器，将保存在磁盘的二进制文件转换成 对象，和反序列化很像
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
        
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        
    }
    

}
