//
//  FeedBackViewController.swift
//  SingleCart
//
//  Created by PromptTech on 03/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class FeedBackViewController: UIViewController {

    var delegate : FeedBackViewControllerDelegate!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var feedbackView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.feedbackTextView.setCornerRadius(radius: 6.0, isShadow: false, isBorderColor: true, borderColor: .lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.4, shadowOpacity: nil, shadowColor: nil, shadowOffset: nil)
         self.feedbackView.setCornerRadius(radius: 6.0, isShadow: false, isBorderColor: true, borderColor: .lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.4, shadowOpacity: nil, shadowColor: nil, shadowOffset: nil)
        self.sendButton.setCornerRadiusWithoutBackground(radius: 6.0)
        feedbackTextView.placeholder = "Enter your feedback here."
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        let _tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(_tap)
    }
    
    @IBAction func backButtontapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func sendButtonTapped(_ sender: UIButton) {
        if feedbackTextView.text.isEmpty{
            self.showSCLAlert(_message:"you have to enter feedback before sending")
        }else{
           let request = CustomerFeedbackRequestModel(_remark: nil, _feedback: feedbackTextView.text)
            Webservice.shared.customerFeedBack(body: request.dictionary) { (model, error) in
                if model != nil{
//                    self.showSCLAlertWithTwoButton("feedback sented successfully.", isCancel: false, cancelbuttonText: nil) { (success, failure) in
//                        if success{
//                             self.delegate.backButtonTapped(view: self)
//                        }
//                    }
                    self.showAlertWithHandler("feedback sented successfully.") { (success, error) in
                        if success{
                            self.delegate.backButtonTapped(view: self)
                        }
                    }
                }else{
                    self.showAlertWithHandler(error!) { (success, error) in
                        if success{
                            self.delegate.backButtonTapped(view: self)
                        }
                    }
                }
            }
        }
    }
}

extension FeedBackViewController{
    @objc func keyboardShow(notification:Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            _ = keyboardRectangle.height
            self.centerConstraint.constant = -50 //keyboardHeight - 50
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutSubviews()
        }
    }
    
    @objc func keyboardHide(notification:Notification){
        self.centerConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutSubviews()
        }
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
        if let _mob = feedbackTextView{
            if !((_mob.text?.isEmpty)!){
                sendButtonTapped(sendButton)
            }
        }
    }
}
