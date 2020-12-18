//
//  UIViewController + Extension.swift
//  SingleCart
//
//  Created by apple on 07/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

extension UIViewController{
    
    func showSCLAlert(_message : String) {
        DispatchQueue.main.async {
            let sclView = SCLAlertView()
            sclView.showAlertInfo(_message: _message)
        }

    }
    
    func showSCLAlertWithTwoButton(_ message : String,isCancel: Bool,cancelbuttonText :String? ,completionBlock : @escaping(Bool,Bool) -> ()){
                DispatchQueue.main.async {
            let sclView = SCLAlertView()
                    sclView.alertWithTwoButtons(message: message, isOkButton: true, isCancelButton: isCancel, okButtonText: OK_TEXT, cancelbuttonText: cancelbuttonText) { (success, failure) in
                        completionBlock(success,failure)
                    }
        }
    }
    
    
    func showAlert(_ message : String){
        DispatchQueue.main.async {
            let alertController = UIAlertController()
            if #available(iOS 13, *){
                self.addChild(alertController)
            }
            alertController.simpAler(title: APPLICATION_NAME, message: message, isOkButton: true, isCancelButton: false, okButtonText: OK_TEXT, cancelbuttonText: nil, preferredStyle: .alert)
        }
        
    }
    
    
    
    func showAlertWithHandler(_ message : String ,completionBlock : @escaping(Bool,Bool) -> ()){
        DispatchQueue.main.async {
            let alertController = UIAlertController()
            if #available(iOS 13, *){
                self.addChild(alertController)
            }
            alertController.simpAlert(title: APPLICATION_NAME, message: message, isOkButton: true, isCancelButton: false, okButtonText: OK_TEXT, cancelbuttonText: nil, preferredStyle: .alert) { (success, failure) in
                completionBlock(success,failure)
            }
        }
        
    }
    
    func showAlertWithHandlerOKCancel(_ message : String, cancelText : String ,completionBlock : @escaping(Bool,Bool) -> ()){
        DispatchQueue.main.async {
            let alertController = UIAlertController()
            if #available(iOS 13, *){
                self.addChild(alertController)
            }
            alertController.simpAlert(title: APPLICATION_NAME, message: message, isOkButton: true, isCancelButton: true, okButtonText: OK_TEXT, cancelbuttonText: cancelText, preferredStyle: .alert) { (success, failure) in
                completionBlock(success,failure)
            }
        }
    }
    
    func showAlertWithHandlerOKCancel(_ message : String ,completionBlock : @escaping(Bool,Bool) -> ()){
        DispatchQueue.main.async {
            let alertController = UIAlertController()
            if #available(iOS 13, *){
                self.addChild(alertController)
            }
            alertController.simpAlert(title: APPLICATION_NAME, message: message, isOkButton: true, isCancelButton: true, okButtonText: OK_TEXT, cancelbuttonText: SIGN_TEXT, preferredStyle: .alert) { (success, failure) in
                completionBlock(success,failure)
            }
        }
    }
        
        func showAlertWithHandlerSignIn(_ message : String ,completionBlock : @escaping(Bool,Bool) -> ()){
            DispatchQueue.main.async {
                let alertController = UIAlertController()
                if #available(iOS 13, *){
                    self.addChild(alertController)
                }
                alertController.simpAlert(title: APPLICATION_NAME, message: message, isOkButton: true, isCancelButton: true, okButtonText: OK_TEXT, cancelbuttonText: "Sign In" , preferredStyle: .alert) { (success, failure) in
                    completionBlock(success,failure)
                }
            }

        
    }
    
}
extension UIView{
    func createDottedLine(width: CGFloat, color: CGColor) {
       let caShapeLayer = CAShapeLayer()
       caShapeLayer.strokeColor = color
       caShapeLayer.lineWidth = width
       caShapeLayer.lineDashPattern = [0,3]
       let cgPath = CGMutablePath()
       let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: self.frame.width)]
       cgPath.addLines(between: cgPoint)
       caShapeLayer.path = cgPath
       layer.addSublayer(caShapeLayer)
    }
}

@IBDesignable class DottedVertical: UIView {

    @IBInspectable var dotColor: UIColor = UIColor.lightGray
    @IBInspectable var lowerHalfOnly: Bool = false

    override func draw(_ rect: CGRect) {

        // say you want 8 dots, with perfect fenceposting:
        let totalCount = 10
        let fullHeight = bounds.size.height
        let width = bounds.size.width
        let itemLength = fullHeight / CGFloat(totalCount)

        let path = UIBezierPath()

        let beginFromTop = CGFloat(0.0)
        let top = CGPoint(x: width/2, y: beginFromTop)
        let bottom = CGPoint(x: width/2, y: fullHeight)

        path.move(to: top)
        path.addLine(to: bottom)

        path.lineWidth = width

        let dashes: [CGFloat] = [itemLength, itemLength]
        path.setLineDash(dashes, count: dashes.count, phase: 0)

        // for ROUNDED dots, simply change to....
        //let dashes: [CGFloat] = [0.0, itemLength * 2.0]
        //path.lineCapStyle = CGLineCap.round

        dotColor.setStroke()
        path.stroke()
    }
}
