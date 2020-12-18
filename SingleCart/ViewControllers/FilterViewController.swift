//
//  FilterViewController.swift
//  SingleCart
//
//  Created by PromptTech on 23/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
//import SwiftRangeSlider
//import WARangeSlider
import ZMSwiftRangeSlider

protocol FilterDelegate {
    func filterApplied(view : UIViewController,_booleanArray :[Bool], _integerArray : [Int])
}

class FilterViewController: UIViewController {

    var constraintArray : [NSLayoutConstraint] = []
    var const: [CGFloat] = []
    var hiddenValues : [Bool] = []
    var viewArrays : [UIView] = []
    var booleanArray : [Bool] = []
    var integerArray : [Int] = []
    var tempBooleanArray : [Bool] = []
    var tempIntegerArray : [Int] = []
    var filterDelegate : FilterDelegate!
    var rangeArray : [Int] = []
    
    @IBOutlet weak var offersView: UIView!
    @IBOutlet weak var shopsView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var filterTableview: UITableView!
    @IBOutlet weak var offerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shopViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var priceRangeslider: RangeSlider!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceMinimumLabel: UILabel!
    
    var defaultBoolean = [false,false,false,false,false,true,true,true,true,true,true,true,true]
    
    @IBOutlet weak var showOpenButton: UIButton!
    @IBOutlet weak var showClosedButton: UIButton!
    
    @IBOutlet weak var showOfferButton: UIButton!
    @IBOutlet weak var showNonOfferButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearButton.setCornerRadius(radius: 0.0, isBg_Color: false, bg_Color: nil, isBorder: true, borderColor: .lightGray, borderWidth: 0.3)
        self.const = [100,0,0]
        self.hiddenValues = [false,true,true]
        self.constraintArray = [priceViewHeightConstraint,shopViewHeightConstraint,offerViewHeightConstraint]
        self.viewArrays = [priceView,shopsView,offersView]
        self.filterTableview.tableFooterView = UIView()
        self.filterTableview.reloadData()
        self.filterTableview.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        for i in 0 ..< constraintArray.count{
            self.constraintArray[i].constant = self.const[i]
            self.viewArrays[i].isHidden = self.hiddenValues[i]
        }
        self.tempBooleanArray = self.booleanArray
        self.tempIntegerArray = self.integerArray
        self.view.layoutIfNeeded()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
//        self.priceRangeslider.de
        self.setUpValues()
    }
    
    func setUpValues(){

        self.showOpenButton.setImage(self.booleanArray[8] ? UIImage(named: "rect_select.png") : UIImage(named: "rect_unSelect.png"), for: .normal)
        self.showClosedButton.setImage(self.booleanArray[7] ? UIImage(named: "rect_select.png") : UIImage(named: "rect_unSelect.png"), for: .normal)
        self.showOfferButton.setImage(self.booleanArray[6] ? UIImage(named: "rect_select.png") : UIImage(named: "rect_unSelect.png"), for: .normal)
        self.showNonOfferButton.setImage(self.booleanArray[5] ? UIImage(named: "rect_select.png") : UIImage(named: "rect_unSelect.png"), for: .normal)
        self.priceRangeslider.setMinAndMaxRange(0, maxRange: 10000)
        self.priceRangeslider.setValueChangedCallback { (min, max) in
            debugPrint("minimum :\(min) , maximum :\(max)")
            self.integerArray[4] = min
            self.integerArray[5] = max
        }
    }
    
    
    @objc func priceChanged(_ sender: RangeSlider) {
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        filterDelegate.filterApplied(view: self, _booleanArray: booleanArray, _integerArray: integerArray)
    }
    
    @IBAction func clearFlterTapped(_ sender: Any) {
        self.booleanArray = defaultBoolean
        self.integerArray[4] = 0
        self.integerArray[5] = 0
        self.setUpValues()
    }
    
    @IBAction func openedShops(_ sender: UIButton) {
        sender.currentImage == UIImage(named: "rect_unSelect.png") ?
            sender.setImage(UIImage(named: "rect_select.png"), for: .normal) : sender.setImage(UIImage(named: "rect_unSelect.png"), for: .normal)
        booleanArray[8] = sender.currentImage == UIImage(named: "rect_unSelect.png") ?  false : true
    }
    
    @IBAction func closedShopsButton(_ sender: UIButton) {
        sender.currentImage == UIImage(named: "rect_unSelect.png") ?
             sender.setImage(UIImage(named: "rect_select.png"), for: .normal) : sender.setImage(UIImage(named: "rect_unSelect.png"), for: .normal)
         booleanArray[7] = sender.currentImage == UIImage(named: "rect_unSelect.png") ?  false : true
    }
    
    @IBAction func showOfferButtontapped(_ sender: UIButton) {
        sender.currentImage == UIImage(named: "rect_unSelect.png") ?
            sender.setImage(UIImage(named: "rect_select.png"), for: .normal) : sender.setImage(UIImage(named: "rect_unSelect.png"), for: .normal)
        booleanArray[6] = sender.currentImage == UIImage(named: "rect_unSelect.png") ?  false : true
    }
    
    @IBAction func showNonOfferButtonTapped(_ sender: UIButton) {
        sender.currentImage == UIImage(named: "rect_unSelect.png") ?
            sender.setImage(UIImage(named: "rect_select.png"), for: .normal) : sender.setImage(UIImage(named: "rect_unSelect.png"), for: .normal)
        booleanArray[5] = sender.currentImage == UIImage(named: "rect_unSelect.png") ?  false : true
    }
}

extension FilterViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell\(indexPath.row)", for: indexPath) as! FilterTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0 ..< self.constraintArray.count{
            self.const[i] = indexPath.row == i ? 100 : 0
            self.hiddenValues[i] = indexPath.row == i ? false : true
        }
        for i in 0 ..< self.constraintArray.count{
            self.constraintArray[i].constant = self.const[i]
            self.viewArrays[i].isHidden = self.hiddenValues[i]
        }
    }
}
