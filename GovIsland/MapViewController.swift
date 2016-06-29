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
    var settingsArray :[Bool] = []
    var imageIconArray :[String] = []
    var annotationPointArray :[String] = []
    var locationArray :[Location] = []
    
    var didUpdateFromLocation :Bool = false
    var locationDetailToUpdate :Location = Location(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), title: "", subtitle: "", categoryId: 0, thumbnailUrl: "")
    var selectedLocationDetail :Location = Location(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), title: "", subtitle: "", categoryId: 0, thumbnailUrl: "")

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
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // check if it came from the settings view before updating
        updateMap()
        updateMapWithLocation()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func addListeners() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(MapViewController.storedCacheFinished), name: "storingCacheFinished", object: nil)
    }
    
    
    func storedCacheFinished(notification :NSNotification) {
        
            print(notification.userInfo!["urlString"])
        
            // let userInfo :[String:String!] = notification.userInfo as! [String:String!]
            // let categoryId = Int(userInfo["categoryId"]!)
            // let urlToLoad :String = userInfo["urlString"]!
            // let url = NSURL(string:urlToLoad)
            // let request = NSURLRequest(URL: url!)
        
            // updateMapWithCache(request, categoryId: categoryId!)
    }
    
    func loadArraysFromPlist() {
        if let path = NSBundle.mainBundle().pathForResource("govisland", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
                let baseUrl = dict["baseUrl"] as! String
                let urlArrayList = dict["urlPrefixes"] as! Array<String>
                imageIconArray = dict["annotationImageNames"] as! Array<String>
                annotationPointArray = dict["iconImageNames"] as! Array<String>
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
    
    
    func updateMapWithLocation() {
        if(didUpdateFromLocation) {
            removeAllAnnotations()
            var mapArray :[Location] = []
            mapArray.append(locationDetailToUpdate)
            updateMapWithLocations(mapArray)
            didUpdateFromLocation = false
        }
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
        
        removeAllAnnotations()
        
        for(index, item) in settingsArray.enumerate() {
            if(item == true) {
                    let urlToLoad = urlArray[index]
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
    
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    // MARK: - MKMapViewDelegate methods
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? Location {
            
            let identifier = "pin"
            var pinAnnotationView: MKAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                pinAnnotationView = dequeuedView
                
                dequeuedView.image = UIImage(named: imageIconArray[annotation.categoryId!])
                let detailButton = UIButton(type: UIButtonType.DetailDisclosure) as UIButton
                
                detailButton.addTarget(self, action: #selector(MapViewController.detailButtonSelected), forControlEvents: .TouchUpInside)
                detailButton.tag = annotation.categoryId!
                selectedLocationDetail = Location(coordinate: annotation.coordinate, title: annotation.title!, subtitle: annotation.subtitle!, categoryId: annotation.categoryId!, thumbnailUrl: annotation.thumbnailUrl!)
                
                dequeuedView.rightCalloutAccessoryView = detailButton
                
            } else {
                
                pinAnnotationView = MKAnnotationView()
                pinAnnotationView.annotation = annotation as Location
                pinAnnotationView.image = UIImage(named: imageIconArray[annotation.categoryId!])
                pinAnnotationView.canShowCallout = true
            
                
                let detailButton = UIButton(type: UIButtonType.DetailDisclosure) as UIButton
                
                detailButton.addTarget(self, action: #selector(MapViewController.detailButtonSelected(_:)), forControlEvents: .TouchUpInside)
                detailButton.tag = annotation.categoryId!
                
                // still wrong but getting there...
            
                
                pinAnnotationView.rightCalloutAccessoryView = detailButton
                
                let imageView = UIImageView(image: UIImage(named: annotationPointArray[annotation.categoryId!]))
                pinAnnotationView.leftCalloutAccessoryView = imageView
                
                return pinAnnotationView
                
            }
            return pinAnnotationView
        }
        return nil
        
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView)
    {
        
        // thumbnailUrl is blank and copy is blank... why?
        
        if let selectedAnnotation = mapView.selectedAnnotations[0] as? Location {
                selectedLocationDetail  = Location(coordinate: selectedAnnotation.coordinate, title: selectedAnnotation.title!, subtitle: selectedAnnotation.subtitle!, categoryId: selectedAnnotation.categoryId!, thumbnailUrl: selectedAnnotation.thumbnailUrl!)
        }
        
    }
    
    
    func detailButtonSelected(selectedButton :UIButton) {

        let navController = self.navigationController! as UINavigationController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewControllerWithIdentifier("ExploreDetailWebViewController") as! ExploreDetailViewController
        
        detailViewController.locationDetail = selectedLocationDetail
        
        // need to prefetch the data? this is coming up blank...
        
        
        navController.pushViewController(detailViewController, animated: true)
        
        
    }

}

