//
//  OfferResponseModel.swift
//  SingleCart
//
//  Created by PromptTech on 04/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

struct OfferResponseModel : Codable {
    let data : [OfferResponseData]?
    let error : Bool?
    let message : String?
    let pageAvailable : Int?
    let pageNo : Int?
    let resultCount : Int?

    enum CodingKeys: String, CodingKey {

        case data = "Data"
        case error = "Error"
        case message = "Message"
        case pageAvailable = "PageAvailable"
        case pageNo = "PageNo"
        case resultCount = "ResultCount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([OfferResponseData].self, forKey: .data)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        pageAvailable = try values.decodeIfPresent(Int.self, forKey: .pageAvailable)
        pageNo = try values.decodeIfPresent(Int.self, forKey: .pageNo)
        resultCount = try values.decodeIfPresent(Int.self, forKey: .resultCount)
        
    }

}
//OfferResponseData
struct OfferResponseData : Codable {
    let actualPrice : Double?
    let categoryData : [OfferCategoryData]?
    let description : String?
    let discount : Double?
    let distance : Double?
    let imageData : [OfferImageData]?
    let inStock : Bool?
    let isCartItem : Bool?
    let isOfferItem : Bool?
    let isWishItem : Bool?
    let itemName : String?
    let manufacture : String?
    let offerNote : String?
    let sellingPrice : Double?
    let shopID : Int?
    let shopName : String?
    let stockID : Int?

    enum CodingKeys: String, CodingKey {

        case actualPrice = "ActualPrice"
        case categoryData = "CategoryData"
        case description = "Description"
        case discount = "Discount"
        case distance = "Distance"
        case imageData = "ImageData"
        case inStock = "InStock"
        case isCartItem = "IsCartItem"
        case isOfferItem = "IsOfferItem"
        case isWishItem = "IsWishItem"
        case itemName = "ItemName"
        case manufacture = "Manufacture"
        case offerNote = "OfferNote"
        case sellingPrice = "SellingPrice"
        case shopID = "ShopID"
        case shopName = "ShopName"
        case stockID = "StockID"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        actualPrice = try values.decodeIfPresent(Double.self, forKey: .actualPrice)
        categoryData = try values.decodeIfPresent([OfferCategoryData].self, forKey: .categoryData)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        discount = try values.decodeIfPresent(Double.self, forKey: .discount)
        distance = try values.decodeIfPresent(Double.self, forKey: .distance)
        imageData = try values.decodeIfPresent([OfferImageData].self, forKey: .imageData)
        inStock = try values.decodeIfPresent(Bool.self, forKey: .inStock)
        isCartItem = try values.decodeIfPresent(Bool.self, forKey: .isCartItem)
        isOfferItem = try values.decodeIfPresent(Bool.self, forKey: .isOfferItem)
        isWishItem = try values.decodeIfPresent(Bool.self, forKey: .isWishItem)
        itemName = try values.decodeIfPresent(String.self, forKey: .itemName)
        manufacture = try values.decodeIfPresent(String.self, forKey: .manufacture)
        offerNote = try values.decodeIfPresent(String.self, forKey: .offerNote)
        sellingPrice = try values.decodeIfPresent(Double.self, forKey: .sellingPrice)
        shopID = try values.decodeIfPresent(Int.self, forKey: .shopID)
        shopName = try values.decodeIfPresent(String.self, forKey: .shopName)
        stockID = try values.decodeIfPresent(Int.self, forKey: .stockID)
    }

}
struct OfferCategoryData : Codable {
    let categoryID : Int?
    let categoryName : String?
    let imagePath : String?

    enum CodingKeys: String, CodingKey {

        case categoryID = "CategoryID"
        case categoryName = "CategoryName"
        case imagePath = "ImagePath"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categoryID = try values.decodeIfPresent(Int.self, forKey: .categoryID)
        categoryName = try values.decodeIfPresent(String.self, forKey: .categoryName)
        imagePath = try values.decodeIfPresent(String.self, forKey: .imagePath)
    }

}

struct OfferImageData : Codable {
    let alternateShareImage : String?
    let hasImage : Bool?
    let imageID : Int?
    let imagePath : String?

    enum CodingKeys: String, CodingKey {

        case alternateShareImage = "AlternateShareImage"
        case hasImage = "HasImage"
        case imageID = "ImageID"
        case imagePath = "ImagePath"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        alternateShareImage = try values.decodeIfPresent(String.self, forKey: .alternateShareImage)
        hasImage = try values.decodeIfPresent(Bool.self, forKey: .hasImage)
        imageID = try values.decodeIfPresent(Int.self, forKey: .imageID)
        imagePath = try values.decodeIfPresent(String.self, forKey: .imagePath)
    }

}
