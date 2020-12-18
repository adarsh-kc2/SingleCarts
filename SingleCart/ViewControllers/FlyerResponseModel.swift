//
//  FlyerResponseModel.swift
//  SingleCart
//
//  Created by PromptTech on 11/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct FlyerResponseModel : Codable {
    let error : Bool?
    let flyerDatas : [FlyerDatas]?
    let message : String?
    let pageAvailable : Int?
    let pageNo : Int?
    let resultCount : Int?

    enum CodingKeys: String, CodingKey {

        case error = "Error"
        case flyerDatas = "FlyerDatas"
        case message = "Message"
        case pageAvailable = "PageAvailable"
        case pageNo = "PageNo"
        case resultCount = "ResultCount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        flyerDatas = try values.decodeIfPresent([FlyerDatas].self, forKey: .flyerDatas)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        pageAvailable = try values.decodeIfPresent(Int.self, forKey: .pageAvailable)
        pageNo = try values.decodeIfPresent(Int.self, forKey: .pageNo)
        resultCount = try values.decodeIfPresent(Int.self, forKey: .resultCount)
    }

}
struct FlyerDatas : Codable {
    let distance : Double?
    let flyerID : Int?
    let flyerImages : [FlyerImages]?
    let isFavShop : Bool?
    let maxDeliveryRange : Int?
    let offerEndDate : String?
    let offerName : String?
    let offerStartDate : String?
    let shopName : String?

    enum CodingKeys: String, CodingKey {

        case distance = "Distance"
        case flyerID = "FlyerID"
        case flyerImages = "FlyerImages"
        case isFavShop = "IsFavShop"
        case maxDeliveryRange = "MaxDeliveryRange"
        case offerEndDate = "OfferEndDate"
        case offerName = "OfferName"
        case offerStartDate = "OfferStartDate"
        case shopName = "ShopName"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        distance = try values.decodeIfPresent(Double.self, forKey: .distance)
        flyerID = try values.decodeIfPresent(Int.self, forKey: .flyerID)
        flyerImages = try values.decodeIfPresent([FlyerImages].self, forKey: .flyerImages)
        isFavShop = try values.decodeIfPresent(Bool.self, forKey: .isFavShop)
        maxDeliveryRange = try values.decodeIfPresent(Int.self, forKey: .maxDeliveryRange)
        offerEndDate = try values.decodeIfPresent(String.self, forKey: .offerEndDate)
        offerName = try values.decodeIfPresent(String.self, forKey: .offerName)
        offerStartDate = try values.decodeIfPresent(String.self, forKey: .offerStartDate)
        shopName = try values.decodeIfPresent(String.self, forKey: .shopName)
    }

}

struct FlyerImages : Codable {
    let flyerDetailID : Int?
    let imagePath : String?

    enum CodingKeys: String, CodingKey {

        case flyerDetailID = "FlyerDetailID"
        case imagePath = "ImagePath"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flyerDetailID = try values.decodeIfPresent(Int.self, forKey: .flyerDetailID)
        imagePath = try values.decodeIfPresent(String.self, forKey: .imagePath)
    }

}
