//
//  SingleCart_CommonButton.swift
//  SingleCart
//
//  Created by apple on 05/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

class CommonButton: UIButton{
    
}


class CommonView : UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 6.0
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
