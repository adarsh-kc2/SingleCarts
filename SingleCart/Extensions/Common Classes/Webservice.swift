//
//  Webservice.swift
//  SingleCart
//
//  Created by PromptTech on 31/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

enum NetworkRequestContentType : String {
    case json       = "application/json"
    case urlEncoded = "application/x-www-form-urlencoded"
    case text       = "text/html; charset=UTF-8"
}

enum NetworkRequestMethod : String {
    case get    = "GET"
    case put    = "PUT"
    case post   = "POST"
    case delete = "DELETE"
}

class Webservice{
    static let shared = Webservice()
    
    //MARK:- Request
    func getRequest(url : URL?, method : NetworkRequestMethod, auth : Bool? , accept: NetworkRequestContentType?, Content_Type :NetworkRequestContentType? ,body: Dictionary<String,Any>?) -> URLRequest{
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        request.setValue(Content_Type?.rawValue, forHTTPHeaderField: "Content-Type")
        request.setValue(REQUESTKEY, forHTTPHeaderField: "RequestKey")
        //        request.setValue(accept?.rawValue, forHTTPHeaderField: "Accept")
        //        if auth!{
        //            let str = "\(UserDefaults.standard.value(forKey:  "token_type")as! String)" + " " + "\(UserDefaults.standard.value(forKey:  "token")as! String)"
        //            request.setValue( str, forHTTPHeaderField: "Authorization" )
        //        }
        if body != nil {
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                request.httpBody = jsonData
            }catch{
            }
        }
        return request
    }
    // Login
    
    func login(body: Dictionary<String,String>,completionBlock : @escaping(LoginResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + LOGIN)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let otp = try? jsonDecoder.decode(LoginResponseModel.self,from: data)
                            if (otp?.Error)! == true{
                                completionBlock(nil, otp?.Message)
                            }else{
                                completionBlock(otp, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    //forgot password -ForgotResponseModel
    
    func forgotPassword(body: Dictionary<String,String>,completionBlock : @escaping(ForgotResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + RESET_PASSWORD)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let forgot = try? jsonDecoder.decode(ForgotResponseModel.self,from: data)
                            if (forgot?.Error)! == true{
                                completionBlock(nil, forgot?.Message)
                            }else{
                                completionBlock(forgot, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    //forgot password -ForgotResponseModel
    
    func forgotPasswordVerification(body: Dictionary<String,String>,completionBlock : @escaping(SetNewPasswordResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + NEW_PASSWORD)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let newPass = try? jsonDecoder.decode(SetNewPasswordResponseModel.self,from: data)
                            if (newPass?.Error)! == true{
                                completionBlock(nil, newPass?.Message)
                            }else{
                                completionBlock(newPass, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    
    // checkUpdates
    func checkDuplicates(body: Dictionary<String,String>,completionBlock : @escaping(CheckUpdateResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + CHECKSIGNUP)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let duplicates = try? jsonDecoder.decode(CheckUpdateResponseModel.self,from: data)
                            if (duplicates?.error)! == true{
                                completionBlock(nil, duplicates?.message!)
                            }else{
                                completionBlock(duplicates, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    
    func signUp(body: Dictionary<String,Any>,completionBlock : @escaping(LoginResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + SIGNUP_URL)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let signUp = try? jsonDecoder.decode(LoginResponseModel.self,from: data)
                            if (signUp?.Error)! == true{
                                completionBlock(nil, signUp?.Message!)
                            }else{
                                completionBlock(signUp, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    
    func getOffers(body: Dictionary<String,Any>,completionBlock : @escaping(OfferResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + GETOFFERPRODUCTS)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "The Internet connection appears to be offline.")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let offer = try? jsonDecoder.decode(OfferResponseModel.self,from: data)
                            if (offer?.error)! == true{
                                completionBlock(nil, offer?.message)
                            }else{
                                completionBlock(offer, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    
    func getOffersSearchResult(body: Dictionary<String,Any>,completionBlock : @escaping(OfferResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + GETOFFERSEARCHPRODUCTS)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "The Internet connection appears to be offline.")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let offer = try? jsonDecoder.decode(OfferResponseModel.self,from: data)
                            if (offer?.error)! == true{
                                completionBlock(nil, offer?.message)
                            }else{
                                completionBlock(offer, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    //GetShopsResponseModel
    
    func getShops(body: Dictionary<String,Any>,completionBlock : @escaping(GetShopsResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + GETSHOPS)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "The Internet connection appears to be offline.")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let shops = try? jsonDecoder.decode(GetShopsResponseModel.self,from: data)
                            if (shops?.error)! == true{
                                completionBlock(nil, shops?.message)
                            }else{
                                completionBlock(shops, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    //get flyers
    
    func getFlyers(body: Dictionary<String,Any>,completionBlock : @escaping(FlyerResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + GETFLYERS)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "The Internet connection appears to be offline.")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let flyer = try? jsonDecoder.decode(FlyerResponseModel.self,from: data)
                            if (flyer?.error)! == true{
                                completionBlock(nil, flyer?.message)
                            }else{
                                completionBlock(flyer, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    //AddtoFavouritesRequestModel
    
    func addtoFavourites(body: Dictionary<String,Any>,completionBlock : @escaping(AddToFavouriteResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + ADDTOFAVOURITES)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "The Internet connection appears to be offline.")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let favourite = try? jsonDecoder.decode(AddToFavouriteResponseModel.self,from: data)
                            if (favourite?.error)! == true{
                                completionBlock(nil, favourite?.message)
                            }else{
                                completionBlock(favourite, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    //GETPROFILE
    func getAccountDetails(body: Dictionary<String,Any>,completionBlock : @escaping(AccountDetailsResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + GETPROFILE)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "The Internet connection appears to be offline.")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let account = try? jsonDecoder.decode(AccountDetailsResponseModel.self,from: data)
                            if (account?.error)! == true{
                                completionBlock(nil, account?.message)
                            }else{
                                completionBlock(account, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    
    //GetAddressResponseModel
    func getUserAddress(body: Dictionary<String,Any>,completionBlock : @escaping(GetAddressResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + GETADDRESS)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "The Internet connection appears to be offline.")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let address = try? jsonDecoder.decode(GetAddressResponseModel.self,from: data)
                            if (address?.error)! == true{
                                completionBlock(nil, address?.message)
                            }else{
                                completionBlock(address, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    
    func changePassword(body: Dictionary<String,Any>,completionBlock : @escaping(SetNewPasswordResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + CHANGE_PASSWORD)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let change = try? jsonDecoder.decode(SetNewPasswordResponseModel.self,from: data)
                            if (change?.Error)! == true{
                                completionBlock(nil, change?.Message)
                            }else{
                                completionBlock(change, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    
    func deleteAddress(body: Dictionary<String,Any>,completionBlock : @escaping(SetNewPasswordResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + DELETEADDRESS)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let delete = try? jsonDecoder.decode(SetNewPasswordResponseModel.self,from: data)
                            if (delete?.Error)! == true{
                                completionBlock(nil, delete?.Message)
                            }else{
                                completionBlock(delete, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    
    func addEditAddress(body: Dictionary<String,Any>,completionBlock : @escaping(SetNewPasswordResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + ADD_EDIT_ADDRESS)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let edit = try? jsonDecoder.decode(SetNewPasswordResponseModel.self,from: data)
                            if (edit?.Error)! == true{
                                completionBlock(nil, edit?.Message)
                            }else{
                                completionBlock(edit, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    
    func getShopDetails(body: Dictionary<String,Any>,completionBlock : @escaping(ShopDetailsResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + GETSHOPDETAILS)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let shopDetail = try? jsonDecoder.decode(ShopDetailsResponseModel.self,from: data)
                            if (shopDetail?.error)! == true{
                                completionBlock(nil, shopDetail?.message!)
                            }else{
                                completionBlock(shopDetail, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    
    //ReviewListResponseModel
    
    func getShopReview(body: Dictionary<String,Any>,completionBlock : @escaping(ReviewListResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + GETREVIEWDETAILS)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let review = try? jsonDecoder.decode(ReviewListResponseModel.self,from: data)
                            if (review?.error)! == true{
                                completionBlock(nil, review?.message!)
                            }else{
                                completionBlock(review, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    //GETREVIEWSUMMARY
    
    func getShopReviewSummary(body: Dictionary<String,Any>,completionBlock : @escaping(ReviewListSummaryModel?,String?) -> ()){
        let url = URL(string : BASE_URL + GETREVIEWSUMMARY)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let review = try? jsonDecoder.decode(ReviewListSummaryModel.self,from: data)
                            if (review?.error)! == true{
                                completionBlock(nil, review?.message!)
                            }else{
                                completionBlock(review, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    //CommonResponseModel
    
    func addToWishList(body: Dictionary<String,Any>,completionBlock : @escaping(CommonResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + ADD_WISH)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let common = try? jsonDecoder.decode(CommonResponseModel.self,from: data)
                            if (common?.error)! == true{
                                completionBlock(nil, common?.message!)
                            }else{
                                completionBlock(common, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    
    func addToCart(body: Dictionary<String,Any>,completionBlock : @escaping(CommonResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + ADD_CART)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let common = try? jsonDecoder.decode(CommonResponseModel.self,from: data)
                            if (common?.error)! == true{
                                completionBlock(nil, common?.message!)
                            }else{
                                completionBlock(common, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    
    //WishListResponseModel
    func getWishList(body: Dictionary<String,Any>,completionBlock : @escaping(WishListResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + GET_WISHLIST)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let getWishList = try? jsonDecoder.decode(WishListResponseModel.self,from: data)
                            if (getWishList?.error)! == true{
                                completionBlock(nil, getWishList?.message!)
                            }else{
                                completionBlock(getWishList, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    
    //CartListResponseModel
    
    func getCartList(body: Dictionary<String,Any>,completionBlock : @escaping(CartListResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + GET_CART)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let getCartList = try? jsonDecoder.decode(CartListResponseModel.self,from: data)
                            if (getCartList?.error)! == true{
                                completionBlock(nil, getCartList?.message!)
                            }else{
                                completionBlock(getCartList, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    
    //CartListResponseModel
    
    func getOrderList(body: Dictionary<String,Any>,completionBlock : @escaping(OrderSummaryResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + MY_ORDERS)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let orderList = try? jsonDecoder.decode(OrderSummaryResponseModel.self,from: data)
                            if (orderList?.error)! == true{
                                completionBlock(nil, orderList?.message!)
                            }else{
                                completionBlock(orderList, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    
    //cartcheckOut api
    
    func cartCheckOut(body: Dictionary<String,Any>,completionBlock : @escaping(CartCheckOutResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + CART_CHECKOUT_URL)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let checkOut = try? jsonDecoder.decode(CartCheckOutResponseModel.self,from: data)
                            if checkOut != nil{
                                //                                if (checkOut?.error)! == true{
                                //                                    completionBlock(nil, checkOut?.message!)
                                //                                }else{
                                //                                    completionBlock(checkOut, nil)
                                //                                }
                                completionBlock(checkOut, nil)
                            }else{
                                completionBlock(nil,"This shop doesn't support delivery to your selected address. \n Please change your address and try again.")
                            }
                            
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    //PlaceOrderResponseModel
    func placeOrder(body: Dictionary<String,Any>,completionBlock : @escaping(PlaceOrderResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + PLACE_ORDER_URL)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let placeOrder = try? jsonDecoder.decode(PlaceOrderResponseModel.self,from: data)
                            if placeOrder != nil{
                                if (placeOrder?.error)! == true{
                                    completionBlock(nil, placeOrder?.message!)
                                }else{
                                    completionBlock(placeOrder, nil)
                                }
                                completionBlock(placeOrder, nil)
                            }else{
                                completionBlock(nil,"some issues found. please try again after sometime")
                            }
                            
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    
    //OrderDetailsResponseModel
    
    func orderSummaryDetails(body: Dictionary<String,Any>,completionBlock : @escaping(OrderDetailsResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + ORDER_DETAILS)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let orderDetails = try? jsonDecoder.decode(OrderDetailsResponseModel.self,from: data)
                            if orderDetails != nil{
                                if (orderDetails?.error)! == true{
                                    completionBlock(nil, orderDetails?.message!)
                                }else{
                                    completionBlock(orderDetails, nil)
                                }
                                completionBlock(orderDetails, nil)
                            }else{
                                completionBlock(nil,"some issues found. please try again after sometime")
                            }
                            
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }

    
    func getShopCategory(body: Dictionary<String,Any>,completionBlock : @escaping(ShopCategoryResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + SHOPCATEGORIES)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let shopCategory = try? jsonDecoder.decode(ShopCategoryResponseModel.self,from: data)
                            if shopCategory != nil{
                                if (shopCategory?.error)! == true{
                                    completionBlock(nil, shopCategory?.message!)
                                }else{
                                    completionBlock(shopCategory, nil)
                                }
                                completionBlock(shopCategory, nil)
                            }else{
                                completionBlock(nil,"some issues found. please try again after sometime")
                            }
                            
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
//GETDASHBOARD_DATA
    
    func getSummaryData(body: Dictionary<String,Any>,completionBlock : @escaping(SummaryDataResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + GETDASHBOARD_DATA)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let shopCategory = try? jsonDecoder.decode(SummaryDataResponseModel.self,from: data)
                            if shopCategory != nil{
                                if (shopCategory?.error)! == true{
                                    completionBlock(nil, shopCategory?.message!)
                                }else{
                                    completionBlock(shopCategory, nil)
                                }
                                completionBlock(shopCategory, nil)
                            }else{
                                completionBlock(nil,"some issues found. please try again after sometime")
                            }
                            
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    
    
    func customerFeedBack(body: Dictionary<String,Any>,completionBlock : @escaping(CommonResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + FEEDBACK_URL)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let common = try? jsonDecoder.decode(CommonResponseModel.self,from: data)
                            if (common?.error)! == true{
                                completionBlock(nil, common?.message!)
                            }else{
                                completionBlock(common, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
    
    func addReview(body: Dictionary<String,Any>,completionBlock : @escaping(CommonResponseModel?,String?) -> ()){
        let url = URL(string : BASE_URL + ADDREVIEW)
        do {
            let request  = getRequest(url: url!, method: .post, auth: false, accept: .json, Content_Type: .json, body: body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                do{
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        completionBlock(nil, "internet error")
                    }else if let data = data{
                        if (response as? HTTPURLResponse)?.statusCode != 200{
                            completionBlock(nil,"There is a problem with your internet connection.")
                        }else{
                            let common = try? jsonDecoder.decode(CommonResponseModel.self,from: data)
                            if (common?.error)! == true{
                                completionBlock(nil, common?.message!)
                            }else{
                                completionBlock(common, nil)
                            }
                        }
                    }
                }catch{
                }
            }
            task.resume()
        }catch{
        }
    }
}



