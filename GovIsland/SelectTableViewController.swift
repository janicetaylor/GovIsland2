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
        
        settingsArray = userdefaults.objectForKey("locationsToLoad") as! Array
        
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
        settingsArray[selectedswitch.tag] = selectedswitch.on
        
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
     
}
