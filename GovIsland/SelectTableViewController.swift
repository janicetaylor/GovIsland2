//
//  SelectTableViewController.swift
//  GovIsland
//
//  Created by janice on 4/1/16.
//  Copyright © 2016 Janice. All rights reserved.
//

import UIKit

class SelectTableViewController: UITableViewController {
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let selectNib = UINib(nibName: "SelectTableViewCell", bundle: nil)
        tableView.registerNib(selectNib, forCellReuseIdentifier:"SelectCell")
        
       
        
        configureTableView()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 8
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {

        let selectCell: SelectTableViewCell = tableView.dequeueReusableCellWithIdentifier("SelectCell", forIndexPath: indexPath) as! SelectTableViewCell
        
        let selectArray :Array = [
            "Army Buildings",
            "Army Homes",
            "Food",
            "Restrooms",
            "Landmarks",
            "Open Spaces",
            "Points of Interest",
            "Recreation"
        ]
        
       selectCell.titleLabel.text = selectArray[indexPath.row]
       selectCell.titleSwitch.setOn(false, animated: true)
       selectCell.titleSwitch.tag = indexPath.row
  
       return selectCell
    }
    
    func configureSwitches()
    {
        
       // have a dictionary lookup for this, that gets passed from the view before it

       // something like this but this is crashing
        
//        let selectedCell :SelectTableViewCell
//        let selectedSwitch = selectedCell.contentView.viewWithTag(2) as! UISwitch
//        selectedSwitch.setOn(true, animated: false)
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