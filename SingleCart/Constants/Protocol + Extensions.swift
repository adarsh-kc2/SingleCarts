//
//  Protocol + Extensions.swift
//  SingleCart
//
//  Created by PromptTech on 09/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

protocol AddAddressDelegate {
    func setRadioButtonSelected(selected: UIButton , unseleted: UIButton)
}

protocol MapViewControllerDelegate {
    func setAddressFields(view : UIViewController , dictionary : Dictionary<String,Any>?)
}

protocol AddressViewControllerDelegate {
    func getData(view: UIViewController , _address :  GetAddressResponseData)
}

protocol CartViewControllerDelegate {
    func getData(_price :  String, _indexPath :IndexPath)
    func setQuantity(_quantity : Int,_indexPath :IndexPath )
//    func moveToCheckOut(_section : Int)
}

protocol TrackViewControllerDelegate {
    func backButtonTapped(view : UIViewController)
  
}

protocol ChangeViewControllerDelegate {
    func backButtonTapped(view : UIViewController)
}

protocol CheckOutViewControllerDelegate {
    func backButtonTapped(view : UIViewController)
}

protocol FeedBackViewControllerDelegate {
    func backButtonTapped(view : UIViewController)
}

protocol ReviewViewControllerDelegate {
    func backButtonTapped(view : UIViewController)
}


protocol ShopViewControllerDelegate {
    func backButtonTapped(view : UIViewController)
//    optional func backButtonTappedWithIds(view : UIViewController,shopId :Int , productId : Int)
}


protocol ProductDelegate {
    func backButtonTapped(view : UIViewController,shopId :Int , productId : OfferResponseData)
}
