//
//  AddRemoveWishListRequestModel.swift
//  SingleCart
//
//  Created by PromptTech on 17/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct AddRemoveWishListRequestModel {
    /*
     {
         "UserID": 25,
     "AuthKey": "T8QC8pt3YAfuL4QnVSTxUA==",
     "ShopID": 5,
     "StockID":3,
     "IsAdding":true
     }
     */
    var dictionary : Dictionary<String,Any> = Dictionary<String,Any>()
    init(_isadd : Bool,_stockId : Int?, _shopId : Int?) {
        dictionary["UserID"] = UserDefaults.standard.value(forKey: USERID) as! Int
        dictionary["AuthKey"] = (UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : "")
        dictionary["ShopID"] = _shopId!
        dictionary["StockID"] = _stockId!
        dictionary["IsAdding"] = _isadd
    }
}
