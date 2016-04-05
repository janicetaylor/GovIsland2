//
//  SelectTableViewController.swift
//  GovIsland
//
//  Created by janice on 4/1/16.
//  Copyright © 2016 Janice. All rights reserved.
//

import UIKit

class SelectTableViewController: UITableViewController {
    
    var selectArray :[String] = []
    var settingsArray :[Bool] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // put this in an object to encapsulate...
        let userdefaults = NSUserDefaults.standardUserDefaults()
        let isFirstTime = true
        userdefaults.setBool(isFirstTime, forKey: "isFirstTime")
        print("isFirstTime : \(isFirstTime)")
        
        settingsArray = userdefaults.objectForKey("locationsToLoad") as! Array
        print("settingsArray : \(settingsArray)")
        
        let selectNib = UINib(nibName: "SelectTableViewCell", bundle: nil)
        tableView.registerNib(selectNib, forCellReuseIdentifier:"SelectCell")
        
        self.selectArray = [
            "Army Buildings",
            "Army Homes",
            "Food",
            "Restrooms",
            "Landmarks",
            "Open Spaces",
            "Points of Interest",
            "Recreation"
        ]
        
        configureTableView()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return selectArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {

        let selectCell: SelectTableViewCell = tableView.dequeueReusableCellWithIdentifier("SelectCell", forIndexPath: indexPath) as! SelectTableViewCell
        
       selectCell.titleLabel.text = selectArray[indexPath.row]
        
       let settingsValue = settingsArray[indexPath.row]
       selectCell.titleSwitch.setOn(settingsValue, animated: false)
        
       selectCell.titleSwitch.tag = indexPath.row
       selectCell.titleSwitch.addTarget(self, action: #selector(SelectTableViewController.switchChanged(_:)), forControlEvents: .TouchUpInside)
        
       return selectCell
    }
    
    
    func switchChanged(selectedswitch :UISwitch)
    {
        print("switchSelected : \(selectedswitch.tag) is on : \(selectedswitch.on)")
        
        settingsArray[selectedswitch.tag] = selectedswitch.on
        
        print("switched changed : settingsArray : \(settingsArray)")
        
        let userdefaults = NSUserDefaults.standardUserDefaults()
        userdefaults.setObject(settingsArray, forKey: "locationsToLoad")
        
    }
    
    
    func configureTableView()
    {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.allowsSelection = false
        tableView.separatorStyle = .None
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
