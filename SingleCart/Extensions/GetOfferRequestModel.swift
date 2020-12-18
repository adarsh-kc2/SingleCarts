//
//  GetOfferRequestModel.swift
//  SingleCart
//
//  Created by PromptTech on 03/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

struct OfferRequestModel{

    var IsAscending : Bool?
    var IsDiscountSorting : Bool?
    var IsPriceSorting : Bool?
    var IsSorting : Bool?
    var IsSortRank : Bool?
    var IsNonShowOffers : Bool?
    var IsShowOffers : Bool?
    var IsClosed : Bool?
    var IsOpen : Bool?
    var IsShowNonRecommended : Bool?
    var IsShowRecommended : Bool?
    var IsShowOutStock : Bool?
    var IsShowInstock : Bool?

    var AuthToken : String?
    var Longitude : String?
    var Latitude : String?
    var Name : String?
    
    var UserID : Int?
    var PageNo : Int?
    var PageSize : Int?
    var EndingPrice : Int?
    var StartingPrice : Int?
    var StockID : Int?
    var ShopType : Int?
    var ShopID : Int?
    var CategoryID : Int?
    
    var dictionary : Dictionary<String,Any> = [:]
 
    init(_name: String? ,_pageNo : Int ,_pageSize : Int , otherParams : Dictionary<String,Any>){
        //AuthToken
        self.dictionary["AuthToken"] = (UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : "")
        self.Name = _name
        self.dictionary["Name"] = self.Name
        
        self.dictionary["Latitude"] = (UserDefaults.standard.value(forKey: LATITUDE)) != nil ? "\(UserDefaults.standard.value(forKey: LATITUDE) as! NSNumber)" : ""
        self.dictionary["Longitude"] = (UserDefaults.standard.value(forKey: LONGITUDE)) != nil ? "\(UserDefaults.standard.value(forKey: LONGITUDE) as! NSNumber)" : ""
        
        self.dictionary["UserID"] = UserDefaults.standard.value(forKey: USERID) as! Int
        PageNo = _pageNo
        PageSize = _pageSize
        
        self.dictionary["PageNo"] = _pageNo
        self.dictionary["PageSize"] = _pageSize
        
        self.dictionary["StartingPrice"] = Double(otherParams["StartingPrice"] as! Int)
        self.dictionary["EndingPrice"] = Double(otherParams["EndingPrice"] as! Int)
        self.dictionary["StockID"] = otherParams["StockID"] as! Int
        self.dictionary["ShopType"] = otherParams["ShopType"] as! Int
        self.dictionary["ShopID"] = otherParams["ShopID"] as! Int
        self.dictionary["CategoryID"] = otherParams["CategoryID"] as! Int
        
        self.dictionary["IsAscending"] = otherParams["IsAscending"] as! Bool
        self.dictionary["IsDiscountSorting"] = otherParams["IsDiscountSorting"] as! Bool
        self.dictionary["IsPriceSorting"] = otherParams["IsPriceSorting"] as! Bool
        self.dictionary["IsSorting"] = otherParams["IsSorting"] as! Bool
        self.dictionary["IsSortRank"] = otherParams["IsSortRank"] as! Bool
        self.dictionary["IsNonShowOffers"] = otherParams["IsNonShowOffers"] as! Bool
        self.dictionary["IsShowOffers"] = otherParams["IsShowOffers"] as! Bool
        self.dictionary["IsClosed"] = otherParams["IsClosed"] as! Bool
        self.dictionary["IsOpen"] = otherParams["IsOpen"] as! Bool
        self.dictionary["IsShowNonRecommended"] = otherParams["IsShowNonRecommended"] as! Bool
        self.dictionary["IsShowRecommended"] = otherParams["IsShowRecommended"] as! Bool
        self.dictionary["IsShowOutStock"] = otherParams["IsShowOutStock"] as! Bool
        self.dictionary["IsShowInstock"] = otherParams["IsShowInstock"] as! Bool
    }
}

