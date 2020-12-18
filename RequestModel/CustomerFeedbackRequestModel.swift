//
//  CustomerFeedbackRequestModel.swift
//  SingleCart
//
//  Created by PromptTech on 03/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
//{
//    "UserID": 5,
//    "AuthKey": "CydrT0mafUFV2wUKCKZ4CQ==",
//    "Remarks": "_Manufacture_Xiaomi_DeviceModel_Redmi Note 5 Pro_AppVersionCode_28_AppTime_2020-07-15 13:36_AndroidVersion_28_Country_IN_Language_en",
//    "Feedback": "To check feedback is working...."
//}
struct CustomerFeedbackRequestModel{
    var dictionary : Dictionary<String,Any> = Dictionary<String,Any>()
    init(_remark : String?, _feedback : String?) {
        dictionary["UserID"] = (UserDefaults.standard.value(forKey: USERID) as! Int)
        dictionary["AuthKey"] = (UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : "")
        
        dictionary["Remarks"] = _remark ?? ""
        dictionary["Feedback"] = _feedback ?? ""

    }
}//
