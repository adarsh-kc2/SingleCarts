//
//  FlyerRequestModel.swift
//  SingleCart
//
//  Created by PromptTech on 11/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
/*
 {
   "UserID": 0,
   "AuthKey": "",
   "FlyerID": 0 ,
   "ShopID":0,
   "PageSize":30,
   "PageNo":1,
   "Latitude":"",
   "Longitude":""
 }*/
struct FlyerRequestModel {
    var UserID : Int?
    var AuthKey : String?
    var FlyerID : Int?
    var ShopID : Int?
    var PageSize : Int?
    var PageNo : Int?
    
    var Latitude : String?
    var Longitude : String?
    var dictionary : Dictionary<String,Any> = [:]
    init(_FlyerID :Int,_ShopID :Int,_PageNo :Int) {
        dictionary["UserID"] = UserDefaults.standard.value(forKey: USERID) as! Int
        dictionary["AuthKey"] = (UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : "")
        dictionary["FlyerID"] = _FlyerID
        dictionary["ShopID"] = _ShopID
        dictionary["PageNo"] = _PageNo
        dictionary["PageSize"] = default_pageSize
        dictionary["Latitude"] = (UserDefaults.standard.value(forKey: LATITUDE)) != nil ? "\(UserDefaults.standard.value(forKey: LATITUDE) as! NSNumber)" : ""
        dictionary["Longitude"] = (UserDefaults.standard.value(forKey: LONGITUDE)) != nil ? "\(UserDefaults.standard.value(forKey: LONGITUDE) as! NSNumber)" : ""
    }
}
