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
    var setLocationBorn = false
    var setLocationLive = false
    var setInterestingLocation = false
    
    var pinsAdded = false
    
    override func loadView() {
        
        mapView = MKMapView()
        
        locationManager = CLLocationManager()
        
        view = mapView //set map to the view - no need to set frame
        
        // segmented control view
        
        // for localisation setup strings correctly
        let standardString = NSLocalizedString("Standard", comment: "Standard Map View")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid Map View")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite Map View")
        
        let segmentedControl = UISegmentedControl(items: [standardString, hybridString, satelliteString])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)   // add to current view
        
        let findMeString = NSLocalizedString("Find Me", comment: "Find My Location")
        let locationButton = UIButton(type: .system)
        locationButton.setTitle(findMeString, for: .normal)
        locationButton.addTarget(self, action: #selector(self.findLocationPressed), for: .touchUpInside)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationButton)
        
        // add strings for localisation into other languages
        let bornString = NSLocalizedString("Born", comment: "Born Location")
        let homeString = NSLocalizedString("Home", comment: "Home Location")
        let aucklandString = NSLocalizedString("Auckland", comment: "Auckland Location")
        let segmentControlPins = UISegmentedControl(items: [bornString, homeString, aucklandString])
        segmentControlPins.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentControlPins.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentControlPins)
        

        // we want Segment Control 1 in middle, at top
        // we want Segment Control 2 in middle, at bottom
        // we want Find Me button in middle, ontop of Segment Control 2

        let margins = view.layoutMarginsGuide   // get superviews layout
        
        segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        
        
        segmentControlPins.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        segmentControlPins.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        segmentControlPins.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -25).isActive = true
        
        locationButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        locationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // add target actions for the 2 controls and button
        locationButton.addTarget(self, action: #selector(findLocationPressed), for: .touchUpInside)
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(segControl:)), for: .valueChanged)
        segmentControlPins.addTarget(self, action: #selector(addPinsToMap(segControl:)), for: .valueChanged)
        
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
            if !setLocationBorn {
                mapView.addAnnotation(bornLocationPin)
                setLocationBorn = true
            }
            let centre = CLLocationCoordinate2D(latitude: 51.068785, longitude: -1.794472)
            let region = MKCoordinateRegionMakeWithDistance(centre, 500, 500)
            self.mapView.setRegion(region, animated: true)
        case 1:
            let homeLocationPin = LocationPin(location: CLLocationCoordinate2D.init(latitude: 51.656489,
                                                                                    longitude: -0.390320), title: "Home is Here!", subtitle: "I live here!")
            if !setLocationLive {
                mapView.addAnnotation(homeLocationPin)
                setLocationLive = true
            }
            let centre = CLLocationCoordinate2D(latitude: 51.656489, longitude: -0.390320)
            let region = MKCoordinateRegionMakeWithDistance(centre, 500, 500)
            self.mapView.setRegion(region, animated: true)
        case 2:
            let aucklandLocationPin = LocationPin(location: CLLocationCoordinate2D.init(latitude: -36.848460,
                                                                                    longitude: 174.763332), title: "Interesting place!", subtitle: "Hey it's Auckland NZ!")
            if !setInterestingLocation {
                mapView.addAnnotation(aucklandLocationPin)
                setInterestingLocation = true
            }
            let centre = CLLocationCoordinate2D(latitude: -36.848460, longitude: 174.763332)
            let region = MKCoordinateRegionMakeWithDistance(centre, 500, 500)
            self.mapView.setRegion(region, animated: true)
        default:
            break
        }
        
    
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("Location updated...")
        
        let location = locations.last
        let centre = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegionMakeWithDistance(centre, 500, 500)
        
        //print(centre)   // this value doesn't appear to change...
        
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error With Location: \(error.localizedDescription)")
    }
}
