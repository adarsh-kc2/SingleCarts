//
//  AccountViewController.swift
//  SingleCart
//
//  Created by PromptTech on 08/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    @IBOutlet weak var accountTableView : UITableView!
    var activityView : UIView? = nil
    var dictionary : Dictionary<String,Any> = Dictionary<String,Any>()
    var accountModel : AccountDetailsResponseModel? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.accountTableView.tableFooterView = UIView()
        self.accountTableView.reloadData()
        self.activityView = UIView()
        self.callProfileData()
        
    }
    
    @IBAction func backButtonTapped(sender : UIButton?){
        self.dismiss(animated: false, completion: nil)
    }
    
    func callProfileData(){
        self.activityView = self.showActivityIndicator(_message: "Please wait..")
        dictionary["AuthKey"] = UserDefaults.standard.value(forKey: AUTHTOKEN) != nil ? UserDefaults.standard.value(forKey: AUTHTOKEN) as! String : ""

        dictionary["UserID"] = UserDefaults.standard.value(forKey: USERID) != nil ? UserDefaults.standard.value(forKey: USERID) as! Int : 0
        Webservice.shared.getAccountDetails(body: dictionary) { (model, errorMessage) in
            self.hideActivityIndicator(uiView: self.activityView!)
            if model != nil{
                self.accountModel = model
            }else{
                self.accountModel = nil
            }
            DispatchQueue.main.async {
                self.accountTableView.reloadData()
            }
        }
    }
}

extension AccountViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if accountModel != nil {
            return 4
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //ACCOUNTTABLEVIEWCELL
        if accountModel != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: ACCOUNTTABLEVIEWCELL + "\(indexPath.row)", for: indexPath) as! accountTableViewCell
            switch indexPath.row{
            case 0:
                cell.accountImageView.setImageViewCornerRadiusWithBorder(radius: cell.accountImageView.frame.height / 2, borderwidth: 0.5, color: .lightGray)
                cell.nameLabel.text = accountModel?.name!
            case 1:
                cell.personalView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
                cell.emailLabel.text = accountModel?.email!
                cell.mobileNumberLabel.text = "+971 \((accountModel?.phone!)!)"
            case 2:
                cell.accountView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
                cell.myAddressButton.addTarget(self, action: #selector(viewAddress), for: .touchUpInside)
                cell.changePasswordButton.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
            case 3:
                cell.signOutView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)
                cell.signOutButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
            default:
                break
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: ACCOUNTEMPTYTABLEVIEWCELL, for: indexPath) as! accountTableViewCell
            //AccountEmptyTableViewCell
            cell.selectionStyle = .none
            cell.textLabel?.text = "No Data Available"
            cell.textLabel?.textAlignment = .center
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return accountModel != nil ? UITableView.automaticDimension : self.accountTableView.frame.height
    }
}

extension AccountViewController : ChangeViewControllerDelegate{
    func backButtonTapped(view: UIViewController) {
        view.dismiss(animated: false) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func clear() {
        guard let domain = Bundle.main.bundleIdentifier else { return }
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(true, forKey: FIRSTTIME)
        UserDefaults.standard.set(true, forKey: AUTHORISED)
        (UIApplication.shared.delegate as! AppDelegate).loginPage()
    }
    
    @objc func changePassword(){
        DispatchQueue.main.async {
            changePass.delegate = self
            if #available(iOS 13.0, *) {
                changePass.modalPresentationStyle = .fullScreen
                self.present(changePass, animated: false)
            }else{
                self.present(changePass, animated: false, completion: nil)
            }
        }
    }
    
    @objc func viewAddress(){
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                address.modalPresentationStyle = .fullScreen
                self.present(address, animated: false)
            }else{
                self.present(address, animated: false, completion: nil)
            }
        }
        
    }
}
