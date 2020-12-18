//
//  WishListResponseModel.swift
//  SingleCart
//
//  Created by PromptTech on 17/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct WishListResponseModel : Codable {
    let data : [WishListResponseData]?
    let error : Bool?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case data = "Data"
        case error = "Error"
        case message = "Message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([WishListResponseData].self, forKey: .data)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}
struct WishListResponseData : Codable {
    let address : String?
    let landmark : String?
    let latitude : String?
    let longitude : String?
    let maxDeliveryRange : Int?
    let name : String?
    let openClose : Bool?
    let openCloseStatus : Bool?
    let place : String?
    let primaryMobile : String?
    let secondaryMobile : String?
    let shopID : Int?
    let wishListShopsProductData : [WishListShopsProductData]?
    let workingHours : String?

    enum CodingKeys: String, CodingKey {

        case address = "Address"
        case landmark = "Landmark"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case maxDeliveryRange = "MaxDeliveryRange"
        case name = "Name"
        case openClose = "OpenClose"
        case openCloseStatus = "OpenCloseStatus"
        case place = "Place"
        case primaryMobile = "PrimaryMobile"
        case secondaryMobile = "SecondaryMobile"
        case shopID = "ShopID"
        case wishListShopsProductData = "WishListShopsProductData"
        case workingHours = "WorkingHours"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        landmark = try values.decodeIfPresent(String.self, forKey: .landmark)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        maxDeliveryRange = try values.decodeIfPresent(Int.self, forKey: .maxDeliveryRange)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        openClose = try values.decodeIfPresent(Bool.self, forKey: .openClose)
        openCloseStatus = try values.decodeIfPresent(Bool.self, forKey: .openCloseStatus)
        place = try values.decodeIfPresent(String.self, forKey: .place)
        primaryMobile = try values.decodeIfPresent(String.self, forKey: .primaryMobile)
        secondaryMobile = try values.decodeIfPresent(String.self, forKey: .secondaryMobile)
        shopID = try values.decodeIfPresent(Int.self, forKey: .shopID)
        wishListShopsProductData = try values.decodeIfPresent([WishListShopsProductData].self, forKey: .wishListShopsProductData)
        workingHours = try values.decodeIfPresent(String.self, forKey: .workingHours)
    }

}


struct CategoryData : Codable {
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


struct ImageData : Codable {
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
struct WishListShopsProductData : Codable {
    let actualPrice : Double?
    let categoryData : [CategoryData]?
    let description : String?
    let discount : Double?
    let distance : Double?
    let imageData : [ImageData]?
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
        categoryData = try values.decodeIfPresent([CategoryData].self, forKey: .categoryData)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        discount = try values.decodeIfPresent(Double.self, forKey: .discount)
        distance = try values.decodeIfPresent(Double.self, forKey: .distance)
        imageData = try values.decodeIfPresent([ImageData].self, forKey: .imageData)
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
