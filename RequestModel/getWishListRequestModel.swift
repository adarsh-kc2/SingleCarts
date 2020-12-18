//
//  getWishListRequestModel.swift
//  SingleCart
//
//  Created by PromptTech on 17/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

struct GetWishListRequestModel{
    /*
      {
     "UserID": 25,
     "AuthKey": "T8QC8pt3YAfuL4QnVSTxUA==",
     "Latitude":"",
     "Longitude":"",
     "ShopID":0
     }
     */
    var dictionary : Dictionary<String,Any> = Dictionary<String,Any>()
    init(_shopId : Int) {
        dictionary["UserID"] = UserDefaults.standard.value(forKey: USERID) as! Int
        dictionary["AuthKey"] = (UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : "")
        dictionary["ShopID"] = _shopId
        self.dictionary["Latitude"] = (UserDefaults.standard.value(forKey: LATITUDE)) != nil ? "\(UserDefaults.standard.value(forKey: LATITUDE) as! NSNumber)" : ""
        self.dictionary["Longitude"] = (UserDefaults.standard.value(forKey: LONGITUDE)) != nil ? "\(UserDefaults.standard.value(forKey: LONGITUDE) as! NSNumber)" : ""

    }
}
