//
//  SecondViewController.swift
//  GovIsland
//
//  Created by janice on 1/20/16.
//  Copyright © 2016 Janice. All rights reserved.
//

import UIKit

class ExploreViewController : UITableViewController
{
    var selectArray :[String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
    
    func configureTableView()
    {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.allowsSelection = false
        tableView.separatorStyle = .None
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
        
        let exploreCell :UITableViewCell = tableView.dequeueReusableCellWithIdentifier("exploreTableCell")!
        
        exploreCell.textLabel?.text = selectArray[indexPath.row]
        
        return exploreCell
       
    }


}

