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
    
    var urlArray :[String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureMap()
        
        self.navigationItem.title = "Map"
        
        let selectBarButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action:#selector(MapViewController.selectFeed))
        self.navigationItem.rightBarButtonItem = selectBarButton
    }
    
    
    func configureMap()
    {
        mapView.scrollEnabled = true
        mapView.zoomEnabled = true
        mapView.showsUserLocation = true
        
        // center on fort jay
        let initialLocation = CLLocation(latitude: 40.6889918, longitude: -74.0190287)
        centerMapOnLocation(initialLocation)
        
        // go through saved preferences and load switch settings 
        // if first time, load in the first one?
        
//        0 - army buildings
//        1 - army houses
//        2 - food
//        3 - restroooms
//        4 - landmarks
//        5 - open spaces
//        6 - points of interest
//        7 - recreation
        
        urlArray = ["http://www.meladori.com/work/govisland/armybuildings.json",
                    "http://www.meladori.com/work/govisland/armyhouses.json",
                    "http://www.meladori.com/work/govisland/food.json",
                    "http://www.meladori.com/work/govisland/restrooms.json",
                    "http://www.meladori.com/work/govisland/landmarks.json",
                    "http://www.meladori.com/work/govisland/openspaces.json",
                    "http://www.meladori.com/work/govisland/pointsofinterest.json",
                    "http://www.meladori.com/work/govisland/recreation.json"]
        
        let foodUrl :String = "http://www.meladori.com/work/govisland/food.json"
        // let restroomUrl :String = "http://www.meladori.com/work/govisland/restrooms.json"
        
        updateMapWithFeed(foodUrl)
        // updateMapWithFeed(restroomUrl)
        
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

