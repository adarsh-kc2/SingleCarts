//
//  GetShopsResponseModel.swift
//  SingleCart
//
//  Created by PromptTech on 05/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct GetShopsResponseModel : Codable {
    let data : [GetShopsResponseData]?
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
        data = try values.decodeIfPresent([GetShopsResponseData].self, forKey: .data)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        pageAvailable = try values.decodeIfPresent(Int.self, forKey: .pageAvailable)
        pageNo = try values.decodeIfPresent(Int.self, forKey: .pageNo)
        resultCount = try values.decodeIfPresent(Int.self, forKey: .resultCount)
    }

}
//GetShopsResponseData
struct GetShopsResponseData : Codable {
    let address : String?
    let closingTime : String?
    let distance : Double?
    let holidays : [String]?
    let homeServiceAllowed : Bool?
    var isFavourite : Bool?
    let landmark : String?
    let latitude : String?
    let logoPath : String?
    let longitude : String?
    let maxDeliveryRange : Int?
    let name : String?
    let offersAvailable : Int?
    let openClose : Bool?
    let openCloseStatus : Bool?
    let openingTime : String?
    let place : String?
    let primaryMobile : String?
    let secondaryMobile : String?
    let serviceType : Int?
    let shopID : Int?
    let shopTypeID : Int?
    let shopTypeName : String?
    let usualDispatchTime : Int?
    let webShopName : String?
    let workingHours : String?

    enum CodingKeys: String, CodingKey {

        case address = "Address"
        case closingTime = "ClosingTime"
        case distance = "Distance"
        case holidays = "Holidays"
        case homeServiceAllowed = "HomeServiceAllowed"
        case isFavourite = "IsFavourite"
        case landmark = "Landmark"
        case latitude = "Latitude"
        case logoPath = "LogoPath"
        case longitude = "Longitude"
        case maxDeliveryRange = "MaxDeliveryRange"
        case name = "Name"
        case offersAvailable = "OffersAvailable"
        case openClose = "OpenClose"
        case openCloseStatus = "OpenCloseStatus"
        case openingTime = "OpeningTime"
        case place = "Place"
        case primaryMobile = "PrimaryMobile"
        case secondaryMobile = "SecondaryMobile"
        case serviceType = "ServiceType"
        case shopID = "ShopID"
        case shopTypeID = "ShopTypeID"
        case shopTypeName = "ShopTypeName"
        case usualDispatchTime = "UsualDispatchTime"
        case webShopName = "WebShopName"
        case workingHours = "WorkingHours"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        closingTime = try values.decodeIfPresent(String.self, forKey: .closingTime)
        distance = try values.decodeIfPresent(Double.self, forKey: .distance)
        holidays = try values.decodeIfPresent([String].self, forKey: .holidays)
        homeServiceAllowed = try values.decodeIfPresent(Bool.self, forKey: .homeServiceAllowed)
        isFavourite = try values.decodeIfPresent(Bool.self, forKey: .isFavourite)
        landmark = try values.decodeIfPresent(String.self, forKey: .landmark)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        logoPath = try values.decodeIfPresent(String.self, forKey: .logoPath)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        maxDeliveryRange = try values.decodeIfPresent(Int.self, forKey: .maxDeliveryRange)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        offersAvailable = try values.decodeIfPresent(Int.self, forKey: .offersAvailable)
        openClose = try values.decodeIfPresent(Bool.self, forKey: .openClose)
        openCloseStatus = try values.decodeIfPresent(Bool.self, forKey: .openCloseStatus)
        openingTime = try values.decodeIfPresent(String.self, forKey: .openingTime)
        place = try values.decodeIfPresent(String.self, forKey: .place)
        primaryMobile = try values.decodeIfPresent(String.self, forKey: .primaryMobile)
        secondaryMobile = try values.decodeIfPresent(String.self, forKey: .secondaryMobile)
        serviceType = try values.decodeIfPresent(Int.self, forKey: .serviceType)
        shopID = try values.decodeIfPresent(Int.self, forKey: .shopID)
        shopTypeID = try values.decodeIfPresent(Int.self, forKey: .shopTypeID)
        shopTypeName = try values.decodeIfPresent(String.self, forKey: .shopTypeName)
        usualDispatchTime = try values.decodeIfPresent(Int.self, forKey: .usualDispatchTime)
        webShopName = try values.decodeIfPresent(String.self, forKey: .webShopName)
        workingHours = try values.decodeIfPresent(String.self, forKey: .workingHours)
    }

}
