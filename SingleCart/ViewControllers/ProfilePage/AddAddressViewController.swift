//
//  AddAddressViewController.swift
//  SingleCart
//
//  Created by PromptTech on 09/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AddAddressViewController: UIViewController {
    @IBOutlet weak var addAddressTableView: UITableView!
    var activityView : UIView? = nil
    var dictionary : Dictionary<String,Any> = [:]
    var isCheck : Bool = false
    var message = ""
    var image : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAddressTableView.tableFooterView = UIView()
        activityView = UIView()
        image = ["face.png","face.png","pin.png","pin.png","face.png","face.png","pin.png","province.png","flag.png","comment.png"]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        let _tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(_tap)
        self.addAddressTableView.reloadData()
        if !(dictionary.isEmpty){
            UserDefaults.standard.set(dictionary["Latitude"] as! String, forKey: ADD_LATITUDE)
            UserDefaults.standard.set(dictionary["Longitude"] as! String, forKey: ADD_LONGITUDE)//Longitude
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if isCheck {
            self.upload()
        }else{
            if checkAll(){
                self.upload()
            }else{
                self.showSCLAlert(_message:message)
            }
        }
    }
    
    func upload(){
        isCheck = false
        activityView = self.showActivityIndicator(_message: "Please Wait...")
        let request = AddAddressRequestModel.init(_dict: dictionary)
        Webservice.shared.addEditAddress(body: request.dic) { (model, error) in
            self.hideActivityIndicator(uiView: self.activityView!)
            if model != nil{
                self.showAlertWithHandler("Address saved successfully") { (success, failure) in
                    if success{
                        self.dismiss(animated: false, completion: nil)
                    }
                }
            }else{
                self.showSCLAlert(_message:error!)
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func locationButtonTapped(){
        DispatchQueue.main.async {
            map_view.mapDelegate = self
            if #available(iOS 13.0, *) {
                map_view.modalPresentationStyle = .fullScreen
                self.present(map_view, animated: false)
            }else{
                self.present(map_view, animated: false, completion: nil)
            }
        }
    }
    
}

extension AddAddressViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ADD_ADDRESSTABLEVIEWCELL + "\(indexPath.row)", for: indexPath) as! addAddressTableViewCell
        if indexPath.row == 0{
            cell.locateOnMapButton.setCornerRadiusWithoutBackground(radius: cell.locateOnMapButton.frame.height / 2)
            cell.locateOnMapButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        }
        if indexPath.row == 1{
            cell.detailsView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
            cell.addressView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)

            cell.firstNametextfield.text = dictionary.isEmpty ? "" : (dictionary["FirstName"] != nil ? (dictionary["FirstName"] as! String).capitalized(with: .current) : "")
            cell.firstNametextfield.withImage(direction: .Left, image: UIImage(named: "face.png")!, colorSeparator: UIColor.orange)
//setLeftView(image: "face.png")
            
            cell.lastNametextfield.text = dictionary.isEmpty ? "" : (dictionary["LastName"] != nil ? (dictionary["LastName"] as! String).capitalized(with: .current) : "")
            cell.lastNametextfield.withImage(direction: .Left, image: UIImage(named: "face.png")!, colorSeparator: UIColor.orange)
            
            cell.address1Textfield.text = dictionary.isEmpty ? "" : (dictionary["Address1"] != nil ? (dictionary["Address1"] as! String).capitalized(with: .current) : "")
            cell.address1Textfield.withImage(direction: .Left, image: UIImage(named: "pin.png")!, colorSeparator: UIColor.orange)
            
            cell.address2Textfield.text = dictionary.isEmpty ? "" : (dictionary["Address2"] != nil ? (dictionary["Address2"] as! String).capitalized(with: .current) : "")
            cell.address2Textfield.withImage(direction: .Left, image: UIImage(named: "pin.png")!, colorSeparator: UIColor.orange)
            
            
            cell.landmarktextfield.text = dictionary.isEmpty ? "" : (dictionary["Landmark"] != nil ? (dictionary["Landmark"] as! String).capitalized(with: .current) : "")
            cell.landmarktextfield.withImage(direction: .Left, image: UIImage(named: "tourism.png")!, colorSeparator: UIColor.orange)
            //tourism
            
            cell.areatextfield.text = dictionary.isEmpty ? "" : (dictionary["Area"] != nil ? (dictionary["Area"] as! String).capitalized(with: .current) : "")
            cell.areatextfield.withImage(direction: .Left, image: UIImage(named: "pin.png")!, colorSeparator: UIColor.orange)
            
            
            cell.citytextfield.text = dictionary.isEmpty ? "" : (dictionary["City"] != nil ? (dictionary["City"] as! String).capitalized(with: .current) : "")
            cell.citytextfield.withImage(direction: .Left, image: UIImage(named: "pin.png")!, colorSeparator: UIColor.orange)
            
            cell.provinceNametextfield.text = dictionary.isEmpty ? "" : (dictionary["Province"] != nil ? (dictionary["Province"] as! String).capitalized(with: .current) : "")
            cell.provinceNametextfield.withImage(direction: .Left, image: UIImage(named: "province.png")!, colorSeparator: UIColor.orange)
            
            cell.countrytextfield.text = dictionary.isEmpty ? "" : (dictionary["Country"] != nil ? (dictionary["Country"] as! String).capitalized(with: .current) : "")
            cell.countrytextfield.withImage(direction: .Left, image: UIImage(named: "flag.png")!, colorSeparator: UIColor.orange)
            
            cell.remarktextfield.text = dictionary.isEmpty ? "" : (dictionary["Remark"] != nil ? (dictionary["Remark"] as! String).capitalized(with: .current) : "")
            cell.remarktextfield.withImage(direction: .Left, image: UIImage(named: "comment.png")!, colorSeparator: UIColor.orange)
            if dictionary.isEmpty{
                // do coding for dictionary is empty
            }else{
                if dictionary["IsHomeAddress"] != nil{
                    cell.homeButton.setBackgroundImage((dictionary["IsHomeAddress"] as! Bool) == true ? UIImage(named: "round_select.png") : UIImage(named: "round_unselect.png"), for: .normal)
                    cell.workButton.setBackgroundImage((dictionary["IsHomeAddress"] as! Bool) == true ? UIImage(named: "round_unselect.png") : UIImage(named: "round_select.png"), for: .normal)
                }
                if dictionary["IsDefault"] != nil{
                    cell.defaultButton.setBackgroundImage((dictionary["IsDefault"] as! Bool) == true ? UIImage(named: "rect_select.png") : UIImage(named: "rect_unSelect.png"), for: .normal)
                }
            }
            cell.buttonDelegate = self
            cell.defaultButton.addTarget(self, action: #selector(setSelected(sender:)), for: .touchUpInside)
        }
        return cell
    }
    
    @objc func setSelected(sender : UIButton){
        if sender.currentBackgroundImage == UIImage(named:"rect_unSelect.png"){
            sender.setBackgroundImage(UIImage(named:"rect_select.png"), for: .normal)
        }else{
            sender.setBackgroundImage(UIImage(named:"rect_unSelect.png"), for: .normal)
        }
    }
}

extension AddAddressViewController :  AddAddressDelegate{
    func setRadioButtonSelected(selected: UIButton , unseleted: UIButton) {
        selected.setBackgroundImage(UIImage(named: "round_select.png"), for: .normal)
        unseleted.setBackgroundImage(UIImage(named: "round_unselect.png"), for: .normal)
    }
}

extension AddAddressViewController {
    @objc func keyboardShow(notification:Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let _key = keyboardRectangle.height
            self.addAddressTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: _key + self.addAddressTableView.rowHeight, right: 0)
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutSubviews()
        }
    }
    
    @objc func keyboardHide(notification:Notification){
        self.addAddressTableView.contentInset = .zero
        UIView.animate(withDuration: 0.5) {
            self.view.layoutSubviews()
        }
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}

extension AddAddressViewController : UITextViewDelegate{
    func checkAll() -> Bool{
        let index = IndexPath(row:1, section: 0)
        var returnValue = false
        let cell = self.addAddressTableView.cellForRow(at:index) as! addAddressTableViewCell
        if let _first = cell.firstNametextfield , let _last = cell.lastNametextfield,let _address = cell.address1Textfield, let _add2 = cell.address2Textfield , let _lan = cell.landmarktextfield , let _area = cell.areatextfield , let _city = cell.citytextfield ,let _province = cell.provinceNametextfield ,let _country = cell.countrytextfield {
            
            if UserDefaults.standard.value(forKey: ADD_LONGITUDE) == nil{
                message = "Please select the location"
            }else if _first.text!.isEmpty{
                message = "Please fill first name"
            }else if _last.text!.isEmpty{
                message = "Please fill last name"
            }else if _address.text!.isEmpty{
                message = "Please fill address"
//            }else if _add2.text!.isEmpty{
//                message = "Please fill address"
//            }else if _lan.text!.isEmpty{
//                message = "Please fill landmark"
//            }else if _city.text!.isEmpty{
//                message = "Please fill city name"
//            }else if _area.text!.isEmpty{
//                message = "Please fill area name"
            }else if _province.text!.isEmpty{
                message = "Please fill province"
            }else if _country.text!.isEmpty{
                message = "Please fill country name"
            }else{
                isCheck = true
                returnValue = true
                if dictionary.isEmpty{
                    dictionary["AddressID"] = 0
                }else{
                    dictionary["AddressID"] = dictionary["AddressID"]
                }
                dictionary["FirstName"] = _first.text!
                dictionary["LastName"] = _last.text!
                dictionary["Address1"] = _address.text!
                dictionary["Address2"] = _add2.text!.isEmpty ? "" : _add2.text!
                dictionary["Landmark"] = _lan.text!.isEmpty ? "" : _lan.text!
                dictionary["Area"] = _area.text!.isEmpty ? "" : _area.text!
                dictionary["City"] = _city.text!.isEmpty ? "" : _city.text!
                dictionary["Country"] = _country.text!
                dictionary["Province"] = _province.text!
                dictionary["Remark"] = cell.remarktextfield.text != nil ? (cell.remarktextfield.text!.isEmpty ? "" : cell.remarktextfield.text!) : ""
                dictionary["IsDefault"] =  cell.defaultButton.currentImage == UIImage(named:"rect_unSelect.png") ? false : true
                dictionary["IsHomeAddress"] = cell.homeButton.currentBackgroundImage == UIImage(named:"round_select.png") ? true : false
                dictionary["Longitude"] = UserDefaults.standard.value(forKey: ADD_LONGITUDE)
                dictionary["Latitude"] = UserDefaults.standard.value(forKey: ADD_LATITUDE)
            }
            return returnValue
        }else{
            message = "Please Fill all the mandatory fields"
            isCheck = false
            return false
        }
    }
}

extension AddAddressViewController : MapViewControllerDelegate{
    func setAddressFields(view: UIViewController, dictionary: Dictionary<String, Any>?) {
        view.dismiss(animated: false, completion: nil)
        if dictionary != nil && !(dictionary!.isEmpty){
            self.dictionary = dictionary!
        }
        self.addAddressTableView.reloadData()
    }
}



