//
//  Statuses.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/4/14.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit
import SDWebImage

//这里是为了cell 的重复利用以及判断是哪一种cell
enum statusType : String{
    case forwordCell = "forwordCell"
    case normalCell = "normalCell"
    
    static func cellID(status:Statuses)->String{
    
        return status.retweeted_status != nil ? forwordCell.rawValue : normalCell.rawValue
    }
}

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
            largePicURLS = [NSURL]()
            for dict in pic_urls!{
                if let urlStr = dict["thumbnail_pic"]
                {
                    // 将字符串转换为URL保存到数组中
                    picURLS?.append(NSURL(string: urlStr as! String)!)
                    // 2.处理大图
                    let largeURLStr = urlStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "large")
                    largePicURLS!.append(NSURL(string: largeURLStr)!)
                }
            }
        }
    }
    var picURLS : [NSURL]?
    var largePicURLS : [NSURL]?
    var user : User?
    ///转发微博
    var retweeted_status : Statuses?
    //如果没有转发，保存的是原创配图URL，反之保存转发配图URL
    var retweetedPicURLS : [NSURL]?{
        return retweeted_status != nil ? retweeted_status?.picURLS : picURLS
    }
    var retweetedLargePicURLS : [NSURL]?{
        return retweeted_status != nil ? retweeted_status?.largePicURLS : largePicURLS
    }
    
    class func dict2model(list:[[String : AnyObject]])->[Statuses]{
       
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
            return
        }
        
        if "retweeted_status" == key
        {
            retweeted_status = Statuses(dict: value as! [String : AnyObject])
            return
        }
    }
    
    class func loadStatuses(since_id:Int , max_id : Int ,finished:(list:[Statuses]?,error:NSError?)->()){
        
        StatusesDAO.loadStatues(since_id, max_id: max_id) { (dicts, error) -> () in
            if dicts == nil{
                finished(list: nil, error: nil)
            }
            
            if error != nil{
                finished(list: nil, error: error)
                return
            }
            
            let models = dict2model(dicts!)
            cacheImages(models, finished: finished)
            
        }
//        let url = "2/statuses/home_timeline.json"
//        var param = ["access_token":UserAccount.loadAccount()!.access_token!]
//        // 下拉刷新
//        if since_id > 0
//        {
//            param["since_id"] = "\(since_id)"
//        }
//        
//        if  max_id > 0
//        {
//            param["max_id"] = "\(max_id - 1)"
//        }
//        
//
//        NetworkTools.shareNetworkTools().GET(url, parameters: param, progress: nil, success: { (_, Json) -> Void in
//            
//            StatusesDAO.cacheStatuses(Json!["statuses"] as! [[String: AnyObject]])
//            
//                //1 json to model , 然后装在集合
//            //print("json= \(Json)")
//            let models = dict2model(Json!["statuses"] as! [[String: AnyObject]])
//            
//            //cache
//            cacheImages(models, finished: finished)
//            }) { (_, error) -> Void in
//                finished(list: nil, error: error)
//        }
    }
    
    class func cacheImages(list:[Statuses],finished:(list:[Statuses]?,error:NSError?)->()){
        
        let group = dispatch_group_create()
        
        for status in list{
            
            guard let _ = status.retweetedPicURLS else
            {
                continue
            }
            for url in status.retweetedPicURLS!{
                dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (_, _, _, _, _) -> Void in
                    
                        dispatch_group_leave(group)
                })
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            print("xiazai finished!")
            finished(list: list, error: nil)
        }
        
    }
    
    // description
    var properties = ["created_at", "id", "text", "source", "pic_urls"]
    override var description: String {
        let dict = dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }
}
