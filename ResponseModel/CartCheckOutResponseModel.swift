//
//  CartCheckOutResponseModel.swift
//  SingleCart
//
//  Created by PromptTech on 22/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct CartCheckOutResponseModel : Codable {
        let cusAddressInfo : CusAddressInfo?
        let error : Bool?
        let isShopVisit : Bool?
        let itemList : [ItemList]?
        let message : String?
        let orderDetails : OrderDetails?
        let shopID : Int?
        let shopInfo : ShopInfo?

        enum CodingKeys: String, CodingKey {

            case cusAddressInfo = "CusAddressInfo"
            case error = "Error"
            case isShopVisit = "IsShopVisit"
            case itemList = "ItemList"
            case message = "Message"
            case orderDetails = "OrderDetails"
            case shopID = "ShopID"
            case shopInfo = "ShopInfo"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            cusAddressInfo = try values.decodeIfPresent(CusAddressInfo.self, forKey: .cusAddressInfo)
            error = try values.decodeIfPresent(Bool.self, forKey: .error)
            isShopVisit = try values.decodeIfPresent(Bool.self, forKey: .isShopVisit)
            itemList = try values.decodeIfPresent([ItemList].self, forKey: .itemList)
            message = try values.decodeIfPresent(String.self, forKey: .message)
            orderDetails = try values.decodeIfPresent(OrderDetails.self, forKey: .orderDetails)
            shopID = try values.decodeIfPresent(Int.self, forKey: .shopID)
            shopInfo = try values.decodeIfPresent(ShopInfo.self, forKey: .shopInfo)
        }

    }

    struct CusAddressInfo : Codable {
        let address1 : String?
        let address2 : String?
        let addressID : Int?
        let area : String?
        let city : String?
        let country : String?
        let customerID : Int?
        let emailAddress : String?
        let firstName : String?
        let isDefault : Bool?
        let isHomeAddress : Bool?
        let landmark : String?
        let lastName : String?
        let latitude : String?
        let longitude : String?
        let mobileNumber : String?
        let province : String?
        let remark : String?

        enum CodingKeys: String, CodingKey {

            case address1 = "Address1"
            case address2 = "Address2"
            case addressID = "AddressID"
            case area = "Area"
            case city = "City"
            case country = "Country"
            case customerID = "CustomerID"
            case emailAddress = "EmailAddress"
            case firstName = "FirstName"
            case isDefault = "IsDefault"
            case isHomeAddress = "IsHomeAddress"
            case landmark = "Landmark"
            case lastName = "LastName"
            case latitude = "Latitude"
            case longitude = "Longitude"
            case mobileNumber = "MobileNumber"
            case province = "Province"
            case remark = "Remark"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            address1 = try values.decodeIfPresent(String.self, forKey: .address1)
            address2 = try values.decodeIfPresent(String.self, forKey: .address2)
            addressID = try values.decodeIfPresent(Int.self, forKey: .addressID)
            area = try values.decodeIfPresent(String.self, forKey: .area)
            city = try values.decodeIfPresent(String.self, forKey: .city)
            country = try values.decodeIfPresent(String.self, forKey: .country)
            customerID = try values.decodeIfPresent(Int.self, forKey: .customerID)
            emailAddress = try values.decodeIfPresent(String.self, forKey: .emailAddress)
            firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
            isDefault = try values.decodeIfPresent(Bool.self, forKey: .isDefault)
            isHomeAddress = try values.decodeIfPresent(Bool.self, forKey: .isHomeAddress)
            landmark = try values.decodeIfPresent(String.self, forKey: .landmark)
            lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
            latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
            longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
            mobileNumber = try values.decodeIfPresent(String.self, forKey: .mobileNumber)
            province = try values.decodeIfPresent(String.self, forKey: .province)
            remark = try values.decodeIfPresent(String.self, forKey: .remark)
        }

    }
    struct ItemList : Codable {
        let actualPrice : Double?
        let quantity : Int?
        let remarks : String?
        let sellingPrice : Double?
        let stockID : Int?

        enum CodingKeys: String, CodingKey {

            case actualPrice = "ActualPrice"
            case quantity = "Quantity"
            case remarks = "Remarks"
            case sellingPrice = "SellingPrice"
            case stockID = "StockID"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            actualPrice = try values.decodeIfPresent(Double.self, forKey: .actualPrice)
            quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
            remarks = try values.decodeIfPresent(String.self, forKey: .remarks)
            sellingPrice = try values.decodeIfPresent(Double.self, forKey: .sellingPrice)
            stockID = try values.decodeIfPresent(Int.self, forKey: .stockID)
        }

    }
    struct OrderDetails : Codable {
        let deliveryCharge : Double?
        let discountAmount : Double?
        let grossAmount : Double?
        let isSuggestDelivery : Bool?
        let itemCount : Int?
        let payableAmount : Double?
        let remarks : String?
        let suggestedDate : String?

        enum CodingKeys: String, CodingKey {

            case deliveryCharge = "DeliveryCharge"
            case discountAmount = "DiscountAmount"
            case grossAmount = "GrossAmount"
            case isSuggestDelivery = "IsSuggestDelivery"
            case itemCount = "ItemCount"
            case payableAmount = "PayableAmount"
            case remarks = "Remarks"
            case suggestedDate = "SuggestedDate"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            deliveryCharge = try values.decodeIfPresent(Double.self, forKey: .deliveryCharge)
            discountAmount = try values.decodeIfPresent(Double.self, forKey: .discountAmount)
            grossAmount = try values.decodeIfPresent(Double.self, forKey: .grossAmount)
            isSuggestDelivery = try values.decodeIfPresent(Bool.self, forKey: .isSuggestDelivery)
            itemCount = try values.decodeIfPresent(Int.self, forKey: .itemCount)
            payableAmount = try values.decodeIfPresent(Double.self, forKey: .payableAmount)
            remarks = try values.decodeIfPresent(String.self, forKey: .remarks)
            suggestedDate = try values.decodeIfPresent(String.self, forKey: .suggestedDate)
        }

    }
    struct ShopInfo : Codable {
        let address : String?
        let closingTime : String?
        let distance : Double?
        let holidays : [String]?
        let homeServiceAllowed : Bool?
        let isFavourite : Bool?
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


struct OpeningTime : Codable {
    let hours : Int?
    let minutes : Int?
    let seconds : Int?
    let milliseconds : Int?
    let ticks : Int?
    let days : Int?
    let totalDays : Double?
    let totalHours : Double?
    let totalMilliseconds : Int?
    let totalMinutes : Double?
    let totalSeconds : Int?

    enum CodingKeys: String, CodingKey {

        case hours = "Hours"
        case minutes = "Minutes"
        case seconds = "Seconds"
        case milliseconds = "Milliseconds"
        case ticks = "Ticks"
        case days = "Days"
        case totalDays = "TotalDays"
        case totalHours = "TotalHours"
        case totalMilliseconds = "TotalMilliseconds"
        case totalMinutes = "TotalMinutes"
        case totalSeconds = "TotalSeconds"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hours = try values.decodeIfPresent(Int.self, forKey: .hours)
        minutes = try values.decodeIfPresent(Int.self, forKey: .minutes)
        seconds = try values.decodeIfPresent(Int.self, forKey: .seconds)
        milliseconds = try values.decodeIfPresent(Int.self, forKey: .milliseconds)
        ticks = try values.decodeIfPresent(Int.self, forKey: .ticks)
        days = try values.decodeIfPresent(Int.self, forKey: .days)
        totalDays = try values.decodeIfPresent(Double.self, forKey: .totalDays)
        totalHours = try values.decodeIfPresent(Double.self, forKey: .totalHours)
        totalMilliseconds = try values.decodeIfPresent(Int.self, forKey: .totalMilliseconds)
        totalMinutes = try values.decodeIfPresent(Double.self, forKey: .totalMinutes)
        totalSeconds = try values.decodeIfPresent(Int.self, forKey: .totalSeconds)
    }

}

struct ClosingTime : Codable {
    let hours : Int?
    let minutes : Int?
    let seconds : Int?
    let milliseconds : Int?
    let ticks : Int?
    let days : Int?
    let totalDays : Double?
    let totalHours : Double?
    let totalMilliseconds : Int?
    let totalMinutes : Double?
    let totalSeconds : Int?

    enum CodingKeys: String, CodingKey {

        case hours = "Hours"
        case minutes = "Minutes"
        case seconds = "Seconds"
        case milliseconds = "Milliseconds"
        case ticks = "Ticks"
        case days = "Days"
        case totalDays = "TotalDays"
        case totalHours = "TotalHours"
        case totalMilliseconds = "TotalMilliseconds"
        case totalMinutes = "TotalMinutes"
        case totalSeconds = "TotalSeconds"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hours = try values.decodeIfPresent(Int.self, forKey: .hours)
        minutes = try values.decodeIfPresent(Int.self, forKey: .minutes)
        seconds = try values.decodeIfPresent(Int.self, forKey: .seconds)
        milliseconds = try values.decodeIfPresent(Int.self, forKey: .milliseconds)
        ticks = try values.decodeIfPresent(Int.self, forKey: .ticks)
        days = try values.decodeIfPresent(Int.self, forKey: .days)
        totalDays = try values.decodeIfPresent(Double.self, forKey: .totalDays)
        totalHours = try values.decodeIfPresent(Double.self, forKey: .totalHours)
        totalMilliseconds = try values.decodeIfPresent(Int.self, forKey: .totalMilliseconds)
        totalMinutes = try values.decodeIfPresent(Double.self, forKey: .totalMinutes)
        totalSeconds = try values.decodeIfPresent(Int.self, forKey: .totalSeconds)
    }

}
