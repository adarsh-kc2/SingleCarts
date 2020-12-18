//
//  UIAlerts + Extensions.swift
//  SingleCart
//
//  Created by apple on 07/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

extension UIAlertController{
    
    func simpAlertWith_TwoButtons(title :String , message: String ,okButtonText : String , cancelbuttonText : String,preferredStyle :UIAlertController.Style){
        let currentTopVC: UIViewController? =  ((UIApplication.shared.delegate) as! AppDelegate).currentTopViewController()
        let alert = UIAlertController(title: title, message:message, preferredStyle:preferredStyle)
        alert.addAction(UIAlertAction(title: okButtonText ,style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: cancelbuttonText, style: .cancel, handler: nil))
        if #available(iOS 13, *){
            alert.modalPresentationStyle = .overCurrentContext
            self.parent!.present(alert, animated: true, completion: nil)
        }else{
            currentTopVC!.present(alert, animated: true, completion: nil)
        }
    }
    
    func simpAler(title :String , message: String ,isOkButton: Bool,isCancelButton: Bool,okButtonText : String? , cancelbuttonText : String?,preferredStyle :UIAlertController.Style){
        DispatchQueue.main.async {
            let currentTopVC: UIViewController? =  ((UIApplication.shared.delegate) as! AppDelegate).currentTopViewController()
            var _alert = self
            _alert = UIAlertController(title: title, message:message, preferredStyle:preferredStyle)
            
            if isOkButton{
                _alert.addAction(UIAlertAction(title: okButtonText ,style: .default, handler: nil))
            }
            if isCancelButton{
                _alert.addAction(UIAlertAction(title: cancelbuttonText, style: .cancel, handler: nil))
            }
            DispatchQueue.main.async(execute: {
                if #available(iOS 13, *){
                    _alert.modalPresentationStyle = .overCurrentContext
                    self.parent!.present(_alert, animated: true, completion: nil)
                }else{
                    currentTopVC!.present(_alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    func simpAlert(title :String , message: String ,isOkButton: Bool,isCancelButton: Bool,okButtonText : String? , cancelbuttonText : String?,preferredStyle :UIAlertController.Style,completionBlock : @escaping(Bool,Bool) -> ()){
        DispatchQueue.main.async {
            let currentTopVC: UIViewController? =  ((UIApplication.shared.delegate) as! AppDelegate).currentTopViewController()
            let alert = UIAlertController(title: title, message:message, preferredStyle:preferredStyle)
            if isOkButton{
                alert.addAction(UIAlertAction(title: okButtonText, style: .default, handler: { (action) in
                    completionBlock(true,false)
                }))
            }
            if isCancelButton{
                alert.addAction(UIAlertAction(title: cancelbuttonText, style: .cancel, handler: { (action) in
                    completionBlock(false,true)
                }))
            }
            if #available(iOS 13, *){
                alert.modalPresentationStyle = .overCurrentContext
                self.parent!.present(alert, animated: true, completion: nil)
            }else{
                currentTopVC!.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension SCLAlertView{
    func showAlertInfo(_message : String){
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: true,
            showCircularIcon: true
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showSuccess(APPLICATION_NAME, subTitle: _message, closeButtonTitle: OK_TEXT, timeout: nil, colorStyle: UInt(HOME_NAVIGATION_BGCOLOR.rgb()!), colorTextButton: UInt(White.rgb()!), circleIconImage: UIImage(named: logo), animationStyle: .noAnimation)
    }
    
    func alertWithTwoButtons( message: String ,isOkButton: Bool,isCancelButton: Bool,okButtonText : String? , cancelbuttonText : String?,completionBlock : @escaping(Bool,Bool) -> ()){
//        let appearance = SCLAlertView.SCLAppearance(
//            showCloseButton: false,
//            showCircularIcon: true
//        )
//        let alertView = SCLAlertView(appearance: appearance)
        if isOkButton{
            self.addButton(OK_TEXT) {
               completionBlock(true,false)
            }
        }
        if isCancelButton{
            self.addButton(cancelbuttonText!) {
               completionBlock(false,true)
            }
        }
        
        self.showSuccess(APPLICATION_NAME, subTitle: message)
//        self.showSuccess(APPLICATION_NAME, subTitle: message, closeButtonTitle: OK_TEXT, timeout: nil, colorStyle: UInt(HOME_NAVIGATION_BGCOLOR.rgb()!), colorTextButton: UInt(White.rgb()!), circleIconImage: UIImage(named: logo), animationStyle: .noAnimation)
        
    }
    
    
}
extension UIColor {

    func rgb() -> Int? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)

            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}
