//
//  OrderDetailsViewController.swift
//  SingleCart
//
//  Created by PromptTech on 25/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import EventKit

class OrderDetailsViewController: UIViewController {
    var orderID : CLong = 0
    var activityView = UIView()
    var dictionary : Dictionary<String,Any> = Dictionary<String,Any>()
    var cells = [String]()
    var orderModel : OrderDetailsResponseModel? = nil
    var firstRow : Int = 0
    var firstTrackRow = 0
    var lastTrackrow = 0
    var str = ""
    var remnarks = ""
    let eventStore = EKEventStore()
    @IBOutlet weak var orderDetailsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.orderModel = nil
        self.cells.removeAll()
        self.orderDetailsTableView.tableFooterView = UIView()
        self.orderDetailsTableView.reloadData()
        getOrderDetails()
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func getOrderDetails(){
        self.activityView = self.showActivityIndicator(_message:"Please wait...")
        dictionary["UserID"] = "\(UserDefaults.standard.value(forKey: USERID) as! Int)"
        dictionary["AuthKey"] = UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : ""
        dictionary["OrderID"] = orderID
        Webservice.shared.orderSummaryDetails(body: dictionary) { (model, errorMessage) in
            self.hideActivityIndicator(uiView: self.activityView)
            if model != nil{
                self.orderModel = model
            }else{
                self.orderModel = nil
            }
            self.setTableViewCell()
        }
    }
    
    func setTableViewCell(){
        cells.removeAll()
        if self.orderModel != nil{
            if orderModel?.orderSummaryData?.customerAddressResponseData != nil{
                cells.append("OrderDetailTableViewCell0")
            }
            if let _track = orderModel?.trackOrderList{
                for i in 0 ..< _track.count{
                    if i == 0{
                        firstTrackRow = cells.count
                        cells.append("OrderDetailTableViewCell5")
                    }else{
                        cells.append("OrderDetailTableViewCell5")
                        lastTrackrow = cells.count
                    }
                }
            }
            if orderModel?.orderSummaryData?.shopResponseData != nil{
                cells.append("OrderDetailTableViewCell1")
            }
            cells.append("OrderDetailTableViewCell2")
            if orderModel?.productList != nil{
                for i in 0 ..< (orderModel?.productList!.count)! {
                    if i == 0{
                        firstRow = cells.count
                    }
                    cells.append("OrderDetailTableViewCell4")
                }
            }
            cells.append("OrderDetailTableViewCell3")
            DispatchQueue.main.async {
                self.orderDetailsTableView.reloadData()
            }
        }
    }
}

extension OrderDetailsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderModel != nil ? cells.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cells.count > 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.row], for: indexPath) as! OrderDetailTableViewCell
            switch cells[indexPath.row] {
            case "OrderDetailTableViewCell0":
                cell.orderNumberLabel.text = "Order Number : " +  (orderModel?.orderSummaryData?.orderNo)!
                cell.orderAddressNameLabel.text = (orderModel?.orderSummaryData?.customerAddressResponseData?.firstName)!
                var addressString = ""
                addressString.append((orderModel?.orderSummaryData?.customerAddressResponseData?.address1) != nil ? ((orderModel?.orderSummaryData?.customerAddressResponseData?.address1)! != "" ? (orderModel?.orderSummaryData?.customerAddressResponseData?.address1)! + "\n" : "") : "")
                addressString.append((orderModel?.orderSummaryData?.customerAddressResponseData?.address2) != nil ? ((orderModel?.orderSummaryData?.customerAddressResponseData?.address2)! != "" ? (orderModel?.orderSummaryData?.customerAddressResponseData?.address2)! + "\n" : "") : "")
                addressString.append((orderModel?.orderSummaryData?.customerAddressResponseData?.area) != nil ? ((orderModel?.orderSummaryData?.customerAddressResponseData?.area)! != "" ? (orderModel?.orderSummaryData?.customerAddressResponseData?.area)! + "\n" : "") : "")
                addressString.append((orderModel?.orderSummaryData?.customerAddressResponseData?.city) != nil ? ((orderModel?.orderSummaryData?.customerAddressResponseData?.city)! != "" ? (orderModel?.orderSummaryData?.customerAddressResponseData?.city)! + "\n" : "") : "")
                addressString.append((orderModel?.orderSummaryData?.customerAddressResponseData?.landmark) != nil ? ((orderModel?.orderSummaryData?.customerAddressResponseData?.landmark)! != "" ? (orderModel?.orderSummaryData?.customerAddressResponseData?.landmark)! + "\n" : "") : "")
                addressString.append((orderModel?.orderSummaryData?.customerAddressResponseData?.province) != nil ? ((orderModel?.orderSummaryData?.customerAddressResponseData?.province)! != "" ? (orderModel?.orderSummaryData?.customerAddressResponseData?.province)! + "\n" : "") : "")
                addressString.append((orderModel?.orderSummaryData?.customerAddressResponseData?.country) != nil ? ((orderModel?.orderSummaryData?.customerAddressResponseData?.country)! != "" ? (orderModel?.orderSummaryData?.customerAddressResponseData?.country)! + "\n" : "") : "")
                cell.orderAddressLabel.text = addressString
                cell.orderAddressView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.25, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
            case "OrderDetailTableViewCell1":
                cell.orderCompanyNameLabel.text = (orderModel?.orderSummaryData?.shopResponseData?.name)!
                cell.orderCompanyCategoryLabel.text = (orderModel?.orderSummaryData?.shopResponseData?.shopTypeName)!
                cell.orderCompanyStatusLabel.text = (orderModel?.orderSummaryData?.shopResponseData?.openCloseStatus)! ? "Open" : "Close"
                cell.orderCompanyStatusLabel.textColor = (orderModel?.orderSummaryData?.shopResponseData?.openCloseStatus)! ? .green : .red
                if orderModel?.orderSummaryData?.shopRemarks != nil{
                    if (orderModel?.orderSummaryData?.shopRemarks)! != ""{
                    remnarks = "Shop remarks : \((orderModel?.orderSummaryData?.shopRemarks)!) \n"
                    }
                }
                cell.orderCompanyNumberLabel.text = "\(remnarks)contact shop if you have any query +971 \((orderModel?.orderSummaryData?.shopResponseData?.primaryMobile)!)"
                cell.orderCompanyNumberCallButton.addTarget(self, action: #selector(callButton), for: .touchUpInside)
                cell.orderCompanyView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.25, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
            case "OrderDetailTableViewCell2":
                cell.deliveryView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.25, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
                cell.calenderView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.25, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
                if (orderModel?.orderSummaryData?.isSuggested)!{
                    let dateFormatter = DateFormatter()
                    let split = (self.orderModel?.orderSummaryData?.suggestDate)!.split(separator: " ")
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    let dateStringS = dateFormatter.date(from: String(split[0]))!
                    str = dateFormatter.string(from: dateStringS)
                }
                cell.deliveryCommentLabel.text = (orderModel?.orderSummaryData?.customerRemarks!)! == "No comments" ? "Suggested delivery  by \(str)" : "My comments : \((orderModel?.orderSummaryData?.customerRemarks!)!) \nSuggested delivery by \(str)"
                cell.addToCalenderButton.addTarget(self, action: #selector(addToCalendar), for: .touchUpInside)
            case "OrderDetailTableViewCell3":
                cell.priceView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.25, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
                cell.itemsNumberLabel.text = "\((orderModel?.orderSummaryData?.noOfItems!)!)"
                cell.grossAmountLabel.text = "AED \((orderModel?.orderSummaryData?.grossAmount!)!)"
                cell.discountAmount.text = "AED \((orderModel?.orderSummaryData?.discountAmount!)!)"
                cell.deliveryLabel.text = (orderModel?.orderSummaryData?.deliveryCharge!) == 0 ? "Free" :  "AED \((orderModel?.orderSummaryData?.deliveryCharge!)!)"
                cell.deliveryLabel.textColor = (orderModel?.orderSummaryData?.grossAmount!)! == 0 ? UIColor.green : UIColor.lightGray
                cell.payableAmountLabel.text = "AED \((orderModel?.orderSummaryData?.netAmount!)!)"
                cell.savedLabel.text = "You are saved AED \((orderModel?.orderSummaryData?.discountAmount!)!) in this order !!"
            case "OrderDetailTableViewCell4":
//                cell.priceView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.25, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
                cell.productNameLabel.text = "\((orderModel?.productList![indexPath.row - firstRow].itemName!)!)"
                var categoryString = ""
                for i in 0 ..< ((orderModel?.productList![indexPath.row - firstRow].categoryData!.count)!){
                    categoryString.append((orderModel?.productList![indexPath.row - firstRow].categoryData![i].categoryName)!)
                    if i != (orderModel?.productList![indexPath.row - firstRow].categoryData!.count)! - 1{
                        categoryString.append(" , ")
                    }
                }
                cell.productCategoryLabel.text = categoryString
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "AED \((orderModel?.productList![indexPath.row - firstRow].actualPrice!)!)")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.productOriginalLabel.attributedText = attributeString
                cell.productOfferLabel.text = "Offer - \((orderModel?.productList![indexPath.row - firstRow].discount!)!)%"
                cell.productOfferPriceLabel.text = "AED \((orderModel?.productList![indexPath.row - firstRow].sellingPrice!)!)"
                cell.productQuantityLabel.text = "Quantity : \((orderModel?.productList![indexPath.row - firstRow].quantity!)!)"
                cell.productImageView.sd_setImage(with: URL(string: (orderModel?.productList![indexPath.row - firstRow].imageData![0].imagePath)!), placeholderImage: UIImage(named: placeHolderImage), options: .continueInBackground, context: nil)
            case "OrderDetailTableViewCell5":
                cell.orderStatusLabel.text = (orderModel?.trackOrderList![indexPath.row - firstTrackRow].heading)! + "\n" + (orderModel?.trackOrderList![indexPath.row - firstTrackRow].message)!
                cell.orderStatusBottomView.isHidden = (orderModel?.trackOrderList![indexPath.row - firstTrackRow].heading)! == "Delivered" ? true : false
                cell.bottomConstraint.constant = (orderModel?.trackOrderList![indexPath.row - firstTrackRow].heading)! == "Delivered" ? 0 : 30
                if (orderModel?.trackOrderList![indexPath.row - firstTrackRow].isCompleted)! == false{
                    cell.orderStatusBottomView.backgroundColor = .clear
                    cell.orderStatusBottomView.dotColor = .lightGray
                    cell.orderStatusImageView.tintColor = .lightGray
                }else{
                    cell.orderStatusBottomView.dotColor = SELECTED_TRACK
                    cell.orderStatusImageView.tintColor = SELECTED_TRACK
                }
            default:
                break
            }
            return cell
        }else{
            let cell = UITableViewCell()
            cell.textLabel?.text = "No Data Available"
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.orderModel != nil ? UITableView.automaticDimension : self.orderDetailsTableView.frame.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cells[indexPath.row] == "OrderDetailTableViewCell4"{
            productDetail.produId = (self.orderModel?.productList![indexPath.row - firstRow].stockID)!
            productDetail.product = self.orderModel?.productList![indexPath.row - firstRow]
            productDetail.shopId = self.orderModel?.orderSummaryData?.shopResponseData?.shopID! as! Int
            self.moveToDetails()
        }
    }
    
    func moveToDetails(){
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                productDetail.modalPresentationStyle = .fullScreen
                self.present(productDetail, animated: false)
            }else{
                self.present(productDetail, animated: false, completion: nil)
            }
        }
    }
    
    @objc func callButton(){
        if (orderModel?.orderSummaryData?.shopResponseData?.primaryMobile)! != ""{
            phone(phoneNum: "+971\((orderModel?.orderSummaryData?.shopResponseData?.primaryMobile)!)")
        }else if (orderModel?.orderSummaryData?.shopResponseData?.secondaryMobile)! != ""{
            phone(phoneNum: "+971\((orderModel?.orderSummaryData?.shopResponseData?.secondaryMobile)!)")
        }else{
            self.showSCLAlert(_message:"No phone number is available")
        }
    }
    
    @objc func addToCalendar(){
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            insertEvent(store: eventStore)
        case .denied:
            print("Access denied")
        case .notDetermined:
            // 3
            eventStore.requestAccess(to: .event, completion:
                {[weak self] (granted: Bool, error: Error?) -> Void in
                    if granted {
                        self!.insertEvent(store: self!.eventStore)
                    } else {
                        print("Access denied")
                    }
            })
        default:
            print("Case default")
        }
    }
    
    func insertEvent(store: EKEventStore) {
        // 1
        let calendars = store.calendars(for: .event)
        
        for calendar in calendars {
            let startDate = Date()
            let endDate = startDate.addingTimeInterval(2 * 60 * 60)
            let event = EKEvent(eventStore: store)
            event.calendar = calendar
            event.title = "Order details"
            event.startDate = startDate
            event.endDate = endDate
            do {
                try store.save(event, span: .thisEvent)
            }
            catch {
                print("Error saving event in calendar")
                
            }
        }
    }
}
