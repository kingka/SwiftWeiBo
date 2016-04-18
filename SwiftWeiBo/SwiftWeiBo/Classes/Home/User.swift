//
//  User.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/4/18.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

class User: NSObject {
    var name : String?
    var avatar_large : String?
    
    init(dict : [String : AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        //print(key)
    }
    
    // description
    var properties = ["name", "avatar_large"]
    override var description: String {
        let dict = dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }
}
