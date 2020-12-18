//
//  SummaryDataResponseModel.swift
//  SingleCart
//
//  Created by PromptTech on 28/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct SummaryDataResponseModel : Codable {
    let data : SummaryDataResponseData?
    let error : Bool?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case data = "Data"
        case error = "Error"
        case message = "Message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(SummaryDataResponseData.self, forKey: .data)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}
struct SummaryDataResponseData : Codable {
    let bannerList : [BannerList]?
    let gridList : [GridList]?

    enum CodingKeys: String, CodingKey {

        case bannerList = "BannerList"
        case gridList = "GridList"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bannerList = try values.decodeIfPresent([BannerList].self, forKey: .bannerList)
        gridList = try values.decodeIfPresent([GridList].self, forKey: .gridList)
    }

}
//struct CategoryData : Codable {
//    let categoryID : Int?
//    let categoryName : String?
//    let imagePath : String?
//
//    enum CodingKeys: String, CodingKey {
//
//        case categoryID = "CategoryID"
//        case categoryName = "CategoryName"
//        case imagePath = "ImagePath"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        categoryID = try values.decodeIfPresent(Int.self, forKey: .categoryID)
//        categoryName = try values.decodeIfPresent(String.self, forKey: .categoryName)
//        imagePath = try values.decodeIfPresent(String.self, forKey: .imagePath)
//    }
//
//}
struct BannerList : Codable {
    let categoryID : Int?
    let categoryName : String?
    let imagePath : String?
    let isOffer : Bool?
    let isRecommended : Bool?
    let shopID : Int?
    let shopTypeID : Int?
    let stockCategoryID : Int?
    let stockID : Int?

    enum CodingKeys: String, CodingKey {

        case categoryID = "CategoryID"
        case categoryName = "CategoryName"
        case imagePath = "ImagePath"
        case isOffer = "IsOffer"
        case isRecommended = "IsRecommended"
        case shopID = "ShopID"
        case shopTypeID = "ShopTypeID"
        case stockCategoryID = "StockCategoryID"
        case stockID = "StockID"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categoryID = try values.decodeIfPresent(Int.self, forKey: .categoryID)
        categoryName = try values.decodeIfPresent(String.self, forKey: .categoryName)
        imagePath = try values.decodeIfPresent(String.self, forKey: .imagePath)
        isOffer = try values.decodeIfPresent(Bool.self, forKey: .isOffer)
        isRecommended = try values.decodeIfPresent(Bool.self, forKey: .isRecommended)
        shopID = try values.decodeIfPresent(Int.self, forKey: .shopID)
        shopTypeID = try values.decodeIfPresent(Int.self, forKey: .shopTypeID)
        stockCategoryID = try values.decodeIfPresent(Int.self, forKey: .stockCategoryID)
        stockID = try values.decodeIfPresent(Int.self, forKey: .stockID)
    }

}
struct GridList : Codable {
    let categoryID : Int?
    let categoryName : String?
    let description : String?
    let productList : [OfferResponseData]?

    enum CodingKeys: String, CodingKey {

        case categoryID = "CategoryID"
        case categoryName = "CategoryName"
        case description = "Description"
        case productList = "ProductList"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categoryID = try values.decodeIfPresent(Int.self, forKey: .categoryID)
        categoryName = try values.decodeIfPresent(String.self, forKey: .categoryName)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        productList = try values.decodeIfPresent([OfferResponseData].self, forKey: .productList)
    }

}
//struct ImageData : Codable {
//    let alternateShareImage : String?
//    let hasImage : Bool?
//    let imageID : Int?
//    let imagePath : String?
//
//    enum CodingKeys: String, CodingKey {
//
//        case alternateShareImage = "AlternateShareImage"
//        case hasImage = "HasImage"
//        case imageID = "ImageID"
//        case imagePath = "ImagePath"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        alternateShareImage = try values.decodeIfPresent(String.self, forKey: .alternateShareImage)
//        hasImage = try values.decodeIfPresent(Bool.self, forKey: .hasImage)
//        imageID = try values.decodeIfPresent(Int.self, forKey: .imageID)
//        imagePath = try values.decodeIfPresent(String.self, forKey: .imagePath)
//    }
//
//}
/*
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
*/
struct ProductList : Codable {
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
