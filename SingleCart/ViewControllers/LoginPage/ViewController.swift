//
//  ViewController.swift
//  SingleCart
//
//  Created by apple on 04/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK:- Variables and Outlets
    var isFromHome = false
    @IBOutlet weak var loginButton: LoadingButton!
    @IBOutlet weak var loginTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mobileNumberTextField: UITextField!{
        didSet{
            guard let field = self.mobileNumberTextField  else { return }
            field.placeholder = "Phone"
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            guard let field = self.passwordTextField  else { return }
            field.placeholder = "Password"
        }
    }
    
    var message = ""
    @IBOutlet weak var labelPassword: UILabel!
    var isChecked: Bool = false
    var check : Bool = true
    var loginRequestModel : LoginRequestModel? = nil
    var isValid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paddingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: mobileNumberTextField.frame.height))
        paddingLabel.text = " +971 "
        self.mobileNumberTextField.leftView = paddingLabel
        self.mobileNumberTextField.leftViewMode = .always
        self.passwordTextField.withImage(direction: .Left, image: UIImage(named: "key.png")!, colorSeparator: UIColor.orange)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.set(true, forKey: FIRSTTIME)
        loginButton!.setCornerRadius(radius: 10.0, isBg_Color: false, bg_Color: nil, isBorder: true, borderColor: UIColor.lightGray, borderWidth: 0.3)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        let _tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(_tap)
        let _labelTouch : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveToForgotPassword))
        self.labelPassword.addGestureRecognizer(_labelTouch)
        self.labelPassword.isUserInteractionEnabled = true
        if isFromHome{
            (UIApplication.shared.delegate as! AppDelegate).loginPage()
        }
        self.passwordTextField.text = ""
        self.mobileNumberTextField.text = ""
        
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: USERAVAILABLE)
        UserDefaults.standard.set(0, forKey: USERID)
        self.moveToHomePage()
    }
}

//MARK:- Button Actions
extension ViewController{
    func moveToSignUp(){
        DispatchQueue.main.async{
            if #available(iOS 13.0, *) {
                SignUP.modalPresentationStyle = .fullScreen
                self.present(SignUP, animated: false)
            }else{
                self.present(SignUP, animated: false, completion: nil)
            }
        }
    }
    
    func moveToHomePage(){
        DispatchQueue.main.async {
            MAINTABBARPAGE.setUPViewController()
            MAINTABBARPAGE.selectedIndex = 0
            if #available(iOS 13.0, *) {
                MAINTABBARPAGE.modalPresentationStyle = .fullScreen
                self.present(MAINTABBARPAGE, animated: false)
            }else{
                self.present(MAINTABBARPAGE, animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        self.moveToSignUp()
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        self.loginButton.showLoading()
        if self.checkAllFields(){
            
            self.loginRequestModel = LoginRequestModel(_deviceType: "", _password: self.passwordTextField.text!, _username: self.mobileNumberTextField.text!)
            Webservice.shared.login(body: self.loginRequestModel!.dictionary) { (model, message) in
                self.isChecked = false
                self.isValid = true
                if model != nil{
                    UserDefaults.standard.set(model?.UserID!, forKey: USERID)
                    UserDefaults.standard.set(model?.SessionKey!, forKey: AUTHTOKEN)
                    UserDefaults.standard.set(true, forKey: USERAVAILABLE)
                    self.moveToHomePage()
                    self.loginButton.hideLoading()
                }else{
                    self.showSCLAlert(_message:message!)
                    self.loginButton.hideLoading()
                }
            }
        }else{
            self.loginButton.hideLoading()
            self.showSCLAlert(_message:message)
        }
    }
    
    @objc func moveToForgotPassword(){
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                forgot.modalPresentationStyle = .fullScreen
                self.present(forgot, animated: false)
            }else{
                self.present(forgot, animated: false, completion: nil)
            }
        }
    }
}

//MARK:- Notifications

extension ViewController {
    @objc func keyboardShow(notification:Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            _ = keyboardRectangle.height
            self.loginTopConstraint.constant = -50 //keyboardHeight - 50
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutSubviews()
        }
    }
    
    @objc func keyboardHide(notification:Notification){
        self.loginTopConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutSubviews()
        }
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
        if let _mob = mobileNumberTextField, let _pass = passwordTextField{
            if !((_mob.text?.isEmpty)!) && !((passwordTextField.text?.isEmpty)!){
                loginButtonAction(loginButton)
            }
        }
    }
}

extension ViewController : UITextFieldDelegate{
    func checkAllFields() -> Bool{
        if let _mob = self.mobileNumberTextField, let _pass = self.passwordTextField{
            if !((_mob.text?.isEmpty)!) && !((self.passwordTextField.text?.isEmpty)!){
                if (_mob.text?.count)! == 9{
                    self.check =  true
                    self.isChecked =  true
                }else if (_pass.text?.count)! >= 6{
                    self.check = false
                    self.isChecked =  false
                    self.message = "Login password is invalid."
                }else{
                    self.check = false
                    self.isChecked =  false
                    self.message = "Entered phone number is invalid."
                }
            }else{
                self.check = false
                self.isChecked =  false
                self.message = "Login credential needed"
            }
            return check
        }else{
            self.isChecked =  false
            self.message = "Login credential needed"
            return check
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = (textField.text)
        if (text?.utf16.count)! >= 1{
            switch textField.tag{
            case 0:
                passwordTextField.becomeFirstResponder()
            case 1:
                passwordTextField.resignFirstResponder()
                checkAllFields()
            default:
                break
            }
        }else{
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1{
            textField.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0{
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 9
        }else{
            return true
        }
    }
}
