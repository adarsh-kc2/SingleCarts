//
//  UIActivityIndicator + Extension.swift
//  SingleCart
//
//  Created by PromptTech on 04/08/20.
//  Copyright © 2020 apple. All rights reserved.
//




import Foundation
import UIKit
extension UIViewController{
    func showActivityIndicator(_message:String?) -> UIView {
        
        let container: UIView = UIView()
        let loadingView: UIView = UIView()
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        container.frame = self.view.frame
        container.center =  CGPoint(x:self.view.frame.size.width / 2 , y: self.view.frame.size.height / 2 - self.view.frame.size.height / 10) //- (self.view.center / 2)
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 150, height: 80)//(0, 0, 80, 80)
        loadingView.center = self.view.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 70)//(0.0, 0.0, 40.0, 40.0);
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2.5)//(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2);
        if let _ = _message{
            let messageLabel:UILabel = UILabel()
            messageLabel.frame = CGRect(x: 0, y:activityIndicator.frame.size.height - 10, width: activityIndicator.frame.size.width+10, height: 20)
            
            
            messageLabel.text = _message
            messageLabel.textAlignment = .center
            messageLabel.textColor = UIColor.white
            messageLabel.font = UIFont.systemFont(ofSize: 12)
            activityIndicator.addSubview(messageLabel)
        }
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        self.view.addSubview(container)
        activityIndicator.startAnimating()
        return container
    }
    
    /*
     Hide activity indicator
     Actually remove activity indicator from its super view
     
     @param uiView - remove activity indicator from this view
     */
    func hideActivityIndicator(uiView: UIView) {
        //        activityIndicator.stopAnimating()
        DispatchQueue.main.sync {
            uiView.removeFromSuperview()
        }

    }
    
    func showActivityIndicatorWithout(_message:String?) -> UIView {
           
           let container: UIView = UIView()
           let loadingView: UIView = UIView()
           let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
           container.frame = self.view.frame
           container.center =  CGPoint(x:self.view.frame.size.width / 2 , y: self.view.frame.size.height / 2 - self.view.frame.size.height / 10) //- (self.view.center / 2)
           container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
           
           loadingView.frame = CGRect(x: 0, y: 0, width: 150, height: 80)//(0, 0, 80, 80)
           loadingView.center = self.view.center
           loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
           loadingView.clipsToBounds = true
           loadingView.layer.cornerRadius = 10
           
           activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 70)//(0.0, 0.0, 40.0, 40.0);
           activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
           activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2.5)//(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2);
           if let _ = _message{
               let messageLabel:UILabel = UILabel()
               messageLabel.frame = CGRect(x: 0, y:activityIndicator.frame.size.height - 10, width: activityIndicator.frame.size.width+10, height: 20)
               
               
               messageLabel.text = _message
               messageLabel.textAlignment = .center
               messageLabel.textColor = UIColor.white
               messageLabel.font = UIFont.systemFont(ofSize: 12)
               activityIndicator.addSubview(messageLabel)
           }
           loadingView.addSubview(activityIndicator)
           container.addSubview(loadingView)
           self.view.addSubview(container)
           activityIndicator.startAnimating()
           return container
       }
    
    func hideActivityIndicatorWithout(uiView: UIView) {
            uiView.removeFromSuperview()
    }
    
    /*
     Define UIColor from hex value
     
     @param rgbValue - hex color value
     @param alpha - transparency level
     */
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}

