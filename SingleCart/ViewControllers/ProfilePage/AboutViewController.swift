//
//  AboutViewController.swift
//  SingleCart
//
//  Created by PromptTech on 03/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import StoreKit

class AboutViewController: UIViewController{//}, AppUpdateNotifier, SKStoreProductViewControllerDelegate {
    
//    func openStoreProductWithiTunesItemIdentifier(_ identifier: String) {
//        let storeViewController = SKStoreProductViewController()
//        storeViewController.delegate = self
//
//        let parameters = [ SKStoreProductParameterITunesItemIdentifier : identifier]
//        storeViewController.loadProduct(withParameters: parameters) { [weak self] (loaded, error) -> Void in
//            if loaded {
//                // Parent class of self is UIViewContorller
//                self?.present(storeViewController, animated: true, completion: nil)
//            }
//            debugPrint(error)
//
//        }
//    }
//    private func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
//        viewController.dismiss(animated: true, completion: nil)
//    }
//
//    func onFirstLaunch() {
////        openStoreProductWithiTunesItemIdentifier("1531598016")
////          let urlStr = "https://apps.apple.com/us/app/id1531598016"
////        if #available(iOS 10.0, *) {
////            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
////
////        } else {
////            UIApplication.shared.openURL(URL(string: urlStr)!)
////        }
//        self.showSCLAlert(_message: "Your application is have no updates.")//showAlert("Your application is have no updates.")//
//    }
//
//    func onVersionUpdate(newVersion: Int, oldVersion: Int) {
//           let urlStr = "https://apps.apple.com/in/app/singlecart/id1531598016"
//         if #available(iOS 10.0, *) {
//             UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
//
//         } else {
//             UIApplication.shared.openURL(URL(string: urlStr)!)
//         }
//    }
    
    
    var urlString = ""
    
    @IBOutlet weak var aboutTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

extension  AboutViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ABOUTTABLEVIEWCELL + "\(indexPath.row)", for: indexPath) as! aboutTableViewCell
        
        if indexPath.row == 1{
            cell.versionLabel.text = "Version : \((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!).\((Bundle.main.infoDictionary?["CFBundleVersion"] as? String)!)"
            cell.rateButton.addTarget(self, action: #selector(rateApp), for: .touchUpInside)
            cell.updateButton.addTarget(self, action: #selector(update), for: .touchUpInside)
        }
        if indexPath.row == 2{
            cell.policyButton.addTarget(self, action: #selector(privacyButtonTapped), for: .touchUpInside)
            cell.termsButton.addTarget(self, action: #selector(termButtonTapped), for: .touchUpInside)
        }
        return cell
    }
 
    @objc func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if let url = URL(string: "https://apps.apple.com/in/app/singlecart/id1531598016") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc func update(){
        let updates = appUpdateAvailable()
        if updates{
            self.showAlertWithHandlerOKCancel("Update is available", cancelText: "Update") { (success, failure) in
                if failure{
                    let urlStr = "https://apps.apple.com/in/app/singlecart/id1531598016"
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
                        
                    } else {
                        UIApplication.shared.openURL(URL(string: urlStr)!)
                    }
                }
            }

        }else{
            self.showSCLAlert(_message: "Your application is have no updates.")
        }
        
    }
    
    @objc func privacyButtonTapped(){
        urlString = PRIVACY
        moveToURLPage()
    }
    
    @objc func termButtonTapped(){
        urlString = TERMS
        moveToURLPage()
    }
    
    func moveToURLPage(){
        urlpage.loadingURL = urlString
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                urlpage.modalPresentationStyle = .fullScreen
                self.present(urlpage, animated: false)
            }else{
                self.present(urlpage, animated: false, completion: nil)
            }
        }
    }
}



class AppVersionUpdateNotifier {
    static let KEY_APP_VERSION = "key_app_version"
    static let shared = AppVersionUpdateNotifier()
    
    private let userDefault:UserDefaults
    var delegate:AppUpdateNotifier?
    
    init() {
        self.userDefault = UserDefaults.standard
    }
    
    func initNotifier(_ delegate:AppUpdateNotifier) {
        self.delegate = delegate
        checkVersionAndNotify()
    }
    
    private func checkVersionAndNotify() {
        let versionOfLastRun = userDefault.object(forKey: AppVersionUpdateNotifier.KEY_APP_VERSION) as? Int
        let currentVersion = Int(Bundle.main.buildVersion)!
        
        if versionOfLastRun == nil {
            // First start after installing the app
            delegate?.onFirstLaunch()
        } else if versionOfLastRun != currentVersion {
            // App was updated since last run
            delegate?.onVersionUpdate(newVersion: currentVersion, oldVersion: versionOfLastRun!)
        } else {
            delegate?.onFirstLaunch()
            // nothing changed
            
        }
        userDefault.set(currentVersion, forKey: AppVersionUpdateNotifier.KEY_APP_VERSION)
    }
}

protocol AppUpdateNotifier {
    func onFirstLaunch()
    func onVersionUpdate(newVersion:Int, oldVersion:Int)
}
extension Bundle {
    var shortVersion: String {
        return infoDictionary!["CFBundleShortVersionString"] as! String
    }
    var buildVersion: String {
        return infoDictionary!["CFBundleVersion"] as! String
    }
}


extension  AboutViewController{
    func appUpdateAvailable() -> Bool{
        let storeInfoURL: String = "http://itunes.apple.com/lookup?bundleId=com.prompttech.SingleCart"
        var upgradeAvailable = false
        // Get the main bundle of the app so that we can determine the app's version number
        let bundle = Bundle.main
        if let infoDictionary = bundle.infoDictionary {
            // The URL for this app on the iTunes store uses the Apple ID for the  This never changes, so it is a constant
            let urlOnAppStore = URL(string: storeInfoURL)
//            let daaa = Data()
            if let dataInJSON = NSData(contentsOf: urlOnAppStore!) {
                // Try to deserialize the JSON that we got
                if let dict: NSDictionary = try! JSONSerialization.jsonObject(with: dataInJSON as Data, options: .allowFragments) as! [String: AnyObject] as NSDictionary? {
                    if let results:NSArray = dict["results"] as? NSArray {
                        if let version = (results[0] as! NSDictionary).value(forKey: "version") as? String {
                            // Get the version number of the current version installed on device
                            if let currentVersion = infoDictionary["CFBundleShortVersionString"] as? String {
                                // Check if they are the same. If not, an upgrade is available.
                                print("\(version)")
                                if version != currentVersion {
                                    upgradeAvailable = true
                                }
                            }
                        }
                    }
                }
            }
        }
        return upgradeAvailable
    }

}
