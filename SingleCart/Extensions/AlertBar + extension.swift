//
//  AlertBar + extension.swift
//  FADA
//
//  Created by ADARSH on 25/08/19.
//  Copyright © 2019 uvionics. All rights reserved.
//


import Foundation
import UIKit
public enum AlertBarType {
    case success
    case warning
    case noaudio
    case safeStripCount
    case unsafeStripCount
    case nodoctor
    
    var backgroundColor: UIColor {
        switch self {
        case .success: return UIColor(r: 53.0, g: 183.0, b: 111.0, a: 1)
        case .warning: return UIColor.init(hex: "#E31E25")
        case .noaudio: return UIColor(r: 240.0, g: 215.0, b: 87.0, a:1)
        case .safeStripCount: return UIColor(r: 53.0, g: 183.0, b: 111.0, a: 1)
        case .unsafeStripCount: return UIColor(r: 240.0, g: 215.0, b: 87.0, a:1)
        case .nodoctor : return UIColor(r: 53.0, g: 183.0, b: 111.0, a: 1)
        }
    }
}

public final class AlertBar {
    var i : Int = 0
    var baseView: UIView?
    public var alertBarView: AlertBarView?
    public static let shared = AlertBar()
    private static let kWindowLevel: CGFloat = UIWindow.Level.statusBar.rawValue + 1
    private var alertBarViews: [AlertBarView] = []
    private var options = Options(shouldConsiderSafeArea: true, isStretchable: false, textAlignment: .left)
    
    
    public struct Options {
        let shouldConsiderSafeArea: Bool
        let isStretchable: Bool
        let textAlignment: NSTextAlignment
        
        public init(
            shouldConsiderSafeArea: Bool = true,
            isStretchable: Bool = false,
            textAlignment: NSTextAlignment = .left) {
            
            self.shouldConsiderSafeArea = shouldConsiderSafeArea
            self.isStretchable = true
            self.textAlignment = textAlignment
        }
    }
    
    public func setDefault(options: Options) {
        self.options = options
    }
    
    public func show(type: AlertBarType, message: String, duration: TimeInterval, options: Options? = nil, completion: (() -> Void)? = nil) {
        
        DispatchQueue.main.async {
            switch type {
            case .success:
                self.alertBarView?.messageLabel.text =  message
                self.alertBarView?.messageLabel.textColor = UIColor.white
                self.alertBarView?.messageLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
                self.alertBarView?.backgroundColor = type.backgroundColor
                if self.i == 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(duration))) {
                        self.alertBarView?.hide()
                        self.alertBarViews.forEach({ $0.hide() })
                    }
                }
                self.i = 1
            case .warning:
                let currentOptions = options ?? self.options
                var safeArea: UIEdgeInsets?
                var window: UIWindow?
                let width = UIScreen.main.bounds.width
                let height = UIScreen.main.bounds.height
                var topPadding: CGFloat?
                let orientation = UIApplication.shared.statusBarOrientation
                let userInterfaceIdiom = UIDevice.current.userInterfaceIdiom
                self.baseView = UIView(frame: UIScreen.main.bounds)
                if orientation.isLandscape {
                    window = UIWindow(frame: CGRect(x: 0, y: 0, width: height, height: width))
                    if userInterfaceIdiom == .phone {
                        let sign: CGFloat = orientation == .landscapeLeft ? -1 : 1
                        let d = fabs(width - height) / 2
                        self.baseView?.transform = CGAffineTransform(rotationAngle: sign * CGFloat.pi / 2).translatedBy(x: sign * d, y: sign * d)
                    }
                } else {
                    window = UIWindow(frame: CGRect(x: 0, y: 0, width: width, height: height))
                    if userInterfaceIdiom == .phone && orientation == .portraitUpsideDown {
                        self.baseView?.transform = CGAffineTransform(rotationAngle: .pi)
                    }
                }
                window?.isUserInteractionEnabled = false
                window?.windowLevel = UIWindow.Level(rawValue: AlertBar.kWindowLevel)
                window?.makeKeyAndVisible()
                self.baseView?.isUserInteractionEnabled = false
                
                if #available(iOS 11.0, *) {
                    topPadding = window?.safeAreaInsets.top
                    safeArea = window?.safeAreaInsets
                } else {
                    safeArea = .zero
                    topPadding = 0
                }
                self.alertBarView = AlertBarView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
                self.alertBarView?.delegate = self
                self.alertBarView?.alerttype = type
                self.alertBarView?.backgroundColor = type.backgroundColor
                self.alertBarView?.messageLabel.text = message
                self.alertBarView?.messageLabel.textColor = UIColor.white
                self.alertBarView?.messageLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
                self.alertBarView?.messageLabel.textAlignment = .center
                self.alertBarView?.fit(safeArea: currentOptions.shouldConsiderSafeArea ? safeArea! : .zero)
                self.alertBarViews.append(self.alertBarView!)
                self.baseView?.addSubview(self.alertBarView!)
                window?.addSubview(self.baseView!)
                //let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
                let statusBarHeight = max(UIApplication.shared.statusBarFrame.size.height, topPadding!)
                let alertBarHeight: CGFloat =    statusBarHeight
                self.alertBarView?.show(duration: duration, translationY: alertBarHeight) {
                    if let index = self.alertBarViews.index(of: self.alertBarView!) {
                        self.alertBarViews.remove(at: index)
                    }
                    // To hold window instance
                    window?.isHidden = false
                    completion?()
                }
            case .noaudio:
                self.alertBarView?.alertType = type
                self.alertBarCreation(_duration: duration, options: options, message: message)
                
                self.alertBarView?.messageLabel.textColor = UIColor.white
                self.alertBarView?.messageLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
                self.alertBarView?.backgroundColor = type.backgroundColor
                /*    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(0.5))) {
                 self.alertBarView?.hide()
                 self.alertBarViews.forEach({ $0.hide() })
                 }*/
            case .safeStripCount:
                self.alertBarView?.alertType = type
                self.alertBarCreation(_duration: duration, options: options, message: message)
                
                self.alertBarView?.messageLabel.textColor = UIColor.white
                self.alertBarView?.messageLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
                self.alertBarView?.backgroundColor = type.backgroundColor
            case .unsafeStripCount:
                self.alertBarView?.alertType = type
                self.alertBarCreation(_duration: duration, options: options, message: message)
                
                self.alertBarView?.messageLabel.textColor = UIColor.white
                self.alertBarView?.messageLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
                self.alertBarView?.backgroundColor = type.backgroundColor
            case .nodoctor:
                self.alertBarView?.alertType = type
                self.alertBarCreation(_duration: duration, options: options, message: message)
                
                self.alertBarView?.messageLabel.textColor = UIColor.white
                self.alertBarView?.messageLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
                self.alertBarView?.backgroundColor = type.backgroundColor
                
                
            }
        }
        alertBarView?.alertType = type
    }
    func alertBarCreation(_duration: TimeInterval,options: Options? = nil,message:String){
        let currentOptions = options ?? self.options
        var safeArea: UIEdgeInsets?
        var window: UIWindow?
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        var topPadding: CGFloat?
        let orientation = UIApplication.shared.statusBarOrientation
        let userInterfaceIdiom = UIDevice.current.userInterfaceIdiom
        self.baseView = UIView(frame: UIScreen.main.bounds)
        if orientation.isLandscape {
            window = UIWindow(frame: CGRect(x: 0, y: 0, width: height, height: width))
            if userInterfaceIdiom == .phone {
                let sign: CGFloat = orientation == .landscapeLeft ? -1 : 1
                let d = fabs(width - height) / 2
                self.baseView?.transform = CGAffineTransform(rotationAngle: sign * CGFloat.pi / 2).translatedBy(x: sign * d, y: sign * d)
            }
        } else {
            window = UIWindow(frame: CGRect(x: 0, y: 0, width: width, height: height))
            if userInterfaceIdiom == .phone && orientation == .portraitUpsideDown {
                self.baseView?.transform = CGAffineTransform(rotationAngle: .pi)
            }
        }
        window?.isUserInteractionEnabled = false
        window?.windowLevel = UIWindow.Level(rawValue: AlertBar.kWindowLevel)
        window?.makeKeyAndVisible()
        self.baseView?.isUserInteractionEnabled = false
        
        if #available(iOS 11.0, *) {
            topPadding = window?.safeAreaInsets.top
            safeArea = window?.safeAreaInsets
        } else {
            safeArea = .zero
        }
        self.alertBarView = AlertBarView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
        // self.alertBarView?.delegate = self
        self.alertBarView?.messageLabel.text =  message
        self.alertBarView?.messageLabel.textColor = UIColor.white
        self.alertBarView?.messageLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        self.alertBarView?.messageLabel.textAlignment = .center
        self.alertBarView?.fit(safeArea: currentOptions.shouldConsiderSafeArea ? safeArea! : .zero)
        self.alertBarViews.append(self.alertBarView!)
        self.baseView?.addSubview(self.alertBarView!)
        window?.addSubview(self.baseView!)
        //let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        if topPadding == nil {
            topPadding = 0
        }
        
        let statusBarHeight = max(UIApplication.shared.statusBarFrame.size.height, topPadding!)//max(30, topPadding!)// max(UIApplication.shared.statusBarFrame.size.height, topPadding!)
        let alertBarHeight: CGFloat =    statusBarHeight
        self.alertBarView?.show(duration: _duration, translationY: alertBarHeight) {
            if let index = self.alertBarViews.index(of: self.alertBarView!) {
                self.alertBarViews.remove(at: index)
            }
            // To hold window instance
            window?.isHidden = true
        }
    }
}

extension AlertBar: AlertBarViewDelegate {
    func alertBarViewHandleRotate(_ alertBarView: AlertBarView, _ alertBarType: AlertBarType) {
        switch alertBarType {
        case .success:
            alertBarView.removeFromSuperview()
            alertBarViews.forEach({ $0.hide() })
            alertBarViews = []
        case .warning:
            
            break
        case .noaudio:
            break
        case .safeStripCount:
            break
        case .unsafeStripCount:
            break
        case .nodoctor:
            break
        }
        
    }
}

// MARK: - Static helpers

public extension AlertBar {
    
    static func setDefault(options: Options) {
        shared.options = options
    }
    
    static func show(type: AlertBarType, message: String, duration: TimeInterval , options: Options? = nil, completion: (() -> Void)? = nil) {
        shared.show(type: type, message: message, duration: duration, options: options, completion: completion)
    }
    static func hide(){
//        alertBarView?.hide()
    }
}

protocol AlertBarViewDelegate: class {
    func alertBarViewHandleRotate(_ alertBarView: AlertBarView, _ alertBarType: AlertBarType)
}

public class AlertBarView: UIView {
    internal let messageLabel = UILabel()
    internal weak var delegate: AlertBarViewDelegate?
    internal var alertType: AlertBarType?
    
    public enum State {
        case showing
        case shown
        case hiding
        case hidden
    }
    
    private static let kMargin: CGFloat = 2
    private static let kAnimationDuration: TimeInterval = 0.2
    var alerttype: AlertBarType?
    private var translationY: CGFloat = 0
    private var completion: (() -> Void)?
    public var state: State = .hidden
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let margin = AlertBarView.kMargin
        messageLabel.frame = CGRect(x: margin, y: margin, width: frame.width - margin*2, height: frame.height - margin*2)
        messageLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(messageLabel)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleRotate(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func fit(safeArea: UIEdgeInsets) {
        let margin = AlertBarView.kMargin
        messageLabel.sizeToFit()
        messageLabel.frame.origin.x = margin + safeArea.left
        messageLabel.frame.origin.y = margin + safeArea.top
        messageLabel.frame.size.width = frame.size.width - margin*2 - safeArea.left - safeArea.right
        if alertType != .noaudio{
            frame.size.height = messageLabel.frame.origin.y + messageLabel.frame.height + margin*2
        }else{
            frame.size.height = messageLabel.frame.origin.y + messageLabel.frame.height + margin*2.5
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func show(duration: TimeInterval, translationY: CGFloat, completion: (() -> Void)?) {
        
        
        guard state == .hiding || state == .hidden else {
            return
        }
        self.state = .showing
        self.translationY = translationY
        self.completion = completion
        
        transform = CGAffineTransform(translationX: 0, y: -translationY)
        UIView.animate(
            withDuration: AlertBarView.kAnimationDuration,
            animations: { () -> Void in
                self.transform = .identity
        }, completion: { _ in
            self.state = .shown
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(duration))) {
                if self.alertType != .warning{
                    self.hide()
                }
                // self.hide()
            }
        })
    }
    
    public func hide() {
        
        
        guard state == .showing || state == .shown else {
            return
        }
        if alertType != .warning{
            self.state = .hiding
            // Hide animation
            UIView.animate(
                withDuration: AlertBarView.kAnimationDuration,
                animations: { () -> Void in
                    self.transform = CGAffineTransform(translationX: 0, y: -self.translationY)
            },
                completion: { (animated: Bool) -> Void in
                    //                self.removeFromSuperview()
                    self.state = .hidden
                    self.completion?()
                    self.completion = nil
            })
        }
    }
    @objc public func handleRotate(_ notification: Notification) {
        delegate?.alertBarViewHandleRotate(self, alerttype!)
    }
}
