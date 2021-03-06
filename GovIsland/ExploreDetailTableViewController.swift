//
//  ExploreDetailTableViewController.swift
//  GovIsland
//
//  Created by janice on 4/19/16.
//  Copyright © 2016 Janice. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit
import SDWebImage


class ExploreDetailTableViewController: UITableViewController {
    
    var titleArray :[String] = []
    var urlArraylist :[String] = []
    var thumbnailArray :[String] = []
    var locationArray :[Location] = []
    var pathArray :[String] = []
    var baseUrl :String = ""
    var prefixUrl :String = ""
    var categoryPrefix :String = ""

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadArraysFromPlist()
        configureTableView()
        styleNavigationBar()
        
        let exploreNib = UINib(nibName: "ExploreDetailTableViewCell", bundle: nil)
        tableView.registerNib(exploreNib, forCellReuseIdentifier:"exploreDetailTableViewCell")
    }
    
    
    func styleNavigationBar() {
        self.navigationController!.navigationBar.topItem!.title = ""
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 210.0/255.0, green: 35.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 18.0)!, NSForegroundColorAttributeName:UIColor.whiteColor()]
    }

    
    func loadArraysFromPlist() {
        if let path = NSBundle.mainBundle().pathForResource("govisland", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
                baseUrl = dict["baseUrl"] as! String
                let urlArrayList = dict["urlPrefixes"] as! Array<String>
                urlArraylist = urlArrayList
                
                for urlString in urlArrayList {
                    pathArray.append("\(baseUrl)\(urlString).json")
                    prefixUrl = baseUrl
                }
            }
        }
        
    }
    
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.allowsSelection = true
        tableView.separatorStyle = .None
        tableView.separatorInset = UIEdgeInsetsZero
    }
    
    
    func updateTableWithCache(lookup :Int) {
        
        print("pathArray : \(pathArray)")
        
        let urlToLoad = pathArray[lookup]
        let cache = NSURLCache.sharedURLCache()
        
        let url = NSURL(string:urlToLoad)
        let urlRequest = NSURLRequest(URL: url!)
        
        if let response = cache.cachedResponseForRequest(urlRequest) {
            
            let jsonData = JSON(data: response.data)
            
            locationArray = []
            
            // print("jsonData from cache : \(jsonData)")
            
            for (_,subJson):(String, JSON) in jsonData {
                
                for (_,secondaryJson):(String, JSON) in subJson {
                    
                    self.navigationItem.title = subJson["title"].stringValue
                    
                    for(_, tertiaryJson):(String, JSON) in secondaryJson {
                        
                        let mylatitude = tertiaryJson["latitude"].doubleValue
                        let mylongitude = tertiaryJson["longitude"].doubleValue
                        let title = tertiaryJson["name"].stringValue
                        let imageUrl = tertiaryJson["image"].stringValue
                        let copy = tertiaryJson["copy"].stringValue
                        let mycoordinate = CLLocationCoordinate2D(latitude:mylatitude, longitude:mylongitude)
                        let urlString = "\(prefixUrl)\(urlArraylist[lookup])" + "/" + "\(imageUrl)"
                        let location = Location(coordinate: mycoordinate, title: title, subtitle: copy, categoryId: lookup, thumbnailUrl: urlString)
                        
                        locationArray.append(location)
                        titleArray.append(title)
                        thumbnailArray.append(imageUrl)
                        categoryPrefix = urlArraylist[lookup]

                        
                    }
                }
            }
            
        }
        
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let exploreCell: ExploreDetailTableViewCell = tableView.dequeueReusableCellWithIdentifier("exploreDetailTableViewCell", forIndexPath: indexPath) as! ExploreDetailTableViewCell
        
        exploreCell.titleView.text = titleArray[indexPath.row]
        
        let urlString = "\(prefixUrl)\(categoryPrefix)" + "/" +  "\(thumbnailArray[indexPath.row])"
        let url = NSURL(string:urlString)
        
        exploreCell.thumbnailImageView.sd_setImageWithURL(url)
        
        // TODO : add placeholder image, add activity indicator
        // [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.domain.com/path/to/image.jpg"]
        // placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        return exploreCell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewControllerWithIdentifier("ExploreDetailWebViewController") as! ExploreDetailViewController
        
        detailViewController.locationDetail = locationArray[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
