//
//  CartCheckOutRequestModel.swift
//  SingleCart
//
//  Created by PromptTech on 22/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct CartCheckOutRequestModel{
/*
     {
        "UserID":1,
        "AuthKey":"cSROs6fQOv7Txrq2rP4Fmg==",
        "ShopID":1,
        "AddressID":5,
        "Latitude":"",
        "Longitude":"",
        "IsShopVisit":true
     }
     */
    var dictionary : Dictionary<String,Any> = Dictionary<String,Any>()
    init(_shopId : Int ,_AddressID : Int?,_IsShopVisit : Bool) {
        dictionary["UserID"] = (UserDefaults.standard.value(forKey: USERID) as! Int)
        dictionary["AuthKey"] = (UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : "")
        dictionary["ShopID"] = _shopId
        dictionary["AddressID"] = _AddressID ?? 0
        dictionary["IsShopVisit"] = _IsShopVisit
        self.dictionary["Latitude"] = (UserDefaults.standard.value(forKey: LATITUDE)) != nil ? "\(UserDefaults.standard.value(forKey: LATITUDE) as! NSNumber)" : ""
        self.dictionary["Longitude"] = (UserDefaults.standard.value(forKey: LONGITUDE)) != nil ? "\(UserDefaults.standard.value(forKey: LONGITUDE) as! NSNumber)" : ""

    }
}
