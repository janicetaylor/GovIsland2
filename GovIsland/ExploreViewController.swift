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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // put this in plist?
        
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
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.allowsSelection = true
        tableView.separatorStyle = .None
        tableView.separatorInset = UIEdgeInsetsZero
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let exploreCell :UITableViewCell = tableView.dequeueReusableCellWithIdentifier("exploreTableCell")!
        
        exploreCell.textLabel?.text = selectArray[indexPath.row]
        
        return exploreCell
       
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailExploreViewController = ExploreDetailTableViewController()
        
        detailExploreViewController.populateTableWithIndex(indexPath.row as Int)
        
        self.navigationController?.pushViewController(detailExploreViewController, animated: true)
        
    }


}

