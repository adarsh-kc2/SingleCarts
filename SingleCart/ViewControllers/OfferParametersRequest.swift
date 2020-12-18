//
//  OfferParametersRequest.swift
//  SingleCart
//
//  Created by PromptTech on 04/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct OfferParametersRequest{
    
    var StockID : Int?
    var ShopType : Int?
    var ShopID : Int?
    var CategoryID : Int?
    var StartingPrice : Int?
    var EndingPrice : Int?
    
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
    
    var dictionary : Dictionary<String,Any> = [:]
    
    init(_integerArray : [Int], _booleanArray : [Bool]){
        //AuthToken
        self.StockID = _integerArray[0]
        dictionary["StockID"] = self.StockID
        
        self.ShopType = _integerArray[1]
        dictionary["ShopType"] = self.ShopType
        
        self.ShopID = _integerArray[2]
        dictionary["ShopID"] = self.ShopID
        
        self.CategoryID = _integerArray[3]
        dictionary["CategoryID"] = self.CategoryID
        
        self.StartingPrice = _integerArray[4]
        dictionary["StartingPrice"] = self.StartingPrice
        
        self.EndingPrice = _integerArray[5]
        dictionary["EndingPrice"] = self.EndingPrice
        
        
        self.IsAscending = _booleanArray[0]
        dictionary["IsAscending"] = self.IsAscending
        
        self.IsDiscountSorting = _booleanArray[1]
        dictionary["IsDiscountSorting"] = self.IsDiscountSorting
        
        self.IsPriceSorting = _booleanArray[2]
        dictionary["IsPriceSorting"] = self.IsPriceSorting
        
        self.IsSorting = _booleanArray[3]
        dictionary["IsSorting"] = self.IsSorting
        
        self.IsSortRank = _booleanArray[4]
        dictionary["IsSortRank"] = self.IsSortRank
        
        self.IsNonShowOffers = _booleanArray[5]
        dictionary["IsNonShowOffers"] = self.IsNonShowOffers
        
        self.IsShowOffers = _booleanArray[6]
        dictionary["IsShowOffers"] = self.IsShowOffers
        
        self.IsClosed = _booleanArray[7]
        dictionary["IsClosed"] = self.IsClosed
        
        self.IsOpen = _booleanArray[8]
        dictionary["IsOpen"] = self.IsOpen
        
        self.IsShowNonRecommended = _booleanArray[9]
        dictionary["IsShowNonRecommended"] = self.IsShowNonRecommended
        
        self.IsShowRecommended = _booleanArray[10]
        dictionary["IsShowRecommended"] = self.IsShowRecommended
        
        self.IsShowOutStock = _booleanArray[11]
        dictionary["IsShowOutStock"] = self.IsShowOutStock
        
        self.IsShowInstock = _booleanArray[12]
        dictionary["IsShowInstock"] = self.IsShowInstock
    }
}
