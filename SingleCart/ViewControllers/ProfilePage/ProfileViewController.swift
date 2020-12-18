//
//  ProfileViewController.swift
//  SingleCart
//
//  Created by PromptTech on 03/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileTableView: UITableView!
    var Countarray = [String]()
    var imageArray = [String]()
    var image = UIImage()
    var titleString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.async {
            var activeView = UIView()
            activeView = self.showActivityIndicator(_message: "Please wait")
            
            if let _id =  UserDefaults.standard.value(forKey: USERID){
                if _id as! Int == 0{
                    self.Countarray = PROFILEARRAY
                    self.imageArray = PROFILEARRAY_IMAGES
                    self.titleString = "Sign in"
                    self.image = UIImage(named: "logo_single_white.png")!
                }else{
                    self.imageArray = PROFILEARRAY_IMAGES_USERID
                    self.Countarray = PROFILEARRAY_USERID
                    self.titleString = "My Account"
                    self.image = UIImage(named: "user1.png")!
                }
                self.hideActivityIndicatorWithout(uiView: activeView)
                self.profileTableView.reloadData()
            }else{
                self.hideActivityIndicatorWithout(uiView: activeView)
                self.profileTableView.reloadData()
            }
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
}

extension ProfileViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Countarray.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PROFILETABLEVIEWCELL + "\(indexPath.row > 1 ? 2 : indexPath.row)", for: indexPath) as! profileTableViewCell
        if indexPath.row == 1{
            cell.profileImageView.image = image
            cell.profileButton.setTitle(titleString, for: .normal)
            if titleString == "My Account"{
                cell.profileButton.addTarget(self, action: #selector(movetoAccountPage), for: .touchUpInside)
            }else{
                cell.profileButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
            }
        }
        if indexPath.row > 1{
            if Countarray[indexPath.row - 2] == "Extras" || Countarray[indexPath.row - 2] == "Logout"{
                cell.accessoryType = .none
            }
            cell.titleLabel?.text = Countarray[indexPath.row - 2]
            cell.titleImageView.image = UIImage(named: imageArray[indexPath.row - 2])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 1{
            switch Countarray[indexPath.row - 2] {
            case "About":
                self.setAboutPage()
            case "Share":
                self.shareButtontapped()
            case "Feedback":
                self.feedBackButtonTapped()
            case "Sell on SingleCart?":
                self.sellOnSingleCart(id: STORE_LINK)
            case "Extras":
                break
            case "My Orders":
                self.moveToOrders()
            case "My Wishlist":
                self.moveToWishList()
            case "My Cart":
                self.moveToCart()
            case "Logout":
                self.clear()
            default:
                break
            }
        }
    }
    
    @objc func clear() {
        guard let domain = Bundle.main.bundleIdentifier else { return }
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(false, forKey: FIRSTTIME)
        UserDefaults.standard.set(true, forKey: AUTHORISED)
        (UIApplication.shared.delegate as! AppDelegate).loginPage()
        
    }
    
    func setAboutPage(){
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                about.modalPresentationStyle = .fullScreen
                self.present(about, animated: false)
            }else{
                self.present(about, animated: false, completion: nil)
            }
        }
    }
    
    @objc func movetoAccountPage(){
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                account.modalPresentationStyle = .fullScreen
                self.present(account, animated: false)
            }else{
                self.present(account, animated: false, completion: nil)
            }
        }
    }
    
    @objc func movetoLoginPage(){
        Login.isFromHome = true
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                Login.modalPresentationStyle = .fullScreen
                self.present(Login, animated: false)
            }else{
                self.present(Login, animated: false, completion: nil)
            }
        }
    }
    
    func feedBackButtonTapped(){
        DispatchQueue.main.async {
            if let _id =  UserDefaults.standard.value(forKey: USERID){
                if _id as! Int != 0{
                    feed_Back.delegate = self
                    DispatchQueue.main.async {
                        if #available(iOS 13.0, *) {
                            feed_Back.modalPresentationStyle = .fullScreen
                            self.present(feed_Back, animated: false)
                        }else{
                            self.present(feed_Back, animated: false, completion: nil)
                        }
                    }
                }else{
                    self.showAlertWithHandlerSignIn(ERROR) { (success, failure) in
                        if success{
                            
                        }else{
                            
                        }
                    }
                }
            }else{
                self.showAlertWithHandlerSignIn(ERROR) { (success, failure) in
                    if success{
                        
                    }else{
                        
                    }
                }
            }
        }
    }
    
    func shareButtontapped(){
        let str = "Check this application on the Appstore\n\n\n\n"
        if let urlStr = NSURL(string: "https://apps.apple.com/in/app/singlecart/id1531598016") {
            let objectsToShare = [str,urlStr] as [Any]
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

extension ProfileViewController : FeedBackViewControllerDelegate{
    func backButtonTapped(view: UIViewController) {
        view.dismiss(animated: false) {
            self.dismiss(animated: false, completion: nil)
        }
    }
}
