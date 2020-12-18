//
//  ShopDetailsViewController.swift
//  SingleCart
//
//  Created by PromptTech on 13/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Charts
import MapKit
import CoreLocation
class ShopDetailsViewController: UIViewController, ChartViewDelegate,UIGestureRecognizerDelegate {
    var isFromList : Bool = false
    var _searchString = ""
    var shopDelegate : ShopViewControllerDelegate!
    var isFromDetails = false
    var image : UIImage? = nil
    var dictionary : Dictionary<String,Double> = [:]
    var valueArray : [Double] = []
    var distance = 0.0
    var imageName = ""
    var shopId : Int = 0
    var shopType = ""
    let request : Dictionary<String,Any> = [:]
    var count = 1
    let screenSize = UIScreen.main.bounds
    var screenWidth = 0.0
    var screenHeight = 0.0
    var isFromNotifications : Bool = false

    var layout : UICollectionViewFlowLayout? = nil
    var layout1 : UICollectionViewFlowLayout? = nil
    var chartView : HorizontalBarChartView!
    var activeView : UIView!
    var offerModel : OfferResponseModel? = nil
    var offer : OfferRequestModel? = nil
    var offerParams : OfferParametersRequest? = nil
    var offerResponseModel : [OfferResponseData]? = []
    
    var shopDetailModel : ShopDetailsResponseModel? = nil
    var shopsResponseModel : GetShopsResponseData? = nil
    var shopReviewModel : ReviewListResponseModel? = nil
    var flyerResponseModel : FlyerResponseModel? = nil
    var flyerResponsedata : [FlyerDatas]? = []
    var reviewListSummary : ReviewListSummaryModel? = nil
    var favouriteRequestmodel : AddtoFavouritesRequestModel? = nil
    var cells : [String] = []
    var tap : UITapGestureRecognizer?  = nil
    var isFavourite = false
    var isTempFavourite = false
    var offerBooleanArray = [Bool]()
    var offerIntegerArray = [Int]()
    
    @IBOutlet weak var shopDetailTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        offerBooleanArray = [false,false,false,false,false,false,false,false,false,false,false,false,false]
        screenWidth = Double(screenSize.width)
        layout = UICollectionViewFlowLayout()
        layout!.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        layout1 = UICollectionViewFlowLayout()
        layout1!.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dictionary.removeAll()
        valueArray = [0,0,0,0,0]
        dictionary["5"] = valueArray[0]
        dictionary["4"] = valueArray[1]
        dictionary["3"] = valueArray[2]
        dictionary["2"] = valueArray[3]
        dictionary["1"] = valueArray[4]
        if let _ = shopsResponseModel{
            cells = ["ShopDetailTableViewCell0","ShopDetailEmptyTableViewCell","ShopDetailEmptyTableViewCell","ShopDetailEmptyTableViewCell","ShopDetailEmptyTableViewCell","ShopDetailEmptyTableViewCell"]
        }else{
            cells = ["ShopDetailEmptyTableViewCell","ShopDetailEmptyTableViewCell","ShopDetailEmptyTableViewCell","ShopDetailEmptyTableViewCell","ShopDetailEmptyTableViewCell","ShopDetailEmptyTableViewCell"]
        }
        self.shopDetailTableView.tableFooterView = UIView()
        isFavourite = self.shopsResponseModel != nil ? (self.shopsResponseModel!.isFavourite)! : false
        isTempFavourite = self.shopsResponseModel != nil ? (self.shopsResponseModel!.isFavourite)! : false
        self.shopDetailTableView.reloadData()
        shopReviewModel = nil
        shopDetailModel = nil
        self.getShopDetails()
    }
    
    
    @objc func tapped(){
        if  (UserDefaults.standard.value(forKey: USERID) as! Int) == 0{
            self.showSCLAlert(_message:"You have to sign in first.")
        }else{
            favouriteRequestmodel = AddtoFavouritesRequestModel(_ShopID: "\((self.shopsResponseModel?.shopID)!)", _IsFavorite: !((self.shopsResponseModel?.isFavourite)!))
            self.setFavourite()
        }
    }
    
    func setFavourite(){
        Webservice.shared.addtoFavourites(body: favouriteRequestmodel!.dictionary) { (model, error) in
            if model != nil{
                self.isFavourite =  !self.isTempFavourite
                self.isTempFavourite = self.isFavourite
            }else{
            }
            DispatchQueue.main.async {
                self.shopDetailTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            }
        }
    }
    
    @IBAction func mapDirectiontapped(_ sender: Any) {
        
        let directionsURL = "http://maps.apple.com/?saddr=Current%20Location&daddr=\((self.shopDetailModel?.data?.latitude)!),\((self.shopDetailModel?.data?.longitude)!)"
        guard let url = URL(string: directionsURL) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
//        location.destLat = (self.shopDetailModel?.data?.latitude)!
//        location.destLong = (self.shopDetailModel?.data?.longitude)!
//        if #available(iOS 13.0, *) {
//            location.modalPresentationStyle = .fullScreen
//            self.present(location, animated: false)
//        }else{
//            self.present(location, animated: false, completion: nil)
//        }
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        var str = ""
        var url : NSURL!
        var datas = ""
        var str2 = ""
        if let _ = shopDetailModel{
            str = "Hello check this shop in SingleCart Application \n\n *\((self.shopDetailModel?.data?.name!)!)* \n\n"
            
            str2 = "\n⏱️ Latest Offers \n🏷️ Discounts \n🔍 Search and buy products\n⭐ Review\nOpen and grab your offers now !! \n\nDo you never tried SingleCart ?\n\n Download from the AppStore\n\n"
            
            url = NSURL(string: "https://apps.apple.com/in/app/singlecart/id1531598016") //&referrer=\(UserDefaults.standard.value(forKey: USERID) as! Int)"
            do{
                datas = try EncryptionManager().aesEncrypt(plainText: "\((self.shopDetailModel?.data?.shopID!))")
            }catch{
            }
            if let urlStr = NSURL(string: "https://www.singlecartretail.com/shop/\((self.shopDetailModel?.data?.webShopName!)!)?action_type=shop&sid=\(datas)&referrer=\(UserDefaults.standard.value(forKey: USERID) as! Int)&name=\((self.shopDetailModel?.data?.name!)!.replacingOccurrences(of: " ", with: "-"))"){
                
                
                let urlString = "https://www.singlecartretail.com/shop/\((self.shopDetailModel?.data?.webShopName!)!)?action_type=shop&sid=\(datas)&referrer=\(UserDefaults.standard.value(forKey: USERID) as! Int)&name=\((self.shopDetailModel?.data?.name!)!.replacingOccurrences(of: " ", with: "-"))"
                let objectsToShare = [str, urlString,str2,url] as [Any]
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
    
    func getShopDetails(){
        self.activeView = self.showActivityIndicator(_message: "Loading...")
        let shopRequest = ShopDetailsRequestModel(_ShopID: shopId)
        Webservice.shared.getShopDetails(body: shopRequest.dictionary) { (model, errorMessage) in
            if model != nil{
                self.shopDetailModel = model
                if self.shopsResponseModel == nil{
                    self.cells[0] = "ShopDetailTableViewCell0"
                }
                self.cells[3] = "ShopDetailTableViewCell1"
                self.cells[4] = "ShopDetailTableViewCell2"
            }else{
                self.shopDetailModel = nil
            }
            DispatchQueue.main.async {
//                self.shopDetailTableView.reloadData()
                if self.shopsResponseModel == nil{
                    self.shopDetailTableView.reloadRows(at: [IndexPath(row: 0, section: 0),IndexPath(row: 3, section: 0),IndexPath(row: 4, section: 0)], with: .none)
                }else{
                    self.shopDetailTableView.reloadRows(at: [IndexPath(row: 0, section: 0),IndexPath(row: 3, section: 0),IndexPath(row: 4, section: 0)], with: .none)
                }
            }
            self.getReviewSummary()
        }
    }
    
    func getFlyers(){
        let flyerRequestModel = FlyerRequestModel(_FlyerID: 0, _ShopID: shopId, _PageNo: 1)
        Webservice.shared.getFlyers(body: (flyerRequestModel.dictionary)) { (model, errorMessage) in
            if model != nil{
                self.flyerResponseModel = model
                for i in 0 ..< (model?.flyerDatas?.count)!{
                    self.flyerResponsedata?.append((model?.flyerDatas![i])!)
                }
                if (model?.flyerDatas?.isEmpty)!{
                    self.cells[5] = "ShopDetailEmptyTableViewCell"
                }else{
                    self.cells[5] = "ShopDetailTableViewCell4"
                }
            }else{
                self.cells[5] = "ShopDetailEmptyTableViewCell"
                self.flyerResponseModel = nil
                self.flyerResponsedata = []
            }
            self.getProducts()
            DispatchQueue.main.async {
                self.shopDetailTableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)
            }
        }
    }
    
    func getReviewSummary(){
        //reviewListSummary
        let shopRequest = ShopDetailsRequestModel(_ShopID: shopId)
        Webservice.shared.getShopReviewSummary(body: shopRequest.dictionary) { (model, errorMessage) in
            if model != nil{
                self.reviewListSummary = model
                self.cells[1] = "ShopDetailTableViewCell3"
                self.setUpValue()
            }else{
                self.reviewListSummary = nil
            }
            self.getFlyers()
        }
    }
    
    func getProducts(){
        self.offerModel = nil
        self.offerResponseModel?.removeAll()
        offerIntegerArray = OfferIntValues
        offerIntegerArray[2] = shopId
//        offerIntegerArray[3] = shopId
        offerBooleanArray = [false,false,false,false,false,true,true,true,true,true,true,true,true]
        offerParams = OfferParametersRequest(_integerArray: offerIntegerArray, _booleanArray: offerBooleanArray)
        offer = OfferRequestModel(_name: _searchString, _pageNo: 1, _pageSize: 30, otherParams: offerParams!.dictionary)
        Webservice.shared.getOffersSearchResult(body: offer!.dictionary) { (model, message) in
            if model != nil{
                self.hideActivityIndicator(uiView: self.activeView)
                self.offerModel = model
                
                if (model?.data!.isEmpty)!{
                    self.cells[2] = "ShopDetailEmptyTableViewCell"
                }else{
                    for i in 0 ..< (model?.data?.count)!{
                        self.offerResponseModel?.append((model?.data![i])!)
                    }
                    self.cells[2] = "ShopDetailTableViewCell5"
                }
                
            }else{
                self.offerModel = nil
                self.cells[2] = "ShopDetailEmptyTableViewCell"
            }
            DispatchQueue.main.async {
                self.shopDetailTableView.reloadData()
            }
        }
    }
    
    func reloadData(){
        DispatchQueue.main.async {
            self.shopDetailTableView.reloadData()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
            self.dismiss(animated: false, completion: nil)
    }
}

extension ShopDetailsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.row], for: indexPath) as! ShopDetailTableViewCell
        //cellsSHOPDETAILTABLEVIEWCELL + "\(indexPath.row)", for: indexPath) as! ShopDetailTableViewCell
        switch cells[indexPath.row]{
        case "ShopDetailTableViewCell0":
            if let _ = self.shopsResponseModel{
                cell.shopNameLabel.text = (self.shopsResponseModel?.name)!
                cell.shopCategoryLabel.text = self.shopType != "" ? self.shopType : (self.shopsResponseModel?.shopTypeName)!
                let distance = String(format: "%.1f", ((self.shopsResponseModel) != nil ? (self.shopsResponseModel?.distance!) : 0) as! CVarArg)
                
                cell.shopDistanceLabel.text = "\(distance) KM"
                cell.shopOpenStatusLabel.textColor = (self.shopsResponseModel?.openCloseStatus)! ? .green : .red
                cell.shopOpenStatusLabel.text = (self.shopsResponseModel?.openCloseStatus)! ? "Open" : "Close"
                cell.shopCloseLabel.text = (self.shopsResponseModel?.workingHours)!
                if let _ = (self.shopsResponseModel!.isFavourite){
                    if isFavourite{
                        imageName = favourite_true
                    }else{
                        imageName = favourite_false
                    }
                }else{
                    imageName = favourite_false
                }
                cell.shopFavouriteImageView.setImage(UIImage(named: imageName), for: .normal)
                cell.shopFavouriteImageView.isUserInteractionEnabled = true
                cell.shopFavouriteImageView.addGestureRecognizer(tap!)
                if let _ = (self.shopsResponseModel!.logoPath){
                    if (self.shopsResponseModel!.logoPath) != nil{
                        imageName = (self.shopsResponseModel!.logoPath)!
                    }else{
                        imageName = shopsPlaceholderImage
                    }
                }else{
                    imageName = shopsPlaceholderImage
                }
                cell.shopImageView.sd_setImage(with: URL(string: imageName), placeholderImage: UIImage(named: shopsPlaceholderImage), options: .continueInBackground, context: nil)
            }else{
                cell.shopNameLabel.text = (self.shopDetailModel?.data!.name)!
                cell.shopCategoryLabel.text = self.shopType != "" ? self.shopType : (self.shopDetailModel?.data!.shopTypeName)!
                if distance == 0.0{
                    distance =  (self.shopDetailModel?.data?.distance)!
                }
                let distances = String(format: "%.1f", distance)
                cell.shopDistanceLabel.text = "\(distances) KM"
                cell.shopOpenStatusLabel.textColor = (self.shopDetailModel?.data!.openCloseStatus)! ? .green : .red
                cell.shopOpenStatusLabel.text = (self.shopDetailModel?.data!.openCloseStatus)! ? "Open" : "Close"
                cell.shopCloseLabel.text = (self.shopDetailModel?.data!.workingHours)!
                if isFavourite{
                    imageName = favourite_true
                }else{
                    imageName = favourite_false
                }
                cell.shopFavouriteImageView.setImage(UIImage(named: imageName), for: .normal)
                cell.shopFavouriteImageView.isUserInteractionEnabled = true
                cell.shopFavouriteImageView.addGestureRecognizer(tap!)
                if let _ = (self.shopDetailModel?.data!.logoPath){
                    if (self.shopDetailModel?.data!.logoPath) != nil{
                        imageName = (self.shopDetailModel?.data!.logoPath)!
                    }else{
                        imageName = shopsPlaceholderImage
                    }
                }else{
                    imageName = shopsPlaceholderImage
                }
                cell.shopImageView.sd_setImage(with: URL(string: imageName), placeholderImage: UIImage(named: shopsPlaceholderImage), options: .continueInBackground, context: nil)
            }
            
        case "ShopDetailTableViewCell1":
            cell.shopAddressView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
            var addressString = self.shopDetailModel?.data?.address != nil ? (self.shopDetailModel?.data?.address)! + "\n" : ""
            addressString.append((self.shopDetailModel?.data?.pinCode != nil ? (self.shopDetailModel?.data?.pinCode)! + "\n"  : ""))
            addressString.append((self.shopDetailModel?.data?.landmark != nil ? (self.shopDetailModel?.data?.landmark)! + "\n"  : ""))
            addressString.append((self.shopDetailModel?.data?.place != nil ? (self.shopDetailModel?.data?.place)! + "\n" : ""))
            cell.shopAddressLabel.text = addressString
        case "ShopDetailTableViewCell2":
            cell.shopAdditionalView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
            var additional = self.shopDetailModel?.data?.maxDeliveryRange != nil ? "Maximum  Delivery range is \((self.shopDetailModel?.data?.maxDeliveryRange)!) Km.\n" : ""
            additional.append(self.shopDetailModel?.data?.usualDispatchTime != nil ? "Usual Dipsatch time is \((self.shopDetailModel?.data?.usualDispatchTime)!) minutes.\n" : "")
            
            cell.shopAdditionalDetailLabel.text = additional
            var additionalDetail = self.shopDetailModel?.data?.freeDeliveryWithinKM != nil ? "No delivery charge within \((self.shopDetailModel?.data?.freeDeliveryWithinKM)!) Km.\n" : ""
            additionalDetail.append(self.shopDetailModel?.data?.freeDeliveryMaxAmt != nil ? "The order amount is upto AED \(Int((self.shopDetailModel?.data?.freeDeliveryMaxAmt)!)) \n" : "")
            cell.shopAdditionLabel.text = additionalDetail
            cell.shopAdditionLabel.textColor = .red
        case "ShopDetailTableViewCell3":
            //            if self.shopDetailModel?.data?.isBorderCol
            //            if self.reviewListSummary.
            cell.ratingView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
            cell.reviewBurron.addTarget(self, action: #selector(reviewTapped), for: .touchUpInside)
            let text = (self.shopDetailModel?.data?.favUsersCount)! != 0 ? ((self.shopDetailModel?.data?.favUsersCount)! == 1 ? "\((self.shopDetailModel?.data?.favUsersCount)!) user choose this shop as their favorite" : "\((self.shopDetailModel?.data?.favUsersCount)!) users choose this shop as their favorite") :  "No choose this shop as their favorite"
            cell.userFavourite.text = text
            cell.ratingValueLabel.text = "\(self.reviewListSummary!.totalRating!)"//shopReviewModel != nil ? shopReviewModel!.reviewLists[] : "0"
            cell.ratingStatusLabel.text = self.reviewListSummary!.rateByWords!
            cell.ratingReviewCountLabel.text = "\(self.reviewListSummary!.userCount!) Reviews"
            
            if dictionary.values.max()! != 0{
                cell.chartView.delegate = self
                setUPCharts(chartView: cell.chartView)
                setDataCount(chartView: cell.chartView, dictionary.count, range: dictionary.values.max()!)
            }else{
                cell.chartView.delegate = nil
                cell.chartView.data = nil
            }
            for i in 0 ..< (self.reviewListSummary?.reviewList?.count)!{
                let value = (self.reviewListSummary?.reviewList![i].percentage)! != 0 ? (self.reviewListSummary?.reviewList![i].percentage)! : 0
                var trackColor : UIColor = .white
                var progressColor : UIColor = .white
                switch value{
                case 0 ..< 26:
                    trackColor = track1
                    progressColor = BGCOLOR_1
                case 26 ..< 51:
                    trackColor = track2
                    progressColor = BGCOLOR_2
                case 51 ..< 75:
                    trackColor = track3
                    progressColor = BGCOLOR_3
                default :
                    trackColor = track4
                    progressColor = BGCOLOR_4
                }
                switch (self.reviewListSummary?.reviewList![i].title)! {
                case "Service":
                    cell.serviceView.setProgressWithAnimation(duration: 1.0, value:value != 0 ? Float(value) : 0)
                    cell.serviceView.progressClr = progressColor
                    cell.serviceView.trackClr = trackColor
                case "Delivery":
                    cell.deliveryView.setProgressWithAnimation(duration: 1.0, value: value != 0 ? Float(value)  : 0)
                    cell.deliveryView.progressClr = progressColor
                    cell.deliveryView.trackClr = trackColor
                case "Quality":
                    cell.qualityView.setProgressWithAnimation(duration: 1.0, value:value != 0 ? Float(value)  : 0)
                    cell.qualityView.progressClr = progressColor
                    cell.qualityView.trackClr = trackColor
                default:
                    cell.priceView.setProgressWithAnimation(duration: 1.0, value:value != 0 ? Float(value)  : 0)
                    cell.priceView.progressClr = progressColor
                    cell.priceView.trackClr = trackColor
                }
            }
        case "ShopDetailTableViewCell4":
            for i in 0 ..< self.flyerResponsedata!.count{
                cell.flyerOfferlabel.text = "Offer period : " + flyerResponsedata![i].offerStartDate! + " to " + flyerResponsedata![i].offerEndDate!
            }
            let distance = String(format: "%.1f", (self.flyerResponseModel != nil ? (self.flyerResponseModel?.flyerDatas![0].distance)! : 0))
            cell.flyerShop.text = (self.flyerResponseModel?.flyerDatas![0].shopName)! + "( \(distance) Km)"
            cell.flyerView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
            cell.flyerImageCollectionView.dataSource = self
            cell.flyerImageCollectionView.delegate = self
            cell.flyerImageCollectionView.tag = indexPath.row
            layout!.itemSize = CGSize(width: self.view.frame.width / 3 + 25 , height: 200)
            layout?.scrollDirection = .horizontal
            cell.flyerImageCollectionView.collectionViewLayout = layout!
            cell.flyerImageCollectionView.reloadData()
            
        case "ShopDetailTableViewCell5":
            cell.viewAllButton.addTarget(self, action: #selector(viewAllButtonTapped(sender:)), for: .touchUpInside)
            cell.productsCollectionView.dataSource = self
            cell.productsCollectionView.delegate = self
            cell.productsCollectionView.tag = indexPath.row
            layout1!.itemSize = CGSize(width: self.view.frame.width / 3 , height: 200)
            layout1?.scrollDirection = .horizontal
            cell.productsCollectionView.collectionViewLayout = layout1!
            cell.productsCollectionView.reloadData()
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: SHOPDETAILEMPTYTABLEVIEWCELL, for: indexPath) as! ShopDetailTableViewCell
//            cell.textLabel?.text = "No Review Found"
            cell.textLabel?.textAlignment = .center
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
    }
}


extension ShopDetailsViewController :UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 2 {
            return (offerResponseModel?.count)!
        }else{
            return (flyerResponsedata![0].flyerImages?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SHOPDETAILPRODUCTCOLLECTIONVIEWCELL, for: indexPath) as! ShopDetailProductCollectionViewCell
            cell.layer.cornerRadius = 6.0
            cell.layer.masksToBounds = true
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.black.cgColor
            cell.productImageView.sd_setImage(with: URL(string: (offerResponseModel![indexPath.row].imageData![0].imagePath)!), placeholderImage: UIImage(named: shopsPlaceholderImage), options: .continueInBackground, context: nil)
            cell.offerButton.isHidden = offerResponseModel![indexPath.row].discount! > 0 ? false : true
            if offerResponseModel![indexPath.row].discount! > 0{
                cell.offerButton.setTitle("\((offerResponseModel![indexPath.row].discount!))%", for: .normal)
            }
            cell.productValidityLabel.text = (offerResponseModel![indexPath.row].offerNote)!
            cell.offerValidityHeightConstraint.constant = (offerResponseModel![indexPath.row].offerNote)!.isEmpty ? 0 : 15
            cell.productNameLabel.text = (offerResponseModel![indexPath.row].itemName)!
            cell.productCategoryLabel.text = (offerResponseModel![indexPath.row].categoryData![0].categoryName)!
            
            cell.productPriceLabel.text = "AED \(String(format: "%.1f", (self.offerResponseModel != nil ? (offerResponseModel![indexPath.row].sellingPrice)! : 0)))"
            return cell
        }else{
            // product cell code
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SHOPDETAILFLYERCOLLECTIONVIEWCELL, for: indexPath) as! flyerCollectionViewCell
            cell.layer.cornerRadius = 6.0
            cell.layer.masksToBounds = true
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.black.cgColor
            cell.flyerImageLabel.text = "Page \(indexPath.row + 1) / \((flyerResponsedata![0].flyerImages?.count)!)"
            cell.flyerImageView.sd_setImage(with: URL(string: (flyerResponsedata![0].flyerImages![indexPath.row].imagePath)!), placeholderImage: UIImage(named: shopsPlaceholderImage), options: .continueInBackground, context: nil)
            cell.flyerDownloadButton.tagSection = 0
            cell.flyerDownloadButton.tag = indexPath.row
            cell.flyerDownloadButton.addTarget(self, action: #selector(download(sender:)), for: .touchUpInside)
            cell.flyerShareButton.tagSection = 0
            cell.flyerShareButton.tag = indexPath.row
            cell.flyerShareButton.addTarget(self, action: #selector(shareImage(sender:)), for: .touchUpInside)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 2{
            productDetail.produId = (self.offerResponseModel![indexPath.row].stockID)!
            productDetail.productData = self.offerResponseModel![indexPath.row]
            productDetail.shopId = self.offerResponseModel![indexPath.row].shopID!
            if isFromDetails{
                shopDelegate.backButtonTapped(view: self)
            }else{
                DispatchQueue.main.async {
                    if #available(iOS 13.0, *) {
                        productDetail.modalPresentationStyle = .fullScreen
                        self.present(productDetail, animated: false)
                    }else{
                        self.present(productDetail, animated: false, completion: nil)
                    }
                }
            }
        }else{
            DispatchQueue.main.async {
                full.urlString = (self.flyerResponsedata![0].flyerImages![indexPath.row].imagePath)!
                if #available(iOS 13.0, *) {
                    full.modalPresentationStyle = .popover
                    self.present(full, animated: false)
                }else{
                    self.present(full, animated: false, completion: nil)
                }
            }
        }
    }
    
    @objc func reviewTapped(){
        if UserDefaults.standard.value(forKey: USERID) as! Int != 0{
            review.delegate = self
            review.shopID = shopId
            DispatchQueue.main.async {
                if #available(iOS 13.0, *) {
                    review.modalPresentationStyle = .fullScreen
                    self.present(review, animated: false)
                }else{
                    self.present(review, animated: false, completion: nil)
                }
            }
        }else{
            self.showAlertWithHandlerSignIn(ERROR) { (success, failure) in
                if success{
                    
                }else{
                    (UIApplication.shared.delegate as! AppDelegate).loginPage()
                }
            }
        }
    }
}


extension ShopDetailsViewController : ReviewViewControllerDelegate{
    func backButtonTapped(view: UIViewController) {
        view.dismiss(animated: false, completion: nil)
    }
    
    func setUpValue(){
        if self.reviewListSummary != nil{
            for i in 0 ..< (reviewListSummary?.rateList!.count)!{
                switch (reviewListSummary?.rateList![i].rate)! {
                case 1:
                    dictionary["1"] = Double((reviewListSummary?.rateList![i].count)!)
                case 2:
                    dictionary["2"] = Double((reviewListSummary?.rateList![i].count)!)
                case 3:
                    dictionary["3"] = Double((reviewListSummary?.rateList![i].count)!)
                case 4:
                    dictionary["4"] = Double((reviewListSummary?.rateList![i].count)!)
                default:
                    dictionary["5"] = Double((reviewListSummary?.rateList![i].count)!)
                }
            }
        }
        DispatchQueue.main.async {
            self.shopDetailTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        }
    }
    
    func setUPCharts(chartView : HorizontalBarChartView ){
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        
        chartView.pinchZoomEnabled = false
        chartView.delegate = self
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = true
        chartView.maxVisibleCount = 60
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1
        
        let leftAxis = chartView.leftAxis
        leftAxis.enabled = false
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisMinimum = 0
        
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = false
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.drawAxisLineEnabled = false
        rightAxis.axisMinimum = 0
        
        let l = chartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 8
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        chartView.legend.enabled = false
        chartView.fitBars = true
    }
    
    func setDataCount(chartView : HorizontalBarChartView,_ count: Int, range: Double) {
        let barWidth = 0.8
        for (kind, numbers) in dictionary{
            let val = dictionary[kind]
            switch kind{
            case "5":
                valueArray[4] = val!
            case "4":
                valueArray[3] = val!
            case "3":
                valueArray[2] = val!
            case "2":
                valueArray[1] = val!
            default:
                valueArray[0] = val!
            }
        }
        let yVals = (0..<count).map { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i + 1), y: valueArray[i], icon: nil)
        }
        let set1 = BarChartDataSet(entries: yVals, label: "review")
        set1.drawIconsEnabled = false
        set1.colors = [BGCOLOR_1,track3,BGCOLOR_3,track4,BGCOLOR_4]
        
        let data = BarChartData(dataSet: set1)
        data.setValueFont(UIFont(name:"HelveticaNeue-Light", size:10)!)
        data.barWidth = barWidth
        
        chartView.data = data
    }
    
    @IBAction func callButton(sender : UIButton){
        if (self.shopDetailModel?.data?.primaryMobile)! != ""{
            phone(phoneNum: (self.shopDetailModel?.data?.primaryMobile)!)
        }else if (self.shopDetailModel?.data?.secondaryMobile)! != ""{
            phone(phoneNum: (self.shopDetailModel?.data?.secondaryMobile)!)
        }else{
            self.showSCLAlert(_message:"No phone number is available")
        }
    }
}

extension ShopDetailsViewController: ProductDelegate{
    @objc func download(sender: UIButton){
     var activityView = UIView()
        
        DispatchQueue.main.async {
    activityView = self.showActivityIndicatorWithout(_message: "Downloading...")
            let imagestring = (self.flyerResponsedata![0].flyerImages![sender.tag].imagePath)!
            if let url = URL(string: imagestring),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                self.hideActivityIndicatorWithout(uiView: activityView)
                self.showSCLAlert(_message: "Flyer downloaded successfully.")//showAlert("Flyer downloaded successfully.")
            }else{
                self.hideActivityIndicatorWithout(uiView: activityView)
                self.showSCLAlert(_message: "Something went wrong, flyer could not download at this time. Please try agein after sometime.")
            }
        }
    }
    
    @objc func shareImage(sender: UIButton) {
        self.downloadImage(from: URL(string: (self.flyerResponsedata![0].flyerImages![sender.tag].imagePath)!)!)
    }
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key)
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> ()){
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            self.image = UIImage(data: data)
            completion(self.image)
        }
    }
    
    func downloadImage(from url: URL){
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            self.image = UIImage(data: data)
            DispatchQueue.main.async {
                let activityViewController:UIActivityViewController = UIActivityViewController(activityItems:  [self.image!], applicationActivities: nil)
                self.present(activityViewController, animated: false, completion: nil)
            }
        }
    }
    
    @objc func viewAllButtonTapped(sender : UIButton){
        products.name = offerResponseModel![0].shopName!
        products.shopType = 0
        products.shopId = offerResponseModel![0].shopID!
        if isFromDetails{
            products.isDelayed = true
        }
        if isFromList{
            self.dismiss(animated: false, completion: nil)
        }else{
            products.isFromDetails = true
            products.isFromShop = true
            products.delegate = self
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
    
    func backButtonTapped(view: UIViewController, shopId: Int, productId: OfferResponseData) {
        
        view.dismiss(animated: false) {
            productDetail.productData = productId
            productDetail.shopId = shopId
            self.shopDelegate.backButtonTapped(view: self)
        }
    }
}
