//
//  MapViewController.swift
//  SingleCart
//
//  Created by PromptTech on 10/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


class MapViewController: UIViewController{
    
    var mapDelegate : MapViewControllerDelegate? = nil
    @IBOutlet weak var mapView: UIView!
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var gMapView: GMSMapView? = nil
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var cirlce: GMSCircle!
    var marker : GMSMarker!
    var mapDic : Dictionary<String,Any> = [:]
    
    var lat = 0.0
    var lng = 0.0
    var latEnd = 0.0
    var lngEnd = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    func setUp(location : CLLocation){
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.latitude, zoom: 6.0)
        
        gMapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        gMapView!.mapType = .normal
        gMapView!.isIndoorEnabled = false
        gMapView!.isBuildingsEnabled = true
        gMapView!.isTrafficEnabled = true
        
        gMapView!.isUserInteractionEnabled = true
        gMapView!.isMyLocationEnabled = true
        gMapView?.delegate = self
        self.mapView.addSubview(gMapView!)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        mapDic = [:]
        mapDelegate?.setAddressFields(view: self, dictionary: mapDic)
    }
    @IBAction func doneButtonTapped(_ sender: Any) {
         mapDelegate?.setAddressFields(view: self, dictionary: mapDic)
    }
}


extension MapViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        setUp(location: location)
        //marker
        
        marker = GMSMarker()
        
        let myLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        //get details
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(myLocation) { response, error in
            //
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            } else {
                if let places = response?.results() {
                    if let place = places.first {
                        
                        
                        if let lines = place.lines {
                            print("GEOCODE: Formatted Address: \(lines)")
                            
                            self.marker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                            self.marker.title = lines.first
                            self.marker.snippet = lines.last
                            self.marker.map = self.gMapView
                            
                        }
                    } else {
                        print("GEOCODE: nil first in places")
                    }
                } else {
                    print("GEOCODE: nil in places")
                }
            }
        }
        
        // get current place
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,longitude: location.coordinate.longitude,zoom: zoomLevel)
        if gMapView!.isHidden {
            gMapView!.isHidden = false
            gMapView!.camera = camera
        } else {
            gMapView!.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            gMapView!.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        @unknown default:
            fatalError()
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
}


extension MapViewController : GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.marker.position = position.target
        
        UserDefaults.standard.set("\(position.target.longitude)", forKey: ADD_LONGITUDE)//value(forKey: ADD_LONGITUDE)
        UserDefaults.standard.set("\(position.target.latitude)", forKey: ADD_LATITUDE)
        
        let myLocation : CLLocationCoordinate2D = position.target
        //get details
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(myLocation) { response, error in
            //
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            } else {
                if let places = response?.results() {
                    if let place = places.first {
                        self.mapDic["Longitude"] = "\(position.target.longitude)"
                        self.mapDic["Latitude"] = "\(position.target.latitude)"
                        self.mapDic["Address1"] = place.addressLine1() != nil ? place.addressLine1()! : ""
                        self.mapDic["Address2"] = place.addressLine2() != nil ? place.addressLine2()! : ""
                        self.mapDic["Landmark"] = place.subLocality != nil ? place.subLocality! : ""
                        self.mapDic["Province"] = place.administrativeArea != nil ? place.administrativeArea! : ""
                        self.mapDic["Area"] = place.administrativeArea != nil ? place.administrativeArea! : ""
                        self.mapDic["City"] = place.locality != nil ? place.locality! : ""
                        self.mapDic["Country"] = place.country != nil ? place.country! : ""
                        if let lines = place.lines {
                            
                            self.marker.title = lines.first
                            self.marker.snippet = lines.last
                            self.marker.map = mapView
                        }
                    } else {
                        print("GEOCODE: nil first in places")
                    }
                } else {
                    print("GEOCODE: nil in places")
                }
            }
        }
    }
}

