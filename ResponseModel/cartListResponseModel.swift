//
//  cartListResponseModel.swift
//  SingleCart
//
//  Created by PromptTech on 19/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct CartListResponseModel : Codable {
    let data : [CartListResponseData]?
    let error : Bool?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case data = "Data"
        case error = "Error"
        case message = "Message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([CartListResponseData].self, forKey: .data)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}
struct CartListResponseData : Codable {
    let address : String?
    let closingTime : String?
    let getCartDataProductData : [GetCartDataProductData]?
    let holidays : [String]?
    let homeServiceAllowed : Bool?
    let landmark : String?
    let latitude : String?
    let longitude : String?
    let maxDeliveryRange : Int?
    let name : String?
    let openClose : Bool?
    let openCloseStatus : Bool?
    let openingTime : String?
    let place : String?
    let primaryMobile : String?
    let secondaryMobile : String?
    let serviceType : Int?
    let shopID : Int?
    let workingHours : String?

    enum CodingKeys: String, CodingKey {

        case address = "Address"
        case closingTime = "ClosingTime"
        case getCartDataProductData = "GetCartDataProductData"
        case holidays = "Holidays"
        case homeServiceAllowed = "HomeServiceAllowed"
        case landmark = "Landmark"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case maxDeliveryRange = "MaxDeliveryRange"
        case name = "Name"
        case openClose = "OpenClose"
        case openCloseStatus = "OpenCloseStatus"
        case openingTime = "OpeningTime"
        case place = "Place"
        case primaryMobile = "PrimaryMobile"
        case secondaryMobile = "SecondaryMobile"
        case serviceType = "ServiceType"
        case shopID = "ShopID"
        case workingHours = "WorkingHours"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        closingTime = try values.decodeIfPresent(String.self, forKey: .closingTime)
        getCartDataProductData = try values.decodeIfPresent([GetCartDataProductData].self, forKey: .getCartDataProductData)
        holidays = try values.decodeIfPresent([String].self, forKey: .holidays)
        homeServiceAllowed = try values.decodeIfPresent(Bool.self, forKey: .homeServiceAllowed)
        landmark = try values.decodeIfPresent(String.self, forKey: .landmark)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        maxDeliveryRange = try values.decodeIfPresent(Int.self, forKey: .maxDeliveryRange)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        openClose = try values.decodeIfPresent(Bool.self, forKey: .openClose)
        openCloseStatus = try values.decodeIfPresent(Bool.self, forKey: .openCloseStatus)
        openingTime = try values.decodeIfPresent(String.self, forKey: .openingTime)
        place = try values.decodeIfPresent(String.self, forKey: .place)
        primaryMobile = try values.decodeIfPresent(String.self, forKey: .primaryMobile)
        secondaryMobile = try values.decodeIfPresent(String.self, forKey: .secondaryMobile)
        serviceType = try values.decodeIfPresent(Int.self, forKey: .serviceType)
        shopID = try values.decodeIfPresent(Int.self, forKey: .shopID)
        workingHours = try values.decodeIfPresent(String.self, forKey: .workingHours)
    }

}

struct cartCategoryData : Codable {
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

struct GetCartDataProductData : Codable {
    let actualPrice : Double?
    let categoryData : [CategoryData]?
    let description : String?
    let discount : Double?
    let imageData : [ImageData]?
    let itemName : String?
    let manufacture : String?
    let offerNote : String?
    let quantity : Int?
    let remark : String?
    let sellingPrice : Double?
    let shopID : Int?
    let shopName : String?
    let stockID : Int?

    enum CodingKeys: String, CodingKey {

        case actualPrice = "ActualPrice"
        case categoryData = "CategoryData"
        case description = "Description"
        case discount = "Discount"
        case imageData = "ImageData"
        case itemName = "ItemName"
        case manufacture = "Manufacture"
        case offerNote = "OfferNote"
        case quantity = "Quantity"
        case remark = "Remark"
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
        imageData = try values.decodeIfPresent([ImageData].self, forKey: .imageData)
        itemName = try values.decodeIfPresent(String.self, forKey: .itemName)
        manufacture = try values.decodeIfPresent(String.self, forKey: .manufacture)
        offerNote = try values.decodeIfPresent(String.self, forKey: .offerNote)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
        remark = try values.decodeIfPresent(String.self, forKey: .remark)
        sellingPrice = try values.decodeIfPresent(Double.self, forKey: .sellingPrice)
        shopID = try values.decodeIfPresent(Int.self, forKey: .shopID)
        shopName = try values.decodeIfPresent(String.self, forKey: .shopName)
        stockID = try values.decodeIfPresent(Int.self, forKey: .stockID)
    }

}


struct cartImageData : Codable {
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
