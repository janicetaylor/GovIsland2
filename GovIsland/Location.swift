//
//  Location.swift
//  GovIsland
//
//  Created by janice on 1/22/16.
//  Copyright © 2016 Janice. All rights reserved.
//

import UIKit
import MapKit

class Location: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
}
