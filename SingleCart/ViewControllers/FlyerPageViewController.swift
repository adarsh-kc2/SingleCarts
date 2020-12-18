//
//  FlyerPageViewController.swift
//  SingleCart
//
//  Created by PromptTech on 11/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SDWebImage

class FlyerPageViewController: UIViewController {
    @IBOutlet weak var wishLishButton: BageButton!
    var layoutCollection : [UICollectionViewFlowLayout] = []
    @IBOutlet weak var cartButton: BageButton!
    var image : UIImage? = nil
    @IBOutlet weak var flyerTableView: UITableView!
    @IBOutlet weak var flyerSearchBar: UISearchBar!
    var flyerRequestModel : FlyerRequestModel? = nil
    var flyerResponseModel : FlyerResponseModel? = nil
    
    var flyerResponsedata : [FlyerDatas]? = []
    var tempflyerResponsedata : [FlyerDatas]? = []
    
    var pageNo = 1
    var flyerId = 0
    var shopId = 0
    var activeView : UIView? = nil
    let screenSize = UIScreen.main.bounds
    var screenWidth = 0.0
    var screenHeight = 0.0
    var _searchString = ""
    
    var layout : UICollectionViewFlowLayout? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        activeView = UIView()
        screenWidth = Double(screenSize.width)
        self.flyerSearchBar.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let _ = Webservice.task{
            Webservice.task.cancel()
            if let _ = self.activeView{
                DispatchQueue.main.async {
                    self.hideActivityIndicatorWithout(uiView: self.activeView!)
                }
            }
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.flyerTableView.delegate = self
        self.flyerTableView.dataSource = self
        self.flyerTableView.tableFooterView = UIView()
        self.flyerResponseModel = nil
        self.flyerResponsedata?.removeAll()
        self.flyerTableView.reloadData()
        getFlyers()
        if let _ = UserDefaults.standard.value(forKey: CART_VALUE){
            cartButton.badge = "\(UserDefaults.standard.value(forKey: CART_VALUE)!)"
        }
        if let _ = UserDefaults.standard.value(forKey: WISH_VALUE){
            wishLishButton.badge = "\(UserDefaults.standard.value(forKey: WISH_VALUE)!)"
        }
    }
    
    func getFlyers(){
        activeView = self.showActivityIndicator(_message: "Please wait...")
        flyerRequestModel = FlyerRequestModel(_FlyerID: flyerId, _ShopID: shopId, _PageNo: pageNo)
        Webservice.shared.getFlyers(body: (flyerRequestModel?.dictionary)!) { (model, errorMessage) in
            self.hideActivityIndicator(uiView: self.activeView!)
            if model == nil && errorMessage == nil{
                self.showAlertWithHandlerOKCancel("Your active session was expired. Please re-login to continue or try again later. Do you want to retry?") { (success, failure) in
                    if success{
                        
                    }else{
                        (UIApplication.shared.delegate as! AppDelegate).loginPage()
                    }
                }
            }else
            if model != nil{
                self.flyerResponseModel = model
                for i in 0 ..< (model?.flyerDatas?.count)!{
                    self.flyerResponsedata?.append((model?.flyerDatas![i])!)
                    self.screenHeight = self.screenWidth
                    self.layout = UICollectionViewFlowLayout()
                    self.layout!.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
                    self.layout!.itemSize = CGSize(width: (self.screenWidth * 3 / 4), height: self.screenHeight - 20)
                    self.layout?.scrollDirection = .horizontal
                    self.layoutCollection.append(self.layout!)
                }
            }else{
                self.showSCLAlert(_message:errorMessage!)
            }
            DispatchQueue.main.async {
                self.flyerTableView.reloadData()
            }
        }
    }
    
    @IBAction func sideMenuButtonTapped(_ sender: Any) {
    }
    
    @IBAction func cartButtonTapped(_ sender: Any) {
        self.moveToCart()
    }
    
    @IBAction func wishListButtonTapped(_ sender: Any) {
        self.moveToWishList()
    }
}

extension FlyerPageViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flyerResponsedata!.isEmpty ? 1 : (flyerResponsedata?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if flyerResponsedata!.isEmpty{
            let cell = tableView.dequeueReusableCell(withIdentifier: FLYEREMPTYRABLEVIEWCELL, for: indexPath) as! FlyerTableViewCell
            cell.selectionStyle = .none
            cell.textLabel?.text = "No Data Available"
            cell.textLabel?.textAlignment = .center
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: FLYERTABLEVIEWCELL, for: indexPath) as! FlyerTableViewCell
            cell.flyerNamelabel.text = flyerResponsedata![indexPath.row].offerName!
            let stringValue = String(format: "%.1f", (flyerResponsedata![indexPath.row].distance!))
            cell.flyerShopLabel.text = flyerResponsedata![indexPath.row].shopName! + " ( \(stringValue) Km )"
            cell.flyerOfferlabel.text = "Offer period : " + flyerResponsedata![indexPath.row].offerStartDate! + " to " + flyerResponsedata![indexPath.row].offerEndDate!
            cell.flyerView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
            cell.flyerImageCollectionView.dataSource = self
            cell.flyerImageCollectionView.delegate = self
            cell.flyerImageCollectionView.tag = indexPath.row
            cell.flyerHeightConstraint.constant = CGFloat(screenWidth)
            cell.flyerImageCollectionView.collectionViewLayout = layoutCollection[indexPath.row]
            cell.flyerImageCollectionView.reloadData()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.flyerResponsedata!.isEmpty ? flyerTableView.frame.height : UITableView.automaticDimension
    }
    
}

extension FlyerPageViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (flyerResponsedata![collectionView.tag].flyerImages?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FLYERCOLLECTIONVIEWCELL, for: indexPath) as! flyerCollectionViewCell
        cell.layer.cornerRadius = 6.0
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.black.cgColor
        cell.flyerImageLabel.text = "Page \(indexPath.row + 1) / \((flyerResponsedata![collectionView.tag].flyerImages?.count)!)"
        cell.flyerImageView.sd_setImage(with: URL(string: (flyerResponsedata![collectionView.tag].flyerImages![indexPath.row].imagePath)!), placeholderImage: UIImage(named: placeHolderImage), options: .continueInBackground, context: nil)//.imageFromURL(urlString: (flyerResponsedata![collectionView.tag].flyerImages![indexPath.row].imagePath)!)
        cell.flyerDownloadButton.tagSection = collectionView.tag
        cell.flyerDownloadButton.tag = indexPath.row
        cell.tag = collectionView.tag
//        cell.flyerDownloadButton.addTarget(self, action: #selector(download(sender:)), for: .touchUpInside)
        cell.flyerDownloadButton.addTarget(self, action: #selector(download(sender:)), for: .touchUpInside)
        cell.flyerShareButton.tagSection = collectionView.tag
        cell.flyerShareButton.tag = indexPath.row
        cell.flyerShareButton.addTarget(self, action: #selector(shareImage(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let _ = self.flyerResponsedata{
            if indexPath.row == self.flyerResponsedata!.count - 1{
                if ((self.flyerResponseModel?.pageAvailable)! > 1) && (pageNo < (self.flyerResponseModel?.pageAvailable)!){
                    pageNo += 1
                    self.getFlyers()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            full.urlString = (self.flyerResponsedata![collectionView.tag].flyerImages![indexPath.row].imagePath)!
            if #available(iOS 13.0, *) {
                full.modalPresentationStyle = .popover
                self.present(full, animated: false)
            }else{
                self.present(full, animated: false, completion: nil)
            }
        }
    }
    
    @objc func download(sender: UIButton){
        self.activeView = self.showActivityIndicator(_message: "Downloading...")
        DispatchQueue.main.async {
            var imagestring = ""
            if (self.flyerResponsedata![sender.tagSection!].flyerImages?.count) == sender.tag{
                imagestring = (self.flyerResponsedata![sender.tagSection! - 1].flyerImages![sender.tag].imagePath)!
            }else{
                imagestring = (self.flyerResponsedata![sender.tagSection!].flyerImages![sender.tag].imagePath)!
            }
            
            if let url = URL(string: imagestring),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                self.hideActivityIndicatorWithout(uiView: self.activeView!)
                self.showSCLAlert(_message: "Flyer downloaded successfully")
            }else{
                self.hideActivityIndicatorWithout(uiView: self.activeView!)
                self.showSCLAlert(_message: "Something went wrong, flyer could not download at this time. Please try agein after sometime.")
            }
        
        }

//        downloadImage(from: URL(string: (flyerResponsedata![sender.tagSection!].flyerImages![sender.tagRow!].imagePath)!)!) { (image) in
//            if image != nil {
//                if let pngRepresentation = image!.pngData(){
//                    if let filePath = self.filePath(forKey: ((((self.flyerResponsedata![sender.tagSection!].flyerImages![sender.tagRow!].imagePath)!.split(separator: "/").last)! as NSString) as String)) {
//                        do  {
//                            try pngRepresentation.write(to: filePath,
//                                                        options: .atomic)
//
//                            print("Saved")
//                        } catch let err {
//                            print("Saving file resulted in error: ", err)
//                        }
//                    }
//                }
//            }
//        }
    }
    
    @objc func shareImage(sender: UIButton) {
        self.downloadImage(from: URL(string: (self.flyerResponsedata![sender.tagSection!].flyerImages![sender.tag].imagePath)!)!)
    }
}

extension FlyerPageViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        self.tempflyerResponsedata = self.flyerResponsedata
        self.flyerResponsedata?.removeAll()
        _searchString = searchBar.text!
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        getFlyers()
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        _searchString = ""
        searchBar.text! = ""
        self.flyerResponsedata = self.tempflyerResponsedata
        self.flyerResponsedata?.removeAll()
        self.pageNo = 1
        getFlyers()
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
            if self.image == nil{
                self.image = UIImage(named: placeHolderImage)
            }
            DispatchQueue.main.async {
                let activityViewController:UIActivityViewController = UIActivityViewController(activityItems:  [self.image!], applicationActivities: nil)
                self.present(activityViewController, animated: false, completion: nil)
            }
          }
          
      }
}


extension UIImageView {
    public func imageFromURL(urlString: String) {

        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        activityIndicator.startAnimating()
        if self.image == nil{
            self.image = UIImage(named: shopsPlaceholderImage)
            self.addSubview(activityIndicator)
        }

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                self.image = UIImage(named: shopsPlaceholderImage)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                activityIndicator.removeFromSuperview()
                self.image = image
            })

        }).resume()
    }
}
