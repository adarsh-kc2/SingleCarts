//
//  SignUPOTPViewController.swift
//  SingleCart
//
//  Created by PromptTech on 06/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SignUPOTPViewController: UIViewController {
    @IBOutlet weak var centerConstraint : NSLayoutConstraint!
    @IBOutlet weak var otpTextField: UITextField!{
        didSet{
            guard let field = self.otpTextField  else { return }
            field.placeholder = "Verification Code"
        }
    }
    @IBOutlet weak var otpLabel: UILabel!{
        didSet{
            guard let field = self.otpLabel  else { return }
            field.text = "Please type the verification  code send to +91 9544359699"
        }
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var resendButton: LoadingButton!
    @IBOutlet weak var verifyButton: LoadingButton!
    var message = ""
    var timer : Timer? = nil
    var timerCount = 120
    var uploadDictionary : Dictionary<String,String>? = nil
    var signUpModel : SignUpModel? = nil
    var activityView : UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = uploadDictionary{
            otpLabel.text = "Please type the verification  code send to \((uploadDictionary!["Phone"])!)"
        }else{
            otpLabel.text = "Please type the verification  code send to your phone"
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        let _tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(_tap)
        activityView = UIView()
        self.timerView.setCornerRadius(radius: self.timerView.frame.height / 2, isShadow: false, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.3, shadowOpacity: nil, shadowColor: nil, shadowOffset: nil)
        self.resendButton.setCornerRadiusWithoutBackground(radius: 10.0)
        self.verifyButton.setCornerRadiusWithoutBackground(radius: 10.0)
        resendButton.isEnabled = false
        timer = Timer()
        timerCount = 120
        startTimer()
    }
    
    @IBAction func verifyButtonTapped(_ sender: Any) {
        if checkOtp(){
            self.signUpModel = SignUpModel(_deviceType: "", _password: uploadDictionary!["Password"]!, _mobile: uploadDictionary!["Phone"]!, _email: uploadDictionary!["Email"]!, _name: uploadDictionary!["Name"]!, _verification: self.otpTextField.text!)
            self.activityView = self.showActivityIndicator(_message: "Please wait...")
            self.verifyButton.showLoading()
            Webservice.shared.signUp(body: (self.signUpModel?.dictionary)!) { (model, error) in
                self.hideActivityIndicator(uiView: self.activityView!)
                self.verifyButton.hideLoading()
                if model != nil{
                    UserDefaults.standard.set(model?.UserID!, forKey: USERID)
                    UserDefaults.standard.set(model?.SessionKey!, forKey: AUTHTOKEN)
                    self.moveToHomePage()
                }else{
                    self.showSCLAlert(_message:error!)
                }
            }
        }else{
            self.showSCLAlert(_message:message)
        }
    }
    
    @IBAction func resendButtonTapped(_ sender: Any) {
        var signUpCheck = Dictionary<String,Any>()
        signUpCheck["Phone"] = uploadDictionary!["Phone"]!
        signUpCheck["Email"] = uploadDictionary!["Email"]!
        signUpCheck["Type"] = 2
        self.resendButton.showLoading()
        Webservice.shared.checkDuplicates(body: signUpCheck) { (model, errorMessage) in
            self.resendButton.hideLoading()
            if model != nil{
                UserDefaults.standard.set(model?.messageID!, forKey: "MessageId")
                self.showSCLAlert(_message: "OTP sent successfully")
            }else{
                self.showSCLAlert(_message:errorMessage!)
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func checkOtp() -> Bool{
        if otpTextField.text!.isEmpty{
            message = "otp field is empty.Please enter the otp verification code"
            return false
//        }else if otpTextField.text! == DEFAULT_OTP {
//            return true
//        }else{
//            message = "Otp that you have entered is invalid."
//            return false
        }else{
            return true
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        DispatchQueue.main.async {
            if self.timerCount != 0{
                self.timerCount -= 1
                self.timerLabel.text = "\(self.timerCount)"
                self.timerView.isOpaque = true
            }else{
                self.timer?.invalidate()
                self.timerCount = 120
                self.timerLabel.text = "\(self.timerCount)"
                self.resendButton.isEnabled = true
                self.timerView.isOpaque = false
            }
        }

    }
    
    func moveToHomePage(){
        DispatchQueue.main.async {
            UserDefaults.standard.set(true, forKey: USERAVAILABLE)
//            (UIApplication.shared.delegate as! AppDelegate).dismissViewControllers()
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
}


extension SignUPOTPViewController{
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
        if let _mob = otpTextField{
            if !((_mob.text?.isEmpty)!){
                verifyButtonTapped(verifyButton)
            }
        }
    }
    
}
