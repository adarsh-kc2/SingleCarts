//
//  MyCartViewController.swift
//  SingleCart
//
//  Created by PromptTech on 18/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MyCartViewController: UIViewController {
    var activityView = UIView()
    @IBOutlet weak var cartTableView: UITableView!
    var checkOutModel : CartCheckOutResponseModel? = nil
    var cartModel : CartListResponseModel? = nil
    var address : GetAddressResponseData? = nil
    var addressModel : GetAddressResponseModel? = nil
    var dictionary : Dictionary<String,Any> = Dictionary<String,Any>()
    var heading : String = "Deliver to :"
    var price = 0.0
    var stepperValue : [[Int]] = [[]]
    var steps : [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.cartTableView.tableFooterView = UIView()
        self.cartTableView.delegate = self
        self.cartTableView.dataSource = self
        self.cartTableView.reloadData()
        getCartData()
        getAddress()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func getCartData(){
        DispatchQueue.main.async {
            self.activityView = self.showActivityIndicator(_message: "Please wait..")
            let request = GetWishListRequestModel(_shopId: 0)
            Webservice.shared.getCartList(body: request.dictionary) { (model, errorMessage) in
                self.hideActivityIndicator(uiView: self.activityView)
//                self.activityView = nil
                if model != nil{
                    self.cartData()
                    self.cartModel = (model?.data?.isEmpty)! ? nil : model
                }else{
                    self.cartModel = nil
                }
//                DispatchQueue.main.async {
//                    self.cartTableView.reloadData()
//                }
                self.setStepperValues(model: self.cartModel)
            }
        }
    }
    
    func setStepperValues(model : CartListResponseModel?){
        
        if let _ = model{
            stepperValue = []
            for i in 0 ..< (model?.data!.count)!{
                steps = []
                for j in 0 ..< (model?.data![i].getCartDataProductData!.count)! {
                    steps.append((model?.data![i].getCartDataProductData![j].quantity)!)
                }
                stepperValue.append(steps)
            }
        }
        DispatchQueue.main.async {
            self.cartTableView.reloadData()
        }

    }
    
    func getAddress(){
        dictionary["AuthKey"] = UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : ""
        dictionary["UserID"] = UserDefaults.standard.value(forKey: USERID) as! Int
        Webservice.shared.getUserAddress(body: dictionary) { (model, errorMessage) in
            if model != nil{
                self.addressModel = model
            }else{
                self.addressModel = nil
            }
            self.setAddress()
        }
    }
    
    func setAddress(){
        if let _ = self.addressModel{
            for i in 0 ..< (self.addressModel?.data!.count)!{
                if (self.addressModel?.data![i].isDefault)!{
                    address = self.addressModel?.data![i]
                    break
                }else{
                    address = self.addressModel?.data![i]
                }
            }
        }
        DispatchQueue.main.async {
            self.cartTableView.reloadData()
        }
    }
}

extension MyCartViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = self.cartModel != nil ? (self.cartModel?.data?.count)! : 0
        return count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            let count = self.cartModel != nil ? (self.cartModel?.data![section - 1].getCartDataProductData?.count)! + 1 : 1
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cartTableViewCell
        if let _ = cartModel {
            if indexPath.section == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: CARTLIST_TABLEVIEWCELL + "0", for: indexPath) as! cartTableViewCell
                cell.cartAddressButton.setCornerRadiusWithoutBackground(radius: 6.0)
                var addressString = ""
                var buttonString = ""
                if let _model = self.addressModel,(self.addressModel?.data!.count)! > 0 {
                    addressString.append((address?.address1) != nil ? (address?.address1)! + "\n" : "")
                    addressString.append((address?.address2) != nil ? (address?.address2)! + " , " : "")
                    addressString.append((address?.area) != nil ? (address?.area)! + " , " : "")
                    addressString.append((address?.city) != nil ? (address?.city)! + " , " : "")
                    addressString.append((address?.landmark) != nil ? (address?.landmark)! + " , " : "")
                    addressString.append((address?.province) != nil ? (address?.province)! + " , " : "")
                    addressString.append((address?.country) != nil ? (address?.country)! : "")
                    buttonString = "Change Address"
                }else{
                    addressString = "No Address Availbale"
                    buttonString = "Add Address"
                }
                cell.cartAddressLabel.text = addressString
                cell.cartAddressButton.setTitle(buttonString, for: .normal)
                cell.cartAddressButton.addTarget(self, action: #selector(addressButtonTapped(sender:)), for: .touchUpInside)
                return cell
            }else{
                if  indexPath.row < (self.cartModel?.data![indexPath.section - 1].getCartDataProductData!.count)!{
                    let cell = tableView.dequeueReusableCell(withIdentifier: CARTLIST_TABLEVIEWCELL + "1", for: indexPath) as! cartTableViewCell
                    cell.cartListStepper.minimumValue = 1.0
                    cell.cartListStepper.isEnabled = true
                    cell.cartDelegate = self
                    cell.cartListView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor:nil , isBorderWidth: true, borderWidth: 0.4, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
                    cell.indexPathValue = indexPath
                    cell.cartListNameLabel.text = self.cartModel?.data![indexPath.section - 1].getCartDataProductData![indexPath.row].itemName!
                    var categoryString = ""
                    for i in 0 ..< (self.cartModel?.data![indexPath.section - 1].getCartDataProductData![indexPath.row].categoryData!.count)!{
                        categoryString.append((self.cartModel?.data![indexPath.section - 1].getCartDataProductData![indexPath.row].categoryData![i].categoryName!)!)
                        if (self.cartModel?.data![indexPath.section - 1].getCartDataProductData![indexPath.row].categoryData!.count)! > 0{
                            categoryString.append(",")
                        }
                    }
                    cell.cartListCategoryLabel.text = categoryString
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "AED \((self.cartModel?.data![indexPath.section - 1].getCartDataProductData![indexPath.row].actualPrice!)!)")
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                    cell.cartListActualPriceLabel.attributedText = attributeString
                    cell.cartListOfferpercentageLabel.text = "Offer - \(String(format: "%.1f",((self.cartModel?.data![indexPath.section - 1].getCartDataProductData![indexPath.row].discount!)!)))%"
                    cell.cartListOfferPriceLabel.text = "AED \((self.cartModel?.data![indexPath.section - 1].getCartDataProductData![indexPath.row].sellingPrice!)!)"
                    cell.cartListQuantityLabel.text = "Quantity : \((self.cartModel?.data![indexPath.section - 1].getCartDataProductData![indexPath.row].quantity!)!)"
                    cell.cartListImageView.sd_setImage(with: URL(string:(self.cartModel?.data![indexPath.section - 1].getCartDataProductData![indexPath.row].imageData![0].imagePath)!)!, placeholderImage: UIImage(named: placeHolderImage), options: .continueInBackground, context: nil)
                    cell.cartListStepper.tagSection = indexPath.section - 1
                    cell.cartListStepper.tagRow = indexPath.row
                    cell.cartListStepper.addTarget(self, action: #selector(setQuantity(Sender:)), for: .valueChanged)

                    return cell
                }else{
                    price = 0.0
                    let cell = tableView.dequeueReusableCell(withIdentifier: CART_CHECKOUT_TABLEVIEWCELL, for: indexPath) as! cartTableViewCell
                    var text1 = ""
                    var text2 = ""
                    if (self.cartModel?.data![indexPath.section - 1].serviceType!) == PRODUCT_TYPE_SHOP{
                        text1 = cartList_1_First
                        text2 = cartList_1_Second
                    }else if (self.cartModel?.data![indexPath.section - 1].serviceType!) == SERVICE_TYPE_SHOP{
                        text1 = cartList_2_First
                        text2 = cartList_2_Second
                    }else{
                        text1 = cartList_3_First
                        text2 = cartList_3_Second
                    }
                    cell.cartListTickOnelabel.text = text1
                    cell.cartListTickTwolabel.text = text2
                    if (self.cartModel?.data![indexPath.section - 1].homeServiceAllowed)! ==  false{
                        cell.cartListTickOneButton.isEnabled = false
                        cell.cartListTickOnelabel.isEnabled = false
                        cell.cartListTickTwoButton.setImage(UIImage(named:"round_select.png"), for: .normal)
                        cell.cartListTickOneButton.setImage(UIImage(named:"round_unselect.png"), for: .normal)
                    }
                    for i in 0 ..< (self.cartModel?.data![indexPath.section - 1].getCartDataProductData!.count)!{
                        price += ((self.cartModel?.data![indexPath.section - 1].getCartDataProductData![i].sellingPrice!)! * Double((self.cartModel?.data![indexPath.section - 1].getCartDataProductData![i].quantity!)!))
                    }
                    cell.cartListFinalPricelabel.text = String(format: "AED %.1f", self.price)
                    cell.tempValue.append(self.price)
                    cell.cartCheckOutButton.setCornerRadiusWithoutBackground(radius: 6.0)
                    cell.cartCheckOutButton.tag = indexPath.section - 1
                    cell.cartCheckOutButton.addTarget(self, action: #selector(cartCheckOut(sender:)), for: .touchUpInside)
                    return cell
                }
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cartEmptyableViewCell", for: indexPath) as! cartTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  self.cartModel != nil ? UITableView.automaticDimension : self.cartTableView.frame.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let _ = cartModel{
            let headerView: UIView = UIView.init(frame: CGRect.init(x: -1, y: 50, width: self.view.frame.width, height: 50))
            headerView.setCornerRadius(radius: 1.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: true, B_GColor:HOME_NAVIGATION_BGCOLOR , isBorderWidth: true, borderWidth: 0.4, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
            let labelView: UILabel = UILabel.init(frame: CGRect.init(x: 10, y: 4, width: 276, height: 42))
            labelView.numberOfLines = 0
            if section == 0{
                labelView.text = heading
            }else{
                labelView.text = self.cartModel?.data![section - 1].name!
            }
            labelView.textColor = .white
            headerView.addSubview(labelView)
            return headerView
        }else{
            let headerView: UIView = UIView.init(frame: CGRect.init(x: -1, y: 50, width: self.view.frame.width, height: 0))
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _ = cartModel{
            return 50
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section != 0 && indexPath.row != (self.cartModel?.data![indexPath.section - 1].getCartDataProductData?.count)!{
            if editingStyle == .delete{
              deleteFromCart(indexpath: indexPath)
            }
        }
    }
    func deleteFromCart(indexpath : IndexPath){
        let request = AddRemoveCartRequestModel(_isadd: false, _stockId: self.cartModel?.data![indexpath.section - 1].getCartDataProductData![indexpath.row].stockID!, _shopId:self.cartModel?.data![indexpath.section - 1].getCartDataProductData![indexpath.row].shopID!, _remarks: "", _quantity: self.cartModel?.data![indexpath.section - 1].getCartDataProductData![indexpath.row].quantity!)
        Webservice.shared.addToCart(body: request.dictionary) { (model, error) in
            if model != nil{
                    self.showSCLAlert(_message:"Item removed from cart successfully.")
            }else{
                self.showSCLAlert(_message:error!)
            }
            self.getCartData()
        }
    }
}

extension MyCartViewController {
    @objc func addressButtonTapped(sender : UIButton){
        if sender.title(for: .normal) == "Add Address"{
            DispatchQueue.main.async {
                if #available(iOS 13.0, *) {
                    add_Address.modalPresentationStyle = .fullScreen
                    self.present(add_Address, animated: false)
                }else{
                    self.present(add_Address, animated: false, completion: nil)
                }
            }
        }else{
            addressDetail.addressModel = addressModel
            addressDetail.addressDelegate = self
            DispatchQueue.main.async {
                if #available(iOS 13.0, *) {
                    addressDetail.modalPresentationStyle = .popover
                    self.present(addressDetail, animated: false)
                }else{
                    self.present(addressDetail, animated: false, completion: nil)
                }
            }
        }
    }
}

extension MyCartViewController : AddressViewControllerDelegate{
    func getData(view: UIViewController, _address: GetAddressResponseData) {
        self.address = _address
        self.cartTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        view.dismiss(animated: false, completion: nil)
    }
}

extension MyCartViewController : CartViewControllerDelegate ,CheckOutViewControllerDelegate{
    func setQuantity(_quantity: Int, _indexPath: IndexPath) {
        //
    }
    
    func backButtonTapped(view: UIViewController) {
        view.dismiss(animated: false) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func setQuantity(Sender: UIStepper) {
        let request = AddRemoveCartRequestModel(_isadd: true, _stockId: (self.cartModel?.data![ Sender.tagSection!].getCartDataProductData![Sender.tagRow!].stockID)!, _shopId: (self.cartModel?.data![Sender.tagSection!].getCartDataProductData![Sender.tagRow!].shopID)!, _remarks: "", _quantity: Int(Sender.value))
//        stepperValue[Sender.tagSection!][Sender.tagRow!] = Int(Sender.value)
        Webservice.shared.addToCart(body: request.dictionary) { (model, errorMessage) in
            if model != nil{
                //coding here
            }else{
                // coding here
            }
            DispatchQueue.main.async {
                self.getCartData()
            }
        }
    }
    
    func getData(_price: String, _indexPath: IndexPath) {
        self.cartTableView.reloadRows(at: [IndexPath(row: (self.cartModel?.data![ _indexPath.section - 1].getCartDataProductData!.count)! + 1, section: _indexPath.section)], with: .none)
    }
    
    @objc func cartCheckOut(sender : UIButton){
        let index = IndexPath(row: (self.cartModel?.data![sender.tag].getCartDataProductData?.count)!, section: sender.tag)
        var isShop : Bool = false
        let cell = self.cartTableView.dequeueReusableCell(withIdentifier: CART_CHECKOUT_TABLEVIEWCELL, for: index) as! cartTableViewCell
        if cell.cartListTickOneButton.imageView?.image != UIImage(named:"round_select.png"){
            isShop = true
            address = nil
        }
        let requst = CartCheckOutRequestModel(_shopId: (self.cartModel?.data![sender.tag].shopID!)!, _AddressID: address != nil ? (address?.addressID)! : nil, _IsShopVisit: isShop)
        self.activityView = self.showActivityIndicator(_message: "Processing....")
        Webservice.shared.cartCheckOut(body: requst.dictionary) { (model, errorMessage) in
            self.hideActivityIndicator(uiView: self.activityView)
//            self.activityView = nil
            if model != nil{
                self.checkOutModel = model
                if (self.checkOutModel?.message)!.contains("Shop is closed"){
                    self.showSCLAlert(_message:(self.checkOutModel?.message)!)
                }else{
                    self.moveToCartCheckOut()
                }
            }else{
                self.checkOutModel = nil
                self.showSCLAlert(_message:errorMessage!)
            }
        }
    }
    
    func moveToCartCheckOut(){
        DispatchQueue.main.async {
            checkOut.checkOutDelegate = self
            checkOut.cheCkOutData = self.checkOutModel
            if #available(iOS 13.0, *) {
                checkOut.modalPresentationStyle = .fullScreen
                self.present(checkOut, animated: false)
            }else{
                self.present(checkOut, animated: false, completion: nil)
            }
        }
    }
}
