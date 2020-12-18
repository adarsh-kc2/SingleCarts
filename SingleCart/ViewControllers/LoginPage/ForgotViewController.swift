//
//  ForgotViewController.swift
//  SingleCart
//
//  Created by apple on 09/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ForgotViewController: UIViewController {

    @IBOutlet weak var sendButton: LoadingButton!
    @IBOutlet weak var forgotCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var mobileTextField: UITextField!{
        didSet{
            guard let field = self.mobileTextField  else { return }
            field.placeholder = "Email or Phone"
        }
    }
    var isChecked = false
    var dictionary : Dictionary<String,String> = Dictionary<String,String>()
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mobileTextField.withImage(direction: .Left, image: UIImage(named: "email.png")!, colorSeparator: UIColor.orange)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func sendButtonTapped(sender : LoadingButton){
        if isChecked {
            self.sendButton.showLoading()
            dictionary["EmailOrMobile"] = self.mobileTextField.text!
            Webservice.shared.forgotPassword(body: self.dictionary) { (model, errorMessage) in
                self.sendButton.hideLoading()
                if model != nil{
                    self.moveToVerificationPage()
                }else{
                    self.showSCLAlert(_message:errorMessage!)
                }
            }
        }else{
            self.checkAllFields()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.sendButton.setCornerRadius(radius: 10.0, isBg_Color: false, bg_Color: nil, isBorder: true, borderColor: UIColor.lightGray, borderWidth: 0.5)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        let _tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(_tap)
    }
    
    func moveToVerificationPage(){
        DispatchQueue.main.async {
            forgotChange.upload_Dictionary = self.dictionary
            if #available(iOS 13.0, *) {
                forgotChange.modalPresentationStyle = .popover
                self.present(forgotChange, animated: false)
            }else{
                self.present(forgotChange, animated: false, completion: nil)
            }
        }
    }
}

extension ForgotViewController {
    @objc func keyboardShow(notification:Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            _ = keyboardRectangle.height
            self.forgotCenterConstraint.constant = -50 //keyboardHeight - 50
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutSubviews()
        }
    }
    
    @objc func keyboardHide(notification:Notification){
        self.forgotCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutSubviews()
        }
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
        if let _mob = mobileTextField{
            if !((_mob.text?.isEmpty)!){
            }
        }
    }
}

extension ForgotViewController : UITextFieldDelegate{
    
    func checkAllFields(){
        isChecked =  true
        if let _mob = mobileTextField{
            if !((_mob.text?.isEmpty)!){
                //send verification code
                sendButtonTapped(sender: sendButton)
            }else{
                self.showSCLAlert(_message:"Login credential missing")
                isChecked = false
            }
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if (text?.utf16.count)! >= 1{
            switch textField.tag{
            case 0:
                checkAllFields()
            default:
                break
            }
        }else{
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.text = ""
    }
}
