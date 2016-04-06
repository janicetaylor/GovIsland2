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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager?
    var urlArray :[String] = []
    var settingsArray :[Bool] = []
    var imageIconArray :[String] = []

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        configureMap()
        
        self.navigationItem.title = "Map"
        
        let selectBarButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action:#selector(MapViewController.selectFeed))
        self.navigationItem.rightBarButtonItem = selectBarButton
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        updateMap()
    }
    
    func configureMap()
    {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = true
        
        if CLLocationManager.locationServicesEnabled() {
            
            let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            if status == CLAuthorizationStatus.NotDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            
            locationManager.startUpdatingLocation()
            self.locationManager = locationManager
            
        } else {
            print("locationServices not enabled")
        }
        
        mapView.scrollEnabled = true
        mapView.zoomEnabled = true
        mapView.showsUserLocation = true
        
        // center on fort jay
        let initialLocation = CLLocation(latitude: 40.6889918, longitude: -74.0190287)
        centerMapOnLocation(initialLocation)
        
        // go through saved preferences and load switch settings 
        // if first time, load in the first one?
        
        // category ids
//        1 - army buildings
//        2 - army houses
//        3 - food
//        4 - restroooms
//        5 - landmarks
//        6 - open spaces
//        7 - points of interest
//        8 - recreation
        
        urlArray = ["http://www.meladori.com/work/govisland/armybuildings.json",
                    "http://www.meladori.com/work/govisland/armyhouses.json",
                    "http://www.meladori.com/work/govisland/food.json",
                    "http://www.meladori.com/work/govisland/restrooms.json",
                    "http://www.meladori.com/work/govisland/landmarks.json",
                    "http://www.meladori.com/work/govisland/openspaces.json",
                    "http://www.meladori.com/work/govisland/pointsofinterest.json",
                    "http://www.meladori.com/work/govisland/recreation.json"]
    }
    
    
    func updateMap()
    {
        let userdefaults = NSUserDefaults.standardUserDefaults()
        let isFirstTime = userdefaults.boolForKey("isFirstTime")
        
        if(isFirstTime == false) {
            settingsArray = [false, false, true, false, false, false, false, false]
            userdefaults.setObject(settingsArray, forKey: "locationsToLoad")
        }
            
        else {
            settingsArray = userdefaults.objectForKey("locationsToLoad") as! Array
        }
        
        removeAllAnnotations()
        
        for(index, item) in settingsArray.enumerate() {
            if(item == true) {
                let urlToLoad = urlArray[index]
                print(urlToLoad)
                updateMapWithFeed(urlToLoad, categoryId: index)
            }
        }

    }
    
    
    func removeAllAnnotations()
    {
        mapView.removeAnnotations(mapView.annotations)
        mapView.showsUserLocation = true
    }
    
    
    func selectFeed()
    {
        let selectTableViewController = SelectTableViewController()
        self.navigationController?.pushViewController(selectTableViewController, animated: true)
    }
    

    func updateMapWithFeed(feedUrlString: String, categoryId: Int)
    {
        
        Alamofire.request(.GET, feedUrlString).responseJSON { response in
            
            let swiftyJsonVar = JSON(response.result.value!)
            
            for (_,subJson):(String, JSON) in swiftyJsonVar {
                
                for (_,secondaryJson):(String, JSON) in subJson {
                    
                    for(_, tertiaryJson):(String, JSON) in secondaryJson {
                        
                        let mylatitude = tertiaryJson["latitude"].doubleValue
                        let mylongitude = tertiaryJson["longitude"].doubleValue
                        let title = tertiaryJson["name"].stringValue
                        
//                        print("mylat : \(mylatitude)")
//                        print("mylong : \(mylongitude)")
//                        print("title : \(title) categoryId : \(categoryId)")

                        
                        let mycoordinate = CLLocationCoordinate2D(latitude:mylatitude, longitude:mylongitude)
                        let location = Location(coordinate: mycoordinate, title: title, subtitle: "", categoryId: categoryId)
                        
                        
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
    
    
    // MARK: - MKMapViewDelegate methods

    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        imageIconArray = ["annotation-armybuildings",
                          "annotation-armyhouses",
                          "annotation-food",
                          "annotation-restrooms",
                          "annotation-landmarks",
                          "annotation-openspaces",
                          "annotation-pointsofinterest",
                          "annotation-recreation"]

        
        if let annotation = annotation as? Location {
            
            let identifier = "pin"
            var pinAnnotationView: MKAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                pinAnnotationView = dequeuedView
                dequeuedView.image = UIImage(named: imageIconArray[annotation.categoryId!])
                
            } else {
                
                // TODO: move this to a plist?
                
                pinAnnotationView = MKAnnotationView()
                pinAnnotationView.annotation = annotation
                pinAnnotationView.image = UIImage(named: imageIconArray[annotation.categoryId!])
                pinAnnotationView.canShowCallout = true
                return pinAnnotationView
                
            }
            return pinAnnotationView
        }
        return nil
        
    }
    
    



}

