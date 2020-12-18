//
//  ShopDetailsRequestModel.swift
//  SingleCart
//
//  Created by PromptTech on 12/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
/*
 {
     "UserID": 24,
     "AuthKey": "9PJZe/mQlLo/3BX3dJ+Vdw==",
     "ShopID": 23
 }
 */
struct ShopDetailsRequestModel{
    var UserID : Int?
     var AuthKey : String?
     var ShopID : Int?
     
     var dictionary : Dictionary<String,Any> = [:]
     init(_ShopID :Int) {
         dictionary["UserID"] = UserDefaults.standard.value(forKey: USERID) as! Int
         dictionary["AuthKey"] = (UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : "")
         dictionary["ShopID"] = _ShopID
        self.dictionary["Latitude"] = (UserDefaults.standard.value(forKey: LATITUDE)) != nil ? "\(UserDefaults.standard.value(forKey: LATITUDE) as! NSNumber)" : ""
        self.dictionary["Longitude"] =  (UserDefaults.standard.value(forKey: LONGITUDE)) != nil ? "\(UserDefaults.standard.value(forKey: LONGITUDE) as! NSNumber)" : ""
        
     }
}
