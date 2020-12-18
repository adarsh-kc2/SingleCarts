//
//  SingleCartCommonFunctions.swift
//  SingleCart
//
//  Created by PromptTech on 17/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController{
    func moveToWishList(){
        if let _id =  UserDefaults.standard.value(forKey: USERID){
            if _id as! Int != 0{
                DispatchQueue.main.async {
                    if #available(iOS 13.0, *) {
                        mywishList.modalPresentationStyle = .fullScreen
                        self.present(mywishList, animated: false)
                    }else{
                        self.present(mywishList, animated: false, completion: nil)
                    }
                }
            }else{
                self.showAlertWithHandlerSignIn(ERROR) { (success, failure) in
                    if success{
                        
                    }else{
                        (UIApplication.shared.delegate as! AppDelegate).loginPage()
                    }
                }
            }
        }else{
            self.showAlertWithHandlerSignIn(ERROR) { (success, failure) in
                if success{
                    
                }else{
                    (UIApplication.shared.delegate as! AppDelegate).loginPage()
                }
            }
        }
        
    }
    
    func cartData(){
        if let _id =  UserDefaults.standard.value(forKey: USERID){
            if _id as! Int != 0{
                DispatchQueue.main.async {
                    let request = GetWishListRequestModel(_shopId: 0)
                    Webservice.shared.getCartList(body: request.dictionary) { (model, errorMessage) in
                        if model != nil{
                            UserDefaults.standard.set((model?.data?.count)!, forKey: CART_VALUE)
                        }else{
                            UserDefaults.standard.set(0, forKey: CART_VALUE)
                        }
                    }
                }
            }else{
                UserDefaults.standard.set(0, forKey: CART_VALUE)
            }
        }
    }
    
    func wishListData(){
        if let _id =  UserDefaults.standard.value(forKey: USERID){
            if _id as! Int != 0{
                DispatchQueue.main.async {
                    let request = GetWishListRequestModel(_shopId: 0)
                    Webservice.shared.getWishList(body: request.dictionary) { (model, errorMessage) in
                        if model != nil{
                            UserDefaults.standard.set((model?.data?.count)!, forKey: WISH_VALUE)
                        }else{
                            UserDefaults.standard.set(0, forKey: WISH_VALUE)
                        }
                    }
                }
            }else{
                UserDefaults.standard.set(0, forKey: WISH_VALUE)
            }
        }
    }
    
    func wishListBadge(completionBlock : @escaping(Int) -> ()){
        var value = 0
        if let _id =  UserDefaults.standard.value(forKey: USERID){
            if _id as! Int != 0{
                DispatchQueue.main.async {
                    let request = GetWishListRequestModel(_shopId: 0)
                    Webservice.shared.getWishList(body: request.dictionary) { (model, errorMessage) in
                        if model != nil{
                            UserDefaults.standard.set((model?.data?.count)!, forKey: WISH_VALUE)
                            value = (model?.data?.count)!
                            completionBlock(value)
                        }else{
                            UserDefaults.standard.set(0, forKey: WISH_VALUE)
                            value = 0
                            completionBlock(value)
                        }
                    }
                }
            }else{
                UserDefaults.standard.set(0, forKey: WISH_VALUE)
                value = 0
                completionBlock(value)
            }
            
           
        }
    }
    
    func cartBadge(completionBlock : @escaping(Int) -> ()){
        var value = 0
        if let _id =  UserDefaults.standard.value(forKey: USERID){
            if _id as! Int != 0{
                DispatchQueue.main.async {
                    let request = GetWishListRequestModel(_shopId: 0)
                    Webservice.shared.getCartList(body: request.dictionary) { (model, errorMessage) in
                        if model != nil{
                            UserDefaults.standard.set((model?.data?.count)!, forKey: CART_VALUE)
                            value = (model?.data?.count)!
                            completionBlock(value)
                        }else{
                            UserDefaults.standard.set(0, forKey: CART_VALUE)
                            completionBlock(value)
                        }
                    }
                }
            }else{
                UserDefaults.standard.set(0, forKey: CART_VALUE)
                completionBlock(value)
            }
        }
    }
    
    func moveToCart(){
        if let _id =  UserDefaults.standard.value(forKey: USERID){
            if _id as! Int != 0{
                DispatchQueue.main.async {
                    if #available(iOS 13.0, *) {
                        myCart.modalPresentationStyle = .fullScreen
                        self.present(myCart, animated: false)
                    }else{
                        self.present(myCart, animated: false, completion: nil)
                    }
                }
            }else{
                self.showAlertWithHandlerSignIn(ERROR) { (success, failure) in
                    if success{
                        
                    }else{
                        (UIApplication.shared.delegate as! AppDelegate).loginPage()
                    }
                }
            }
        }else{
            self.showAlertWithHandlerSignIn(ERROR) { (success, failure) in
                if success{
                    
                }else{
                    (UIApplication.shared.delegate as! AppDelegate).loginPage()
                }
            }
        }
        
        
    }
    
    func moveToOrders(){
        if let _id =  UserDefaults.standard.value(forKey: USERID){
            if _id as! Int != 0{
                DispatchQueue.main.async {
                    if #available(iOS 13.0, *) {
                        order.modalPresentationStyle = .fullScreen
                        self.present(order, animated: false)
                    }else{
                        self.present(order, animated: false, completion: nil)
                    }
                }
            }else{
                self.showAlertWithHandlerSignIn(ERROR) { (success, failure) in
                    if success{
                        
                    }else{
                        (UIApplication.shared.delegate as! AppDelegate).loginPage()
                    }
                }
            }
        }else{
            self.showAlertWithHandlerSignIn(ERROR) { (success, failure) in
                if success{
                    
                }else{
                    (UIApplication.shared.delegate as! AppDelegate).loginPage()
                }
            }
        }
        
    }
    
    func sellOnSingleCart(id :String){
        DispatchQueue.main.async {
            urlpage.loadingURL = id
            DispatchQueue.main.async {
                if #available(iOS 13.0, *) {
                    urlpage.modalPresentationStyle = .fullScreen
                    self.present(urlpage, animated: false)
                }else{
                    self.present(urlpage, animated: false, completion: nil)
                }
            }
        }
    }
    
    func phone(phoneNum: String) {
        if let url = URL(string: "tel://\(phoneNum)") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func updateToken(){
        if let _value = UserDefaults.standard.value(forKey: USERID){
            if (_value as! Int) != 0{
                var dictionary = Dictionary<String,Any>()
                dictionary["UserID"] = UserDefaults.standard.value(forKey: USERID) as! Int
                dictionary["AuthKey"] = UserDefaults.standard.value(forKey: AUTHTOKEN) as! String
                dictionary["Token"] = UserDefaults.standard.value(forKey: FIREBASETOKEN) != nil ? UserDefaults.standard.value(forKey: FIREBASETOKEN) as! String : ""
                Webservice.shared.updateTone(body: dictionary) { (model, error) in
                    if model != nil{
                        // token updated
                    }else{
                        // token not updated
                    }
                }
            }
        }
    }
}


