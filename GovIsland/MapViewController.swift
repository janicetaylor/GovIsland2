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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    var locationManager: CLLocationManager?
    var urlArray :[String] = []
    // var filenameArray :[String] = []
    var settingsArray :[Bool] = []
    var imageIconArray :[String] = []
    var locationArray :[Location] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        
        loadArraysFromPlist()
        configureMap()
        styleSideBar()
        styleNavigationBar()
        addListeners()
        
        let downloadCache = DownloadCache()
        downloadCache.prefetchData()
        
        initializeSettings()

    }
    
    func addListeners() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(MapViewController.storedCacheFinished), name: "storingCacheFinished", object: nil)
    }
    
    
    func storedCacheFinished(notification :NSNotification) {
        
            print(notification.userInfo!["urlString"])
        
            let userInfo :[String:String!] = notification.userInfo as! [String:String!]
            let categoryId = Int(userInfo["categoryId"]!)
            let urlToLoad :String = userInfo["urlString"]!
            let url = NSURL(string:urlToLoad)
            let request = NSURLRequest(URL: url!)
        
            // updateMapWithCache(request, categoryId: categoryId!)
    }
    
    func loadArraysFromPlist() {
        if let path = NSBundle.mainBundle().pathForResource("govisland", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
                let baseUrl = dict["baseUrl"] as! String
                let urlArrayList = dict["urlPrefixes"] as! Array<String>
                for urlString in urlArrayList {
                    urlArray.append("\(baseUrl)\(urlString).json")
                }
            }
        }
        
    }
    
    func styleSideBar() {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.revealViewController().rearViewRevealWidth = 140
    }
    
    func styleNavigationBar() {
        self.navigationItem.title = "Map"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 210.0/255.0, green: 35.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 18.0)!, NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        filterButton.action = #selector(MapViewController.selectFeed)
        filterButton.target = self
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateMap()
    }
    
    func configureMap() {
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
    }
    
    
    func updateMap() {
        let userdefaults = NSUserDefaults.standardUserDefaults()
        let isFirstTime = userdefaults.boolForKey("isFirstTime")
        
          if(isFirstTime == false) {
            settingsArray = [false, false, true, false, false, false, false, false]
            userdefaults.setObject(settingsArray, forKey: "locationsToLoad")
          }

          else {
             settingsArray = userdefaults.objectForKey("locationsToLoad") as! Array
        }
        
        // TODO: bug with this... why do some annotations not get removed?
        
        removeAllAnnotations()
        
        print("updateMap : settingsArray : \(settingsArray)")
        
        for(index, item) in settingsArray.enumerate() {
            
            if(item == true) {

                    let urlToLoad = urlArray[index]
                
                    print("index : \(index) item : \(item) urlToLoad : \(urlToLoad)")
                
                    // let filenameToLoad :String = filenameArray[index]
                
                
                // !! TODO - ask the cache if this needs to be downloaded again
                
//                    let downloadCache = DownloadCache()
//                    downloadCache.downloadJsonWithUrl(urlToLoad, categoryId: index)
                    // updateMapWithFeed(urlToLoad, categoryId: index)
                
                    // updateMapWithLocalJson(filenameToLoad, categoryId: index)
                
                    let url = NSURL(string:urlToLoad)
                    let request = NSURLRequest(URL: url!)
                
                     updateMapWithCache(request, categoryId: index)

            }
        }

    }
    
    
    func removeAllAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.showsUserLocation = true
    }
    
    
    func initializeSettings() {
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
    }
    
    
    func selectFeed() {
        let selectTableViewController = SelectTableViewController()
        self.navigationController?.pushViewController(selectTableViewController, animated: true)
    }
    
    
    func updateMapWithLocalJson(fileName: String, categoryId: Int) {
        
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json")
        
        if let data = NSData(contentsOfFile: path!) {
            let json = JSON(data: data)
            
            //If json is .Dictionary
            for (_,subJson):(String, JSON) in json {
                
                for (_,secondaryJson):(String, JSON) in subJson {
                   
                    for(_, tertiaryJson):(String, JSON) in secondaryJson {
                     
                        let mylatitude = tertiaryJson["latitude"].doubleValue
                        let mylongitude = tertiaryJson["longitude"].doubleValue
                        let title = tertiaryJson["name"].stringValue
                        
                        let mycoordinate = CLLocationCoordinate2D(latitude:mylatitude, longitude:mylongitude)
                        
                        let location = Location(coordinate: mycoordinate, title: title, subtitle: "", categoryId: categoryId, thumbnailUrl: "")
                        
                        mapView.addAnnotation(location)
                        
                    }
                    
                }
            }
            
            
        }
        
    }

    
    func updateMapWithCache(urlRequest :NSURLRequest, categoryId :Int) {
        
        let cache = NSURLCache.sharedURLCache()
        
        // ask the cache if it has it?
        
        if let response = cache.cachedResponseForRequest(urlRequest) {
            
            let jsonData = JSON(data: response.data)
            
            locationArray = []
            
            // print("jsonData from cache : \(jsonData)")
            
                for (_,subJson):(String, JSON) in jsonData {
            
                        for (_,secondaryJson):(String, JSON) in subJson {
            
                                for(_, tertiaryJson):(String, JSON) in secondaryJson {
            
                                    let mylatitude = tertiaryJson["latitude"].doubleValue
                                    let mylongitude = tertiaryJson["longitude"].doubleValue
                                    let title = tertiaryJson["name"].stringValue
                                    let mycoordinate = CLLocationCoordinate2D(latitude:mylatitude, longitude:mylongitude)
                                    let location = Location(coordinate: mycoordinate, title: title, subtitle: "", categoryId: categoryId, thumbnailUrl: "")
            
                                    locationArray.append(location)
                                            
                                }
                        }
                }
            
            updateMapWithLocations(locationArray)
            
        }
        
    }
    
    
    func updateMapWithLocations(locationArray :Array<Location>) {
        for mapLocation in locationArray {
            mapView.addAnnotation(mapLocation)

        }
    }
    
    

    func updateMapWithFeed(feedUrlString: String, categoryId: Int) {
        
        Alamofire.request(.GET, feedUrlString).responseJSON { response in
            
            // TODO: sometimes this comes back as nil when unwrapping optional value?
            
            let swiftyJsonVar = JSON(response.result.value!)
                        
            for (_,subJson):(String, JSON) in swiftyJsonVar {
                
                for (_,secondaryJson):(String, JSON) in subJson {
                    
                    for(_, tertiaryJson):(String, JSON) in secondaryJson {
                        
                        let mylatitude = tertiaryJson["latitude"].doubleValue
                        let mylongitude = tertiaryJson["longitude"].doubleValue
                        let title = tertiaryJson["name"].stringValue
                        let mycoordinate = CLLocationCoordinate2D(latitude:mylatitude, longitude:mylongitude)
                        
                        let location = Location(coordinate: mycoordinate, title: title, subtitle: "", categoryId: categoryId, thumbnailUrl: "")
                        
                        self.mapView.addAnnotation(location)
                        
                    }
                }
                
            }
            
        }
        
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    // MARK: - MKMapViewDelegate methods
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        // TODO: move to plist 
        
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
                let detailButton = UIButton(type: UIButtonType.DetailDisclosure) as UIButton
                detailButton.addTarget(self, action: #selector(MapViewController.detailButtonSelected), forControlEvents: .TouchUpInside)
                dequeuedView.rightCalloutAccessoryView = detailButton
                
            } else {
                
                pinAnnotationView = MKAnnotationView()
                pinAnnotationView.annotation = annotation as Location
                pinAnnotationView.image = UIImage(named: imageIconArray[annotation.categoryId!])
                pinAnnotationView.canShowCallout = true
                
                let detailButton = UIButton(type: UIButtonType.DetailDisclosure) as UIButton
                detailButton.addTarget(self, action: #selector(MapViewController.detailButtonSelected(_:)), forControlEvents: .TouchUpInside)
                detailButton.tag = annotation.categoryId!
                
                pinAnnotationView.rightCalloutAccessoryView = detailButton
                
                return pinAnnotationView
                
            }
            return pinAnnotationView
        }
        return nil
        
    }
    
    
    func detailButtonSelected(selectedButton :UIButton) {
        tabBarController?.selectedIndex = 1
    }

}

