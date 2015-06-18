//
//  ViewController.swift
//  Where am I
//
//  Created by Aida Legrand on 17.06.15.
//  Copyright (c) 2015 Aida Legrand. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var map: MKMapView!
    
    @IBOutlet var userLatitude: UILabel!
    
    @IBOutlet var userLongitude: UILabel!
    
    @IBOutlet var userSpeed: UILabel!
    
    @IBOutlet var userCourse: UILabel!
    
    @IBOutlet var userAdress: UILabel!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var userLocation:CLLocation = locations[0] as! CLLocation
        
        // показываем карту
        var latDelta:CLLocationDegrees = 0.001
        
        var longDelta:CLLocationDegrees = 0.001
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        self.map.setRegion(region, animated: true)
        
        // выдаем данные пользователю
        userLatitude.text = "\(userLocation.coordinate.latitude)"
        userLongitude.text = "\(userLocation.coordinate.longitude)"
        userSpeed.text = "\(userLocation.speed)"
        userCourse.text = "\(userLocation.course)"
        
        // грабим адрес
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            
            if error != nil {
                println(error)
            } else {
                
                if let p = CLPlacemark(placemark: placemarks?[0] as! CLPlacemark) {
                    
                    // потому что если пользователь едет быстро, номер дома может не успеть подгрузиться
                    var subThoroughfare:String  = ""
                    
                    if (p.subThoroughfare != nil) {
                        subThoroughfare = p.subThoroughfare
                    }
                    
                    self.userAdress.text = "\(subThoroughfare) \(p.thoroughfare) \n \(p.subAdministrativeArea), \(p.postalCode) \(p.country)"
                    
                }
                
            }
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

