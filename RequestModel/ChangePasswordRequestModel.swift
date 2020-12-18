//
//  ChangePasswordRequestModel.swift
//  SingleCart
//
//  Created by PromptTech on 08/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
/*
 {
     "AuthKey": "CydrT0mafUFV2wUKCKZ4CQ==",
     "UserID": 5,
     "OldPassword":"123456",
     "NewPassword":"123456789"
 }
 */
struct ChangePasswordRequestModel {
    var OldPassword : String?
    var NewPassword : String?
    
    var dictionary : Dictionary<String,Any> = [:]
    
    init(_old: String ,_new : String){
        self.OldPassword = _old
        self.NewPassword = _new
        
        self.dictionary["NewPassword"] = _new
        self.dictionary["OldPassword"] = _old
        
        self.dictionary["AuthKey"] = (UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : "")
        self.dictionary["UserID"] = UserDefaults.standard.value(forKey: USERID) as! Int

    }
}
