//
//  OrderDetailsResponseModel.swift
//  SingleCart
//
//  Created by PromptTech on 25/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct OrderDetailsResponseModel : Codable {
    let error : Bool?
    let message : String?
    let hasOrders : Bool?
    let orderSummaryData : OrderSummaryData?
    let productList : [OrderProductList]?
    let trackOrderList : [TrackOrderList]?

    enum CodingKeys: String, CodingKey {

        case error = "Error"
        case message = "Message"
        case hasOrders = "hasOrders"
        case orderSummaryData = "orderSummaryData"
        case productList = "productList"
        case trackOrderList = "trackOrderList"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        hasOrders = try values.decodeIfPresent(Bool.self, forKey: .hasOrders)
        orderSummaryData = try values.decodeIfPresent(OrderSummaryData.self, forKey: .orderSummaryData)
        productList = try values.decodeIfPresent([OrderProductList].self, forKey: .productList)
        trackOrderList = try values.decodeIfPresent([TrackOrderList].self, forKey: .trackOrderList)
    }

}

struct OrderCategoryData : Codable {
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
struct OrderCustomerAddressResponseData : Codable {
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

struct OrderImageData : Codable {
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


struct OrderSummaryData : Codable {
    let cancellationReason : String?
    let customerRemarks : String?
    let deliveryCharge : Double?
    let discountAmount : Double?
    let grossAmount : Double?
    let isCancellable : Bool?
    let isPending : Bool?
    let isShopVisit : Bool?
    let isSuggested : Bool?
    let netAmount : Double?
    let noOfItems : Int?
    let orderDate : String?
    let orderID : Int?
    let orderNo : String?
    let shopRemarks : String?
    let status : String?
    let suggestDate : String?
    let customerAddressResponseData : OrderCustomerAddressResponseData?
    let shopResponseData : OrderShopResponseData?

    enum CodingKeys: String, CodingKey {

        case cancellationReason = "CancellationReason"
        case customerRemarks = "CustomerRemarks"
        case deliveryCharge = "DeliveryCharge"
        case discountAmount = "DiscountAmount"
        case grossAmount = "GrossAmount"
        case isCancellable = "IsCancellable"
        case isPending = "IsPending"
        case isShopVisit = "IsShopVisit"
        case isSuggested = "IsSuggested"
        case netAmount = "NetAmount"
        case noOfItems = "NoOfItems"
        case orderDate = "OrderDate"
        case orderID = "OrderID"
        case orderNo = "OrderNo"
        case shopRemarks = "ShopRemarks"
        case status = "Status"
        case suggestDate = "SuggestDate"
        case customerAddressResponseData = "customerAddressResponseData"
        case shopResponseData = "shopResponseData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cancellationReason = try values.decodeIfPresent(String.self, forKey: .cancellationReason)
        customerRemarks = try values.decodeIfPresent(String.self, forKey: .customerRemarks)
        deliveryCharge = try values.decodeIfPresent(Double.self, forKey: .deliveryCharge)
        discountAmount = try values.decodeIfPresent(Double.self, forKey: .discountAmount)
        grossAmount = try values.decodeIfPresent(Double.self, forKey: .grossAmount)
        isCancellable = try values.decodeIfPresent(Bool.self, forKey: .isCancellable)
        isPending = try values.decodeIfPresent(Bool.self, forKey: .isPending)
        isShopVisit = try values.decodeIfPresent(Bool.self, forKey: .isShopVisit)
        isSuggested = try values.decodeIfPresent(Bool.self, forKey: .isSuggested)
        netAmount = try values.decodeIfPresent(Double.self, forKey: .netAmount)
        noOfItems = try values.decodeIfPresent(Int.self, forKey: .noOfItems)
        orderDate = try values.decodeIfPresent(String.self, forKey: .orderDate)
        orderID = try values.decodeIfPresent(Int.self, forKey: .orderID)
        orderNo = try values.decodeIfPresent(String.self, forKey: .orderNo)
        shopRemarks = try values.decodeIfPresent(String.self, forKey: .shopRemarks)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        suggestDate = try values.decodeIfPresent(String.self, forKey: .suggestDate)
        customerAddressResponseData = try values.decodeIfPresent(OrderCustomerAddressResponseData.self, forKey: .customerAddressResponseData)
        shopResponseData = try values.decodeIfPresent(OrderShopResponseData.self, forKey: .shopResponseData)
    }

}

struct OrderProductList : Codable {
    let actualPrice : Double?
    let categoryData : [OfferCategoryData]?
    let description : String?
    let discount : Double?
    let imageData : [OfferImageData]?
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
        categoryData = try values.decodeIfPresent([OfferCategoryData].self, forKey: .categoryData)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        discount = try values.decodeIfPresent(Double.self, forKey: .discount)
        imageData = try values.decodeIfPresent([OfferImageData].self, forKey: .imageData)
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


struct OrderShopResponseData : Codable {
    let address : String?
    let closingTime : String?
    let distance : Int?
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
        distance = try values.decodeIfPresent(Int.self, forKey: .distance)
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


struct TrackOrderList : Codable {
    let heading : String?
    let isCancelled : Bool?
    let isCompleted : Bool?
    let isReturned : Bool?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case heading = "Heading"
        case isCancelled = "IsCancelled"
        case isCompleted = "IsCompleted"
        case isReturned = "IsReturned"
        case message = "Message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        heading = try values.decodeIfPresent(String.self, forKey: .heading)
        isCancelled = try values.decodeIfPresent(Bool.self, forKey: .isCancelled)
        isCompleted = try values.decodeIfPresent(Bool.self, forKey: .isCompleted)
        isReturned = try values.decodeIfPresent(Bool.self, forKey: .isReturned)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}
