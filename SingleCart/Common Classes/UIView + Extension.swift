//
//  UIView + Extension.swift
//  SingleCart
//
//  Created by PromptTech on 03/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    func setCornerRadius(radius: CGFloat, isShadow : Bool, isBorderColor : Bool , borderColor : UIColor? , isBGColor : Bool , B_GColor : UIColor?,  isBorderWidth : Bool , borderWidth : CGFloat? , shadowOpacity : Float?, shadowColor : UIColor?,shadowOffset : CGSize?){
        if isShadow{
            self.layer.shadowColor = shadowColor!.cgColor
            self.layer.shadowOpacity = shadowOpacity!
            self.layer.shadowOffset = shadowOffset!
            self.layer.shadowRadius = radius
        }
        
        if isBGColor{
            self.backgroundColor = B_GColor!
        }
        
        if isBorderColor{
            self.layer.borderColor = borderColor?.cgColor
        }
        
        if isBorderWidth{
            self.layer.borderWidth = borderWidth!
        }
        
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        
    }
}
