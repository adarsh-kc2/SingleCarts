//
//  ReviewViewController.swift
//  SingleCart
//
//  Created by PromptTech on 06/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import FloatRatingView

class ReviewViewController: UIViewController {

    var shopID : Int = 0
    var delegate : ReviewViewControllerDelegate!
    var reviewListSummary : ReviewListResponseModel? = nil
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var service: FloatRatingView!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var delivery: FloatRatingView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var price: FloatRatingView!
    @IBOutlet weak var qualty: FloatRatingView!
    var dictionary1 = Dictionary<String,Any>()
    var dictionary2 = Dictionary<String,Any>()
    var dictionary3 = Dictionary<String,Any>()
    var dictionary4 = Dictionary<String,Any>()
    var message = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.ratingView.setCornerRadius(radius: 6.0, isShadow: false, isBorderColor: true, borderColor: .lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.5, shadowOpacity: nil, shadowColor: nil, shadowOffset:     nil)
        self.getReview()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func getReview(){
        let shopRequest = ShopDetailsRequestModel(_ShopID: shopID)
        Webservice.shared.getShopReview(body: shopRequest.dictionary) { (model, errorMessage) in
            if model != nil{
                self.reviewListSummary = model
                self.setUpView()
            }else{
                self.reviewListSummary = nil
            }
        }
    }
    
    func setUpView(){
        DispatchQueue.main.async {
            for i in 0 ..< (self.reviewListSummary?.reviewLists?.count)!{
                switch (self.reviewListSummary?.reviewLists![i].title)! {
                case "Service":
                    self.service.rating = (self.reviewListSummary?.reviewLists![i].rate!)!.doubleValue
                    self.service.fullImage = UIImage(named: "star.png")
                    self.serviceLabel.text = (self.reviewListSummary?.reviewLists![i].description)!
                case "Delivery":
                    self.delivery.rating = (self.reviewListSummary?.reviewLists![i].rate!)!.doubleValue
                    self.delivery.fullImage = UIImage(named: "star.png")
                    self.deliveryLabel.text = (self.reviewListSummary?.reviewLists![i].description)!
                case "Quality":
//                    self.qualty.
                    self.qualty.rating = (self.reviewListSummary?.reviewLists![i].rate!)!.doubleValue
                    self.qualty.fullImage = UIImage(named: "star.png")
                    self.qualityLabel.text = (self.reviewListSummary?.reviewLists![i].description)!
                default:
                    self.price.rating = (self.reviewListSummary?.reviewLists![i].rate!)!.doubleValue
                    self.price.fullImage = UIImage(named: "star.png")
                    self.priceLabel.text = (self.reviewListSummary?.reviewLists![i].description)!
                }
            }
            
        }
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        dictionary1["RevQID"] = 1
        dictionary1["Rate"] = Int(service.rating)
        dictionary1["Description"] = "Overall services and staffs behaviour"
        dictionary1["Title"] = "Service"
        dictionary1["Percentage"] = 0
        
        dictionary2["RevQID"] = 3
        dictionary2["Rate"] = Int(delivery.rating)
        dictionary2["Description"] = "About their delivery"
        dictionary2["Title"] = "Delivery"
        dictionary2["Percentage"] = 0
        
        dictionary3["RevQID"] = 4
        dictionary3["Rate"] = Int(qualty.rating)
        dictionary3["Description"] = "Quality of product or services"
        dictionary3["Title"] = "Quality"
        dictionary3["Percentage"] = 0
        
        dictionary4["RevQID"] = 6
        dictionary4["Rate"] = Int(price.rating)
        dictionary4["Description"] = "Provide product or sevices at better price"
        dictionary4["Title"] = "Price"
        dictionary4["Percentage"] = 0
        
        let request = AddReviewRequestModel(service: dictionary1, delivery: dictionary2, quality: dictionary3, price: dictionary4, shopId: shopID)
        Webservice.shared.addReview(body: request.dictionary) { (model, errorMessage) in
            if model != nil{
                self.message = "Submitted successfully"
            }else{
                self.message = errorMessage!
            }
            self.showAlertWithHandler(self.message) { (success, fail) in
                if success{
                    self.delegate.backButtonTapped(view : self)
                    
                }
            }
        }
    }
    
}


extension Int {
  var doubleValue: Double {
    return Double(self)
  }
}
