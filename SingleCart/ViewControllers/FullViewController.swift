//
//  FullViewController.swift
//  SingleCart
//
//  Created by PromptTech on 04/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import ImageScrollView

class FullViewController: UIViewController ,UIScrollViewDelegate {
    var urlString = ""
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.imageScrollView.isScrollEnabled = true
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 6.0
        self.imageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: placeHolderImage), options: .continueInBackground, context: nil)
        self.imageView.isUserInteractionEnabled = true
        self.panGesture.delegate = self
        self.panGesture.addTarget(self, action: #selector(Imagetapped(sender:)))
        self.imageView.addGestureRecognizer(panGesture)
        self.tapGesture.delegate = self
        self.tapGesture.addTarget(self, action: #selector(doubleTap(sender:)))
        self.tapGesture.numberOfTapsRequired = 2
        self.imageView.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func cloaseButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
       
        return imageView
    }

}

extension FullViewController : UIGestureRecognizerDelegate{
    @objc func Imagetapped(sender : UIPanGestureRecognizer){
                let translation = sender.translation(in: self.imageScrollView)
        self.imageView.center = CGPoint(x: self.imageView.center.x + translation.x, y: self.imageView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.imageScrollView)
    }
    
    @objc func doubleTap(sender : UITapGestureRecognizer){
        debugPrint("tap")
        imageScrollView.minimumZoomScale = 1.0
        if imageScrollView.zoomScale == 1 {
             imageScrollView.zoom(to: zoomRectForScale(scale: imageScrollView.zoomScale, center: sender.location(in: sender.view)), animated: true)
         } else {
             imageScrollView
                .setZoomScale(1, animated: true)
         }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = imageScrollView.convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}
