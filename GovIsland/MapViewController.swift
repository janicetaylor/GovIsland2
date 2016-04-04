//
//  FirstViewController.swift
//  GovIsland
//
//  Created by janice on 1/20/16.
//  Copyright © 2016 Janice. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import Alamofire
import Haneke

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // center on fort jay
        // http://www.meladori.com/work/govisland/food.json
        
        let initialLocation = CLLocation(latitude: 40.6889918, longitude: -74.0190287)
        centerMapOnLocation(initialLocation)
        
        let foodUrl :String = "http://www.meladori.com/work/govisland/food.json"
        // let restroomUrl :String = "http://www.meladori.com/work/govisland/restrooms.json"

        updateMapWithFeed(foodUrl)
        // updateMapWithFeed(restroomUrl)
        
        self.navigationItem.title = "Food"
        
        let selectBarButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action:#selector(MapViewController.selectFeed))
        self.navigationItem.rightBarButtonItem = selectBarButton
    }
    
    
    func selectFeed()
    {
        let selectTableViewController = SelectTableViewController()
        self.navigationController?.pushViewController(selectTableViewController, animated: true)
        
    }
    

    func updateMapWithFeed(feedUrlString: String)
    {
        
        Alamofire.request(.GET, feedUrlString).responseJSON { response in
            
            let swiftyJsonVar = JSON(response.result.value!)
            
            for (key,subJson):(String, JSON) in swiftyJsonVar {
                
                print("key: \(key)")
                print("subJson: \(subJson)")
                
                for (secondkey,secondaryJson):(String, JSON) in subJson {
                    print("secondkey: \(secondkey)")
                    print("secondaryJson: \(secondaryJson)")
                    
                    for(thirdkey, tertiaryJson):(String, JSON) in secondaryJson {
                        print("thirdkey: \(thirdkey)")
                        print("tertiaryJson: \(tertiaryJson)")
                        
                        let mylatitude = tertiaryJson["latitude"].doubleValue
                        let mylongitude = tertiaryJson["longitude"].doubleValue
                        let title = tertiaryJson["name"].stringValue
                        
                        print("mylat : \(mylatitude)")
                        print("mylong : \(mylongitude)")
                        print("title : \(title)")
                        
                        let mycoordinate = CLLocationCoordinate2D(latitude:mylatitude, longitude:mylongitude)
                        let location = Location(coordinate: mycoordinate, title: title, subtitle: "")
                        self.mapView.addAnnotation(location)
                        
                    }
                }
                
            }
            
        }
        
    }
    
    func centerMapOnLocation(location: CLLocation)
    {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }


}

