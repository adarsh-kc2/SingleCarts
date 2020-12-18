//
//  TrackViewController.swift
//  SingleCart
//
//  Created by PromptTech on 26/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class TrackViewController: UIViewController {
    @IBOutlet weak var trackTableView: UITableView!
     var track : [TrackOrderList]? = nil
    var delegate : TrackViewControllerDelegate?
    
    @IBOutlet weak var tableViewheight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.trackTableView.tableFooterView = UIView()
        self.trackTableView.delegate = self
        self.trackTableView.dataSource = self
        if track != nil{
            tableViewheight.constant = CGFloat(track!.count * 68) 
        }else{
            tableViewheight.constant = 250
        }
        self.trackTableView.reloadData()
    }
    
    @IBAction func closeButtontapped(_ sender: Any) {
        delegate?.backButtonTapped(view: self)
    }
}


extension TrackViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return track!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell", for: indexPath) as! TrackTableViewCell
        cell.orderStatusLabel.text = (track![indexPath.row].heading)! + "\n" + (track![indexPath.row].message)!
        cell.orderStatusBottomView.isHidden = (track![indexPath.row].heading)! == "Delivered" ? true : false
        if (track![indexPath.row].heading)! == "Delivered"{
            cell.bottomConstraint.constant = 0
        }
        if (track![indexPath.row].isCompleted)! == false{
            cell.orderStatusBottomView.backgroundColor = .clear
            cell.orderStatusBottomView.dotColor = .lightGray
            cell.orderStatusImageView.tintColor = .lightGray
        }else{
            cell.orderStatusBottomView.dotColor = SELECTED_TRACK
            cell.orderStatusImageView.tintColor = SELECTED_TRACK
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110// UITableView.automaticDimension
    }
    
}
