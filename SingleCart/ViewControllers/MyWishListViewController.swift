//
//  MyWishListViewController.swift
//  SingleCart
//
//  Created by PromptTech on 17/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MyWishListViewController: UIViewController {
    var activityView : UIView!
    var wishListModel : WishListResponseModel? = nil
    @IBOutlet weak var wishListTableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        wishListModel = nil
        self.wishListTableview.tableFooterView = UIView()
        self.wishListTableview.reloadData()
        self.getWishListData()
    }
    
    func getWishListData(){
        DispatchQueue.main.async {
            self.activityView = self.showActivityIndicator(_message: "Please wait..")
            let request = GetWishListRequestModel(_shopId: 0)
            Webservice.shared.getWishList(body: request.dictionary) { (model, errorMessage) in
                self.hideActivityIndicator(uiView: self.activityView)
                self.activityView = nil
                if model == nil && errorMessage == nil{
                    self.showAlertWithHandlerOKCancel("Your active session was expired. Please re-login to continue or try again later. Do you want to retry?") { (success, failure) in
                        if success{
                            
                        }else{
                            (UIApplication.shared.delegate as! AppDelegate).loginPage()
                        }
                    }
                }else
                if model != nil{
                    self.wishListData()
                    self.wishListModel = (model?.data?.isEmpty)! ? nil : model
                }else{
                    self.wishListModel = nil
                    self.showSCLAlert(_message:errorMessage!)
                }
                DispatchQueue.main.async {
                    self.wishListTableview.reloadData()
                }
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

extension MyWishListViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = self.wishListModel != nil ? ((self.wishListModel?.data?.count)! == 0 ? 1 : (self.wishListModel?.data?.count)!) : 1
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.wishListModel != nil ?  ((self.wishListModel?.data?.isEmpty)! ? 1 : (self.wishListModel?.data![section].wishListShopsProductData?.count)! ): 1
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.wishListModel != nil {
            if (self.wishListModel?.data!.isEmpty)!{
                let cell = tableView.dequeueReusableCell(withIdentifier: "wishListEmptyTableViewCell", for: indexPath) as! wishListTableViewCell
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: WISHLIST_TABLEVIEWCELL, for: indexPath) as! wishListTableViewCell
                cell.wishListNameLabel.text = self.wishListModel?.data![indexPath.section].wishListShopsProductData![indexPath.row].itemName!
                var categoryString = ""
                for i in 0 ..< (self.wishListModel?.data![indexPath.section].wishListShopsProductData![indexPath.row].categoryData!.count)!{
                    categoryString.append((self.wishListModel?.data![indexPath.section].wishListShopsProductData![indexPath.row].categoryData![i].categoryName!)!)
                    if (self.wishListModel?.data![indexPath.section].wishListShopsProductData![indexPath.row].categoryData!.count)! > 0{
                        categoryString.append(",")
                    }
                }
                cell.wishListCategoryLabel.text = categoryString
                cell.wishListPlaceLabel.text = self.wishListModel?.data![indexPath.section].wishListShopsProductData![indexPath.row].shopName!
                let distance = String(format: "%.1f", (self.wishListModel?.data![indexPath.section].wishListShopsProductData != nil ? (self.wishListModel?.data![indexPath.section].wishListShopsProductData![indexPath.row].distance)! : 0))
                cell.wishListDistanceLabel.text = "\(distance) KM"
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "AED \((self.wishListModel?.data![indexPath.section].wishListShopsProductData![indexPath.row].actualPrice)!)")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.wishListPriceLabel.attributedText = attributeString
                cell.wishListOfferPriceLabel.text = "AED \((self.wishListModel?.data![indexPath.section].wishListShopsProductData![indexPath.row].sellingPrice)!)"
                cell.wishListOfferValidityLabel.text = "\((self.wishListModel?.data![indexPath.section].wishListShopsProductData![indexPath.row].offerNote)!)"
                cell.cartButton.setCornerRadius(radius: 6.0, isBg_Color: true, bg_Color: HOME_NAVIGATION_BGCOLOR, isBorder: true, borderColor: DEFAULT_BORDER_COLOR, borderWidth: 0.5)
                cell.removeButton.setCornerRadius(radius: 6.0, isBg_Color: false, bg_Color: nil, isBorder: true, borderColor: DEFAULT_BORDER_COLOR, borderWidth: 0.5)
                cell.wishListImageView.sd_setImage(with: URL(string:(self.wishListModel?.data![indexPath.section].wishListShopsProductData![indexPath.row].imageData![0].imagePath)!)!, placeholderImage: UIImage(named: "No_Image_Available.png"), options: .continueInBackground, context: nil)
                cell.wishListView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.4, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
                cell.cartButton.tagSection = indexPath.section
                cell.cartButton.tagRow = indexPath.row
                cell.cartButton.addTarget(self, action: #selector(addToCart(sender:)), for: .touchUpInside)
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "wishListEmptyTableViewCell", for: indexPath) as! wishListTableViewCell
           cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  self.wishListModel != nil ? ((self.wishListModel?.data?.isEmpty)! ? self.wishListTableview.frame.height: UITableView.automaticDimension) : self.wishListTableview.frame.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let _wish = self.wishListModel{
            let headerView: UIView = UIView.init(frame: CGRect.init(x: -1, y: 50, width: self.view.frame.width, height: 50))
            headerView.setCornerRadius(radius: 1.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: true, B_GColor:HOME_NAVIGATION_BGCOLOR , isBorderWidth: true, borderWidth: 0.4, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
            let labelView: UILabel = UILabel.init(frame: CGRect.init(x: 10, y: 4, width: 276, height: 42))
            labelView.numberOfLines = 0
            labelView.text = self.wishListModel?.data![section].name!
            labelView.textColor = .white
            headerView.addSubview(labelView)
            return headerView
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _wish = self.wishListModel{
            if _wish.data!.isEmpty{
                return 0
            }
             return 50
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "Remove") { action, index in
            self.deleteProduct(id: ((self.wishListModel?.data![editActionsForRowAt.section].wishListShopsProductData![editActionsForRowAt.row].stockID)!), shopId: ((self.wishListModel?.data![editActionsForRowAt.section].wishListShopsProductData![editActionsForRowAt.row].shopID)!))
        }
        more.backgroundColor = .lightGray
        return [more]
    }
    
    func deleteProduct(id: Int , shopId: Int){
        let request = AddRemoveWishListRequestModel(_isadd: false, _stockId: id, _shopId: shopId)
        Webservice.shared.addToWishList(body: request.dictionary) { (model, error) in
            self.getWishListData()
        }
    }
    @objc func addToCart(sender : UIButton){
        self.addToCartProduct(id: ((self.wishListModel?.data![sender.tagSection!].wishListShopsProductData![sender.tagRow!].stockID)!), shopId: ((self.wishListModel?.data![sender.tagSection!].wishListShopsProductData![sender.tagRow!].shopID)!), quantity: 1, remarks: "")
    }
    
    func addToCartProduct(id: Int , shopId: Int,quantity : Int ,remarks : String){
        let request = AddRemoveCartRequestModel(_isadd: true, _stockId: id, _shopId: shopId, _remarks: remarks, _quantity: quantity)
        Webservice.shared.addToCart(body: request.dictionary) { (model, error) in
            self.getWishListData()
            
        }
    }
    
}
