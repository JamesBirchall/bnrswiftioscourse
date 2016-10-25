//
//  LocationPins.swift
//  WorldTrotter
//
//  Created by James Birchall on 25/10/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import Foundation
import MapKit

class LocationPin: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D

    var title: String?
    
    var subtitle: String?
    
    init(location: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = location
        self.title = title
        self.subtitle = subtitle
    }
}
