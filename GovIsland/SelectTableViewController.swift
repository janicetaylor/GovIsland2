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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // TODO: put this in an object to encapsulate?
        
        let userdefaults = NSUserDefaults.standardUserDefaults()
        let isFirstTime = true
        userdefaults.setBool(isFirstTime, forKey: "isFirstTime")
        
        settingsArray = userdefaults.objectForKey("locationsToLoad") as! Array
        
        let selectNib = UINib(nibName: "SelectTableViewCell", bundle: nil)
        tableView.registerNib(selectNib, forCellReuseIdentifier:"SelectCell")
        
        // TODO: put this in a plist?
        
        loadTableTitlesFromPlist()
        styleNavigationBar()
        configureTableView()
    }
    
    
    func styleNavigationBar() {
        self.navigationItem.title = "Filter"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 210.0/255.0, green: 35.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 18.0)!, NSForegroundColorAttributeName:UIColor.whiteColor()]
    }
    
    
    func loadTableTitlesFromPlist() {
        if let path = NSBundle.mainBundle().pathForResource("govisland", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {

                let filterList = dict["filterOptions"] as! Array<String>
                selectArray = filterList
                
                }
            }
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let selectCell: SelectTableViewCell = tableView.dequeueReusableCellWithIdentifier("SelectCell", forIndexPath: indexPath) as! SelectTableViewCell
        
       selectCell.titleLabel.text = selectArray[indexPath.row]
        
       let settingsValue = settingsArray[indexPath.row]
       selectCell.titleSwitch.setOn(settingsValue, animated: false)
        
       selectCell.titleSwitch.tag = indexPath.row
       selectCell.titleSwitch.addTarget(self, action: #selector(SelectTableViewController.switchChanged(_:)), forControlEvents: .TouchUpInside)
        
       return selectCell
    }
    
    
    func switchChanged(selectedswitch :UISwitch) {
        settingsArray[selectedswitch.tag] = selectedswitch.on
        
        let userdefaults = NSUserDefaults.standardUserDefaults()
        userdefaults.setObject(settingsArray, forKey: "locationsToLoad")
    }
    
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.allowsSelection = false
        tableView.separatorStyle = .None
    }
     
}
