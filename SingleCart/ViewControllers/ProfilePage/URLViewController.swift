//
//  URLViewController.swift
//  SingleCart
//
//  Created by PromptTech on 03/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import WebKit

class URLViewController: UIViewController {
    var activityView : UIView? = nil
    @IBOutlet weak var urlView: WKWebView!
    @IBOutlet weak var backButton: UIButton!
    
    var loadingURL : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView = UIView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        urlView.navigationDelegate = self
        urlView.load(URLRequest(url: URL(string: loadingURL)!))
//        activityView = self.showActivityIndicator(_message: "Wait...")
        urlView.allowsBackForwardNavigationGestures = true
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

extension URLViewController : WKNavigationDelegate{
      func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint("finished")
//        DispatchQueue.main.async {
//            self.hideActivityIndicator(uiView: self.activityView!)
//        }
        
        // Refreshing the content in case of editing...
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    }
}
