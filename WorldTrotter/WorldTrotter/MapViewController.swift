//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by James Birchall on 16/10/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var mapView: MKMapView! // implicity unwrapped optional - not needed to setup in init()
    var locationManager: CLLocationManager!
    
    var pinsAdded = false
    
    override func loadView() {
        
        mapView = MKMapView()
        
        locationManager = CLLocationManager()
        
        view = mapView //set map to the view - no need to set frame
        
        // segmented control view
        let segmentedControl = UISegmentedControl(items: ["Standard","Hybrid","Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(segmentedControl)   // add to current view
        
        let locationButton = UIButton(type: .infoDark)
        locationButton.setTitle("Show Location", for: .normal)
        locationButton.addTarget(self, action: #selector(self.findLocationPressed), for: .touchUpInside)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(locationButton)
        
        //let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.topAnchor)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        //let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        //let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        let buttonBottomConstraint = locationButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -30)
        let buttonLeadingConstraint = locationButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let buttonTrailingConstraint = locationButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        buttonBottomConstraint.isActive = true
        buttonLeadingConstraint.isActive = true
        buttonTrailingConstraint.isActive = true
        
        segmentedControl.addTarget(self, action: #selector(self.mapTypeChanged), for: .valueChanged)
        
        pinsAdded = false   // so we can reset the annotations
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print("MapViewController loaded its view.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.locationManager.delegate = self
    }
    
    func mapTypeChanged(segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    func findLocationPressed() {
        //print("Pressed find location!")
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
            
            if !pinsAdded {
                addPinsToMap()
                pinsAdded = true
            }
        } else {
            self.locationManager.requestWhenInUseAuthorization()
            findLocationPressed()
        }
        
    }
    
    func addPinsToMap() {
        
    let bornLocationPin = LocationPin(location: CLLocationCoordinate2D.init(latitude: 51.068785, longitude: -1.794472), title: "Born Here!", subtitle: "I was born Here!")
        
        mapView.addAnnotation(bornLocationPin)
//        let salisburyBorn = MKMapPoint
//        salisburyBorn.pinTintColor = UIColor.red
//        salisburyBorn.
        //mapView.addAnnotation(salisburyBorn)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("Location updated...")
        
        let location = locations.last
        let centre = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegionMakeWithDistance(centre, 500, 500)
        
        print(centre)   // this value doesn't appear to change...
        
        self.mapView.setRegion(region, animated: true)
        self.mapView.showsTraffic = true
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error With Location: \(error.localizedDescription)")
    }
}
