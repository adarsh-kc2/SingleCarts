//
//  PermissionViewController.swift
//  SingleCart
//
//  Created by PromptTech on 19/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import MapKit
import Photos
import EventKit

class PermissionViewController: UIViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    fileprivate let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    @IBOutlet weak var calendarSwitch: UISwitch!
    @IBOutlet weak var gallerySwitch: UISwitch!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var permissionView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.permissionView.setCornerRadius(radius: 6.0, isShadow: false, isBorderColor: true, borderColor: .lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.3, shadowOpacity: nil, shadowColor: nil, shadowOffset: nil)
        continueButton.isEnabled = false
        continueButton.setCornerRadius(radius: 6.0, bg_Color: .lightGray)
        self.setViews()
    }
    
    func setViews(){
        currentLocation()
    }
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        if sender.tag == 0{
            if sender.isOn{
                currentLocation()
            }
            
        }else if sender.tag == 1{
            if sender.isOn{
                checkPhotoLibraryUsage()
            }
        }else{
            if sender.isOn{
                checkCalendar()
            }
        }
        checkAll()
    }
    func checkAll(){
        if locationSwitch.isOn && gallerySwitch.isOn && calendarSwitch.isOn{
            continueButton.isEnabled = true
            continueButton.setCornerRadius(radius: 6.0, bg_Color: HOME_NAVIGATION_BGCOLOR)
        }else{
            continueButton.isEnabled = false
            continueButton.setCornerRadius(radius: 6.0, bg_Color: .lightGray)
        }
    }
    @IBAction func continueButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: AUTHORISED)
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                Login.modalPresentationStyle = .fullScreen
                self.present(Login, animated: false)
            }else{
                self.present(Login, animated: false, completion: nil)
            }
        }
    }
}

extension PermissionViewController :CLLocationManagerDelegate{
    func checkPhotoLibraryUsage(){
        PHPhotoLibrary.requestAuthorization { status in
            
            if status == .authorized {
                print("Permission granted")
            } else {
                print("Unavailable")
            }
            
        }
    }
    
    func checkCalendar(){
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            break
//            insertEvent(store: eventStore)
        case .denied:
            print("Access denied")
        case .notDetermined:
            // 3
            eventStore.requestAccess(to: .event, completion:
                {[weak self] (granted: Bool, error: Error?) -> Void in
                    if granted {
//                        self!.insertEvent(store: self!.eventStore)
                    } else {
                        print("Access denied")
                    }
            })
        default:
            print("Case default")
        }
    }
    
    func currentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.showsBackgroundLocationIndicator = true
        
        let locStatus = CLLocationManager.authorizationStatus()
        switch locStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Services are disabled", message: "Please enable Location Services in your Settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        case .authorizedAlways, .authorizedWhenInUse:
            debugPrint("access granted")
            self.locationSwitch.isOn = true
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let currentLocation = location.coordinate
        _ = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 800, longitudinalMeters: 800)
        
        debugPrint("current location : \(currentLocation)")
        UserDefaults.standard.set(currentLocation.latitude, forKey: LATITUDE)
        UserDefaults.standard.set(currentLocation.longitude, forKey: LONGITUDE)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
