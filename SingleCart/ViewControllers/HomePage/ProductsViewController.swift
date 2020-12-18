//
//  ProductsViewController.swift
//  SingleCart
//
//  Created by PromptTech on 29/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {
    @IBOutlet weak var productSegment: UISegmentedControl!
    var isFromShop: Bool = false
    var isShowOffers : Bool = true
    var isOpen : Bool = true
    var isClosed : Bool = true
    var categoryId = 0
    var shopId = 0
    var stockId = 0
    var shopType = 0
    var isFirst = false
    var tag = 0
    var name = ""
    var imageName = ""
    var _searchString = ""
    var pageNo = 1
    var pageSize = 30
    var height : CGFloat = 0
    var offerIntegerArray = [Int]()
    var offerBooleanArray = [Bool]()
    var isFromDetails = false
    var isDelayed = false
    var currentRow = 0
    var isFromProductSearch = false
    var isFromSort = false
    
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var productSegmentView: UIView!
    @IBOutlet weak var productSegmentHeight: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productSearchBar: UISearchBar!
    
    var offerModel : OfferResponseModel? = nil
    var offers : OfferRequestModel? = nil
    var offerParams : OfferParametersRequest? = nil
    var offerResponseModel : [OfferResponseData]? = []
    var tempOfferResponseModel : [OfferResponseData]? = []
    var delegate : ProductDelegate!
    var activityView : UIView?  = nil
    var otherDictionary : Dictionary<String,Any> = Dictionary<String,Any>()
    var shopsModel : GetShopsResponseModel? = nil
    var shopsRequest : GetSearchShopsRequestModel? = nil
    var shopsResponseModel : [GetShopsResponseData]? = []
    var tempShopsResponseModel : [GetShopsResponseData]? = []
    var favouriteRequestmodel : AddtoFavouritesRequestModel? = nil
    var booleanArray : [Bool] = [Bool]()
    var tempOfferBooleanArray : [Bool] = [Bool]()
    var tempOfferintegerArray : [Int] = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        offerIntegerArray = OfferIntValues
        offerBooleanArray = [false,false,false,false,false,true,true,true,true,true,true,true,true]
        activityView = UIView()
        self.sortButton.setTitle("SORT", for: .normal)
        self.sortButton.setImage(UIImage(named: "sort.png"), for: .normal)
        self.sortButton.imageEdgeInsets.left = -40
        
        self.filterButton.setTitle("FILTER", for: .normal)
        self.filterButton.setImage(UIImage(named: "filter.png"), for: .normal)
        self.filterButton.imageEdgeInsets.left = -40
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.sortButton.isEnabled = self.tag == 0 ? true : false
        self.sortButton.tintColor = self.tag == 0 ? HOME_NAVIGATION_BGCOLOR : .lightGray
        self.sortButton.setTitleColor(self.tag == 0 ? HOME_NAVIGATION_BGCOLOR : .lightGray, for: .normal)
        self.offerBooleanArray = [false,false,false,false,false,true,true,true,true,true,true,true,true]
        self.setvalues()
    }
    
    override func viewDidAppear(_ animated: Bool) {
            
    }
    
    func setvalues(){
        self.productSegment.selectedSegmentIndex = 0
        self.productSearchBar.delegate = self
        self.tempOfferBooleanArray = self.offerBooleanArray
        self.productSearchBar.text = ""
        self._searchString = ""
        self.productSearchBar.showsCancelButton = false
        self.offerModel = nil
        self.offerParams = nil
        self.productTableView.tableFooterView = UIView()
        self.offerResponseModel?.removeAll()
        self.shopsResponseModel?.removeAll()
        
        self.productSearchBar.delegate = self
        self.offerIntegerArray = OfferIntValues
        self.offerIntegerArray[3] = categoryId
        self.offerIntegerArray[2] = shopId //categoryId//shopType
        self.offerIntegerArray[1] = shopType//shopId
        self.offerIntegerArray[0] = stockId
        self.productNameLabel.text = name
        if isFromProductSearch {
            offerIntegerArray = OfferIntValues
        }
        self.tempOfferintegerArray = offerIntegerArray
        if isFromShop {
            self.productSegmentView.isHidden = true
            self.productSegmentHeight.constant = 0
            self.productSegment.selectedSegmentIndex = 0
        }
        self.productTableView.reloadData()
        self.pageNo = 1
        DispatchQueue.main.async {
            self.getProducts()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.isFromProductSearch = false
        
    }
    
    func getProducts() {
        offerParams = OfferParametersRequest(_integerArray: offerIntegerArray, _booleanArray: offerBooleanArray)
        offers = OfferRequestModel(_name: _searchString, _pageNo: pageNo, _pageSize: pageSize, otherParams: offerParams!.dictionary)
        
        if _searchString == "" {
            if self.pageNo == 1{
                if !isFromSort{
                    self.activityView = self.showActivityIndicator(_message: "Loading......")
                }
            }
        }

        Webservice.shared.getOffersSearchResult(body: offers!.dictionary) { (model, message) in
            if self._searchString == ""{
                if self.pageNo == 1{
                    if let _ = self.activityView{
                        self.hideActivityIndicator(uiView: self.activityView!)
                    }
                }
            }
            if self.pageNo == 1{
                self.offerResponseModel?.removeAll()
                self.shopsResponseModel?.removeAll()
            }
            if model == nil && message == nil{
                self.showAlertWithHandlerOKCancel("Your active session was expired. Please re-login to continue or try again later. Do you want to retry?") { (success, failure) in
                    if success{
                        
                    }else{
                        (UIApplication.shared.delegate as! AppDelegate).loginPage()
                    }
                }
            }else if model != nil{
                self.offerModel = model

//                self.reloadDatas()
                self.removeDuplicates()
            }else{
                self.offerResponseModel?.removeAll()
                self.offerModel = nil
                self.showSCLAlert(_message:message!)
                self.reloadDatas()
            }
        }
    }
    
    func reloadDatas(){
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.productTableView.reloadData()
        })
    }
    
    func removeDuplicates(){
        var temp : [OfferResponseData] = []
        for i in 0 ..< (self.offerModel?.data?.count)!{
            self.offerResponseModel?.append((self.offerModel?.data![i])!)
        }
        if (self.offerResponseModel?.isEmpty)!{
            self.offerResponseModel?.removeAll()
            self.offerResponseModel = temp
        }else{
            for i in 0 ..< (self.offerResponseModel?.count)! - 1{
                var count = 0
                for j in i + 1 ..< (self.offerResponseModel?.count)!{
                    if self.offerResponseModel![i].itemName! == self.offerResponseModel![j].itemName!{
                        count += 1
                    }
                }
                if count == 0{
                    temp.append(self.offerResponseModel![i])
                }
            }
            temp.append(self.offerResponseModel!.last!)
            self.offerResponseModel?.removeAll()
            self.offerResponseModel = temp
            
        }
        self.reloadDatas()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        isFromShop = false
        self.offerIntegerArray = OfferIntValues
        self.dismiss(animated: false, completion: nil)
    }
    
    func getShops(){
        shopsRequest = GetSearchShopsRequestModel(_name: _searchString, _pageNo: pageNo, _pageSize: pageSize, _ShowOffers: isShowOffers, _ShopType: shopType, _isClosed: isOpen, _isOpen: isClosed, _shopId: 0)
        if pageNo == 1{
            self.shopsResponseModel?.removeAll()
            self.shopsModel = nil
        }
        if _searchString == "" {
            activityView = self.showActivityIndicator(_message: "Please wait....")
        }
        
        Webservice.shared.getShops(body: (shopsRequest?.dictionary)!) { (model, errorMessage) in
            if self._searchString == "" {
                self.hideActivityIndicator(uiView: self.activityView!)
            }
            if model == nil && errorMessage == nil{
                self.showAlertWithHandlerOKCancel("Your active session was expired. Please re-login to continue or try again later. Do you want to retry?") { (success, failure) in
                    if success{
                        
                    }else{
                        (UIApplication.shared.delegate as! AppDelegate).loginPage()
                    }
                }
            }else
                if model != nil{
                    self.shopsModel = model
                    for i in 0 ..< (model?.data?.count)!{
                        self.shopsResponseModel?.append((model?.data![i])!)
                        self.booleanArray.append((model?.data![i].isFavourite)!)
                    }
                    self.removeShopsDuplicates()
                }else{
                    self.booleanArray.removeAll()
                    self.shopsModel = nil
                    self.shopsResponseModel?.removeAll()
                    self.showSCLAlert(_message:errorMessage!)
            }
            DispatchQueue.main.async {
                self.productTableView.reloadData()
            }
        }
    }
    
    func removeShopsDuplicates(){
        var temp : [GetShopsResponseData] = []
        if (self.shopsResponseModel?.isEmpty)!{
            self.shopsResponseModel?.removeAll()
            self.shopsResponseModel = temp
        }else{
            for i in 0 ..< (self.shopsResponseModel?.count)! - 1{
                var count = 0
                for j in i + 1 ..< (self.shopsResponseModel?.count)!{
                    if self.shopsResponseModel![i].shopID! == self.shopsResponseModel![j].shopID!{
                        count += 1
                    }
                }
                if count == 0{
                    temp.append(self.shopsResponseModel![i])
                }
            }
            temp.append(self.shopsResponseModel!.last!)
            self.shopsResponseModel?.removeAll()
            self.shopsResponseModel = temp
        }
        self.reloadDatas()
    }
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        self.tag  = sender.selectedSegmentIndex
        pageNo = 1
        self.tag == 0 ? self.getProducts() : self.getShops()
        self.sortButton.isEnabled = self.tag == 0 ? true : false
        self.sortButton.tintColor = self.tag == 0 ? HOME_NAVIGATION_BGCOLOR : .lightGray
        self.sortButton.setTitleColor(self.tag == 0 ? HOME_NAVIGATION_BGCOLOR : .lightGray, for: .normal)
    }
}

extension ProductsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tag == 0{
            return self.offerResponseModel!.isEmpty ? 1 : (self.offerResponseModel?.count)!
        }else{
            return self.shopsResponseModel!.isEmpty ? 1 : (self.shopsResponseModel?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tag == 0){
            if !(self.offerResponseModel!.isEmpty){
                if (self.offerResponseModel?.count)! > 0 && indexPath.row < (self.offerResponseModel?.count)!{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "productTableViewCell", for: indexPath) as! productTableViewCell
                    cell.offerButton.isHidden = self.offerResponseModel![indexPath.row].discount! > 0 ? false : true
                    if self.offerResponseModel![indexPath.row].discount! > 0{
                        cell.offerButton.setTitle("\(self.offerResponseModel![indexPath.row].discount!)%", for: .normal)
                    }
                    cell.productNameLabel.text = self.offerResponseModel![indexPath.row].itemName!
                    cell.productTypeLabel.text = self.offerResponseModel![indexPath.row].shopName!
                    cell.productContentLabel.text = self.offerResponseModel![indexPath.row].description!
                    if (self.offerResponseModel![indexPath.row].offerNote)! != ""{
                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "AED \((self.offerResponseModel![indexPath.row].actualPrice)!)")
                        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                        cell.productPreviousPriceLabel.attributedText = attributeString
                    }else{
                        cell.productPreviousPriceLabel.text = ""
                    }
                    cell.productCurrentPriceLabel.text = "AED \((self.offerResponseModel![indexPath.row].sellingPrice)!)"
                    let distance = String(format: "%.1f", ((self.offerResponseModel![indexPath.row].distance) != nil ? (self.offerResponseModel![indexPath.row].distance)! : 0))
                    cell.productDistanceLabel.text =    "\(distance) KM"
                    cell.productOfferValidityLabel.text = "\((self.offerResponseModel![indexPath.row].offerNote)!)"
                    cell.offerHeightConstraint.constant = (self.offerResponseModel![indexPath.row].offerNote)! != "" ? 15 : 0
                    if let _ = (self.offerResponseModel![indexPath.row].imageData){
                        if (self.offerResponseModel![indexPath.row].imageData![0].imagePath) != nil{
                            imageName = (self.offerResponseModel![indexPath.row].imageData![0].imagePath)!
                        }else{
                            imageName = placeHolderImage
                        }
                    }else{
                        imageName = placeHolderImage
                    }
                    cell.productImageView.sd_setImage(with: URL(string: imageName), placeholderImage: UIImage(named: placeHolderImage), options: .continueInBackground, context: nil)
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
        }else{
            //productShopTableViewCell
            if !(self.shopsResponseModel!.isEmpty){
                if (self.shopsResponseModel?.count)! > 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "productShopTableViewCell", for: indexPath) as! productTableViewCell
                    cell.shopNameLabel.text = self.shopsResponseModel![indexPath.row].name!
                    cell.shopDescriptionLabel.text = self.shopsResponseModel![indexPath.row].shopTypeName!
                    let distance = String(format: "%.1f", self.shopsResponseModel  != nil ? (self.shopsResponseModel![indexPath.row].distance!) : 0)
                    cell.shopDistancePriceLabel.text = "\(distance) KM"
                    cell.shopStatusLabel.text = ((self.shopsResponseModel![indexPath.row].openClose!) == true) ? "Open" : "Closed"
                    cell.shopStatusLabel.textColor = ((self.shopsResponseModel![indexPath.row].openClose!) == true) ? HOME_NAVIGATION_BGCOLOR : UIColor.red
                    if let _ = (self.shopsResponseModel![indexPath.row].logoPath){
                        if (self.shopsResponseModel![indexPath.row].logoPath) != nil{
                            imageName = (self.shopsResponseModel![indexPath.row].logoPath)!
                        }else{
                            imageName = shopsPlaceholderImage
                        }
                    }else{
                        imageName = shopsPlaceholderImage
                    }
                    cell.offerImageView.sd_setImage(with: URL(string: imageName), placeholderImage: UIImage(named: shopsPlaceholderImage), options: .continueInBackground, context: nil)
                    if let _ = (self.shopsResponseModel![indexPath.row].isFavourite){
                        if (self.booleanArray[indexPath.row]){
                            imageName = favourite_true
                        }else{
                            imageName = favourite_false
                        }
                    }else{
                        imageName = favourite_false
                    }
                    cell.shopFavouriteImageView.setImage(UIImage(named: imageName), for: .normal)
                    cell.shopFavouriteImageView.tag = indexPath.row
                    cell.shopFavouriteImageView.addTarget(self, action: #selector(setFavouriteButton), for: .touchUpInside)
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
                cell.textLabel?.text = "No Data Available"
                cell.textLabel?.textAlignment = .center
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tag == 0){
            if (self.offerResponseModel!.count) > 0{
                if isDelayed{
                    self.delegate.backButtonTapped(view: self, shopId: self.offerResponseModel![indexPath.row].shopID!, productId: self.offerResponseModel![indexPath.row])
                }else if isFirst{
                    productDetail.produId = (self.offerResponseModel![indexPath.row].stockID)!
                    productDetail.productData = self.offerResponseModel![indexPath.row]
                    productDetail.shopId = self.offerResponseModel![indexPath.row].shopID!
                    self.dismiss(animated: false, completion: nil)
                }else{
                    productDetail.produId = (self.offerResponseModel![indexPath.row].stockID)!
                    productDetail.productData = self.offerResponseModel![indexPath.row]
                    productDetail.shopId = self.offerResponseModel![indexPath.row].shopID!
                    productDetail.isFromProduct = true
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
        }else{
            if (self.shopsResponseModel!.count) > 0{
                shop_Detail.isFromList = true
                shop_Detail.shopId = (self.shopsResponseModel![indexPath.row].shopID)!
                shop_Detail.shopType = (self.shopsResponseModel![indexPath.row].shopTypeName)!
                shop_Detail.shopsResponseModel = self.shopsResponseModel![indexPath.row]
                self.moveToDetailPage()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tag == 0{
            return self.offerResponseModel!.count > 0 ? UITableView.automaticDimension : productTableView.frame.height
        }else{
            return self.shopsResponseModel!.count > 0 ? UITableView.automaticDimension : productTableView.frame.height
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (_searchString != "" && tag == 0) || _searchString == ""{
            if let _ = self.offerModel{
                if indexPath.row == self.offerResponseModel!.count - 1{
                    if ((self.offerModel?.pageAvailable)! > 1) && (pageNo < (self.offerModel?.pageAvailable)!){
                        pageNo += 1
                        self.getProducts()
                    }
                }
            }
        }else{
            if let _ = self.shopsModel{
                if indexPath.row == self.shopsResponseModel!.count - 1{
                    if ((self.shopsModel?.pageAvailable)! > 1) && (pageNo < (self.shopsModel?.pageAvailable)!){
                        pageNo += 1
                        self.getShops()
                    }
                }
            }
        }
    }
    
    func moveToDetailPage(){
        self.tag = 0
        self.productSegment.setEnabled(true, forSegmentAt: 0)
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                shop_Detail.modalPresentationStyle = .fullScreen
                self.present(shop_Detail, animated: false)
            }else{
                self.present(shop_Detail, animated: false, completion: nil)
            }
        }
    }
}

extension ProductsViewController : UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.async {
            searchBar.showsCancelButton = true
            self._searchString = searchText
            
            if self._searchString == ""{
                self.setValues(segmentHidden: true)
                searchBar.showsCancelButton = false
            }else{
                self.isFromShop ? self.setValues(segmentHidden: true) : self.setValues(segmentHidden: false)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.showsCancelButton = true
            searchBar.endEditing(true)
            self._searchString = searchBar.text!
            if self._searchString == ""{
                searchBar.showsCancelButton = false
                self.setValues(segmentHidden: true)
            }else{
                self.isFromShop ? self.setValues(segmentHidden: true) : self.setValues(segmentHidden: false)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.endEditing(true)
            searchBar.showsCancelButton = false
            self._searchString = ""
            searchBar.text! = ""
            self.productSegment.selectedSegmentIndex = 0
            self.setValues(segmentHidden: true)
        }
    }
    
    func setValues(segmentHidden : Bool){
        Webservice.task.cancel()
        self.productSegmentView.isHidden = isFromShop ? true : false//segmentHidden
        self.productSegmentHeight.constant = isFromShop ? 0 : 30//segmentHidden ? 0 : 30
        self.productSegment.selectedSegmentIndex = segmentHidden ? 0 : self.tag
        self.offerResponseModel?.removeAll()
        self.shopsResponseModel?.removeAll()
        self.shopsModel = nil
        self.pageNo = 1
        self.offerModel = nil
        self.offerIntegerArray[3] = self.categoryId
        self.offerIntegerArray[2] = self.shopId //categoryId//shopType
        self.offerIntegerArray[1] = self.shopType//shopId
        self.offerIntegerArray[0] = self.stockId
        self.offerBooleanArray = [false,false,false,false,false,true,true,true,true,true,true,true,true]
        self.tag = self.productSegment.selectedSegmentIndex
        self.sortButton.isEnabled = self.tag == 0 ? true : false
        self.sortButton.tintColor = self.tag == 0 ? HOME_NAVIGATION_BGCOLOR : .lightGray
        self.sortButton.setTitleColor(self.tag == 0 ? HOME_NAVIGATION_BGCOLOR : .lightGray, for: .normal)
        self.tag == 0 ? self.getProducts() : self.getShops()
    }
    
    @objc func setFavouriteButton(sender: UIButton){
        self.currentRow = sender.tag
        if  (UserDefaults.standard.value(forKey: USERID) as! Int) == 0{
            self.showSCLAlert(_message:"You have to sign in first.")
        }else{
            favouriteRequestmodel = AddtoFavouritesRequestModel(_ShopID: "\((self.shopsResponseModel![sender.tag].shopID)!)", _IsFavorite: !(self.booleanArray[sender.tag]))
            self.setFavourite()
        }
    }
    
    func setFavourite(){
        self.activityView = self.showActivityIndicator(_message: "Please wait...")
        Webservice.shared.addtoFavourites(body: favouriteRequestmodel!.dictionary) { (model, error) in
            self.hideActivityIndicator(uiView: self.activityView!)
            if model != nil{
                self.booleanArray[self.currentRow] = !(self.booleanArray[self.currentRow])
                // do coding here
            }else{
                // set error Message
            }
            DispatchQueue.main.async {
                self.productTableView.reloadRows(at: [IndexPath(row: self.currentRow, section: 0)], with: .none)
            }
        }
    }
    
    @IBAction func sortButtontapped(sender : UIButton){
        self.isFromSort = false
        sort.sortBoolean = self.offerBooleanArray
        sort.sortDelegate = self
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                sort.modalPresentationStyle = .popover
                self.present(sort, animated: false)
            }else{
                self.present(sort, animated: false, completion: nil)
            }
        }
    }
    @IBAction func filterButtontapped(sender : UIButton){
        filter.filterDelegate = self
        filter.booleanArray = self.offerBooleanArray
        filter.integerArray = self.offerIntegerArray
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                filter.modalPresentationStyle = .fullScreen
                self.present(filter, animated: false)
            }else{
                self.present(filter, animated: false, completion: nil)
            }
        }
    }
}

extension ProductsViewController : FilterDelegate,sortDelegate{
    func buttonSelected(view: UIViewController, sortBoolean: [Bool], _ isFromSort: Bool) {
        view.dismiss(animated: false) {
            self.pageNo = 1
            self.isFromSort = isFromSort
            self.offerBooleanArray = sortBoolean
            self.tag == 0 ? self.getProducts() : self.getShops()
        }
        
    }
    
    
    func filterApplied(view: UIViewController, _booleanArray: [Bool], _integerArray: [Int]) {
        view.dismiss(animated: false) {
            self.pageNo = 1
            self.offerResponseModel?.removeAll()
            self.shopsResponseModel?.removeAll()
            self.offerBooleanArray = _booleanArray
            self.offerIntegerArray = _integerArray
            if self.tag == 1{
                self.isOpen = self.offerBooleanArray[8]
                self.isClosed = self.offerBooleanArray[7]
                self.isShowOffers = self.offerBooleanArray[6]
            }
            self.tag == 0 ? self.getProducts() : self.getShops()
        }
    }
    
    override func viewWillLayoutSubviews() {
    }
    
}
