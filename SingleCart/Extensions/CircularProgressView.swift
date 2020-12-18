//
//  CircularProgressView.swift
//  SingleCart
//
//  Created by PromptTech on 13/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit
class CircularProgressView: UIView {
    var progressLyr = CAShapeLayer()
    var trackLyr = CAShapeLayer()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeCircularPath()
    }
    var progressClr = UIColor.white {
        didSet {
            progressLyr.strokeColor = progressClr.cgColor
        }
    }
    var trackClr = UIColor.white {
        didSet {
            trackLyr.strokeColor = trackClr.cgColor
        }
    }
    var _value = 0.0
    var progressValue : UILabel!
    
    func makeCircularPath() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width/2
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        
        progressValue = UILabel(frame: CGRect(x: self.frame.size.width/2 - 30, y: self.frame.size.width/2 - 10, width: 60, height: 20))
        progressValue.textAlignment = .center
        progressValue.text = ""
        trackLyr.path = circlePath.cgPath
        trackLyr.fillColor = UIColor.clear.cgColor
        trackLyr.strokeColor = trackClr.cgColor
        trackLyr.lineWidth = 4.0
        trackLyr.strokeEnd = 1.0
        layer.addSublayer(trackLyr)
        progressLyr.path = circlePath.cgPath
        progressLyr.fillColor = UIColor.clear.cgColor
        progressLyr.strokeColor = progressClr.cgColor
        progressLyr.lineWidth = 5.0
        progressLyr.strokeEnd = 0.0
        layer.addSublayer(progressLyr)
        self.addSubview(progressValue)
    }
    
    func setProgressWithAnimation(duration: TimeInterval, value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        
        if value == 0{
            animation.toValue = value
            progressValue.text = "0%"
        }else{
            var _f = Float(value / 100)
            animation.toValue = _f
            progressValue.text = String(format: "%.1f%",value)
        }
        
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        progressLyr.strokeEnd = value != 0 ? CGFloat(value / 100) : CGFloat(value)
        progressLyr.add(animation, forKey: "animateprogress")
    }
}
