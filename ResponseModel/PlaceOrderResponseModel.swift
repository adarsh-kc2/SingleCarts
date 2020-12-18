//
//  PlaceOrderResponseModel.swift
//  SingleCart
//
//  Created by PromptTech on 23/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct PlaceOrderResponseModel : Codable {
    let error : Bool?
    let message : String?
    let returnID : Int?
    let orderRefNo : String?

    enum CodingKeys: String, CodingKey {

        case error = "Error"
        case message = "Message"
        case returnID = "ReturnID"
        case orderRefNo = "OrderRefNo"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        returnID = try values.decodeIfPresent(Int.self, forKey: .returnID)
        orderRefNo = try values.decodeIfPresent(String.self, forKey: .orderRefNo)
    }

}
