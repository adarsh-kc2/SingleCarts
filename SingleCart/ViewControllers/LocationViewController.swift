//
//  LocationViewController.swift
//  SingleCart
//
//  Created by PromptTech on 04/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire


class LocationViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: UIView!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var gMapView: GMSMapView? = nil
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var cirlce: GMSCircle!
    var marker : GMSMarker!
    var destLat : String = ""
    var destLong : String = ""
    
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
//        let markerEnd = GMSMarker()
        let MomentaryLatitude = ("\(UserDefaults.standard.value(forKey: LATITUDE))" as! NSString).doubleValue
        let MomentaryLongitude = ("\(UserDefaults.standard.value(forKey: LONGITUDE))" as! NSString).doubleValue
        let location : CLLocation = CLLocation(latitude: MomentaryLatitude as
        CLLocationDegrees, longitude: MomentaryLongitude as CLLocationDegrees)
        setUp(location: location)
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
        let destLatitude = (destLat as! NSString).doubleValue
        let destLongitude = (destLong as! NSString).doubleValue
        let destLocation : CLLocation = CLLocation(latitude: destLatitude as
        CLLocationDegrees, longitude: destLongitude as CLLocationDegrees)
        draw(src: location.coordinate, dst: destLocation.coordinate)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
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
    
    func draw(src: CLLocationCoordinate2D, dst: CLLocationCoordinate2D){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(src.latitude),\(src.longitude)&destination=\(dst.latitude),\(dst.longitude)&sensor=false&mode=walking&key=AIzaSyCMeseIFEIjn8CcBtxplgz-pDyKpVJBnAo")!
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        let preRoutes = json["routes"] as! NSArray
                        if preRoutes.count > 0 {
                            let routes = preRoutes[0] as! NSDictionary
                            let routeOverviewPolyline:NSDictionary = routes.value(forKey: "overview_polyline") as! NSDictionary
                            let polyString = routeOverviewPolyline.object(forKey: "points") as! String

                            DispatchQueue.main.async(execute: {
                                let path = GMSPath(fromEncodedPath: polyString)
                                let polyline = GMSPolyline(path: path)
                                polyline.strokeWidth = 5.0
                                polyline.strokeColor = UIColor.green
                                polyline.map = self.gMapView
                            })
                        }
                    }

                } catch {
                    print("parsing error")
                }
            }
        })
        task.resume()
    }
}
