//
//  AddressDetailsViewController.swift
//  SingleCart
//
//  Created by PromptTech on 19/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AddressDetailsViewController: UIViewController {
    
    @IBOutlet weak var addAddressButton: UIButton!
    @IBOutlet weak var addressTableView: UITableView!
    var dictionary : Dictionary<String,Any> = Dictionary<String,Any>()
    var activityView : UIView!
    var addressDelegate : AddressViewControllerDelegate!
    var addressModel : GetAddressResponseModel? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addAddressButton.setCornerRadius(radius: 6.0, isBg_Color: false, bg_Color: nil, isBorder: true, borderColor: UIColor.white, borderWidth: 0.6)
        self.addressTableView.tableFooterView = UIView()
        self.addressTableView.delegate = self
        self.addressTableView.dataSource = self
        self.addressTableView.reloadData()
        if let _ = UserDefaults.standard.value(forKey: ADD_LATITUDE){
            UserDefaults.standard.removeObject(forKey: ADD_LATITUDE)
            UserDefaults.standard.removeObject(forKey: ADD_LONGITUDE)
        }
        self.getAddress()
        
    }
    @IBAction func addAddressButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            add_Address.dictionary = [:]
            if #available(iOS 13.0, *) {
                add_Address.modalPresentationStyle = .fullScreen
                self.present(add_Address, animated: false)
            }else{
                self.present(add_Address, animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func closeButtontapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func doneButtontapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func getAddress(){
        activityView = self.showActivityIndicator(_message: "Please wait..")
        dictionary["AuthKey"] = UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : ""
        dictionary["UserID"] = UserDefaults.standard.value(forKey: USERID) as! Int
        Webservice.shared.getUserAddress(body: dictionary) { (model, errorMessage) in
            self.hideActivityIndicator(uiView:self.activityView)
            self.activityView = nil
            if model != nil{
                self.addressModel = model
            }else{
                self.addressModel = nil
            }
            DispatchQueue.main.async {
                self.addressTableView.reloadData()
            }
        }
    }
}

extension AddressDetailsViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addressModel != nil ? (self.addressModel!.data!.isEmpty ? 1 : (self.addressModel!.data!.count)) : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if addressModel != nil {
            if (addressModel?.data!.isEmpty)!{
                
                let cell = UITableViewCell()
                cell.textLabel?.text = "No Data Available"
                cell.textLabel?.textAlignment = .center
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: ADDRESS_DETAIL_TABLEVIEWCELL, for: indexPath) as! addressDetailTableViewCell
                cell.addressNameLabel.text = addressModel?.data![indexPath.row].firstName!
                cell.addressView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
                var addressString = ""
                addressString.append((addressModel?.data![indexPath.row].address1) != nil ? (addressModel?.data![indexPath.row].address1)! + "\n" : "")
                addressString.append((addressModel?.data![indexPath.row].address2) != nil ? (addressModel?.data![indexPath.row].address2)! + "\n" : "")
                addressString.append((addressModel?.data![indexPath.row].area) != nil ? (addressModel?.data![indexPath.row].area)! + "\n" : "")
                addressString.append((addressModel?.data![indexPath.row].city) != nil ? (addressModel?.data![indexPath.row].city)! + "\n" : "")
                addressString.append((addressModel?.data![indexPath.row].landmark) != nil ? (addressModel?.data![indexPath.row].landmark)! + "\n" : "")
                addressString.append((addressModel?.data![indexPath.row].province) != nil ? (addressModel?.data![indexPath.row].province)! + "\n" : "")
                addressString.append((addressModel?.data![indexPath.row].country) != nil ? (addressModel?.data![indexPath.row].country)! + "\n" : "")
                cell.defaultWidthConstraint.constant = (addressModel?.data![indexPath.row].isDefault)! ? 90 : 0
                cell.homeButton.setCornerRadiusWithoutBackground(radius: cell.homeButton.frame.height / 2)
                cell.homeWidthConstraint.constant = (addressModel?.data![indexPath.row].isHomeAddress)! ? 90 : 0
                cell.DefaultButton.setCornerRadiusWithoutBackground(radius: cell.homeButton.frame.height / 2)
                cell.workWidthConstraint.constant = !((addressModel?.data![indexPath.row].isHomeAddress)!) ? 90 : 0
                cell.workButton.setCornerRadiusWithoutBackground(radius: cell.homeButton.frame.height / 2)
                cell.addressLabel.text = addressString
                return cell
            }
        }else{
            let cell = UITableViewCell()
            cell.textLabel?.text = "No Data Available"
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addressDelegate.getData(view: self, _address:(addressModel?.data![indexPath.row])!)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.addressModel != nil{
            if self.addressModel!.data!.isEmpty{
                return self.addressTableView.frame.height
            }else{
                return UITableView.automaticDimension
            }
        }else{
            return self.addressTableView.frame.height
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if !((addressModel?.data!.isEmpty)!){
            if editingStyle == .delete {
                deleteAddress(address: (addressModel?.data![indexPath.row].addressID)!)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
            }
        }
    }
    
    func deleteAddress(address : Int){
        var activityView = UIView()
        dictionary.removeAll()
        activityView = self.showActivityIndicator(_message: "Please wait..")
        dictionary["AuthKey"] = UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : ""
        dictionary["CustomerID"] = UserDefaults.standard.value(forKey: USERID) as! Int
        dictionary["AddressID"] = address
        Webservice.shared.deleteAddress(body: dictionary) { (model, errorMessage) in
            self.hideActivityIndicator(uiView:activityView)
            if model != nil{
                
            }else{
                self.showSCLAlert(_message:errorMessage!)
            }
            self.getAddress()
        }
        self.getAddress()
    }
}
