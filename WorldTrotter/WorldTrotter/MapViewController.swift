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
        
        let locationButton = UIButton(type: .system)
        locationButton.setTitle("Find Me", for: .normal)
        locationButton.addTarget(self, action: #selector(self.findLocationPressed), for: .touchUpInside)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationButton)
        
        let segmentControlPins = UISegmentedControl(items: ["Born","Home","Auckland"])
        segmentControlPins.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentControlPins.selectedSegmentIndex  = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentControlPins)
        

        // we want Segment Control 1 in middle, at top
        // we want Segment Control 2 in middle, at bottom
        // we want Find Me button in middle, ontop of Segment Control 2

        let margins = view.layoutMarginsGuide   // get superviews layout
        
        segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        let segmentControlHeight = NSLayoutConstraint(item: segmentedControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30).isActive = true
        
        segmentControlPins.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        segmentControlPins.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        //segmentControlPins.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 50)
        
        self.updateViewConstraints()
        
        //let pinSegment = NSLayoutConstraint(item: segmentControlPins, attribute: .top, relatedBy:.greaterThanOrEqual, toItem: segmentedControl, attribute: .bottom, multiplier: 1.0, constant: 20.0).isActive = true
        
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
        } else {
            self.locationManager.requestWhenInUseAuthorization()
            findLocationPressed()
        }
        
    }
    
    func addPinsToMap(segControl: UISegmentedControl) {
        
        switch segControl.selectedSegmentIndex {
        case 0:
            let bornLocationPin = LocationPin(location: CLLocationCoordinate2D.init(latitude: 51.068785,
                                                                                    longitude: -1.794472), title: "Born Here!", subtitle: "I was born Here!")
            mapView.addAnnotation(bornLocationPin)
        case 1:
            let homeLocationPin = LocationPin(location: CLLocationCoordinate2D.init(latitude: 51.656489,
                                                                                    longitude: -0.390320), title: "Home is Here!", subtitle: "I live here!")
            mapView.addAnnotation(homeLocationPin)
        case 2:
            let aucklandLocationPin = LocationPin(location: CLLocationCoordinate2D.init(latitude: -36.848460,
                                                                                    longitude: 174.763332), title: "Interesting place!", subtitle: "Hey it's Auckland NZ!")
            mapView.addAnnotation(aucklandLocationPin)
        default:
            break
        }
        
    
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
