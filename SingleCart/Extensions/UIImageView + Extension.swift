//
//  UIImageView + Extension.swift
//  SingleCart
//
//  Created by PromptTech on 04/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit



extension UIImageView{
     func setImageViewCornerRadius(radius : CGFloat ){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    func setImageViewCornerRadiusWithBorder(radius : CGFloat ,borderwidth : CGFloat , color : UIColor){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderwidth
        self.layer.borderColor = color.cgColor
    }
}



