//
//  AppDelegate.swift
//  SingleCart
//
//  Created by apple on 04/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import ReachabilitySwift
import GoogleMaps
import GooglePlaces
import Firebase
import UserNotifications
//import Fireba


@UIApplicationMain


 
class AppDelegate: UIResponder, UIApplicationDelegate {
    fileprivate let locationManager: CLLocationManager = {
         let manager = CLLocationManager()
         manager.requestWhenInUseAuthorization()
         return manager
     }()
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyB49CWMgd877N351ZIewDlZif8oo9J-s5o")
        GMSPlacesClient.provideAPIKey("AIzaSyB49CWMgd877N351ZIewDlZif8oo9J-s5o")
        //
//        GMSServices.provideAPIKey("AIzaSyCMeseIFEIjn8CcBtxplgz-pDyKpVJBnAo")
//        GMSPlacesClient.provideAPIKey("AIzaSyCMeseIFEIjn8CcBtxplgz-pDyKpVJBnAo")
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
//        currentLocation()
        
        if let _ = UserDefaults.standard.value(forKey: FIRSTTIME){
            if let _ = UserDefaults.standard.value(forKey: AUTHORISED){
                if let _ = UserDefaults.standard.value(forKey: USERAVAILABLE){
                    if let _ = UserDefaults.standard.value(forKey: USERID){
                        //do coding
                    }else{
                        UserDefaults.standard.set(0, forKey: USERID)
                    }
                    self.currentLocation()
                    self.homePage()
                }else{
                    self.loginPage()
                }
            }else{
                self.permissionPage()
            }
            
        }else{
            self.starUpPage()
        }
//        checkNetworkRexchability()
        registerForPushNotifications()
        return true
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current() // 1
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        UserDefaults.standard.set(token, forKey: DEVICETOKEN)
        print("Device Token: \(token)")
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func showScreen(index : Int){
        if let _ = UserDefaults.standard.value(forKey: FIRSTTIME){
            if let _ = UserDefaults.standard.value(forKey: AUTHORISED){
                if let _ = UserDefaults.standard.value(forKey: USERAVAILABLE){
                    if let _ = UserDefaults.standard.value(forKey: USERID){
                        //do coding
                    }else{
                        UserDefaults.standard.set(0, forKey: USERID)
                    }
                    self.dismissViewControllers()
                    MAINTABBARPAGE.setUPViewController()
                    MAINTABBARPAGE.selectedIndex = index
                    self.window?.rootViewController = MAINTABBARPAGE
                    
                }else{
                    self.loginPage()
                }
            }else{
                self.permissionPage()
            }
            
        }else{
            self.starUpPage()
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.pathComponents.contains("sid"){
            showScreen(index: 2)
        }else{
            showScreen(index: 0)
        }
        
        
        let array = url.absoluteString.split(separator: "&")
        return true
    }
    
    
    //MARK:- myown functions
    
    func currentTopViewController() -> UIViewController {
        var topVC: UIViewController?
        if #available(iOS 13.0, *){
            topVC = (self.window?.rootViewController)
            
        }else{
            topVC  = self.window?.rootViewController
        }
        while ((topVC?.presentedViewController) != nil) {
            topVC = topVC?.presentedViewController
        }
        return topVC!
    }
}

extension UIWindow {
    
    public var visibleViewController: UIViewController? {
        return UIWindow.visibleViewController(from: rootViewController)
    }
    
    public static func visibleViewController(from viewController: UIViewController?) -> UIViewController? {
        switch viewController {
        case let navigationController as UINavigationController:
            return UIWindow.visibleViewController(from: navigationController.visibleViewController ?? navigationController.topViewController)
        case let tabBarController as UITabBarController:
            return UIWindow.visibleViewController(from: tabBarController.selectedViewController)
        case let presentingViewController where viewController?.presentedViewController != nil:
            return UIWindow.visibleViewController(from: presentingViewController?.presentedViewController)
        default:
            return viewController
        }
    }
}

extension AppDelegate{
    func starUpPage(){
        DispatchQueue.main.async {
            self.window?.rootViewController = StarUpPage
            self.dismissViewControllers()
        }
    }
    
    func permissionPage(){
        DispatchQueue.main.async {
            self.window?.rootViewController = Permission
            self.dismissViewControllers()
        }
    }
    
    func loginPage(){
        DispatchQueue.main.async {
            guard let domain = Bundle.main.bundleIdentifier else { return }
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set(false, forKey: FIRSTTIME)
            UserDefaults.standard.set(true, forKey: AUTHORISED)
            MAINTABBARPAGE.viewControllers?.removeAll()
            self.window?.rootViewController = Login
            self.dismissViewControllers()
        }
    }
    
    func homePage(){
        self.dismissViewControllers()
        DispatchQueue.main.async {
            if let _ = UserDefaults.standard.value(forKey: USERAVAILABLE){
                if let _ = UserDefaults.standard.value(forKey: USERID){
                    //do coding
                }else{
                    UserDefaults.standard.set(0, forKey: USERID)
                }
                self.currentLocation()
                MAINTABBARPAGE.setUPViewController()
                MAINTABBARPAGE.selectedIndex = 0
                self.window?.rootViewController = MAINTABBARPAGE
                self.dismissViewControllers()
            }else{
                self.loginPage()
            }
        }
    }
}

extension AppDelegate : CLLocationManagerDelegate{
    func currentLocation(){
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                debugPrint("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                debugPrint("Access")
                locationManager.delegate = self
            }
        }else{
            debugPrint("Location services are not enabled")
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
//MARK:- Checking network reachability

extension AppDelegate : MessagingDelegate{
    func checkNetworkRechability() {
        do {
            Network.reachability = try ReachabilityManager(hostname: "www.google.com")
            try Network.reachability?.start()
            NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        } catch {
            print(error)
        }
    }
    
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            AlertBar.show(type: .warning, message: "Offline", duration: 10)
            self.showNoWifiView()
        case .wifi:
            AlertBar.show(type: .success, message: "Online", duration: 5)
            AlertBar.hide()
            self.homePage()
        case .wwan:
            AlertBar.show(type: .success, message: "Online", duration: 5)
            self.homePage()
        }
    }
    
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    func showNoWifiView(){
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                self.window?.rootViewController = noWifi
                self.window?.makeKeyAndVisible()
            }else{
                self.window?.rootViewController = noWifi
            }
        }
    }
    
    func dismissViewControllers() {
        self.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
            UserDefaults.standard.set(result.token, forKey: FIREBASETOKEN)//value(forKey:FIREBASETOKEN)
//            self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
          }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        debugPrint("notification : ",userInfo)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        debugPrint("remoteMessage : ",remoteMessage)
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        debugPrint("Did Recieving notification : ",notification)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
              willPresent notification: UNNotification,
              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        debugPrint("notification : ",notification)
        
    }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        debugPrint("user activity ",userActivity.webpageURL?.absoluteURL)
        if ((userActivity.webpageURL?.absoluteString)?.contains("sid"))!{
            showScreen(index: 2)
            var dic : Dictionary<String,Any> = Dictionary<String,Any>()
            dic["url"] = userActivity.webpageURL?.absoluteURL
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("shopDeepLink"), object: nil,userInfo: dic)
//
            return true
        }else if ((userActivity.webpageURL?.absoluteString)?.contains("pid"))!{
            showScreen(index: 0)
            var dic : Dictionary<String,Any> = Dictionary<String,Any>()
            dic["url"] = userActivity.webpageURL?.absoluteURL
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("productDeepLink"), object: nil,userInfo: dic)
            return true
        }else{
           return false
        }
        
        
    }
    func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        debugPrint("failed user activity")
    }
    
    func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
        debugPrint("user activity didUpdate ",userActivity.webpageURL?.absoluteURL)
    }
}
