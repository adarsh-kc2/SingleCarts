//
//  ChangePasswordViewController.swift
//  SingleCart
//
//  Created by PromptTech on 08/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    var delegate : ChangeViewControllerDelegate!
    var isChecked = false
    var request : ChangePasswordRequestModel? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        oldPasswordTextField.text = ""
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
        saveButton!.setCornerRadius(radius: 10.0, isBg_Color: false, bg_Color: nil, isBorder: true, borderColor: UIColor.lightGray, borderWidth: 0.3)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        let _tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(_tap)
    }
    
    @IBAction func backButtonTapped(sender : UIButton?){
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender : UIButton?){
        var activityView = UIView()
        if checkAllFields(){
            if newPasswordTextField.text! == confirmPasswordTextField.text!{
                activityView = self.showActivityIndicator(_message: "Please wait..")
                request = ChangePasswordRequestModel(_old: oldPasswordTextField.text!, _new: newPasswordTextField.text!)
                Webservice.shared.changePassword(body: (request?.dictionary)!) { (model, errorMessage) in
                    self.hideActivityIndicator(uiView: activityView)
                    if model != nil{
                        self.showAlertWithHandler("Password updated.") { (success, failure) in
                            if success{
                                self.delegate.backButtonTapped(view: self)
                            }
                        }
                    }else{
                        self.showSCLAlert(_message:errorMessage!)
                    }
                }
            }else{
                self.showSCLAlert(_message:"Password  mismatch.!")
            }
        }else{
            self.checkAllFields()
        }
    }
}

extension ChangePasswordViewController {
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
        if let _old = oldPasswordTextField, let _new = newPasswordTextField , let _con = confirmPasswordTextField{
            if !((_old.text?.isEmpty)!) && !((_new.text?.isEmpty)!) && !((_con.text?.isEmpty)!){
                saveButtonTapped(sender: saveButton)
            }
        }
    }
}

extension ChangePasswordViewController : UITextFieldDelegate{
    func checkAllFields() -> Bool{
        isChecked =  true
        if let _old = oldPasswordTextField, let _new = newPasswordTextField , let _con = confirmPasswordTextField{
            if !((_old.text?.isEmpty)!) && !((_new.text?.isEmpty)!) && !((_con.text?.isEmpty)!){
                isChecked = true
            }else{
               isChecked = false
            }
        }else{
            isChecked = false
        }
        return isChecked
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if (text?.utf16.count)! >= 1{
            switch textField.tag{
            case 0:
                newPasswordTextField.becomeFirstResponder()
            case 1:
                confirmPasswordTextField.becomeFirstResponder()
            case 2:
                confirmPasswordTextField.resignFirstResponder()
                checkAllFields()
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
