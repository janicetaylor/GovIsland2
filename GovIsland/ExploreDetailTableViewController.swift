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

class ExploreDetailTableViewController: UITableViewController {
    
    var titleArray :[String] = []
    var locationArray :[Location] = []
    var filenameArray :[String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureTableView()
        
        // look up the list based on the index 
        
        // ask the cache? 

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
       
    }
    
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.allowsSelection = true
        tableView.separatorStyle = .None
        tableView.separatorInset = UIEdgeInsetsZero
    }

    
    func populateTableWithIndex(lookup:Int)
    {
        
        // TODO: put this in a plist
        
        var filenameArray :[String] = [ "armybuildings",
                                        "armyhomes",
                                        "food",
                                        "restrooms",
                                        "landmarks",
                                        "openspaces",
                                        "pointsofinterest",
                                        "recreation"]
        
        let fileName = filenameArray[lookup]
        
        // TODO: loading this locally for now, should cache and load this dynamically?
        
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json")
        
        if let data = NSData(contentsOfFile: path!) {
            let json = JSON(data: data)
            
                for(_,subJson):(String, JSON) in json {
                    
                    let locationJson = subJson["location"]
                    
                    for(_,secondaryJson):(String, JSON) in locationJson {
                        
                        // TODO: this is duplicate code, move it?

                        let mylatitude = secondaryJson["latitude"].doubleValue
                        let mylongitude = secondaryJson["longitude"].doubleValue
                        let title = secondaryJson["title"].stringValue
                        let subtitle = secondaryJson["copy"].stringValue
                        let thumbnailUrl = secondaryJson["image"].stringValue
                        
                        let mycoordinate = CLLocationCoordinate2D(latitude:mylatitude, longitude:mylongitude)
                        
                        let baseUrl :String = "http://www.meladori.com/work/govisland/\(fileName)/\(thumbnailUrl)"
                        
                        let location = Location(coordinate: mycoordinate, title: title, subtitle: subtitle, categoryId: lookup, thumbnailUrl: baseUrl)
                        
                        locationArray.append(location)
                        titleArray.append(title)
                        
                        self.navigationItem.title = subJson["title"].stringValue
                        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("exploreDetailTableViewCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewControllerWithIdentifier("ExploreDetailWebViewController") as! ExploreDetailViewController
        
        
        detailViewController.locationDetail = locationArray[indexPath.row]
    
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
