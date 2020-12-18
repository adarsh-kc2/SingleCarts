//
//  AddReviewRequestModel.swift
//  SingleCart
//
//  Created by PromptTech on 06/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct  AddReviewRequestModel {
    var dictionary : Dictionary<String,Any> = Dictionary<String,Any>()
    var reviewinput : [Dictionary<String,Any>] = [Dictionary<String,Any>]()
//    "ReviewListInputs":[
//    {
//    "RevQID":1,
//    "Rate":3
//    },
//            {
//    "RevQID":3,
//    "Rate":5
//    },
//            {
//    "RevQID":4,
//    "Rate":3
//    },
//            {
//    "RevQID":6,
//    "Rate":3
//    }
//    ]
    
    init(service : Dictionary<String,Any>?, delivery : Dictionary<String,Any>?,quality : Dictionary<String,Any>?, price : Dictionary<String,Any>?,shopId : Int?) {
        dictionary["UserID"] = (UserDefaults.standard.value(forKey: USERID) as! Int)
        dictionary["AuthKey"] = (UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : "")
        dictionary["ShopID"] = shopId!
        reviewinput.append(service!)
        reviewinput.append(delivery!)
        reviewinput.append(quality!)
        reviewinput.append(price!)
        dictionary["ReviewListInputs"] = reviewinput
        

    }
}
