//
//  GetShopsRequestModel.swift
//  SingleCart
//
//  Created by PromptTech on 05/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

struct GetShopsRequestModel {
    var ShowOffers : Bool?
    var ShopType : Int?
    var PageSize : Int?
    var PageNo : Int?
    
    var dictionary : Dictionary<String,Any> = [:]
    
    init(_name: String? ,_pageNo : Int ,_pageSize : Int ,_ShowOffers :Bool ,_ShopType : Int){
        self.dictionary["AuthKey"] = (UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : "")
        self.dictionary["Name"] = _name != nil ? _name : ""
        self.dictionary["Latitude"] = (UserDefaults.standard.value(forKey: LATITUDE)) != nil ? "\(UserDefaults.standard.value(forKey: LATITUDE) as! NSNumber)" : ""
        self.dictionary["Longitude"] =  (UserDefaults.standard.value(forKey: LONGITUDE)) != nil ? "\(UserDefaults.standard.value(forKey: LONGITUDE) as! NSNumber)" : ""
        
        self.dictionary["UserID"] = UserDefaults.standard.value(forKey: USERID) as! Int
        self.dictionary["PageNo"] = _pageNo
        self.dictionary["PageSize"] = _pageSize
        self.dictionary["ShopType"] = _ShopType
        self.dictionary["ShowOffers"] = _ShowOffers
    }
    
    /*
     //        {
     //
     //            "IsClosed": true,
     //            "IsOpen": true,
     //            "ShopID": 0,
     //            "ShopType": 0,
     //            "ShowOffers": true,
     //            "UserID": 25
     //        }
     */
}


struct GetSearchShopsRequestModel {
    var ShowOffers : Bool?
    var ShopType : Int?
    var PageSize : Int?
    var PageNo : Int?
    var IsClosed : Bool?
    var IsOpen : Bool?
    var ShopID : Int?
    
    var dictionary : Dictionary<String,Any> = [:]
    
    init(_name: String? ,_pageNo : Int ,_pageSize : Int ,_ShowOffers :Bool ,_ShopType : Int, _isClosed : Bool, _isOpen : Bool , _shopId : Int){
        self.dictionary["AuthKey"] = (UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : "")
        self.dictionary["Name"] = _name != nil ? _name : ""
        self.dictionary["Latitude"] = (UserDefaults.standard.value(forKey: LATITUDE)) != nil ? "\(UserDefaults.standard.value(forKey: LATITUDE) as! NSNumber)" : ""
        self.dictionary["Longitude"] =  (UserDefaults.standard.value(forKey: LONGITUDE)) != nil ? "\(UserDefaults.standard.value(forKey: LONGITUDE) as! NSNumber)" : ""
        
        self.dictionary["UserID"] = UserDefaults.standard.value(forKey: USERID) as! Int
        self.dictionary["PageNo"] = _pageNo
        self.dictionary["PageSize"] = _pageSize
        self.dictionary["ShopType"] = _ShopType
        self.dictionary["ShowOffers"] = _ShowOffers
        
    }
    
    /*
     //        {
     //
     //            "IsClosed": true,
     //            "IsOpen": true,
     //            "ShopID": 0,
     //            "ShopType": 0,
     //            "ShowOffers": true,
     //            "UserID": 25
     //        }
     */
}



