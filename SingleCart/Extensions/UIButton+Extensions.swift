//
//  UIButton+Extensions.swift
//  SingleCart
//
//  Created by apple on 05/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    
    public struct tagProperty{
        static var section: Int? = 0
        static var row : Int? = 0
    }
    public var tagSection: Int? {
        get {
            return tagProperty.section
        }
        set(aNewvalue) {
            tagProperty.section = aNewvalue
        }
    }
    public var tagRow: Int? {
        get {
            return tagProperty.row
        }
        set(aNewvalue) {
            tagProperty.row = aNewvalue
        }
    }
    
    
    func setCornerRadius(radius : CGFloat ,bg_Color : UIColor){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.backgroundColor = bg_Color
    }
    
    func setCornerRadiusWithoutBackground(radius : CGFloat ){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func setCornerRadius(radius:CGFloat, isBg_Color : Bool,bg_Color : UIColor? ,isBorder: Bool,borderColor :UIColor?,borderWidth:CGFloat? ){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        if isBg_Color{
          self.backgroundColor = bg_Color
        }
        if isBorder{
            self.layer.borderWidth = borderWidth!
            self.layer.borderColor = borderColor!.cgColor
        }
        
    }
}


extension UIStepper{
    
    public struct tagProperty{
        static var section: Int? = 0
        static var row : Int? = 0
    }
    public var tagSection: Int? {
        get {
            return tagProperty.section
        }
        set(aNewvalue) {
            tagProperty.section = aNewvalue
        }
    }
    public var tagRow: Int? {
        get {
            return tagProperty.row
        }
        set(aNewvalue) {
            tagProperty.row = aNewvalue
        }
    }
}
