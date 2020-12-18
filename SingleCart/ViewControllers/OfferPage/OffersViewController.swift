//
//  OffersViewController.swift
//  SingleCart
//
//  Created by apple on 15/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SDWebImage

class OffersViewController: UIViewController {
    @IBOutlet weak var wishLishButton: BageButton!
    
    @IBOutlet weak var cartButton: BageButton!
    var offerModel : OfferResponseModel? = nil
    var offer : OfferRequestModel? = nil
    var offerParams : OfferParametersRequest? = nil
    var offerResponseModel : [OfferResponseData]? = []
    var tempOfferResponseModel : [OfferResponseData]? = []
    
    var activityView : UIView?  = nil
    
    var name = ""
    var imageName = ""
    var _searchString = ""
    
    var pageNo = 1
    var pageSize = 30
    var height : CGFloat = 0
    
    var otherDictionary : Dictionary<String,Any> = Dictionary<String,Any>()
    
    var offerIntegerArray = [Int]()
    var offerBooleanArray = [Bool]()
    
    @IBOutlet weak var offerTableView: UITableView!
    @IBOutlet weak var offerSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        offerIntegerArray = OfferIntValues
        offerBooleanArray = [false,false,false,true,false,true,true,true,true,true,true,true,true]
//        activityView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        offerSearchBar.text = ""
        _searchString = ""
        offerSearchBar.showsCancelButton = false
        self.offerModel = nil
        self.offerTableView.tableFooterView = UIView()
        self.offerTableView.reloadData()
        self.offerResponseModel?.removeAll()
        getAllOffers()
        if let _ = UserDefaults.standard.value(forKey: CART_VALUE){
            cartButton.badge = "\(UserDefaults.standard.value(forKey: CART_VALUE)!)"
        }
        if let _ = UserDefaults.standard.value(forKey: WISH_VALUE){
            wishLishButton.badge = "\(UserDefaults.standard.value(forKey: WISH_VALUE)!)"
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let _ = Webservice.task{
            Webservice.task.cancel()
            if let _ = self.activityView{
                DispatchQueue.main.async {
                    self.hideActivityIndicatorWithout(uiView: self.activityView!)
                }
            }
        }
    }
    
    func getAllOffers(){
        offerParams = OfferParametersRequest(_integerArray: OfferIntValues, _booleanArray: offerBooleanArray)
        offer = OfferRequestModel(_name: _searchString, _pageNo: pageNo, _pageSize: pageSize, otherParams: offerParams!.dictionary)
        
        self.activityView = self.showActivityIndicator(_message: "Loading......")
        Webservice.shared.getOffers(body: offer!.dictionary) { (model, message) in
            self.hideActivityIndicator(uiView: self.activityView!)
            if model == nil && message == nil{
                self.showAlertWithHandlerOKCancel("Your active session was expired. Please re-login to continue or try again later. Do you want to retry?") { (success, failure) in
                    if success{
                        
                    }else{
                        (UIApplication.shared.delegate as! AppDelegate).loginPage()
                    }
                }
            }else if model != nil{
                self.offerModel = model
                for i in 0 ..< (model?.data?.count)!{
                    self.offerResponseModel?.append((model?.data![i])!)
                }
            }else{
                self.offerModel = nil
                self.showSCLAlert(_message:message!)
            }
            DispatchQueue.main.async {
                self.offerTableView.reloadData()
            }
        }
    }
    
    func getOffersSearchProducts(){
        offerParams = OfferParametersRequest(_integerArray: OfferIntValues, _booleanArray: offerBooleanArray)
        offer = OfferRequestModel(_name: _searchString, _pageNo: pageNo, _pageSize: pageSize, otherParams: offerParams!.dictionary)
        
//        self.activityView = self.showActivityIndicator(_message: "Loading......")
        Webservice.shared.getOffersSearchResult(body: offer!.dictionary) { (model, message) in
//            self.hideActivityIndicator(uiView: self.activityView!)
            if model != nil{
                self.offerModel = model
                for i in 0 ..< (model?.data?.count)!{
                    self.offerResponseModel?.append((model?.data![i])!)
                }
            }else{
                self.offerModel = nil
                self.showSCLAlert(_message:message!)
            }
            DispatchQueue.main.async {
                self.offerTableView.reloadData()
            }
        }
    }
    
    @IBAction func wishLIstTapped(_ sender: Any) {
        self.moveToWishList()
    }
    
    @IBAction func cartButtonTapped(_ sender: Any) {
        self.moveToCart()
    }
    
    @IBAction func sideMenuButtonTapped(_ sender: Any) {
    }
    
}
extension OffersViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.offerResponseModel!.isEmpty ? 1 : (self.offerResponseModel?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !(self.offerResponseModel!.isEmpty){
            if (self.offerResponseModel?.count)! > 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: OFFERTABLEVIEWCELL, for: indexPath) as! OfferTableViewCell
                cell.productNameLabel.text = self.offerResponseModel![indexPath.row].itemName!
                cell.productTypeLabel.text = self.offerResponseModel![indexPath.row].shopName!
                cell.productContentLabel.text = self.offerResponseModel![indexPath.row].description!
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "AED \((self.offerResponseModel![indexPath.row].actualPrice)!)")
                
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.productPreviousPriceLabel.attributedText = attributeString
                cell.productCurrentPriceLabel.text = "AED \((self.offerResponseModel![indexPath.row].sellingPrice)!)"
                let distance = String(format: "%.1f", ((self.offerResponseModel![indexPath.row].distance) != nil ? (self.offerResponseModel![indexPath.row].distance)! : 0))
                cell.productDistanceLabel.text =    "\(distance) KM"
                cell.offerValidityLabel.text = "\((self.offerResponseModel![indexPath.row].offerNote)!)"
                if let _ = (self.offerResponseModel![indexPath.row].imageData){
                    if (self.offerResponseModel![indexPath.row].imageData![0].imagePath) != nil{
                        imageName = (self.offerResponseModel![indexPath.row].imageData![0].imagePath)!
                    }else{
                        imageName = placeHolderImage
                    }
                }else{
                    imageName = placeHolderImage
                }
                cell.offerCellImageView.sd_setImage(with: URL(string: imageName), placeholderImage: UIImage(named: placeHolderImage), options: .continueInBackground, context: nil)
                cell.productPercentage.setTitle("\((self.offerResponseModel![indexPath.row].discount)!)%", for: .normal)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: OFFEREMPTYTABLEVIEWCELL, for: indexPath) as! OfferTableViewCell
                cell.selectionStyle = .none
                cell.textLabel?.text = "No Data Available"
                cell.textLabel?.textAlignment = .center
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: OFFEREMPTYTABLEVIEWCELL, for: indexPath) as! OfferTableViewCell
            cell.selectionStyle = .none
            cell.textLabel?.text = "No Data Available"
            cell.textLabel?.textAlignment = .center
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.offerResponseModel?.isEmpty)!{
            
        }else{
            productDetail.produId = (self.offerResponseModel![indexPath.row].stockID)!
            productDetail.productData = self.offerResponseModel![indexPath.row]
            productDetail.shopId = self.offerResponseModel![indexPath.row].shopID!
            DispatchQueue.main.async {
                if #available(iOS 13.0, *) {
                    productDetail.modalPresentationStyle = .fullScreen
                    self.present(productDetail, animated: false)
                }else{
                    self.present(productDetail, animated: false, completion: nil)
                }
            }
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.offerResponseModel!.count > 0 ? UITableView.automaticDimension : offerTableView.frame.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let _ = self.offerModel{
            if indexPath.row == self.offerResponseModel!.count - 1{
                if ((self.offerModel?.pageAvailable)! > 1) && (pageNo < (self.offerModel?.pageAvailable)!){
                    pageNo += 1
                    self.getAllOffers()
                }
            }
        }
    }
}


extension OffersViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        self.tempOfferResponseModel = self.offerResponseModel
        self.offerResponseModel?.removeAll()
        _searchString = searchText
        Webservice.task.cancel()
        getOffersSearchProducts()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
        //        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        _searchString = ""
        searchBar.text! = ""
        self.offerResponseModel = self.tempOfferResponseModel
        self.offerResponseModel?.removeAll()
        self.pageNo = 1
        Webservice.task.cancel()
        getAllOffers()
    }
}




