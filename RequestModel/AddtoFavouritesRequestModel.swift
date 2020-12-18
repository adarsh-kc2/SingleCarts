//
//  AddtoFavouritesRequestModel.swift
//  SingleCart
//
//  Created by PromptTech on 05/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit
/*
  {
 "UserID":"5",
 "AuthKey":"CydrT0mafUFV2wUKCKZ4CQ==",
 "ShopID":"3",
 "IsFavorite":true
 }
 */
struct AddtoFavouritesRequestModel {
    
    var UserID : String?
    var AuthKey : String?
    var ShopID : String?
    var IsFavorite : Bool?
    
    var dictionary : Dictionary<String,Any> = [:]
    
    init(_ShopID: String ,_IsFavorite : Bool ){
        self.ShopID = _ShopID
        self.IsFavorite = _IsFavorite
        self.dictionary["IsFavorite"] = _IsFavorite
        self.dictionary["ShopID"] = _ShopID
        self.dictionary["UserID"] = "\(UserDefaults.standard.value(forKey: USERID) as! Int)"
        self.dictionary["AuthKey"] = (UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : "")
    }
}
