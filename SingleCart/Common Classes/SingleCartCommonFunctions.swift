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
        if #available(iOS 13.0, *) {
            mywishList.modalPresentationStyle = .fullScreen
            self.present(mywishList, animated: false)
        }else{
            self.present(mywishList, animated: false, completion: nil)
        }
    }
    func moveToCart(){
        if #available(iOS 13.0, *) {
            myCart.modalPresentationStyle = .fullScreen
            self.present(myCart, animated: false)
        }else{
            self.present(myCart, animated: false, completion: nil)
        }
    }
    
    func moveToOrders(){
        if #available(iOS 13.0, *) {
            order.modalPresentationStyle = .fullScreen
            self.present(order, animated: false)
        }else{
            self.present(order, animated: false, completion: nil)
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
}
