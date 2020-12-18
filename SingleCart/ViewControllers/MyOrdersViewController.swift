//
//  MyOrdersViewController.swift
//  SingleCart
//
//  Created by PromptTech on 20/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MyOrdersViewController: UIViewController {
    var activityView : UIView!
    var isFirst : Bool = false
    var dictionary : Dictionary<String,Any> = Dictionary<String,Any>()
    var orderModel : OrderSummaryResponseModel? = nil
    var order : OrderDetailsResponseModel? = nil
    var dateString = ""
    var timeString = ""
    var dateStringS = Date()
    var timeStrings = Date()
    @IBOutlet weak var orderTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.orderTableView.tableFooterView = UIView()
        self.orderTableView.delegate = self
        self.orderTableView.dataSource = self
        self.orderTableView.reloadData()
        getOrders()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func getOrders(){
        self.activityView = self.showActivityIndicator(_message: "Please wait..")
        let request = GetOrderRequestModel(_shopId: 0)
        Webservice.shared.getOrderList(body: request.dictionary) { (model, errorMessage) in
            self.hideActivityIndicator(uiView: self.activityView)
            self.activityView = nil
            if model != nil{
                self.orderModel = model
            }else{
                self.orderModel = nil
            }
            DispatchQueue.main.async {
                self.orderTableView.reloadData()
            }
        }
    }
}

extension MyOrdersViewController : UITableViewDelegate,UITableViewDataSource,TrackViewControllerDelegate{
    func backButtonTapped(view: UIViewController) {
        self.isFirst = false
        view.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (orderModel != nil ? ((orderModel?.orderSummariesData!.isEmpty)! ? 1 : (orderModel?.orderSummariesData?.count)!) : 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if orderModel != nil {
            if (orderModel?.orderSummariesData!.isEmpty)!{
                let cell = tableView.dequeueReusableCell(withIdentifier: MY_ORDER_EMPTY_TABLEVIEWCELL, for: indexPath) as! MyOrderTableViewCell
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: MY_ORDER_TABLEVIEWCELL, for: indexPath) as! MyOrderTableViewCell
                cell.orderTrackButton.setCornerRadiusWithoutBackground(radius: 6.0)
                cell.orderView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor:nil , isBorderWidth: true, borderWidth: 0.4, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
                cell.orderShopNameLabel.text = self.orderModel?.orderSummariesData![indexPath.row].shopResponseData?.name!
                cell.orderIdLabel.text = "Order Number : \((self.orderModel?.orderSummariesData![indexPath.row].orderNo)!)"
                cell.orderItemsLabel.text = "No. of Items : \((self.orderModel?.orderSummariesData![indexPath.row].noOfItems)!)"
                
                if (self.orderModel?.orderSummariesData![indexPath.row].isSuggested!)!{
                    let dateFormatter = DateFormatter()
                    let split = (self.orderModel?.orderSummariesData![indexPath.row].suggestDate)!.split(separator: " ")
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    dateStringS = dateFormatter.date(from: String(split[0]))!
                    dateString = dateFormatter.string(from: dateStringS)
                }
                var suggestedString = (self.orderModel?.orderSummariesData![indexPath.row].isSuggested!)! ? "\nSuggested delivery by \(dateString) " : ""//" at \(timeString)" : ""
                cell.orderDateLabel.text = "Ordered on :" + (self.orderModel?.orderSummariesData![indexPath.row].orderDate!)! + suggestedString
                cell.orderStatusLabel.text = (self.orderModel?.orderSummariesData![indexPath.row].status!)!
                cell.orderStatusLabel.textColor = (self.orderModel?.orderSummariesData![indexPath.row].isPending!)! ? .red : .green
                cell.orderTrackButton.tag = indexPath.row
                cell.orderTrackButton.addTarget(self, action: #selector(trackOrder(sender:)), for: .touchUpInside)
                cell.orderPriceButton.setTitle("AED \((self.orderModel?.orderSummariesData![indexPath.row].netAmount!)!)", for: .normal)
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: MY_ORDER_EMPTY_TABLEVIEWCELL, for: indexPath) as! MyOrderTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = self.orderModel{
            DispatchQueue.main.async {
                orderDetail.orderID = (self.orderModel?.orderSummariesData![indexPath.row].orderID!)!
                if #available(iOS 13.0, *) {
                    orderDetail.modalPresentationStyle = .fullScreen
                    self.present(orderDetail, animated: false)
                }else{
                    self.present(orderDetail, animated: false, completion: nil)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if orderModel != nil{
            if (orderModel?.orderSummariesData!.isEmpty)!{
                return self.orderTableView.frame.height
            }else{
                return UITableView.automaticDimension
            }
        }else{
            return self.orderTableView.frame.height
        }
    }
    
    @objc func trackOrder(sender : UIButton){
        dictionary["UserID"] = "\(UserDefaults.standard.value(forKey: USERID) as! Int)"
        dictionary["AuthKey"] = UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : ""
        dictionary["OrderID"] = (self.orderModel?.orderSummariesData![sender.tag].orderID!)!
        self.activityView = self.showActivityIndicator(_message: "wait...")
        Webservice.shared.orderSummaryDetails(body: dictionary) { (model, errorMessage) in
            self.hideActivityIndicator(uiView: self.activityView)
            if model != nil{
                self.order = model
            }else{
                self.order = nil
            }
            self.moveToTrackPage()
        }
    }
    
    func moveToTrackPage(){
        if isFirst{
            return
        }else{
            self.isFirst = true
            if self.order != nil{
                DispatchQueue.main.async {
                    track.track = self.order?.trackOrderList!
                    track.delegate = self
                    if #available(iOS 13.0, *) {
                        track.modalPresentationStyle = .overFullScreen
                        self.present(track, animated: false)
                    }else{
                        self.present(track, animated: false, completion: nil)
                    }
                }
            }else{
                self.showSCLAlert(_message:"Tracking is not available now.")
            }
        }
    }
}
