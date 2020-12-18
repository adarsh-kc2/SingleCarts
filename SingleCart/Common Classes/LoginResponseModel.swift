//
//  LoginResponseModel.swift
//  SingleCart
//
//  Created by PromptTech on 31/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
/*
 {
     "CustomerName": null,
     "EmailAddress": null,
     "Error": false,
     "Message": "Successfully Logged",
     "SessionKey": "HKDEhPHGaK0JToUwo33Wfw==",
     "UserID": 17
 }
 */

struct LoginResponseModel : Decodable {
    let CustomerName : String?
    let Message : String?
    let SessionKey : String?
    
    let EmailAddress : String?
    let Error : Bool?
    let UserID : Int?
}

struct ForgotResponseModel : Decodable {
    let Message : String?
    let Error : Bool?
}

struct SetNewPasswordResponseModel : Decodable{
    let Message : String?
    let Error : Bool?
    let ReturnID : Int?
}

/*
 {
     "Error": true,
     "Message": "Invalid user",
     "ReturnID": 0
 }*/
