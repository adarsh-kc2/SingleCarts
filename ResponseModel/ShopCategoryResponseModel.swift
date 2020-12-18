//
//  ShopCategoryResponseModel.swift
//  SingleCart
//
//  Created by PromptTech on 28/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct ShopCategoryResponseModel : Codable {
    let data : [ShopCategoryResponseData]?
    let error : Bool?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case data = "Data"
        case error = "Error"
        case message = "Message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([ShopCategoryResponseData].self, forKey: .data)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}
struct ShopCategoryResponseData : Codable {
    let categoryID : Int?
    let categoryName : String?
    let image : String?
    let serviceType : Int?

    enum CodingKeys: String, CodingKey {

        case categoryID = "CategoryID"
        case categoryName = "CategoryName"
        case image = "Image"
        case serviceType = "ServiceType"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categoryID = try values.decodeIfPresent(Int.self, forKey: .categoryID)
        categoryName = try values.decodeIfPresent(String.self, forKey: .categoryName)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        serviceType = try values.decodeIfPresent(Int.self, forKey: .serviceType)
    }

}
