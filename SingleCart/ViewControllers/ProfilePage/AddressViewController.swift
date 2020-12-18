//
//  AddressViewController.swift
//  SingleCart
//
//  Created by PromptTech on 08/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AddressViewController: UIViewController {
    
    @IBOutlet weak var addressTableViewCell: UITableView!
    var dictionary : Dictionary<String,Any> = Dictionary<String,Any>()
    var activityView : UIView!
    var addressModel : GetAddressResponseModel? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addressTableViewCell.tableFooterView = UIView()
        self.addressModel = nil
        self.addressTableViewCell.reloadData()
        if let _ = UserDefaults.standard.value(forKey: ADD_LATITUDE){
            UserDefaults.standard.removeObject(forKey: ADD_LATITUDE)
            UserDefaults.standard.removeObject(forKey: ADD_LONGITUDE)
        }
        getAddress()
    }
    @IBAction func addAddressButtonTapped(_ sender: Any) {
        //        self.showAlert("Please wait it is under development. sorry for inconvience")
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
    
    @IBAction func backButtontapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func getAddress(){
        activityView = self.showActivityIndicator(_message: "Please wait..")
        dictionary["AuthKey"] = (UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : "")
        dictionary["UserID"] = UserDefaults.standard.value(forKey: USERID) as! Int
        Webservice.shared.getUserAddress(body: dictionary) { (model, errorMessage) in
            self.hideActivityIndicator(uiView:self.activityView)
            if model != nil{
                self.addressModel = model
            }else{
                self.addressModel = nil
            }
            DispatchQueue.main.async {
                self.addressTableViewCell.reloadData()
            }
        }
    }
}

extension AddressViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addressModel != nil ? (self.addressModel!.data!.isEmpty ? 2 : (self.addressModel!.data!.count) + 1) : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if addressModel != nil {
            if (addressModel?.data!.isEmpty)!{
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ADDRESSTABLEVIEWCELL + "\(indexPath.row)", for: indexPath) as! addressTableViewCell
                    cell.addAddressButton.setCornerRadiusWithoutBackground(radius: cell.addAddressButton.frame.height / 2)
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ADDRESSEMPTYTABLEVIEWCELL, for: indexPath) as! addressTableViewCell
                    return cell
                }
            }else{
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ADDRESSTABLEVIEWCELL + "\(indexPath.row)", for: indexPath) as! addressTableViewCell
                    cell.addAddressButton.setCornerRadiusWithoutBackground(radius: cell.addAddressButton.frame.height / 2)
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ADDRESSTABLEVIEWCELL + "\(1)", for: indexPath) as! addressTableViewCell
                    cell.addressNameLabel.text = addressModel?.data![indexPath.row - 1].firstName!
                    cell.addressView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
                    var addressString = ""
                    addressString.append((addressModel?.data![indexPath.row - 1].address1) != nil ? (addressModel?.data![indexPath.row - 1].address1)! + "\n" : "")
                    addressString.append((addressModel?.data![indexPath.row - 1].address2) != nil ? (addressModel?.data![indexPath.row - 1].address2)! + "\n" : "")
                    addressString.append((addressModel?.data![indexPath.row - 1].area) != nil ? (addressModel?.data![indexPath.row - 1].area)! + "\n" : "")
                    addressString.append((addressModel?.data![indexPath.row - 1].city) != nil ? (addressModel?.data![indexPath.row - 1].city)! + "\n" : "")
                    addressString.append((addressModel?.data![indexPath.row - 1].landmark) != nil ? (addressModel?.data![indexPath.row - 1].landmark)! + "\n" : "")
                    addressString.append((addressModel?.data![indexPath.row - 1].province) != nil ? (addressModel?.data![indexPath.row - 1].province)! + "\n" : "")
                    addressString.append((addressModel?.data![indexPath.row - 1].country) != nil ? (addressModel?.data![indexPath.row - 1].country)! + "\n" : "")
                    
                    cell.defaultWidthConstraint.constant = (addressModel?.data![indexPath.row - 1].isDefault)! ? 90 : 0
                    cell.homeButton.setCornerRadiusWithoutBackground(radius: cell.homeButton.frame.height / 2)
                    cell.homeWidthConstraint.constant = (addressModel?.data![indexPath.row - 1].isHomeAddress)! ? 90 : 0
                    cell.DefaultButton.setCornerRadiusWithoutBackground(radius: cell.homeButton.frame.height / 2)
                    cell.workWidthConstraint.constant = !((addressModel?.data![indexPath.row - 1].isHomeAddress)!) ? 90 : 0
                    cell.workButton.setCornerRadiusWithoutBackground(radius: cell.homeButton.frame.height / 2)
                    cell.addressLabel.text = addressString
                    return cell
                }
            }
        }else{
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: ADDRESSTABLEVIEWCELL + "\(indexPath.row)", for: indexPath) as! addressTableViewCell
                cell.addAddressButton.setCornerRadiusWithoutBackground(radius: cell.addAddressButton.frame.height / 2)
                // code for addtarget
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: ADDRESSEMPTYTABLEVIEWCELL, for: indexPath) as! addressTableViewCell
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0{
            var dictionary : Dictionary<String,Any> = [:]
            if let _add = self.addressModel , !(_add.data!.isEmpty){
                dictionary["FirstName"] = _add.data![indexPath.row - 1].firstName!
                dictionary["LastName"] = _add.data![indexPath.row - 1].lastName!
                dictionary["Address1"] = _add.data![indexPath.row - 1].address1!
                dictionary["Address2"] = _add.data![indexPath.row - 1].address2!
                dictionary["Landmark"] = _add.data![indexPath.row - 1].landmark!
                dictionary["Area"] = _add.data![indexPath.row - 1].area!
                dictionary["City"] = _add.data![indexPath.row - 1].city!
                dictionary["Province"] = _add.data![indexPath.row - 1].province!
                dictionary["Country"] = _add.data![indexPath.row - 1].country!
                dictionary["Remark"] = _add.data![indexPath.row - 1].remark!
                dictionary["AddressID"] = _add.data![indexPath.row - 1].addressID!
                dictionary["IsDefault"] = _add.data![indexPath.row - 1].isDefault!
                dictionary["IsHomeAddress"] = _add.data![indexPath.row - 1].isHomeAddress!
                dictionary["Longitude"] = _add.data![indexPath.row - 1].longitude!
                dictionary["Latitude"] = _add.data![indexPath.row - 1].latitude!
                add_Address.dictionary = dictionary
                DispatchQueue.main.async {
                    if #available(iOS 13.0, *) {
                        add_Address.modalPresentationStyle = .fullScreen
                        self.present(add_Address, animated: false)
                    }else{
                        self.present(add_Address, animated: false, completion: nil)
                    }
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row ==  0 {
            return UITableView.automaticDimension
        }else{
            if self.addressModel != nil{
                if self.addressModel!.data!.isEmpty{
                    return self.addressTableViewCell.frame.height - 60
                }else{
                    return UITableView.automaticDimension
                }
            }else{
                return self.addressTableViewCell.frame.height - 60
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row !=  0{
            if addressModel != nil {
                if self.addressModel!.data!.isEmpty{
                    return false
                }else{
                    return true
                }
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row !=  0 && addressModel != nil {
            if !((addressModel?.data!.isEmpty)!){
                if editingStyle == .delete {
                    deleteAddress(address: (addressModel?.data![indexPath.row - 1].addressID)!)
                } else if editingStyle == .insert {
                    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
                }
            }
        }
    }
    
    func deleteAddress(address : Int){
        var activityView = UIView()
        dictionary.removeAll()
        activityView = self.showActivityIndicator(_message: "Please wait..")
        dictionary["AuthKey"] = (UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : "")
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
