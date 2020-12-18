//
//  AddAddressRequestModel.swift
//  SingleCart
//
//  Created by PromptTech on 09/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AddAddressRequestModel {
    var dic : Dictionary<String,Any> = [:]
    init(_dict : Dictionary<String,Any>) {
        dic["AuthKey"] = (UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : "")
        dic["CustomerID"] = UserDefaults.standard.value(forKey: USERID) as! Int
        
//        dic["Latitude"] =  "\(UserDefaults.standard.value(forKey: ADD_LATITUDE))"
//        dic["Longitude"] = "\(UserDefaults.standard.value(forKey: ADD_LONGITUDE))"
        dic["AddressID"] = _dict["AddressID"]
        
        dic["FirstName"] = _dict["FirstName"]
        dic["LastName"] = _dict["LastName"]
        dic["Address1"] = _dict["Address1"]
        dic["Address2"] = _dict["Address2"]
        dic["Landmark"] = _dict["Landmark"]
        dic["Province"] = _dict["Province"]
        dic["Area"] = _dict["Area"]
        dic["City"] = _dict["City"]
        dic["Country"] = _dict["Country"]
        dic["Remark"] = _dict["Remark"]
        dic["Latitude"] = _dict["Latitude"]
        dic["Longitude"] = _dict["Longitude"]
        
        dic["IsDefault"] = _dict["IsDefault"]
        dic["IsHomeAddress"] = _dict["IsHomeAddress"]
        
    }
}
