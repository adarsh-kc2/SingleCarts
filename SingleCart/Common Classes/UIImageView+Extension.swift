//
//  UIImageView+Extension.swift
//  SingleCart
//
//  Created by PromptTech on 30/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    func setCornerRadius(radius:CGFloat){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    func setCornerRadiusWithBorder(radius:CGFloat,borderWidth: CGFloat,borderColor : UIColor){
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}



