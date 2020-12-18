//
//  SignUpRequestModel.swift
//  SingleCart
//
//  Created by PromptTech on 07/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

struct SignUpModel {
    var deviceType : String?
    var password : String?
    var username : String?
    
    var dictionary : Dictionary<String,Any> = [:]
    
    init(_deviceType: String ,_password : String ,_mobile : String,_email : String , _name : String , _verification : String){
        self.deviceType = _deviceType
        self.username = _mobile
        self.password = _password
        
        self.dictionary["Email"] = _email
        self.dictionary["Name"] = _name
        self.dictionary["Mobile"] = self.username!
        self.dictionary["Password"] = self.password!
        
        self.dictionary["Token"] = self.deviceType!
        self.dictionary["Device"] = String((UIDevice.current.modelName.split(separator: " ").first)!)
        self.dictionary["Model"] = UIDevice.current.modelName
        self.dictionary["OSVersion"] = UIDevice.current.systemVersion
        self.dictionary["AppVersion"] = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!
        self.dictionary["RCode"] = 0
        self.dictionary["MessageID"] = "\(UserDefaults.standard.value(forKey: "MessageId") as! Int)"
        self.dictionary["VerificationCode"]  = _verification//MessageId
    }
}
