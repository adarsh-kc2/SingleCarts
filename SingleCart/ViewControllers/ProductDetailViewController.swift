//
//  ProductDetailViewController.swift
//  SingleCart
//
//  Created by PromptTech on 16/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    var productData : OfferResponseData!
    var product : OrderProductList!
    var shopDetailModel : ShopDetailsResponseModel? = nil
    var isCart = false
    var isWishList = false
    
    @IBOutlet weak var productNamelabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var wishLishButton: BageButton!
    @IBOutlet weak var cartButton: BageButton!
    
    let screenSize = UIScreen.main.bounds
    var screenWidth = 0.0
    var screenHeight = 0.0
    var imageCount = 0
    var layout : UICollectionViewFlowLayout? = nil
    var currentImage = 0
    var quantity = 1
    var shopId = 0
    var shopName = ""
    var isFromProduct = false
    var isFromNotification : Bool = false
    var produId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        screenWidth = Double(screenSize.width)
        layout = UICollectionViewFlowLayout()
        //        isCart = productData != nil ?  productData!.isCartItem! :  false
        layout!.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        self.productTableView.tableFooterView = UIView()
        self.addToCartButton.setTitle("ADD TO CART", for: .normal)
        self.addToCartButton.setImage(UIImage(named: "my_cart.png"), for: .normal)
        //        self.addToCartButton.backgroundColor = .blue
        self.addToCartButton.imageEdgeInsets.left = -40
        self.addToCartButton.setCornerRadius(radius: 6.0, isBg_Color: false, bg_Color: nil, isBorder: true, borderColor: DEFAULT_BORDER_COLOR, borderWidth: 0.5)
        self.orderButton.setCornerRadius(radius: 6.0, isBg_Color: false, bg_Color: nil, isBorder: true, borderColor: DEFAULT_BORDER_COLOR, borderWidth: 0.5)
        
        if !isFromNotification{
            imageCount = productData != nil ? (productData.imageData?.count)! : (product.imageData?.count)!
            self.productTableView.delegate = self
            self.productTableView.dataSource = self
            productNamelabel.text = productData != nil ? productData.itemName! : product.itemName!
            self.getShops()
            self.productTableView.reloadData()
        }else{
            self.getProductDetails()
        }
        
        if let _ = UserDefaults.standard.value(forKey: CART_VALUE){
            cartButton.badge = "\(UserDefaults.standard.value(forKey: CART_VALUE)!)"
        }
        if let _ = UserDefaults.standard.value(forKey: WISH_VALUE){
            wishLishButton.badge = "\(UserDefaults.standard.value(forKey: WISH_VALUE)!)"
        }
    }
    
    
    func getProductDetails(){
        let offerParams = OfferParametersRequest(_integerArray: [produId,0,0,0,0,0], _booleanArray: [false,false,false,false,false,true,true,true,true,true,true,true,true])
        let offer = OfferRequestModel(_name:"", _pageNo: 1, _pageSize: 30, otherParams: offerParams.dictionary)
        Webservice.shared.getOffersSearchResult(body: offer.dictionary) { (model, message) in
            if model != nil{
                self.productData = model?.data![0]
            }else{
                self.productData = nil
            }
            
            DispatchQueue.main.async {
                self.imageCount = self.productData != nil ? (self.productData.imageData?.count)! : (self.product.imageData?.count)!
                self.productTableView.delegate = self
                self.productTableView.dataSource = self
                self.productNamelabel.text = self.productData != nil ? self.productData.itemName! : self.product.itemName!
                self.shopId = self.productData != nil ? self.productData.shopID! : 0
                self.getShops()
                self.productTableView.reloadData()
            }
        }
    }
    
    func getShops(){
        let shopRequest = ShopDetailsRequestModel(_ShopID: shopId)
        Webservice.shared.getShopDetails(body: shopRequest.dictionary) { (model, errorMessage) in
            if model != nil{
                self.shopDetailModel = model
                self.shopName = ((self.shopDetailModel?.data?.webShopName)! != "" ? (self.shopDetailModel?.data?.webShopName)! : (self.shopDetailModel?.data?.name)!.replacingOccurrences(of: " ", with: "-")) as! String
//                self.shopName = (self.shopDetailModel?.data?.name)!.replacingOccurrences(of: " ", with: "-")
            }else{
                self.shopDetailModel = nil
            }
            DispatchQueue.main.async {
                self.productTableView.reloadRows(at: [IndexPath(row: 2, section: 0)
                ], with: .none)
            }
        }
    }
    
    @IBAction func searchButtontapped(_ sender: Any) {
        products.isFromProductSearch = true
        products.name = "Products"
        if isFromProduct{
            self.dismiss(animated: false, completion: nil)
        }else{
            self.moveToProduct()
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                if currentImage == imageCount - 1 {
                    currentImage = 0
                }else{
                    currentImage += 1
                }
            case UISwipeGestureRecognizer.Direction.right:
                if currentImage == 0 {
                    currentImage = imageCount - 1
                }else{
                    currentImage -= 1
                }
            default:
                break
            }
            self.productTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.isFromNotification = false
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func orderButtonTapped(_ sender: Any) {
        if let _id =  UserDefaults.standard.value(forKey: USERID){
            if _id as! Int != 0{
                let request = AddRemoveCartRequestModel(_isadd: true, _stockId: productData != nil ? productData.stockID! : product.stockID!, _shopId: productData != nil ? productData.shopID! : product.shopID!, _remarks: "", _quantity: quantity)
                Webservice.shared.addToCart(body: request.dictionary) { (model, error) in
                    //            sender.hideLoading()
                    if model != nil{
                        self.quantity += 1
                        self.showAlertWithHandler("Item added to cart successfully.") { (success, failure) in
                            if success{
                                self.moveToCart()
                            }
                        }
                        self.cartBadge { (value) in
                            self.cartButton.badge = "\(value)"
                        }
                    }else{
                        self.showSCLAlert(_message: error!)
                    }
                }
            }else{
                self.showAlertWithHandlerSignIn(ERROR) { (success, failure) in
                    if failure{
                        (UIApplication.shared.delegate as! AppDelegate).loginPage()
                    }
                }
            }
        }
    }
    
    @IBAction func addToCart(_ sender: LoadingButton) {
        if let _id =  UserDefaults.standard.value(forKey: USERID){
            if _id as! Int != 0{
                sender.showLoading()
                let request = AddRemoveCartRequestModel(_isadd: true, _stockId: productData != nil ? productData.stockID! : product.stockID!, _shopId: productData != nil ? productData.shopID! : product.shopID!, _remarks: "", _quantity: quantity)
                Webservice.shared.addToCart(body: request.dictionary) { (model, error) in
                    sender.hideLoading()
                    if model != nil{
                        self.cartData()
                        self.showSCLAlert(_message:"Item added to cart successfully.")
                        self.quantity += 1
                    }else{
                        self.showSCLAlert(_message:error!)
                    }
                    self.cartBadge { (value) in
                        self.cartButton.badge = "\(value)"
                    }
                }
            }else{
                self.showSCLAlert(_message:"You have to login to use this feature.")
            }
        }
    }
    
    @IBAction func cartButtonTapped(_ sender: Any) {
        self.moveToCart()
    }
    
    @IBAction func wishListButtonTapped(_ sender: Any) {
        self.moveToWishList()
    }
}

extension ProductDetailViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productData != nil || product != nil{
            return 5
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if productData != nil || product != nil{
            let cell = tableView.dequeueReusableCell(withIdentifier: PRODUCTDETAILTABLEVIEWCELL + "\(indexPath.row)", for: indexPath) as! productDetailTableViewCell
            if indexPath.row == 0{
                if let _ = productData{
                    cell.offerPercentageButton.isHidden = productData.discount! > 0 ? false : true
                    if productData.discount! > 0{
                        cell.offerPercentageButton.setTitle("\(productData!.discount!)%", for: .normal)
                    }
                    cell.productImagEVIEW.sd_setImage(with: URL(string:productData!.imageData![currentImage].imagePath!), placeholderImage: UIImage(named: placeHolderImage), options: .continueInBackground, context: nil)
                    cell.productImagEVIEW.isUserInteractionEnabled = (productData!.imageData!.count) > 1 ? true : false
                    cell.poductpageControl.numberOfPages = (productData!.imageData!.count)
                    cell.poductpageControl.isHidden = (productData!.imageData!.count) > 1 ? false : true
                    if (productData!.imageData!.count) > 1{
                        //swipe
                        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
                        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
                        self.view.addGestureRecognizer(swipeRight)
                        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
                        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
                        self.view.addGestureRecognizer(swipeLeft)
                    }
                }else{
                    cell.offerPercentageButton.isHidden = product!.discount! > 0 ? false : true
                    if product!.discount! > 0 {
                        cell.offerPercentageButton.setTitle("\(product!.discount!)%", for: .normal)
                    }
                    cell.productImagEVIEW.sd_setImage(with: URL(string:product!.imageData![currentImage].imagePath!), placeholderImage: UIImage(named: placeHolderImage), options: .continueInBackground, context: nil)
                    cell.productImagEVIEW.isUserInteractionEnabled = (product!.imageData!.count) > 1 ? true : false
                    cell.poductpageControl.numberOfPages = (product!.imageData!.count)
                    cell.poductpageControl.isHidden = (product!.imageData!.count) > 1 ? false : true
                    if (product!.imageData!.count) > 1{
                        //swipe
                        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
                        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
                        self.view.addGestureRecognizer(swipeRight)
                        
                        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
                        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
                        self.view.addGestureRecognizer(swipeLeft)
                    }
                }
                cell.poductpageControl.currentPage = currentImage
                cell.productNameLabel.text = productData != nil ? productData.itemName! : product.itemName!
                cell.productPricelabel.text = "AED \(productData != nil ? productData.sellingPrice! : product.sellingPrice!)"
                if productData != nil ? productData.offerNote! != "" : product.offerNote! != ""{
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "AED \(productData != nil ? productData.actualPrice! : product.actualPrice!)")
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                    cell.productOldPriceLabel.attributedText = attributeString
                    
                }else{
                    cell.productOldPriceLabel.text = ""
                }
            }
            
            if indexPath.row == 1{
                //share
                cell.shareButton.setTitle("SHARE", for: .normal)
                cell.shareButton.setImage(UIImage(named: "share.png"), for: .normal)
                cell.shareButton.imageEdgeInsets.left = -50
                cell.shareButton.setCornerRadius(radius: 6.0, isBg_Color: false, bg_Color: nil, isBorder: true, borderColor: DEFAULT_BORDER_COLOR, borderWidth: 0.5)
                
                cell.wishListButton.setCornerRadius(radius: 6.0, isBg_Color: false, bg_Color: nil, isBorder: true, borderColor: DEFAULT_BORDER_COLOR, borderWidth: 0.5)
                cell.wishListButton.setTitle("WISHLIST", for: .normal)
                cell.wishListButton.setImage(UIImage(named: "my_wishlist.png"), for: .normal)
                cell.wishListButton.imageEdgeInsets.left = -50
                //my_wishlist
                cell.wishListButton.addTarget(self, action: #selector(addToWishList(_sender:)), for: .touchUpInside)
                cell.shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
            }
            
            if indexPath.row == 2{
                cell.shopNameLabel.text = productData != nil ? productData.shopName! : product.shopName!
                let dist : Double = (self.shopDetailModel != nil ? self.shopDetailModel?.data?.distance! : (productData != nil ? productData.distance! : 0)) as! Double
                let distance = String(format: "%.1f",dist)
                cell.shopDistanceLabel.text = "\(distance) KM"
                cell.shopDetailsLabel.text = "Click here to browse other products and services available in \(productData != nil ? productData.shopName! : product.shopName!)"
                var imageName = shopsPlaceholderImage
                if let _ = shopDetailModel{
                    if let _ = shopDetailModel!.data?.logoPath{
                        imageName = (shopDetailModel!.data?.logoPath)! != "" ? (shopDetailModel!.data?.logoPath)! : shopsPlaceholderImage
                    }else if let _ = shopDetailModel!.data?.alternateLogo{
                        imageName = (shopDetailModel!.data?.alternateLogo)! != "" ? (shopDetailModel!.data?.alternateLogo)! : shopsPlaceholderImage
                    }else{
                        imageName = shopsPlaceholderImage
                    }
                }
                cell.shopImageLabel.sd_setImage(with: URL(string:imageName)!, placeholderImage: UIImage(named: shopsPlaceholderImage), options: .continueInBackground, context: nil)
            }
            
            if indexPath.row == 3{
                cell.productCategoryCollectionView.delegate = self
                cell.productCategoryCollectionView.dataSource = self
                cell.productCategoryCollectionView.reloadData()
            }
            
            if indexPath.row == 4{
                var details = productData != nil ? "\n \(productData.description!)" : "\n No description available"
                details.append(productData != nil ? "\n \(productData.manufacture!)" : "\n No manufacture available")
                cell.productDetailsLabel.text = details
                cell.offeNotesLabel.text = (productData != nil ? "\n \(productData.offerNote!)" : "")
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
        if productData != nil || product != nil{
            return indexPath.row == 3 ? 80 : UITableView.automaticDimension
        }else{
            return self.productTableView.frame.height
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PRODUCTDETAILTABLEVIEWCELL + "\(indexPath.row)", for: indexPath) as! productDetailTableViewCell
            
            shop_Detail.shopDelegate = self
            shop_Detail.isFromDetails = true
            shop_Detail.shopId = shopId
            shop_Detail.shopType = cell.shopNameLabel.text!//"\((shopDetailModel!.data?.webShopName)!)"
            shop_Detail.distance = (productData != nil ? productData.distance! : 0)
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
    
    @objc func shareButtonTapped(){
        var str = ""
        var url = ""//: URL!
        var appString = ""
        var appURL = ""//: URL!
        var datas = ""
        if let _ = productData{
            str = "Hi, Check this product in SingleCart Application \n*\(self.productData.itemName!)*\n Price : AED\(self.productData.sellingPrice!) \nLimited discount : -\(self.productData.discount!)%\nFrom\((self.productData.shopName!))\n\n"
            do{
                datas = try EncryptionManager().aesEncrypt(plainText: "\(self.productData.stockID!)")
            }catch{
            }
            url = "https://www.singlecartretail.com/productdetails/\(self.shopName)/\(self.productData.stockID!)?pname=\(self.productData.itemName!.replacingOccurrences(of: " ", with: "-"))&action_type=product&pid=\(datas)&referrer=\(UserDefaults.standard.value(forKey: USERID) as! Int)&sname=\(self.shopName.replacingOccurrences(of: " ", with: "-"))"
            appString = "\n\n Do you never tried SingleCart ? \nDownload from the APPStore\n\n"
            appURL = "https://apps.apple.com/in/app/singlecart/id1531598016"//&referrer=\(UserDefaults.standard.value(forKey: USERID) as! Int)"
        }else{
            str = "Hi, Check this product in SingleCart Application \n*\(self.product.itemName!)*\nPrice : AED\(self.product.sellingPrice!) \nLimited discount : -\(self.product.discount!)%\nFrom \((self.product.shopName!))\n\n"
            do{
                datas = try EncryptionManager().aesEncrypt(plainText: "\(self.product.stockID!)")
            }catch{
            }
            url = "https://www.singlecartretail.com/productdetails/\(self.shopName)/\(self.product.stockID!)?pname=\(self.product.itemName!.replacingOccurrences(of: " ", with: "-"))&action_type=product&pid=\(datas)&referrer=\(UserDefaults.standard.value(forKey: USERID) as! Int)&sname=\(self.shopName.replacingOccurrences(of: " ", with: "-"))"
            appString = "\n\nDo you never tried SingleCart ? \nDownload from the Appstore\n\n"
            appURL = "https://apps.apple.com/in/app/singlecart/id1531598016"//&referrer=\(UserDefaults.standard.value(forKey: USERID) as! Int)"
            
        }
        
        let attributedString = NSMutableAttributedString(string: str + url)
    
        attributedString.addAttribute(.link, value: url, range: NSRange(location: str.count, length: url.count))
        let attributedString1 = NSMutableAttributedString(string: appString + appURL)
        attributedString1.addAttribute(.link, value: appURL, range: NSRange(location: appString.count, length: appURL.count))
        
        
        if let urlStr = NSURL(string: url), let urlStr1 = NSURL(string: appURL){
            let objectsToShare = [attributedString,attributedString1] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popup = activityVC.popoverPresentationController {
                    popup.sourceView = self.view
                    popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                }
            }
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}

extension ProductDetailViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ShopViewControllerDelegate{
    func backButtonTapped(view: UIViewController) {
        self.dismiss(animated: false) {
            self.productNamelabel.text = self.productData != nil ? self.productData.itemName! : self.product.itemName!
            self.productTableView.reloadData()
            self.getShops()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productData != nil ? (productData!.categoryData!.count) : (product!.categoryData!.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCategoryCollectionViewCell", for: indexPath) as! productCategoryCollectionViewCell
        cell.contentView.setCornerRadius(radius: cell.contentView.frame.height / 2, isShadow: true, isBorderColor: true, borderColor: UIColor.black, isBGColor: true, B_GColor: .white, isBorderWidth: true, borderWidth: 0.6, shadowOpacity: 0.9, shadowColor: .lightGray, shadowOffset: .zero)
        cell.productCategoryLabel.textColor = HOME_NAVIGATION_BGCOLOR
        cell.productCategoryLabel.text = productData != nil ? productData!.categoryData![indexPath.row].categoryName! : product!.categoryData![indexPath.row].categoryName!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        products.name = productData!.categoryData![indexPath.row].categoryName!
        products.categoryId = productData!.categoryData![indexPath.row].categoryID!
        products.shopId = 0
        products.shopType = 0
        isFromProduct ? self.dismiss(animated: false, completion: nil) : moveToProduct()
    }
    
    func moveToProduct(){
        DispatchQueue.main.async {
            products.isFirst = true
            if #available(iOS 13.0, *) {
                products.modalPresentationStyle = .fullScreen
                self.present(products, animated: false)
            }else{
                self.present(products, animated: false, completion: nil)
            }
        }
    }
}

extension ProductDetailViewController{
    @objc func addToWishList(_sender : LoadingButton){
        if let _id =  UserDefaults.standard.value(forKey: USERID){
            if _id as! Int != 0{
                _sender.showLoading()
                //                isWishList = !(isWishList)
                let request = AddRemoveWishListRequestModel(_isadd: true, _stockId: productData != nil ? productData.stockID! : product.stockID!, _shopId: productData != nil ? productData.shopID! : product.shopID!)
                Webservice.shared.addToWishList(body: request.dictionary) { (model, error) in
                    _sender.hideLoading()
                    if model != nil{
                        self.showSCLAlert(_message:"Item added to wishlist successfully.")
                        self.wishListBadge { (value) in
                            self.wishLishButton.badge = "\(value)"
                        }
                    }else{
                        self.showSCLAlert(_message:error!)
                    }
                }
            }else{
                self.showSCLAlert(_message:"You have to login to use this feature.")
                
            }
        }
    }
}
