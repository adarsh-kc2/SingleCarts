//
//  ForgotPasswordChangeViewController.swift
//  SingleCart
//
//  Created by PromptTech on 07/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ForgotPasswordChangeViewController: UIViewController {
    @IBOutlet weak var verificationTextField : UITextField!
    @IBOutlet weak var newPassTextField : UITextField!
    @IBOutlet weak var confirmPassTextField : UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var verifyView: UIView!
    @IBOutlet weak var centerConstraint : NSLayoutConstraint!
    var upload_Dictionary  : Dictionary<String,String>?
    var isChecked = false
    var activityView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.submitButton.setCornerRadiusWithoutBackground(radius: self.submitButton.frame.height / 2)
        self.verifyView.setCornerRadius(radius: 10.0, isShadow: false, isBorderColor: true, borderColor: .lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.5, shadowOpacity: nil, shadowColor: nil, shadowOffset: nil)
        self.backButton.setCornerRadiusWithoutBackground(radius: self.backButton.frame.height / 2)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        let _tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(_tap)
        self.confirmPassTextField.text = ""
        self.newPassTextField.text = ""
        self.verificationTextField.text = ""
    }
    
    @IBAction func backButtonTapped(sender : UIButton){
        self.dismiss(animated: false, completion: nil)
        
    }
    
    @IBAction func submitButtonTapped(sender : UIButton){
        if isChecked{
            activityView = self.showActivityIndicator(_message: "Processing")
            upload_Dictionary!["ResetToken"] = verificationTextField.text!
            upload_Dictionary!["NewPassword"] = newPassTextField.text!
            Webservice.shared.forgotPasswordVerification(body: upload_Dictionary!) { (model, message) in
                self.hideActivityIndicator(uiView: self.activityView)
                if model != nil{
                    self.moveToLoginPage()
                }else{
                    self.showSCLAlert(_message:message!)
                }
            }
        }else{
            self.checkFields()
        }
    }
    
    func moveToLoginPage(){
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                 Login.modalPresentationStyle = .overCurrentContext
                 self.present(Login, animated: false)
             }else{
                 self.present(Login, animated: false, completion: nil)
             }
        }
    }
}

extension ForgotPasswordChangeViewController : UITextFieldDelegate{
    func checkFields(){
        isChecked =  true
        if let _ver = verificationTextField , let _new = newPassTextField , let _con = confirmPassTextField{
            if !((_ver.text?.isEmpty)!) && !((_con.text?.isEmpty)!) &&  !((_new.text?.isEmpty)!){
                if (_con.text)! ==  (_new.text)!{
                    submitButtonTapped(sender: submitButton)
                }else{
                    self.showSCLAlert(_message:"Password Mismatch")
                }
                //send verification code
                
            }else{
                self.showSCLAlert(_message:"Fill all the fields")
                isChecked = false
            }
            
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if (text?.utf16.count)! >= 1{
            switch textField.tag{
            case 0:
                newPassTextField.becomeFirstResponder()
            case 1:
                confirmPassTextField.becomeFirstResponder()
            case 2:
                confirmPassTextField.resignFirstResponder()
                checkFields()
            default:
                break
            }
        }else{
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 2{
           textField.text = ""
        }
        
    }
    
}
extension ForgotPasswordChangeViewController {
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
        if let _ver = verificationTextField,let _new = newPassTextField,let _con = confirmPassTextField{
            if !((_ver.text?.isEmpty)!) && !((_new.text?.isEmpty)!) && !((_con.text?.isEmpty)!){
            }
        }
    }
}
