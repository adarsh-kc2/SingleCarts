//
//  PlaceOrderRequestModel.swift
//  SingleCart
//
//  Created by PromptTech on 23/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

    
   /*
    
      {
   "UserID":1,
   "AuthKey":"cSROs6fQOv7Txrq2rP4Fmg==",
   "ShopID":1,
   "AddressID":5,
   "IsSuggestedDelivery":true,
   "SuggestedDate":"2020-08-24 18:41:18",
   "Remarks":"some remark comment",
   "IsShopVisit":true
}
*/
struct PlaceOrderRequestModel{

    var dictionary : Dictionary<String,Any> = Dictionary<String,Any>()
    init(_shopId : Int ,_AddressID : Int,_IsShopVisit : Bool,isSuggestedDelivery : Bool,_remark : String, _date : String) {
        dictionary["UserID"] = (UserDefaults.standard.value(forKey: USERID) as! Int)
        dictionary["AuthKey"] = (UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : "")
        dictionary["ShopID"] = _shopId
        dictionary["AddressID"] = _AddressID
        dictionary["IsShopVisit"] = _IsShopVisit
        dictionary["SuggestedDate"] = _date
        self.dictionary["IsSuggestedDelivery"] = isSuggestedDelivery
        self.dictionary["Remarks"] = _remark

    }
}
