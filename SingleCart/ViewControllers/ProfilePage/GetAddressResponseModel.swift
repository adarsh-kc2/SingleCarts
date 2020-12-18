//
//  GetAddressResponseModel.swift
//  SingleCart
//
//  Created by PromptTech on 08/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct GetAddressResponseModel : Codable {
    let data : [GetAddressResponseData]?
    let error : Bool?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case data = "Data"
        case error = "Error"
        case message = "Message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([GetAddressResponseData].self, forKey: .data)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}
struct GetAddressResponseData : Codable {
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
