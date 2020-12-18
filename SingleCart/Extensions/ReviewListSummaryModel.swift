//
//  ReviewListSummaryModel.swift
//  SingleCart
//
//  Created by PromptTech on 15/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct ReviewListSummaryModel : Codable {
    let error : Bool?
    let message : String?
    let rateByWords : String?
    let rateList : [RateList]?
    let reviewList : [ReviewListData]?
    let totalRating : Double?
    let userCount : Int?

    enum CodingKeys: String, CodingKey {

        case error = "Error"
        case message = "Message"
        case rateByWords = "RateByWords"
        case rateList = "RateList"
        case reviewList = "ReviewList"
        case totalRating = "TotalRating"
        case userCount = "UserCount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        rateByWords = try values.decodeIfPresent(String.self, forKey: .rateByWords)
        rateList = try values.decodeIfPresent([RateList].self, forKey: .rateList)
        reviewList = try values.decodeIfPresent([ReviewListData].self, forKey: .reviewList)
        totalRating = try values.decodeIfPresent(Double.self, forKey: .totalRating)
        userCount = try values.decodeIfPresent(Int.self, forKey: .userCount)
    }

}

struct ReviewListData : Codable {
    let description : String?
    let percentage : Double?
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
        percentage = try values.decodeIfPresent(Double.self, forKey: .percentage)
        rate = try values.decodeIfPresent(Int.self, forKey: .rate)
        revQID = try values.decodeIfPresent(Int.self, forKey: .revQID)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }

}

struct RateList : Codable {
    let count : Int?
    let countPercent : Double?
    let rate : Int?

    enum CodingKeys: String, CodingKey {

        case count = "Count"
        case countPercent = "CountPercent"
        case rate = "Rate"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        countPercent = try values.decodeIfPresent(Double.self, forKey: .countPercent)
        rate = try values.decodeIfPresent(Int.self, forKey: .rate)
    }

}
