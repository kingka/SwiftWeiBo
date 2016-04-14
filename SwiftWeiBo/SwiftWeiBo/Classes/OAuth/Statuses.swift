//
//  Statuses.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/4/14.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

class Statuses: NSObject {

    var created_at : String?
    var id : Int = 0
    var text : String?
    var source : String?
    var pic_urls : [[String : AnyObject]]?
    
    
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
        print(key)
    }
    
    class func loadStatuses(finished:(list:[Statuses]?,error:NSError?)->()){
        let url = "2/statuses/home_timeline.json"
        let param = ["access_token":UserAccount.loadAccount()!.access_token!]
        NetworkTools.shareNetworkTools().GET(url, parameters: param, progress: nil, success: { (_, Json) -> Void in
                //1 json to model , 然后装在集合
            let models = dict2model(Json!["statuses"] as! [[String: AnyObject]])
            finished(list: models, error: nil)
            }) { (_, error) -> Void in
                finished(list: nil, error: error)
        }
    }
    
    // description
    var properties = ["created_at", "id", "text", "source", "pic_urls"]
    override var description: String {
        let dict = dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }
}
