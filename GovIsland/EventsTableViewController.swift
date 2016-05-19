//
//  EventsTableViewController.swift
//  GovIsland
//
//  Created by janice on 5/17/16.
//  Copyright © 2016 Janice. All rights reserved.
//

import UIKit
import EventKit
import SwiftyJSON

class EventsTableViewController: UITableViewController {
    
    var eventArray :[Event] = []
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventNib = UINib(nibName: "EventsTableViewCell", bundle: nil)
        tableView.registerNib(eventNib, forCellReuseIdentifier:"eventsTableViewCell")
        
        configureTableView()
        populateTable()
        styleNavigationBar()
    }
    
    func populateTable() {
        
        // TODO: loading this locally for now, should cache and load this dynamically?
        
        let path = NSBundle.mainBundle().pathForResource("events", ofType: "json")
        
        if let data = NSData(contentsOfFile: path!) {
            let json = JSON(data: data)
            
            for(_,subJson):(String, JSON) in json {
                
                let eventsJson = subJson["event"]
                
                for(_,secondaryJson):(String, JSON) in eventsJson {
                    
                    let location = secondaryJson["location"].stringValue
                    let about = secondaryJson["about"].stringValue
                    let title = secondaryJson["title"].stringValue
                    let url = secondaryJson["link"].stringValue
                    let time = secondaryJson["time"].stringValue
                    let datestring = secondaryJson["date"].stringValue
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let date = dateFormatter.dateFromString(datestring)
                    
                    let event:Event = Event(location: location, about: about, title: title, url: url, time: time, date: date!)
                    
                    eventArray.append(event)
                    
                }
                
            }
        
        }
        
    }
    
    func styleNavigationBar() {
        self.navigationItem.title = "Events"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 210.0/255.0, green: 35.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 18.0)!, NSForegroundColorAttributeName:UIColor.whiteColor()]
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.allowsSelection = false
        tableView.separatorStyle = .SingleLine
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.revealViewController().rearViewRevealWidth = 140
        
    }
    
    
    func addEventToCalendar(title title: String, description: String?, startDate: NSDate, endDate: NSDate, completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccessToEntityType(.Event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.saveEvent(event, span: .ThisEvent)
                } catch let e as NSError {
                    completion?(success: false, error: e)
                    return
                }
                completion?(success: true, error: nil)
            } else {
                completion?(success: false, error: error)
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let eventsCell: EventsTableViewCell = tableView.dequeueReusableCellWithIdentifier("eventsTableViewCell", forIndexPath: indexPath) as! EventsTableViewCell
        
        let event:Event = eventArray[indexPath.row]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.stringFromDate(event.date)
        
        eventsCell.titleLabel.text = event.title
        eventsCell.aboutLabel.text = event.about
        eventsCell.dateLabel.text = "\(dateString) at \(event.time) in \(event.location)"
        eventsCell.calendarButton.tag = indexPath.row
        eventsCell.calendarButton.addTarget(self, action:#selector(EventsTableViewController.didAddToCalendar), forControlEvents:UIControlEvents.TouchUpInside)
        eventsCell.separatorInset = UIEdgeInsetsZero
        
        return eventsCell
    }
 
    func didAddToCalendar(sender:UIButton) {
        
        let eventSelected:Event = eventArray[sender.tag]
        
        print("adding event to calendar : \(eventSelected.title)")
        print("date adding to calendar : \(eventSelected.date)")
        
        addEventToCalendar(title: eventSelected.title, description: eventSelected.about, startDate: eventSelected.date, endDate: eventSelected.date)
        
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
