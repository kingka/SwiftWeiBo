//
//  Statuses.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/4/14.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit
import SDWebImage

class Statuses: NSObject {

    var created_at : String?{
        didSet{
            let date = NSDate.dateWithStr(created_at!)
            created_at = date.descDate
        }
    }
    var id : Int = 0
    var text : String?
    var source : String?{
        didSet{
            if source == ""{
                return
            }
            let sourceStr = source! as NSString
            let startRange = sourceStr.rangeOfString(">").location+1
            let length = sourceStr.rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startRange
            source = sourceStr.substringWithRange(NSMakeRange(startRange, length))
        }
    }
    var pic_urls : [[String : AnyObject]]?{
        didSet{
            picURLS = [NSURL]()
            for dict in pic_urls!{
                if let urlStr = dict["thumbnail_pic"]
                {
                    // 将字符串转换为URL保存到数组中
                    picURLS?.append(NSURL(string: urlStr as! String)!)
                }
            }
        }
    }
    var picURLS : [NSURL]?
    var user : User?
    
    
    class func dict2model(list:[[String : AnyObject]])->[Statuses]{
        //let keys = ["created_at","id","text","source","pic_urls"]
        var models = [Statuses]()
        for dict in list
        {
            let model = Statuses(dict: dict)
            models.append(model)
        }
        return models
    }
    
    init(dict : [String : AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        //print(key)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        super.setValue(value, forKey: key)
        if "user" == key
        {
            user = User(dict: value as! [String : AnyObject])
            
        }
    }
    
    class func loadStatuses(finished:(list:[Statuses]?,error:NSError?)->()){
        let url = "2/statuses/home_timeline.json"
        let param = ["access_token":UserAccount.loadAccount()!.access_token!]
        NetworkTools.shareNetworkTools().GET(url, parameters: param, progress: nil, success: { (_, Json) -> Void in
                //1 json to model , 然后装在集合
            print("json= \(Json)")
            let models = dict2model(Json!["statuses"] as! [[String: AnyObject]])
            
            //cache
            cacheImages(models)
            
            finished(list: models, error: nil)
            }) { (_, error) -> Void in
                finished(list: nil, error: error)
        }
    }
    
    class func cacheImages(list:[Statuses]){
        
        let group = dispatch_group_create()
        
        for status in list{
            
            guard let _ = status.picURLS else
            {
                continue
            }
            for url in status.picURLS!{
                dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (_, _, _, _, _) -> Void in
                    
                        dispatch_group_leave(group)
                })
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            print("xiazai finished!")
        }
        
    }
    
    // description
    var properties = ["created_at", "id", "text", "source", "pic_urls"]
    override var description: String {
        let dict = dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }
}
