//
//  SortViewController.swift
//  SingleCart
//
//  Created by PromptTech on 23/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
protocol sortDelegate {
    func buttonSelected(view : UIViewController,sortBoolean : [Bool],_ isFromSort : Bool)
}

class SortViewController: UIViewController {
    
    var buttons : [UIButton] = []
    
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var newestFirstButton: UIButton!
    @IBOutlet weak var priceLowHighButton: UIButton!
    @IBOutlet weak var priceHighLowButton: UIButton!
    @IBOutlet weak var discountLowHighButton: UIButton!
    @IBOutlet weak var discountHighLowButton: UIButton!
    var sortBoolean : [Bool] = []
    var sortDelegate : sortDelegate!
    var selectedTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        buttons = [newestFirstButton,priceLowHighButton,priceHighLowButton,discountLowHighButton,discountHighLowButton]
        self.setUpView()
        self.sortView.setCornerRadius(radius: 6.0, isShadow: false, isBorderColor: true, borderColor: .lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.4, shadowOpacity: nil, shadowColor: nil, shadowOffset: nil)

        let _tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        self.view.addGestureRecognizer(_tap)
    }
    
    func setUpView(){
        if sortBoolean[0],sortBoolean[2],sortBoolean[3]{
            self.selectedTag = 1
        }else if sortBoolean[2],sortBoolean[3]{
            self.selectedTag = 2
        }else if sortBoolean[0],sortBoolean[1],sortBoolean[3]{
            self.selectedTag = 3
        }else if sortBoolean[1],sortBoolean[3]{
            self.selectedTag = 4
        }else{
            self.selectedTag = 0
        }
        
        self.setButtons()
    }
    
    func setButtons(){
        for i in 0 ..< buttons.count{
            self.selectedTag == buttons[i].tag ? buttons[i].setImage(UIImage(named:"round_select.png"), for: .normal) : buttons[i].setImage(UIImage(named:"round_unselect.png"), for: .normal)
        }
    }
    
    @objc func dismissView(){
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func sortbuttonSelected(_ sender: UIButton) {
        for i in 0 ..< buttons.count{
            sender.tag == buttons[i].tag ? buttons[i].setImage(UIImage(named:"round_select.png"), for: .normal) : buttons[i].setImage(UIImage(named:"round_unselect.png"), for: .normal)
            switch sender.tag {
            case 0:
                setBoolean(false,false,false,false)
            case 1:
                setBoolean(true,false,true,true)
            case 2:
                setBoolean(false,false,true,true)
            case 3:
                setBoolean(true,true,false,true)
            default:
                setBoolean(false,true,false,true)
            }
        }

    }
    
    func setBoolean(_ first : Bool,_ second : Bool,_ third : Bool,_ forth : Bool){
        self.sortBoolean[0] = first
        self.sortBoolean[1] = second
        self.sortBoolean[2] = third
        self.sortBoolean[3] = forth
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.sortDelegate.buttonSelected(view: self, sortBoolean: self.sortBoolean, true)//buttonSelected
        }
    }
}
