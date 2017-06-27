//
//  MapViewController.swift
//  iOSTest
//
//  Created by Yulminator on 6/15/17.
//  Copyright © 2017 YuraPetrov. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    var zoom: Float = 15
    var firstPlace = Place()
    
    class Place {
        var checked = false
        var object: Object!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        setMarkers()
    }
    
    private func setMarkers() {
        for place in PlacesData.array {
        
            let marker = GMSMarker(position: place.location)
            if place.selected {
                if !firstPlace.checked {
                    firstPlace.object = place
                    firstPlace.checked = true
                }
                
                marker.title = place.title
                marker.map = mapView
                marker.icon = UIImage(named: "marker")
            }
        }
    }
    
    @IBAction func btnList(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showList", sender: self)
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
  
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if firstPlace.checked {
            
            mapView.camera = GMSCameraPosition(target: firstPlace.object.location, zoom: zoom, bearing: 0, viewingAngle: 0)
            mapView.padding = UIEdgeInsets(top: 100, left: 0, bottom: 60, right: 0)
            locationManager.stopUpdatingLocation()
        }
    }
}
