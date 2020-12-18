//
//  UIButton + BageButton.swift
//  SingleCart
//
//  Created by PromptTech on 05/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

class BageButton: UIButton {
    
    var badgeLabel = UILabel()
    
    var badge: String? {
        didSet {
            addBadgeToButon(badge: badge)
        }
    }

    public var badgeBackgroundColor = UIColor.red {
        didSet {
            badgeLabel.backgroundColor = badgeBackgroundColor
        }
    }
    
    public var badgeTextColor = UIColor.white {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }
    
    public var badgeFont = UIFont.systemFont(ofSize: 10.0) {
        didSet {
            badgeLabel.font = badgeFont
        }
    }
    
    public var badgeEdgeInsets: UIEdgeInsets? {
        didSet {
            addBadgeToButon(badge: badge)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBadgeToButon(badge: nil)
    }
    
    func addBadgeToButon(badge: String?) {
        DispatchQueue.main.async {
            self.badgeLabel.text = badge
            self.badgeLabel.textColor = self.badgeTextColor
            self.badgeLabel.backgroundColor = self.badgeBackgroundColor
            self.badgeLabel.font = self.badgeFont
            self.badgeLabel.sizeToFit()
            self.badgeLabel.textAlignment = .center
            let badgeSize = self.badgeLabel.frame.size
            
            let height = max(15, Double(badgeSize.height) + 5.0)
            let width = max(height, Double(badgeSize.width) + 10.0)
            
            var vertical: Double?, horizontal: Double?
            if let badgeInset = self.badgeEdgeInsets {
                vertical = Double(badgeInset.top) - Double(badgeInset.bottom)
                horizontal = Double(badgeInset.left) - Double(badgeInset.right)
                
                let x = (Double(self.bounds.size.width) - 10 + horizontal!)
                let y = -(Double(badgeSize.height) / 2) - 10 + vertical!
                self.badgeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
            } else {
                let x = self.frame.width - CGFloat((width / 2.0))
                let y = CGFloat(-(height / 2.0))
                self.badgeLabel.frame = CGRect(x: x, y: y, width: CGFloat(width), height: CGFloat(height))
            }
            
            self.badgeLabel.layer.cornerRadius = self.badgeLabel.frame.height/2
            self.badgeLabel.layer.masksToBounds = true
            self.addSubview(self.badgeLabel)
            self.badgeLabel.isHidden = badge != "0" ? false : true
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addBadgeToButon(badge: "\(0)")
//        fatalError("init(coder:) has not been implemented")
    }
}
