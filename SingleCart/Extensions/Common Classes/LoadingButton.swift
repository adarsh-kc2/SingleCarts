//
//  LoadingButton.swift
//  SingleCart
//
//  Created by apple on 05/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

class LoadingButton: UIButton {
    
    var originalButtonText : String = ""
    var activityIndicator  : UIActivityIndicatorView = UIActivityIndicatorView()
    var xCenterConstraint  : NSLayoutConstraint! = nil
    var yCenterConstraint  : NSLayoutConstraint! = nil
    
//    override init(frame: CGRect) {
//        super.init(frame: .zero)
//        self.layer.cornerRadius = 10.0
//        self.layer.masksToBounds = true
//        self.layer.borderWidth = 0.3
//        self.layer.borderColor = UIColor.black.cgColor
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    func showLoading(beginIgnoringInteractionEvents : Bool) -> Void {
        if(beginIgnoringInteractionEvents){
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        originalButtonText = (titleLabel?.text)!
        setTitle("", for: UIControl.State.normal)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = self.titleColor(for: UIControl.State.normal)
        showSpinning()
    }
    func showLoading() -> Void {
        showLoading(beginIgnoringInteractionEvents : true)
    }
    func hideLoading(with string: String? = nil) -> Void {
        DispatchQueue.main.async {
            UIApplication.shared.endIgnoringInteractionEvents()
            if let string = string {
                self.setTitle(string, for: UIControl.State.normal)
            }
            else {
                self.setTitle(self.originalButtonText, for: UIControl.State.normal)
                
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
    
    private func showSpinning() -> Void {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() -> Void {
        xCenterConstraint = NSLayoutConstraint.init(item: self, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        //DispatchQueue.main.async {
        self.addConstraint(self.xCenterConstraint);
        //}
        yCenterConstraint = NSLayoutConstraint.init(item: self, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        
        //DispatchQueue.main.async {
        self.addConstraint(self.yCenterConstraint);
        //}
    }
    
}
