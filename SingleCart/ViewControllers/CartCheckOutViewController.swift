//
//  CartCheckOutViewController.swift
//  SingleCart
//
//  Created by PromptTech on 22/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import FSCalendar

class CartCheckOutViewController: UIViewController {
    
    @IBOutlet var timePickerView: UIView!
    @IBOutlet weak var timePickersView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    
    var checkOutDelegate : CheckOutViewControllerDelegate!
    var pickerView = UIView()
    var timePicker = UIDatePicker()
    @IBOutlet var fsCalendarView: FSCalendar!
    var activeView = UIView()
    @IBOutlet weak var checkOutTableView: UITableView!
    var cheCkOutData : CartCheckOutResponseModel!
    @IBOutlet weak var placeOrderButton: UIButton!
    @IBOutlet weak var priceButton: UIButton!
    var isSuggested : Bool = false
    var remark : String = ""
    var dateTimeString : String = ""
    var dateString = ""
    var timeString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkOutTableView.tableFooterView = UIView()
        self.checkOutTableView.delegate = self
        self.checkOutTableView.dataSource = self
        self.placeOrderButton.setCornerRadiusWithoutBackground(radius: 10.0)
        self.priceButton.setCornerRadiusWithoutBackground(radius: 10.0)
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateString = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "hh:mm a"
        timeString = dateFormatter.string(from: date)
        
        self.checkOutTableView.reloadData()
        self.priceButton.setTitle("AED \((cheCkOutData.orderDetails?.payableAmount)!)", for: .normal)
    }
    
    @IBAction func backButtontapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func placeOrderButtonTapped(_ sender: Any) {
        let cell = checkOutTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! CheckOutTableViewCell
        remark = cell.commentBox.text.isEmpty ? "" : cell.commentBox.text
        dateTimeString = cell.datetextField.text! + " " + cell.timeTextField.text!
        self.activeView = self.showActivityIndicator(_message: "Please Wait....")
        let request = PlaceOrderRequestModel(_shopId: (cheCkOutData.shopID!), _AddressID: (cheCkOutData.cusAddressInfo?.addressID!)!, _IsShopVisit: (cheCkOutData.isShopVisit!), isSuggestedDelivery: isSuggested, _remark: remark, _date: dateTimeString)
        Webservice.shared.placeOrder(body: request.dictionary) { (model, errorMessage) in
            self.hideActivityIndicator(uiView: self.activeView)
            if model != nil{
                self.showAlertWithHandler((model?.message!)!) { (success, failure) in
                    if success{
                        self.checkOutDelegate.backButtonTapped(view: self)
                    }
                }
            }else{
                self.showSCLAlert(_message:errorMessage!)
            }
        }
        
    }
}

extension CartCheckOutViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CHECKOUT_TABLEVIEWCELL + "\(indexPath.row)", for: indexPath) as! CheckOutTableViewCell
        switch indexPath.row {
        case 0:
            cell.serviceProviderView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
            cell.shopNameLabel.text = cheCkOutData.shopInfo?.name!
            cell.shopTypeLabel.text = "\((cheCkOutData.shopInfo?.shopTypeName)!) \nDistance :\(String(format: "%.1f",cheCkOutData.shopInfo?.distance! as! CVarArg)) Km"
            cell.shopStatusLabel.text = (cheCkOutData.shopInfo?.openCloseStatus!) == true ? "Open" : "Close"
            cell.shopStatusLabel.textColor = (cheCkOutData.shopInfo?.openCloseStatus!) == true ? UIColor.green : UIColor.red
            var additional = self.cheCkOutData?.shopInfo?.maxDeliveryRange != nil ? "Maximum  Delivery range is \((self.cheCkOutData?.shopInfo?.maxDeliveryRange)!) Km.\n" : ""
            additional.append(self.cheCkOutData?.shopInfo?.usualDispatchTime != nil ? "Usual Dipsatch time is \((self.cheCkOutData?.shopInfo?.usualDispatchTime)!) minutes.\n" : "")
            cell.shopDescriptionLabel.text = additional
        case 1:
            if (self.cheCkOutData.shopInfo?.serviceType)! == PRODUCT_TYPE_SHOP{
                if (self.cheCkOutData.isShopVisit)!{
                    cell.detailsLabel.text = "Collection details :"
                    cell.schedulelabel.text = "Suggest collection date and time"
                }else{
                    cell.detailsLabel.text = "Delivery details :"
                    cell.schedulelabel.text = "Suggest delivery date and time"
                }
            }else{
                if (self.cheCkOutData.isShopVisit)!{
                    cell.detailsLabel.text = "Shop visit details :"
                }else{
                    cell.detailsLabel.text = "Home service details :"
                }
            }
            cell.sceduleButton.addTarget(self, action: #selector(scheduleService(sender:)), for: .touchUpInside)
            cell.sceduleButton.tag = indexPath.row
            cell.shopVisitProviderView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
            cell.datetextField.addTarget(self, action: #selector(getDate), for: .editingDidBegin)
            cell.timeTextField.text = timeString
            cell.datetextField.text = dateString
            
            cell.timeTextField.addTarget(self, action: #selector(getTime), for: .editingDidBegin)
            cell.commentBox.setCornerRadius(radius: 2.0, isShadow: false, isBorderColor: true, borderColor: .lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.6, shadowOpacity: nil, shadowColor: nil, shadowOffset: nil)
        case 2:
            cell.helpView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
            var str = ""
            if (self.cheCkOutData?.shopInfo?.primaryMobile!)! != ""{
              str = (self.cheCkOutData?.shopInfo?.primaryMobile!)!
            }else if (self.cheCkOutData?.shopInfo?.secondaryMobile!)! != ""{
                str = (self.cheCkOutData?.shopInfo?.secondaryMobile!)!
            }else{
                str = ""
            }
            cell.numberLabel.text =  str != "" ? "Contact shop if any query : +971 \(str)" : ""
            cell.callButton.isEnabled = str != "" ? true : false
            cell.callButton.addTarget(self, action: #selector(callButton), for: .touchUpInside)
        case 3:
            cell.priceView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
            cell.itemsNumberLabel.text = "\((self.cheCkOutData?.orderDetails?.itemCount)!)"
            cell.grossAmountLabel.text = "AED \((self.cheCkOutData?.orderDetails?.grossAmount)!)"
            cell.discountAmount.text = "AED \((self.cheCkOutData?.orderDetails?.discountAmount)!)"
            cell.deliveryLabel.text = (self.cheCkOutData?.orderDetails?.deliveryCharge)! == 0 ? "Free" :  "AED \((self.cheCkOutData?.orderDetails?.deliveryCharge)!)"
            cell.deliveryLabel.textColor = (self.cheCkOutData?.orderDetails?.deliveryCharge)! == 0 ? UIColor.green : UIColor.lightGray
            cell.payableAmountLabel.text = "AED \((self.cheCkOutData?.orderDetails?.payableAmount)!)"
            cell.savedLabel.text = "You are saved AED \((self.cheCkOutData?.orderDetails?.discountAmount)!) in this order."
        default :
            return UITableViewCell()
        }
        return cell
    }
}

extension CartCheckOutViewController: FSCalendarDelegate {
    @objc func scheduleService(sender : UIButton){
        if sender.currentImage == UIImage(named: "rect_unSelect.png"){
            sender.setImage(UIImage(named: "rect_select.png"), for: .normal)
            isSuggested = true
        }else{
            sender.setImage(UIImage(named: "rect_unSelect.png"), for: .normal)
            isSuggested = false
        }
    }
    
    @objc func getDate() {
        fsCalendarView.frame = CGRect(x: self.view.frame.midX - (self.view.frame.width / 2 - 10), y: self.view.frame.midY - (self.view.frame.width / 2 - 10), width: self.view.frame.width - 20, height: self.view.frame.width - 20)
        fsCalendarView.delegate = self
        self.view.addSubview(fsCalendarView)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateString = dateFormatter.string(from: date)
        self.fsCalendarView.removeFromSuperview()
        reloadRows()
    }
    
    @objc func getTime() {
        self.timePickerView.setCornerRadius(radius: 6.0, isShadow: false, isBorderColor: true, borderColor: .lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.5, shadowOpacity: nil, shadowColor: nil, shadowOffset: nil)
        self.timePickersView.setCornerRadius(radius: 6.0, isShadow: false, isBorderColor: true, borderColor: .lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.5, shadowOpacity: nil, shadowColor: nil, shadowOffset: nil)
        timePicker = UIDatePicker(frame: CGRect(x: 0.0, y: 0.0, width: self.timePickersView.frame.width, height: self.timePickersView.frame.height))
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(datePickerFromValueChanged), for: UIControl.Event.valueChanged)
        self.timePickersView.addSubview(timePicker)
        self.doneButton.setCornerRadius(radius: 6.0, bg_Color: HOME_NAVIGATION_BGCOLOR)
        self.timePickerView.addSubview(timePickersView)
        self.timePickerView.frame = CGRect(x: self.view.frame.midX -  self.timePickerView.frame.width / 2, y: self.view.frame.midY -  self.timePickerView.frame.height / 2, width: self.timePickerView.frame.width, height: self.timePickerView.frame.height)
        self.view.addSubview(self.timePickerView)
    }    
    
    @objc func datePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        timeString = dateFormatter.string(from: sender.date)
        reloadRows()
    }
    
    func reloadRows(){
        DispatchQueue.main.async {
            self.checkOutTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        }
        
    }
    
    @objc func callButton(){
        if (self.cheCkOutData?.shopInfo?.primaryMobile!)! != ""{
            phone(phoneNum: (self.cheCkOutData?.shopInfo?.primaryMobile!)!)
        }else if (self.cheCkOutData?.shopInfo?.secondaryMobile!)! != ""{
            phone(phoneNum: (self.cheCkOutData?.shopInfo?.secondaryMobile!)!)
        }else{
            self.showSCLAlert(_message:"No phone number is available")
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        self.timePickerView.removeFromSuperview()
        self.timePicker.removeFromSuperview()
        reloadRows()
    }
}
