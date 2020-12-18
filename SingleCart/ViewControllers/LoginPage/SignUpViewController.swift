//
//  SignUpViewController.swift
//  SingleCart
//
//  Created by apple on 06/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    //MARK:- VARIABLES AND OUTLETS
    // to store the current active textfield
    @IBOutlet weak var terms: UILabel!
    var activeTextField : UITextField? = nil
    @IBOutlet weak var agreeButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!{
        didSet{
            guard let field = self.nameTextField  else { return }
            field.placeholder = "Name *"
        }
    }
    @IBOutlet weak var phoneTextField: UITextField!{
        didSet{
            guard let field = self.phoneTextField  else { return }
            field.placeholder = "Phone *"
        }
    }
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            guard let field = self.emailTextField  else { return }
            field.placeholder = "Email *"
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            guard let field = self.passwordTextField  else { return }
            field.placeholder = "Password *"
        }
    }
    @IBOutlet weak var c_PasswordTextField: UITextField!{
        didSet{
            guard let field = self.c_PasswordTextField  else { return }
            field.placeholder = "Confirm Password *"
        }
    }
    
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    var constraintConstant = 0.0
    var isChecked : Bool = false
    @IBOutlet weak var signUPButton: LoadingButton!
    var signUpDictionary : Dictionary<String,String> = Dictionary<String,String>()
    var signUpCheck : Dictionary<String,Any> = Dictionary<String,Any>()
    var isAgreed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paddingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 45, height: phoneTextField.frame.height))
        paddingLabel.text = " +971 "
        self.phoneTextField.leftView = paddingLabel
        self.phoneTextField.leftViewMode = .always
        
        self.nameTextField.withImage(direction: .Left, image: UIImage(named: "face.png")!, colorSeparator: UIColor.orange)
        self.emailTextField.withImage(direction: .Left, image: UIImage(named: "email.png")!, colorSeparator: UIColor.orange)
        self.passwordTextField.withImage(direction: .Left, image: UIImage(named: "key.png")!, colorSeparator: UIColor.orange)
        self.c_PasswordTextField.withImage(direction: .Left, image: UIImage(named: "key.png")!, colorSeparator: UIColor.orange)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let attributedString = NSMutableAttributedString(string: "I agree terms and conditions.")
        attributedString.addAttribute(.link, value: TERMS, range: NSRange(location: 8, length: 20))
        let tap1 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(open))
        self.terms.addGestureRecognizer(tap1)
//        attributedString.addAttrib
        self.terms.isUserInteractionEnabled = true
        
        self.terms.attributedText = attributedString
        if isAgreed {
            self.signUPButton.isEnabled = true
            self.signUPButton.backgroundColor = HOME_NAVIGATION_BGCOLOR
            self.agreeButton.setImage(UIImage(named:"rect_select.png"), for: .normal)
        }else{
            self.signUPButton.isEnabled = false
            self.signUPButton.backgroundColor = .lightGray
            self.agreeButton.setImage(UIImage(named:"rect_unSelect.png"), for: .normal)
        }
        signUPButton!.setCornerRadius(radius: 10.0, isBg_Color: false, bg_Color: nil, isBorder: true, borderColor: UIColor.lightGray, borderWidth: 0.3)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        let _tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(_tap)
    }
    
    @objc func open(){
        urlpage.loadingURL = TERMS
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                urlpage.modalPresentationStyle = .fullScreen
                self.present(urlpage, animated: false)
            }else{
                self.present(urlpage, animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func agreeButtonTapped(_ sender: UIButton) {
        if agreeButton.currentImage == UIImage(named:"rect_unSelect.png"){
            self.isAgreed = true
            self.signUPButton.isEnabled = true
            self.signUPButton.backgroundColor = HOME_NAVIGATION_BGCOLOR
            self.agreeButton.setImage(UIImage(named:"rect_select.png"), for: .normal)
        }else{
            self.isAgreed = false
            self.signUPButton.isEnabled = false
            self.signUPButton.backgroundColor = UIColor.lightGray
            self.agreeButton.setImage(UIImage(named:"rect_unSelect.png"), for: .normal)
        }
        
    }
}

//MARK:- BUTTON Actions

extension SignUpViewController{
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        if isChecked{
            self.isChecked = false
            signUPButton.showLoading()
            Webservice.shared.checkDuplicates(body: signUpCheck) { (model, errorMessage) in
                self.signUPButton.hideLoading()
                if model != nil{
                    UserDefaults.standard.set(model?.messageID!, forKey: "MessageId")
                    self.moveToOtpPage()
                }else{
                    self.showSCLAlert(_message:errorMessage!)
                }
            }
        }else{
            checkAllFields()
        }
    }
    
    //backButton tapped
    @IBAction func buttonAlreadyTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func moveToOtpPage(){
        DispatchQueue.main.async {
            signUpOtp.uploadDictionary = self.signUpDictionary
            if #available(iOS 13.0, *) {
                signUpOtp.modalPresentationStyle = .fullScreen
                self.present(signUpOtp, animated: false)
            }else{
                self.present(signUpOtp, animated: false, completion: nil)
            }
        }
    }
    
}
//MARK:- Notification Actions

extension SignUpViewController{
    @objc func keyboardShow(notification:Notification){
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        var shouldMoveViewUp = false
        // if active text field is not nil
        if let activeTextField = activeTextField {
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            if bottomOfTextField > topOfKeyboard {
                shouldMoveViewUp = true
            }
        }
        if(shouldMoveViewUp) {
            self.view.frame.origin.y = CGFloat(0 - constraintConstant)
        }
    }
    
    @objc func keyboardHide(notification:Notification){
        self.view.frame.origin.y = 0
    }
    
    @objc func dismissKeyboard(){
        self.constraintConstant = 0
        view.endEditing(true)
        if isChecked{
            self.isChecked = false
        }else{
            checkAllFields()
        }
    }
}
//MARK:- textField Delegates Actions

extension SignUpViewController : UITextFieldDelegate{
    func checkAllFields(){
        if let _name = nameTextField, let _phone = phoneTextField, let _email = emailTextField, let _pass = passwordTextField, let _cPass = c_PasswordTextField{
            if !((_name.text?.isEmpty)!) && !((_phone.text?.isEmpty)!) && !((_email.text?.isEmpty)!) && !((_pass.text?.isEmpty)!) && !((_cPass.text?.isEmpty)!){
                
                if _pass.text!.count < 6{
                    self.showSCLAlert(_message:"Password should contain minimum 6 letters")
                }else if (_phone.text!.count < 9 || _phone.text!.count > 9 ) {
                    self.showSCLAlert(_message:"Phone number is invalid")
                }else if !(isValidEmailAddress(emailAddressString: _email.text!)){
                    self.showSCLAlert(_message:"Invalid email address")
                }else{
                    if _pass.text! == _cPass.text! {
                        isChecked =  true
                        signUpCheck["Phone"] = _phone.text!
                        signUpCheck["Email"] = _email.text!
                        signUpCheck["Type"] = 2
                        signUpDictionary["Name"] = _name.text!
                        signUpDictionary["Phone"] = _phone.text!
                        signUpDictionary["Email"] = _email.text!
                        signUpDictionary["Password"] = _pass.text!
                        signUpDictionary["ConfirmPassword"] = _cPass.text!
                        if agreeButton.currentImage == UIImage(named:"rect_select.png"){
                            signUpButtonTapped(signUPButton)
                        }else{
                            self.showSCLAlert(_message:"Please agree the terms and conditions")
                        }
                    }else{
                        self.showSCLAlert(_message:"Password Mismatch")
                    }
                }
            }else{
                self.showSCLAlert(_message:"Fill all the fields")
            }
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if (text?.utf16.count)! >= 1{
            if textField.tag == 0{
                (textField.text!).capitalized(with: .current)
            } //.capitalizedStringWithLocale(NSLocale.currentLocale)
            switch textField.tag{
            case 0:
                self.constraintConstant = -50
                phoneTextField.becomeFirstResponder()
            case 1:
                self.constraintConstant = -50
                emailTextField.becomeFirstResponder()
            case 2:
                self.constraintConstant = -70
                if !(isValidEmailAddress(emailAddressString: textField.text!)){
                    self.showSCLAlert(_message: "Invalid email address")
                }
                isValidEmailAddress(emailAddressString: textField.text!) ? passwordTextField.becomeFirstResponder() : emailTextField.becomeFirstResponder()
            case 3:
                self.constraintConstant = -75
                c_PasswordTextField.becomeFirstResponder()
            case 4:
                c_PasswordTextField.resignFirstResponder()
                checkAllFields()
            default:
                break
            }
        }else{
        }
        setViewLayout()
    }
    
    func setViewLayout(){
        self.centerConstraint.constant = CGFloat(self.constraintConstant)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 3{
            if UIDevice.current.modelName == "iPhone SE" || UIDevice.current.modelName == "Simulator" {
                self.constraintConstant = 100
            }else{
                self.constraintConstant = 70
            }
        }else if textField.tag == 4{
            self.constraintConstant = 100
        }
        self.activeTextField = textField
        self.view.layoutIfNeeded()
        if textField.tag == 4{
            textField.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 1{
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 9
//        }else if textField.tag == 3{
//            let currentText = textField.text ?? ""
//            guard let stringRange = Range(range, in: currentText) else { return false }
//            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//            return updatedText.count <= 8
//        }else if textField.tag == 3{
//            let currentText = textField.text ?? ""
//            guard let stringRange = Range(range, in: currentText) else { return false }
//            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//            return updatedText.count <= 6
        }else{
            return true
        }
        // get the current text, or use an empty string if that failed
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
}
