//
//  FeedPageViewController.swift
//  SingleCart
//
//  Created by apple on 14/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SCLAlertView

class FeedPageViewController: UIViewController{
    
    @IBOutlet weak var searchSegment: UISegmentedControl!
    @IBOutlet weak var segmentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var feedSearchBar: UISearchBar!
    @IBOutlet weak var wishLishButton: BageButton!
    @IBOutlet weak var cartButton: BageButton!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterHeightConstraint: NSLayoutConstraint!
    
    var offerResponseModel : [OfferResponseData]? = []
    var offerModel : OfferResponseModel? = nil
    var shopModel : ShopCategoryResponseModel? = nil
    var summaryModel : SummaryDataResponseModel? = nil
    var shopsModel : GetShopsResponseModel? = nil
    var shopsRequest : GetSearchShopsRequestModel? = nil
    var shopsResponseModel : [GetShopsResponseData]? = []
    var tempShopsResponseModel : [GetShopsResponseData]? = []
    var favouriteRequestmodel : AddtoFavouritesRequestModel? = nil
    var booleanArray : [Bool] = [Bool]()
    var currentRow = 0
    var imageName = ""
    var pageNo = 1
    var segmentSelected = 0
    var shopType = 0
    var _searchString = ""
    var activeView : UIView!
    var cells : [String] = [String]()
    var dictionary : Dictionary<String,Any> = Dictionary<String,Any>()
    var indexPathRow : [Int] = [0,0]
    var isShowOffers : Bool = true
    var isOpen : Bool = true
    var isClosed : Bool = true
    var isFromSort = false
    var offerBooleanArray = [false,false,false,false,false,true,true,true,true,true,true,true,true]
    var offerIntegerArray : [Int] = []
    var isFromFilter = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let _ = Webservice.task{
            Webservice.task.cancel()
            if let _ = self.activeView{
                DispatchQueue.main.async {
                    self.hideActivityIndicatorWithout(uiView: self.activeView)
                }
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.offerIntegerArray = OfferIntValues
        self.sortButton.setTitle("SORT", for: .normal)
        self.sortButton.setImage(UIImage(named: "sort.png"), for: .normal)
        self.sortButton.imageEdgeInsets.left = -40
        
        self.filterButton.setTitle("FILTER", for: .normal)
        self.filterButton.setImage(UIImage(named: "filter.png"), for: .normal)
        self.filterButton.imageEdgeInsets.left = -40
        self.sortButton.isEnabled = self.segmentSelected == 0 ? true : false
        self.sortButton.tintColor = self.segmentSelected == 0 ? HOME_NAVIGATION_BGCOLOR : .lightGray
        self.sortButton.setTitleColor(self.segmentSelected == 0 ? HOME_NAVIGATION_BGCOLOR : .lightGray, for: .normal)
        
        self.segmentViewHeightConstraint.constant = 0
        self.segmentView.isHidden = true
        self.filterHeightConstraint.constant = 0
        self.filterView.isHidden = true
        if !isFromFilter{
            feedSearchBar.text = ""
            feedSearchBar.showsCancelButton = false
            _searchString = ""
        }
        self.updateToken()
        self.shopsResponseModel?.removeAll()
        self.dictionary["UserID"] = "\(UserDefaults.standard.value(forKey: USERID) as! Int)"
        self.dictionary["AuthKey"] = UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : ""
        self.dictionary["Latitude"] = (UserDefaults.standard.value(forKey: LATITUDE)) != nil ? "\(UserDefaults.standard.value(forKey: LATITUDE) as! NSNumber)" : ""
        self.dictionary["Longitude"] = (UserDefaults.standard.value(forKey: LONGITUDE)) != nil ? "\(UserDefaults.standard.value(forKey: LONGITUDE) as! NSNumber)" : ""
        self.shopModel = nil
        self.summaryModel = nil
        self.cells.removeAll()
        self.indexPathRow = [0,0]
        self.feedTableView.tableFooterView = UIView()
        self.feedTableView.delegate = self
        self.feedTableView.dataSource = self
        self.feedTableView.reloadData()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(notification(_notification:)), name: Notification.Name("productDeepLink"), object: nil)
        getShopCategories()
    }
    
    @objc func notification(_notification : Notification){
        let value = (((((((_notification.userInfo as! NSDictionary)["url"]! as! URL).absoluteString).split(separator: "&") as! NSArray)[2] as! String).split(separator: "=") as! NSArray).lastObject as! String)
        do{
            let datas = try EncryptionManager().aesDecrypt(cipherText: value).replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: "")
            if datas != "Could not decrypt"{
                self.moveToProductDetails(id : Int(datas)!)
            }
        }catch{
        }
    }
    
    func moveToProductDetails(id : Int){
        self.activeView = nil
        DispatchQueue.main.async {
            productDetail.produId = id
            productDetail.isFromNotification = true
            if #available(iOS 13.0, *) {
                productDetail.modalPresentationStyle = .fullScreen
                self.present(productDetail, animated: false)
            }else{
                self.present(productDetail, animated: false, completion: nil)
            }
        }
        
    }
    
    @IBAction func wishListTapped(_ sender: Any) {
        self.moveToWishList()
    }
    
    @IBAction func cartButtonTapped(_ sender: Any) {
        self.moveToCart()
    }
    
    @IBAction func sideMenuTapped(_ sender: Any) {
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        self.segmentSelected  = sender.selectedSegmentIndex
        self.pageNo = 1
        self.segmentSelected == 0 ? self.getProducts() : self.getShops()
        self.sortButton.isEnabled = self.segmentSelected == 0 ? true : false
        self.sortButton.tintColor = self.segmentSelected == 0 ? HOME_NAVIGATION_BGCOLOR : .lightGray
        self.sortButton.setTitleColor(self.segmentSelected == 0 ? HOME_NAVIGATION_BGCOLOR : .lightGray, for: .normal)
    }
    
    @IBAction func sortButtonTapped(_ sender: Any) {
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
    
    @IBAction func filterButtontapped(_ sender: Any) {
        self.isFromFilter = true
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
    
    func getShops(){
        shopsRequest = GetSearchShopsRequestModel(_name: _searchString, _pageNo: pageNo, _pageSize: default_pageSize, _ShowOffers: isShowOffers, _ShopType: shopType, _isClosed: isOpen, _isOpen: isClosed, _shopId: 0)
        if pageNo == 1{
            self.shopsResponseModel?.removeAll()
            self.shopsModel = nil
        }
        if _searchString == "" {
            activeView = self.showActivityIndicator(_message: "Please wait....")
        }
        
        Webservice.shared.getShops(body: (shopsRequest?.dictionary)!) { (model, errorMessage) in
            if self._searchString == "" {
                self.hideActivityIndicator(uiView: self.activeView!)
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
                self.feedTableView.reloadData()
            }
        }
    }
    
    func removeShopsDuplicates(){
        var temp : [GetShopsResponseData]? = []
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
                    temp?.append(self.shopsResponseModel![i])
                }
            }
            temp?.append(self.shopsResponseModel!.last!)
            self.shopsResponseModel?.removeAll()
            self.shopsResponseModel = temp
        }
    }
}
extension FeedPageViewController{
    
    func getSummaryData(){
        Webservice.shared.getSummaryData(body: dictionary) { (model, errorMessage) in
            self.hideActivityIndicator(uiView: self.activeView)
            if model != nil{
                self.summaryModel = model
            }else{
                self.summaryModel = nil
            }
            self.setTableViewCells()
        }
    }
    
    func getShopCategories(){
        self.activeView = self.showActivityIndicator(_message: "Please wait..")
        Webservice.shared.getShopCategory(body: dictionary) { (model, error) in
            if model != nil{
                self.shopModel = model
            }else{
                self.shopModel = nil
                self.showSCLAlert(_message:error!)
            }
            self.getSummaryData()
        }
        setBadges()
    }
    
    func setTableViewCells(){
        cells.removeAll()
        if _searchString != ""{
        }else{
            if self.summaryModel != nil{
                if summaryModel?.error! != true{
                    for i in 0 ..< (self.summaryModel?.data?.bannerList?.count)!{
                        if i == 0 {
                            indexPathRow[0] = cells.count
                        }
                        cells.append("FeedTableViewCell1")
                    }
                    for i in 0 ..< (self.summaryModel?.data?.gridList?.count)!{
                        if i == 0 {
                            indexPathRow[1] = cells.count
                        }
                        cells.append("FeedTableViewCell2")
                    }
                    if self.shopModel != nil{
                        cells.append("FeedTableViewCell0")
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.feedTableView.reloadData()
        }
    }
    
    func setBadges(){
        self.cartBadge { (value) in
            self.cartButton.badge = "\(value)"
        }
        self.wishListBadge { (value) in
            self.wishLishButton.badge = "\(value)"
        }
        if let _ = UserDefaults.standard.value(forKey: CART_VALUE){
            cartButton.badge = "\(UserDefaults.standard.value(forKey: CART_VALUE)!)"
        }
        if let _ = UserDefaults.standard.value(forKey: WISH_VALUE){
            wishLishButton.badge = "\(UserDefaults.standard.value(forKey: WISH_VALUE)!)"
        }
    }
}

extension  FeedPageViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if _searchString != ""{
            return 1
        }else{
            if self.summaryModel != nil{
                if summaryModel?.error! != true{
                    return (self.summaryModel?.data?.gridList!.count)! + 1
                }else{
                    return 1
                }
            }else{
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if _searchString != ""{
            return segmentSelected == 0 ? (offerResponseModel!.isEmpty ? 1 : (offerResponseModel?.count)!) : (self.shopsResponseModel!.isEmpty ? 1 : (self.shopsResponseModel?.count)!)
        }else{
            if section == 0{
                var count = 0
                if self.summaryModel != nil{
                    if self.summaryModel?.error! != true{
                        if (self.summaryModel?.data?.bannerList?.count)! > 0{
                            count += 1
                        }
                        if self.shopModel != nil{
                            count += 1
                        }
                    }else{
                        count = 1
                    }
                }
                return count
            }else{
                var bannerCount = Int((self.summaryModel?.data?.bannerList?.count)! / (self.summaryModel?.data?.gridList![section - 1].productList?.count)!)
                if bannerCount >= 2{
                    return (self.summaryModel?.data?.gridList![section - 1].productList?.count)! + ((self.summaryModel?.data?.bannerList?.count)! > section ? 2 : 0)
                }else{
                    return (self.summaryModel?.data?.gridList![section - 1].productList?.count)! + ((self.summaryModel?.data?.bannerList?.count)! > section ? 1 : 0)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if _searchString != "" && segmentSelected == 0{
            if (offerResponseModel?.isEmpty)!{
                let cell = UITableViewCell()
                cell.isEditing = false
                cell.selectionStyle = .none
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.text = "No products available."
                cell.textLabel?.textAlignment = .center
                return cell
            }else if (offerResponseModel?.count)! > 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "FeedProductTableViewCell", for: indexPath) as! FeedProductTableViewCell
                cell.productView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
                cell.productNameLabel.text =  offerResponseModel![indexPath.row].itemName!
                cell.productOfferButton.isHidden = offerResponseModel![indexPath.row].discount! > 0 ? false : true
                if  offerResponseModel![indexPath.row].discount! > 0{
                    cell.productOfferButton.setTitle("\(offerResponseModel![indexPath.row].discount!)%", for: .normal)
                }
                cell.productCategoryLabel.text = (offerResponseModel![indexPath.row].shopName!) + "\n" + (offerResponseModel![indexPath.row].categoryData![0].categoryName!)
                let distance = String(format: "%.1f", offerResponseModel![indexPath.row] != nil ? (offerResponseModel![indexPath.row].distance)! : 0)
                cell.shopDistancLabel.text =  "\(distance) Km"
                cell.newPriceLabel.text =  "AED \((offerResponseModel![indexPath.row].sellingPrice)!)"
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "AED \((offerResponseModel![indexPath.row].actualPrice)!)")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.oldPriceLabel.attributedText = attributeString
                cell.offerNotesLabel.text = " \((offerResponseModel![indexPath.row].offerNote)!)"
                cell.productImageView.sd_setImage(with: URL(string: (offerResponseModel![indexPath.row].imageData![0].imagePath)!), placeholderImage: UIImage(named: placeHolderImage), options: .continueInBackground, context: nil)
                return cell
            }else{
                let cell = UITableViewCell()
                cell.isEditing = false
                cell.selectionStyle = .none
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.text = "No feed data available."
                cell.textLabel?.textAlignment = .center
                return cell
            }
        }else if _searchString != "" && segmentSelected == 1{
            if !(self.shopsResponseModel!.isEmpty){
                if (self.shopsResponseModel?.count)! > 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "feedShopTableViewCell", for: indexPath) as! FeedProductTableViewCell
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
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    cell.isEditing = false
                    cell.textLabel?.numberOfLines = 0
                    cell.textLabel?.text = "No Shops found!."
                    cell.textLabel?.textAlignment = .center
                    return cell
                }
            }else{
                let cell = UITableViewCell()
                cell.selectionStyle = .none
                cell.isEditing = false
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.text = "No Shops found!."
                cell.textLabel?.textAlignment = .center
                return cell
            }
        } else{
            if cells.count == 0{
                let cell = UITableViewCell()
                cell.selectionStyle = .none
                cell.isEditing = false
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.text = "No feed data available."
                cell.textLabel?.textAlignment = .center
                return cell
            }else{
                if indexPath.section == 0{
                    if (self.shopModel != nil) && indexPath.row == 0{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell0", for: indexPath) as! FeedTableViewCell
                        let layout = UICollectionViewFlowLayout()
                        layout.itemSize = CGSize(width: 60, height: 70)
                        layout.scrollDirection = .horizontal
                        cell.feedTypeCollectionView.collectionViewLayout = layout
                        cell.feedTypeCollectionView.reloadData()
                        return cell
                    }else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell1", for: indexPath) as! FeedTableViewCell
                        cell.bannerImageView.sd_setImage(with: URL(string: (self.summaryModel?.data?.bannerList![indexPath.section].imagePath)!), placeholderImage: nil, options: .continueInBackground, context: nil)
                        cell.bannerImageView.isUserInteractionEnabled = true
                        return cell
                    }
                }else{
                    var bannerCount = Int((self.summaryModel?.data?.bannerList?.count)! / (self.summaryModel?.data?.gridList![indexPath.section - 1].productList?.count)!)
                    if bannerCount > 1{
                        if indexPath.row == 0{
                            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell1", for: indexPath) as! FeedTableViewCell
                            cell.bannerImageView.sd_setImage(with: URL(string: (self.summaryModel?.data?.bannerList![indexPath.section * 2 - 1].imagePath)!), placeholderImage: nil, options: .continueInBackground, context: nil)
                            cell.bannerImageView.isUserInteractionEnabled = true
                            return cell
                        }else if indexPath.row == (self.summaryModel?.data?.gridList![indexPath.section - 1].productList?.count)! + 1{
                            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell1", for: indexPath) as! FeedTableViewCell
                            cell.bannerImageView.sd_setImage(with: URL(string: (self.summaryModel?.data?.bannerList![indexPath.section * 2].imagePath)!), placeholderImage: UIImage(named: placeHolderImage), options: .continueInBackground, context: nil)
                            cell.bannerImageView.isUserInteractionEnabled = true
                            return cell
                        }else{
                            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedProductTableViewCell", for: indexPath) as! FeedProductTableViewCell
                            cell.productOfferButton.isHidden = Int((self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row - 1].discount!)!) > 0 ? false : true
                            if  (self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row - 1].discount!)! > 0{
                                cell.productOfferButton.setTitle("\((self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row - 1].discount!)!)%", for: .normal)
                            }
                            cell.productView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
                            cell.productNameLabel.text =  (self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row - 1].itemName)!
                            cell.productCategoryLabel.text = (self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row - 1].shopName!)! + "\n" + (self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row - 1].categoryData![0].categoryName!)!
                            let distance = String(format: "%.1f", (self.summaryModel?.data?.gridList![indexPath.section - 1].productList) != nil ? (self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row - 1].distance)! : 0)
                            cell.shopDistancLabel.text =  "\(distance) Km"
                            cell.newPriceLabel.text =  "AED \((self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row - 1].sellingPrice)!)"
                            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "AED \((self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row - 1].actualPrice)!)")
                            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                            cell.oldPriceLabel.attributedText = attributeString
                            cell.offerNotesLabel.text = " \((self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row - 1].offerNote)!)"
                            cell.productImageView.sd_setImage(with: URL(string: (self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row - 1].imageData![0].imagePath)!), placeholderImage: UIImage(named: placeHolderImage), options: .continueInBackground, context: nil)
                            return cell
                        }
                    }else{
                        if indexPath.row == (self.summaryModel?.data?.gridList![indexPath.section - 1].productList?.count)!{
                            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell1", for: indexPath) as! FeedTableViewCell
                            cell.bannerImageView.sd_setImage(with: URL(string: (self.summaryModel?.data?.bannerList![indexPath.section].imagePath)!), placeholderImage: nil, options: .continueInBackground, context: nil)
                            cell.bannerImageView.isUserInteractionEnabled = true
                            return cell
                        }else{
                            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedProductTableViewCell", for: indexPath) as! FeedProductTableViewCell
                            cell.productOfferButton.isHidden = Int((self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row].discount!)!) > 0 ? false : true
                            if  (self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row].discount!)! > 0{
                                cell.productOfferButton.setTitle("\((self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row].discount!)!)%", for: .normal)
                            }
                            cell.productView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
                            cell.productNameLabel.text =  (self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row].itemName)!
                            cell.productCategoryLabel.text = (self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row].shopName!)! + "\n" + (self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row].categoryData![0].categoryName!)!
                            let distance = String(format: "%.1f", (self.summaryModel?.data?.gridList![indexPath.section - 1].productList) != nil ? (self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row].distance)! : 0)
                            cell.shopDistancLabel.text =  "\(distance) Km"
                            cell.newPriceLabel.text =  "AED \((self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row].sellingPrice)!)"
                            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "AED \((self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row].actualPrice)!)")
                            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                            if (self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row].offerNote)! != ""{
                                cell.oldPriceLabel.attributedText = attributeString
                            }else{
                                cell.oldPriceLabel.text = ""
                            }
                            
                            cell.offerNotesLabel.text = " \((self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row].offerNote)!)"
                            if (self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row].offerNote)! != ""{
                                cell.offerHeightConstraint.constant = 14
                            }else{
                                cell.offerHeightConstraint.constant = 0
                            }
                            cell.productImageView.sd_setImage(with: URL(string: (self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row].imageData![0].imagePath)!), placeholderImage: UIImage(named: placeHolderImage), options: .continueInBackground, context: nil)
                            return cell
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat(0)
        if _searchString != ""{
            return segmentSelected == 0 ? (!(offerResponseModel!.isEmpty) ? UITableView.automaticDimension : self.feedTableView.frame.height) : (self.shopsResponseModel!.isEmpty ? self.feedTableView.frame.height : UITableView.automaticDimension)//UITableView.automaticDimension
        }else{
            if indexPath.section == 0{
                if cells.count == 0{
                    height = self.feedTableView.frame.height
                }else{
                    if self.shopModel != nil && indexPath.row == 0{
                        height = 100
                    }else{
                        height = 150
                    }
                }
            }else{
                var bannerCount = Int((self.summaryModel?.data?.bannerList?.count)! / (self.summaryModel?.data?.gridList![indexPath.section - 1].productList?.count)!)
                if bannerCount > 1{
                    if indexPath.row == 0{
                        height = 150
                    }else if indexPath.row == (self.summaryModel?.data?.gridList![indexPath.section - 1].productList?.count)! + 1{
                        height = 150
                    }else{
                        height = UITableView.automaticDimension
                    }
                }else{
                    if indexPath.row == (self.summaryModel?.data?.gridList![indexPath.section - 1].productList?.count)!{
                        height = 150
                    }else{
                        height = UITableView.automaticDimension
                    }
                }
            }
            return CGFloat(height)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView.init(frame: CGRect.init(x: -1, y: 50, width: self.view.frame.width, height: 50))
        headerView.setCornerRadius(radius: 1.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: true, B_GColor:.white , isBorderWidth: true, borderWidth: 0.4, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
        let labelView: UILabel = UILabel.init(frame: CGRect.init(x: 10, y: 4, width: self.view.frame.width - 120, height: 42))
        labelView.numberOfLines = 0
        labelView.text = self.summaryModel?.data?.gridList![section - 1].categoryName!
        labelView.textColor = HOME_NAVIGATION_BGCOLOR
        let viewAllButton: UIButton = UIButton(frame: CGRect(x: self.view.frame.width - 90, y: 13, width: 80, height: 24))
        viewAllButton.setTitle("View All", for: .normal)
        viewAllButton.setTitleColor(.white, for: .normal)
        viewAllButton.titleLabel?.font = UIFont(name: "System", size: 14)
        viewAllButton.setCornerRadius(radius: 6.0, isBg_Color: true, bg_Color: HOME_NAVIGATION_BGCOLOR, isBorder: true, borderColor: .white, borderWidth: 0.6)
        viewAllButton.tag =  section - 1
        viewAllButton.addTarget(self, action: #selector(viewAllButtonTapped(sender:)), for: .touchUpInside)
        headerView.addSubview(viewAllButton)
        headerView.addSubview(labelView)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if _searchString != "" && segmentSelected == 0{
            productDetail.productData = offerResponseModel![indexPath.row]
            productDetail.produId = (offerResponseModel![indexPath.row].stockID)!
            productDetail.shopId = (offerResponseModel![indexPath.row].shopID)!
            productDetail.isFromProduct = false
            self.moveToProductDetails()
        }else if _searchString != "" && segmentSelected == 1{
            if (self.shopsResponseModel!.count) > 0{
                shop_Detail.isFromList = false
                shop_Detail.shopId = (self.shopsResponseModel![indexPath.row].shopID)!
                shop_Detail.shopType = (self.shopsResponseModel![indexPath.row].shopTypeName)!
                shop_Detail.shopsResponseModel = self.shopsResponseModel![indexPath.row]
                self.moveToDetailPage()
            }
        }else{
            if indexPath.section == 0{
                if (self.summaryModel != nil){
                    if self.summaryModel?.error == true{
                        return
                    }else{
                        products.name = (self.summaryModel?.data?.bannerList![indexPath.section].categoryName)!
                        products.shopType = (self.summaryModel?.data?.bannerList![indexPath.section].shopTypeID)!
                        self.moveToProduct()
                    }
                }else{
                    products.name = (self.summaryModel?.data?.bannerList![indexPath.row].categoryName)!
                    products.shopType = (self.summaryModel?.data?.bannerList![indexPath.row].shopTypeID)!
                    self.moveToProduct()
                }
            }else{
                var bannerCount = Int((self.summaryModel?.data?.bannerList?.count)! / (self.summaryModel?.data?.gridList![indexPath.section - 1].productList?.count)!)
                if bannerCount > 1{
                    if indexPath.row == 0 {
                        products.name = (self.summaryModel?.data?.bannerList![indexPath.section * 2 - 1].categoryName)!
                        products.shopType = (self.summaryModel?.data?.bannerList![indexPath.section * 2 - 1].shopTypeID)!
                        self.moveToProduct()
                    }
                    else if indexPath.row == (self.summaryModel?.data?.gridList![indexPath.section - 1].productList?.count)! + 1{
                        products.name = (self.summaryModel?.data?.bannerList![indexPath.section * 2].categoryName)!
                        products.shopType = (self.summaryModel?.data?.bannerList![indexPath.section * 2].shopTypeID)!
                        self.moveToProduct()
                    }else{
                        productDetail.productData = (self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row - 1])!
                        productDetail.shopId = (self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row - 1].shopID)!
                        productDetail.produId = (self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row - 1].stockID)!
                        productDetail.isFromProduct = false
                        self.moveToProductDetails()
                    }
                }else{
                    if indexPath.row == (self.summaryModel?.data?.gridList![indexPath.section - 1].productList?.count)!{
                        products.name = (self.summaryModel?.data?.bannerList![indexPath.section].categoryName)!
                        products.shopType = (self.summaryModel?.data?.bannerList![indexPath.section].shopTypeID)!
                        products.shopId = 0
                        self.moveToProduct()
                    }else{
                        productDetail.productData = (self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row])!
                        productDetail.shopId = (self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row].shopID)!
                        productDetail.produId = (self.summaryModel?.data?.gridList![indexPath.section - 1].productList![indexPath.row].stockID)!
                        productDetail.isFromProduct = false
                        self.moveToProductDetails()
                    }
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (_searchString != "" && segmentSelected == 0) || _searchString == ""{
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
}


extension FeedPageViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shopModel != nil ? (self.shopModel?.data?.count)! : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopCategoryCollectionViewCell", for: indexPath) as! ShopCategoryCollectionViewCell
        cell.layer.cornerRadius = 6.0
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 0.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.shopCategoryLabel.text = self.shopModel?.data![indexPath.row].categoryName!
        cell.shopCategoryImageView.setCornerRadiusWithBorder(radius: cell.shopCategoryImageView.frame.height / 2, borderWidth: 0.5, borderColor: .lightGray)
        cell.shopCategoryImageView.sd_setImage(with: URL(string: (self.shopModel?.data![indexPath.row].image)!), placeholderImage: UIImage(named: placeHolderImage), options: .continueInBackground, context: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        products.name = (self.shopModel?.data![indexPath.row].categoryName)!
        products.shopId = 0
        products.shopType = (self.shopModel?.data![indexPath.row].categoryID)!
        moveToProduct()
    }
    
    @objc func viewAllButtonTapped(sender : UIButton){
        products.isFirst = false
        products.name = (self.summaryModel?.data?.gridList![sender.tag].categoryName)!
        products.shopId = 0
        products.shopType = (self.summaryModel?.data?.gridList![sender.tag].categoryID)!
        moveToProduct()
    }
    
    func moveToProduct(){
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                products.modalPresentationStyle = .fullScreen
                self.present(products, animated: false)
            }else{
                self.present(products, animated: false, completion: nil)
            }
        }
    }
}

extension FeedPageViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        _searchString = searchText
        if _searchString == ""{
            searchBar.showsCancelButton = false
            segmentSelected = 0
            getShopCategories()
            DispatchQueue.main.async {
                self.setUI(setBool: true)
                self.feedTableView.reloadData()
            }
        }else{
            DispatchQueue.main.async {
                Webservice.task.cancel()
                self.setUI(setBool: false)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchBar.endEditing(true)
        DispatchQueue.main.async {
            Webservice.task.cancel()
            self.setUI(setBool: false)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        self._searchString = ""
        searchBar.text! = ""
        self.segmentSelected = 0
        self.booleanArray = [false,false,false,false,false,true,true,true,true,true,true,true,true]
        self.getShopCategories()
        DispatchQueue.main.async {
            Webservice.task.cancel()
            self.setUI(setBool: true)
        }
    }
    
    func setUI(setBool : Bool){
        self.segmentView.isHidden = setBool
        self.segmentViewHeightConstraint.constant = setBool ? 0 : 30
        self.filterHeightConstraint.constant = setBool ? 0 : 30
        self.filterView.isHidden = setBool
        self.offerResponseModel?.removeAll()
        self.shopsResponseModel?.removeAll()
        self.pageNo = 1
        self.segmentSelected == 0 ? self.getProducts() : self.getShops()
        self.searchSegment.selectedSegmentIndex = self.segmentSelected
    }
    
    func getProducts(){
        DispatchQueue.main.async {
            self.feedTableView.reloadData()
        }
        let offerParams = OfferParametersRequest(_integerArray: offerIntegerArray, _booleanArray: offerBooleanArray)
        let offer = OfferRequestModel(_name: _searchString, _pageNo: pageNo, _pageSize: 30, otherParams: offerParams.dictionary)
        Webservice.shared.getOffersSearchResult(body: offer.dictionary) { (model, message) in
            if model != nil{
                self.offerModel = model
                for i in 0 ..< (model?.data?.count)!{
                    self.offerResponseModel?.append((model?.data![i])!)
                }
                self.removeDuplicates()
            }else{
                self.offerModel = nil
                self.offerResponseModel?.removeAll()
            }
            DispatchQueue.main.async {
                self.feedTableView.reloadData()
            }
        }
    }
    
    func removeDuplicates(){
        var temp : [OfferResponseData]? = []
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
                    temp?.append(self.offerResponseModel![i])
                }
            }
            temp?.append(self.offerResponseModel!.last!)
            self.offerResponseModel?.removeAll()
            self.offerResponseModel = temp
        }
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
        self.activeView = self.showActivityIndicator(_message: "Please wait...")
        Webservice.shared.addtoFavourites(body: favouriteRequestmodel!.dictionary) { (model, error) in
            self.hideActivityIndicator(uiView: self.activeView!)
            if model != nil{
                self.booleanArray[self.currentRow] = !(self.booleanArray[self.currentRow])
                // do coding here
            }else{
                // set error Message
            }
            DispatchQueue.main.async {
                self.feedTableView.reloadRows(at: [IndexPath(row: self.currentRow, section: 0)], with: .none)
            }
        }
    }
    
    func moveToDetailPage(){
        self.segmentSelected = 0
        self.searchSegment.setEnabled(true, forSegmentAt: 0)
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                shop_Detail.modalPresentationStyle = .fullScreen
                self.present(shop_Detail, animated: false)
            }else{
                self.present(shop_Detail, animated: false, completion: nil)
            }
        }
    }
    
    func moveToProductDetails(){
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

extension FeedPageViewController : FilterDelegate,sortDelegate{
    func buttonSelected(view: UIViewController, sortBoolean: [Bool], _ isFromSort: Bool) {
        view.dismiss(animated: false) {
            self.pageNo = 1
            self.offerResponseModel?.removeAll()
            self.shopsResponseModel?.removeAll()
            self.isFromSort = isFromSort
            self.offerBooleanArray = sortBoolean
            self.segmentSelected == 0 ? self.getProducts() : self.getShops()
        }
    }
    
    func filterApplied(view: UIViewController, _booleanArray: [Bool], _integerArray: [Int]) {
        view.dismiss(animated: false) {
            self.pageNo = 1
            self.offerResponseModel?.removeAll()
            self.shopsResponseModel?.removeAll()
            
            self.offerBooleanArray = _booleanArray
            self.offerIntegerArray = _integerArray
            if self.segmentSelected == 1{
                self.isOpen = self.offerBooleanArray[8]
                self.isClosed = self.offerBooleanArray[7]
                self.isShowOffers = self.offerBooleanArray[6]
            }
            self.segmentSelected == 0 ? self.getProducts() : self.getShops()
            DispatchQueue.main.async {
                self.setUI(setBool: false)
            }
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
}
