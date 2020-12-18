//
//  AccountDetailsResponseModel.swift
//  SingleCart
//
//  Created by PromptTech on 08/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

struct AccountDetailsResponseModel : Codable {
    let email : String?
    let error : Bool?
    let message : String?
    let name : String?
    let phone : String?

    enum CodingKeys: String, CodingKey {

        case email = "Email"
        case error = "Error"
        case message = "Message"
        case name = "Name"
        case phone = "Phone"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
    }

}

