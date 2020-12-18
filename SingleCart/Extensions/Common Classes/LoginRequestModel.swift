//
//  LoginRequestModel.swift
//  SingleCart
//
//  Created by PromptTech on 31/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

struct LoginRequestModel {
    var deviceType : String?
    var password : String?
    var username : String?
    
    var dictionary : Dictionary<String,String> = [:]
    
    init(_deviceType: String ,_password : String ,_username : String){
        self.deviceType = _deviceType
        self.username = _username
        self.password = _password
        
        self.dictionary["Mobile"] = self.username!
        self.dictionary["Password"] = self.password!
        
        self.dictionary["Token"] = self.deviceType!
        self.dictionary["Device"] = String((UIDevice.current.modelName.split(separator: " ").first)!)
        self.dictionary["Model"] = UIDevice.current.modelName
        self.dictionary["OSVersion"] = UIDevice.current.systemVersion
        self.dictionary["AppVersion"] = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!
//        self.dictionary["OSVersion"] = self.deviceType!
    }
}
