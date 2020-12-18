//
//  ShopsViewController.swift
//  SingleCart
//
//  Created by apple on 18/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ShopsViewController: UIViewController {
    @IBOutlet weak var wishLishButton: BageButton!
    
    @IBOutlet weak var cartButton: BageButton!
    @IBOutlet weak var shopsTableView: UITableView!
    @IBOutlet weak var shopsSearchBar: UISearchBar!
    
    var shopsResponseModel : [GetShopsResponseData]? = []
    var tempShopsResponseModel : [GetShopsResponseData]? = []
    var favouriteRequestmodel : AddtoFavouritesRequestModel? = nil
    var shopsModel : GetShopsResponseModel? = nil
    var shopsRequest : GetShopsRequestModel? = nil
    var booleanArray : [Bool] = [Bool]()
    
    var activityView : UIView!
    
    var imageName : String = ""
    var _searchString = ""

    @IBOutlet weak var shopSearchBar: UISearchBar!
    var pageNo = 1
    var pageSize = 30
    var shopType = 0
    var currentRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    
    override func viewWillAppear(_ animated: Bool) {
        shopsSearchBar.text = ""
        shopsSearchBar.showsCancelButton = false
        _searchString = ""
        self.shopsModel = nil
        self.shopsResponseModel?.removeAll()
        self.booleanArray.removeAll()
        self.shopsTableView.tableFooterView = UIView()
        self.shopsTableView.reloadData()
        getShops()
        if let _ = UserDefaults.standard.value(forKey: CART_VALUE){
            cartButton.badge = "\(UserDefaults.standard.value(forKey: CART_VALUE)!)"
        }
        if let _ = UserDefaults.standard.value(forKey: WISH_VALUE){
            wishLishButton.badge = "\(UserDefaults.standard.value(forKey: WISH_VALUE)!)"
        }
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(notification(_notification:)), name: Notification.Name("shopDeepLink"), object: nil)
    }
    
    @objc func notification(_notification : Notification){
        let value = ((((((_notification.userInfo as! NSDictionary)["url"]! as! URL).absoluteString).split(separator: "&") as! NSArray)[1] as! String).split(separator: "=") as! NSArray).lastObject as! String
        do{
            let datas = try EncryptionManager().aesDecrypt(cipherText: value).replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: "")
            if datas != "Could not decrypt"{
                shop_Detail.shopId = Int(datas)!
                self.moveToDetailPage()
            }
        }catch{
        }
    }
    
    func getShops(){
        shopsRequest = GetShopsRequestModel(_name: _searchString, _pageNo: pageNo , _pageSize: pageSize, _ShowOffers: false, _ShopType: shopType)
        if pageNo == 1{
            self.shopsResponseModel?.removeAll()
            self.shopsModel = nil
        }
        if _searchString == "" {
            activityView = self.showActivityIndicator(_message: "Please wait....")
        }
        
        Webservice.shared.getShops(body: (shopsRequest?.dictionary)!) { (model, errorMessage) in
            if self._searchString == "" {
                self.hideActivityIndicator(uiView: self.activityView)
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
                self.removeDuplicates()
            }else{
                self.booleanArray.removeAll()
                self.shopsModel = nil
                self.shopsResponseModel?.removeAll()
                self.showSCLAlert(_message:errorMessage!)
            }
            DispatchQueue.main.async {
                self.shopsTableView.reloadData()
            }
        }
    }
    
    func removeDuplicates(){
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
            self.hideActivityIndicator(uiView: self.activityView)
            if model != nil{
                self.booleanArray[self.currentRow] = !(self.booleanArray[self.currentRow])
                // do coding here
            }else{
                // set error Message
            }
            DispatchQueue.main.async {
                self.shopsTableView.reloadRows(at: [IndexPath(row: self.currentRow, section: 0)], with: .none)
            }
        }
    }
    @IBAction func sideMenuTapped(_ sender: Any) {
    }
    
    @IBAction func cartButtonTapped(_ sender: Any) {
        self.moveToCart()
    }
    @IBAction func wishListButtonTapped(_ sender: Any) {
        self.moveToWishList()
    }
    
}

extension ShopsViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shopsResponseModel!.isEmpty ? 1 : (self.shopsResponseModel?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !(self.shopsResponseModel!.isEmpty){
            if (self.shopsResponseModel?.count)! > 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: SHOPSTABLEVIEWCELL, for: indexPath) as! shopsTableViewCell
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
                let cell = tableView.dequeueReusableCell(withIdentifier: SHOPEMPTYTABLEVIEWCELL, for: indexPath) as! ShopDetailTableViewCell
                cell.selectionStyle = .none
                cell.textLabel?.text = "No Data Available"
                cell.textLabel?.textAlignment = .center
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: SHOPEMPTYTABLEVIEWCELL, for: indexPath) as! shopsTableViewCell
            cell.textLabel?.text = "No Data Available"
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.shopsResponseModel!.count > 0 ? UITableView.automaticDimension : shopsTableView.frame.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(self.shopsResponseModel!.isEmpty){
            shop_Detail.shopId = (self.shopsResponseModel![indexPath.row].shopID)!
            shop_Detail.shopType = (self.shopsResponseModel![indexPath.row].shopTypeName)!
            shop_Detail.shopsResponseModel = self.shopsResponseModel![indexPath.row]
            moveToDetailPage()
        }
    }
    
    func moveToDetailPage(){
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                shop_Detail.modalPresentationStyle = .fullScreen
                self.present(shop_Detail, animated: false)
            }else{
                self.present(shop_Detail, animated: false, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let _ = self.shopsModel{
            if indexPath.row == self.shopsResponseModel!.count - 1{
                if ((self.shopsModel?.pageAvailable)! > 1) && (pageNo < (self.shopsModel?.pageAvailable)!){
                    pageNo += 1
                    getShops()
                }
            }
        }
    }
}

extension ShopsViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        self.shopsResponseModel?.removeAll()
        self.booleanArray.removeAll()
        _searchString = searchText
        self.shopsModel = nil
        Webservice.task.cancel()
        getShops()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        self.booleanArray.removeAll()
        self._searchString = searchBar.text!
        self.shopsResponseModel?.removeAll()
        Webservice.task.cancel()
        self.getShops()
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        _searchString = ""
        searchBar.text! = ""
        self.shopsResponseModel?.removeAll()
        self.booleanArray.removeAll()
        self.pageNo = 1
        Webservice.task.cancel()
        getShops()
    }
}







