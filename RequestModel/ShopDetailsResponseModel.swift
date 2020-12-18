//
//  ShopDetailsResponseModel.swift
//  SingleCart
//
//  Created by PromptTech on 12/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
/*
 {
     "Data": {
         "Address": "Beside Al Mullah Plaza - النهدة - دبي - United Arab Emirates",
         "AlternateLogo": null,
         "BaseDeliveryCharge": 0.00000,
         "BulkOrderFreeDelivery": false,
         "ClosingTime": "PT21H",
         "DistCovInBaseCharge": 0,
         "EmailID": "ruchi@email.com",
         "FavUsersCount": 1,
         "FreeDeliveryMaxAmt": 0.00000,
         "FreeDeliveryOffer": true,
         "FreeDeliveryWithinKM": 25,
         "HasShopLogo": false,
         "Holidays": [],
         "HomeServiceAllowed": true,
         "IsWebEnabled": null,
         "Landmark": "Near",
         "Latitude": "25.280322938065172",
         "LogoPath": "",
         "Longitude": "55.357426218688495",
         "MaxDeliveryRange": 45,
         "MaxPackageWeight": 0,
         "MinValueForBulkOrder": 0.00000,
         "MinimumCartValue": 5.00000,
         "Name": "Ruchikkoott",
         "OpenClose": true,
         "OpenCloseStatus": true,
         "OpeningTime": "PT8H",
         "PerKmCharge": 0.00000,
         "PinCode": "",
         "Place": "Dubai",
         "PrimaryMobile": "987654337",
         "SecondaryMobile": "987654337",
         "ServiceType": 1,
         "ShopID": 23,
         "ShopType": 5,
         "UsualDispatchTime": 60,
         "WebShopName": "",
         "WorkingHours": "Closes 09:00 PM"
     },
     "Error": false,
     "Message": "Processed Successfully"
 }
 */


struct ShopDetailsResponseModel : Codable {
    let data : ShopDetailsResponseData?
    let error : Bool?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case data = "Data"
        case error = "Error"
        case message = "Message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(ShopDetailsResponseData.self, forKey: .data)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}

struct ShopDetailsResponseData : Codable {
   let address : String?
    let alternateLogo : String?
    let baseDeliveryCharge : Double?
    let bulkOrderFreeDelivery : Bool?
    let closingTime : String?
    let closingTimeView : String?
    let distCovInBaseCharge : Int?
    let distance : Double?
    let emailID : String?
    let favUsersCount : Int?
    let freeDeliveryMaxAmt : Double?
    let freeDeliveryOffer : Bool?
    let freeDeliveryWithinKM : Int?
    let hasShopLogo : Bool?
    let holidays : [String]?
    let homeServiceAllowed : Bool?
    let isWebEnabled : String?
    let landmark : String?
    let latitude : String?
    let logoPath : String?
    let longitude : String?
    let maxDeliveryRange : Int?
    let maxPackageWeight : Int?
    let minValueForBulkOrder : Double?
    let minimumCartValue : Double?
    let name : String?
    let openClose : Bool?
    let openCloseStatus : Bool?
    let openingTime : String?
    let openingTimeView : String?
    let perKmCharge : Double?
    let pinCode : String?
    let place : String?
    let primaryMobile : String?
    let secondaryMobile : String?
    let serviceType : Int?
    let shopID : Int?
    let shopType : Int?
    let shopTypeName : String?
    let usualDispatchTime : Int?
    let webShopName : String?
    let workingHours : String?

    enum CodingKeys: String, CodingKey {

        case address = "Address"
        case alternateLogo = "AlternateLogo"
        case baseDeliveryCharge = "BaseDeliveryCharge"
        case bulkOrderFreeDelivery = "BulkOrderFreeDelivery"
        case closingTime = "ClosingTime"
        case closingTimeView = "ClosingTimeView"
        case distCovInBaseCharge = "DistCovInBaseCharge"
        case distance = "Distance"
        case emailID = "EmailID"
        case favUsersCount = "FavUsersCount"
        case freeDeliveryMaxAmt = "FreeDeliveryMaxAmt"
        case freeDeliveryOffer = "FreeDeliveryOffer"
        case freeDeliveryWithinKM = "FreeDeliveryWithinKM"
        case hasShopLogo = "HasShopLogo"
        case holidays = "Holidays"
        case homeServiceAllowed = "HomeServiceAllowed"
        case isWebEnabled = "IsWebEnabled"
        case landmark = "Landmark"
        case latitude = "Latitude"
        case logoPath = "LogoPath"
        case longitude = "Longitude"
        case maxDeliveryRange = "MaxDeliveryRange"
        case maxPackageWeight = "MaxPackageWeight"
        case minValueForBulkOrder = "MinValueForBulkOrder"
        case minimumCartValue = "MinimumCartValue"
        case name = "Name"
        case openClose = "OpenClose"
        case openCloseStatus = "OpenCloseStatus"
        case openingTime = "OpeningTime"
        case openingTimeView = "OpeningTimeView"
        case perKmCharge = "PerKmCharge"
        case pinCode = "PinCode"
        case place = "Place"
        case primaryMobile = "PrimaryMobile"
        case secondaryMobile = "SecondaryMobile"
        case serviceType = "ServiceType"
        case shopID = "ShopID"
        case shopType = "ShopType"
        case shopTypeName = "ShopTypeName"
        case usualDispatchTime = "UsualDispatchTime"
        case webShopName = "WebShopName"
        case workingHours = "WorkingHours"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        alternateLogo = try values.decodeIfPresent(String.self, forKey: .alternateLogo)
        baseDeliveryCharge = try values.decodeIfPresent(Double.self, forKey: .baseDeliveryCharge)
        bulkOrderFreeDelivery = try values.decodeIfPresent(Bool.self, forKey: .bulkOrderFreeDelivery)
        closingTime = try values.decodeIfPresent(String.self, forKey: .closingTime)
        closingTimeView = try values.decodeIfPresent(String.self, forKey: .closingTimeView)
        distCovInBaseCharge = try values.decodeIfPresent(Int.self, forKey: .distCovInBaseCharge)
        distance = try values.decodeIfPresent(Double.self, forKey: .distance)
        emailID = try values.decodeIfPresent(String.self, forKey: .emailID)
        favUsersCount = try values.decodeIfPresent(Int.self, forKey: .favUsersCount)
        freeDeliveryMaxAmt = try values.decodeIfPresent(Double.self, forKey: .freeDeliveryMaxAmt)
        freeDeliveryOffer = try values.decodeIfPresent(Bool.self, forKey: .freeDeliveryOffer)
        freeDeliveryWithinKM = try values.decodeIfPresent(Int.self, forKey: .freeDeliveryWithinKM)
        hasShopLogo = try values.decodeIfPresent(Bool.self, forKey: .hasShopLogo)
        holidays = try values.decodeIfPresent([String].self, forKey: .holidays)
        homeServiceAllowed = try values.decodeIfPresent(Bool.self, forKey: .homeServiceAllowed)
        isWebEnabled = try values.decodeIfPresent(String.self, forKey: .isWebEnabled)
        landmark = try values.decodeIfPresent(String.self, forKey: .landmark)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        logoPath = try values.decodeIfPresent(String.self, forKey: .logoPath)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        maxDeliveryRange = try values.decodeIfPresent(Int.self, forKey: .maxDeliveryRange)
        maxPackageWeight = try values.decodeIfPresent(Int.self, forKey: .maxPackageWeight)
        minValueForBulkOrder = try values.decodeIfPresent(Double.self, forKey: .minValueForBulkOrder)
        minimumCartValue = try values.decodeIfPresent(Double.self, forKey: .minimumCartValue)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        openClose = try values.decodeIfPresent(Bool.self, forKey: .openClose)
        openCloseStatus = try values.decodeIfPresent(Bool.self, forKey: .openCloseStatus)
        openingTime = try values.decodeIfPresent(String.self, forKey: .openingTime)
        openingTimeView = try values.decodeIfPresent(String.self, forKey: .openingTimeView)
        perKmCharge = try values.decodeIfPresent(Double.self, forKey: .perKmCharge)
        pinCode = try values.decodeIfPresent(String.self, forKey: .pinCode)
        place = try values.decodeIfPresent(String.self, forKey: .place)
        primaryMobile = try values.decodeIfPresent(String.self, forKey: .primaryMobile)
        secondaryMobile = try values.decodeIfPresent(String.self, forKey: .secondaryMobile)
        serviceType = try values.decodeIfPresent(Int.self, forKey: .serviceType)
        shopID = try values.decodeIfPresent(Int.self, forKey: .shopID)
        shopType = try values.decodeIfPresent(Int.self, forKey: .shopType)
        shopTypeName = try values.decodeIfPresent(String.self, forKey: .shopTypeName)
        usualDispatchTime = try values.decodeIfPresent(Int.self, forKey: .usualDispatchTime)
        webShopName = try values.decodeIfPresent(String.self, forKey: .webShopName)
        workingHours = try values.decodeIfPresent(String.self, forKey: .workingHours)
    }

}
