//
//  SignUpCheckRequestModel.swift
//  SingleCart
//
//  Created by PromptTech on 06/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

struct SignUpCheckRequestModel {
    var Phone : String?
    var Email : String?
    var dictionary : Dictionary<String,String>?
    
    init(_phone : String , _email : String) {
        self.Phone = _phone
        self.Email = _email
        dictionary!["Phone"] = self.Phone
        dictionary!["Email"] = self.Email
    }

}
