//
//  ReviewListResponseModel.swift
//  SingleCart
//
//  Created by PromptTech on 13/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct ReviewListResponseModel : Codable {
    let error : Bool?
    let message : String?
    let reviewLists : [ReviewLists]?

    enum CodingKeys: String, CodingKey {

        case error = "Error"
        case message = "Message"
        case reviewLists = "ReviewLists"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        reviewLists = try values.decodeIfPresent([ReviewLists].self, forKey: .reviewLists)
    }

}

struct ReviewLists : Codable {
    let description : String?
    let percentage : Int?
    let rate : Int?
    let revQID : Int?
    let title : String?

    enum CodingKeys: String, CodingKey {

        case description = "Description"
        case percentage = "Percentage"
        case rate = "Rate"
        case revQID = "RevQID"
        case title = "Title"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        percentage = try values.decodeIfPresent(Int.self, forKey: .percentage)
        rate = try values.decodeIfPresent(Int.self, forKey: .rate)
        revQID = try values.decodeIfPresent(Int.self, forKey: .revQID)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }

}
