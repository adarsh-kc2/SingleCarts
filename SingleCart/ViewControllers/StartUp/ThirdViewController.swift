//
//  ThirdViewController.swift
//  SingleCart
//
//  Created by apple on 11/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonLoginTapped(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: FIRSTTIME)
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                Permission.modalPresentationStyle = .fullScreen
                self.present(Permission, animated: false)
            }else{
                self.present(Permission, animated: false, completion: nil)
            }
        }
    }
}
