//
//  AddRemoveCartRequestModel.swift
//  SingleCart
//
//  Created by PromptTech on 17/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
// {
//"UserID":"5",
//"AuthKey":"CydrT0mafUFV2wUKCKZ4CQ==",
//"ShopID":5,
//"StockID":1,
//"Quantity":4,
//"Remarks":"Sample remarkasd",
//"IsAdding":true
//}


struct AddRemoveCartRequestModel{
    var dictionary : Dictionary<String,Any> = Dictionary<String,Any>()
    init(_isadd : Bool,_stockId : Int?, _shopId : Int?,_remarks : String?,_quantity : Int?) {
        dictionary["UserID"] = UserDefaults.standard.value(forKey: USERID) as! Int
        dictionary["AuthKey"] = (UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : "")
        dictionary["ShopID"] = _shopId!
        dictionary["StockID"] = _stockId!
        dictionary["IsAdding"] = _isadd
        dictionary["Quantity"] = _quantity
        dictionary["Remarks"] = _remarks
    }
}
