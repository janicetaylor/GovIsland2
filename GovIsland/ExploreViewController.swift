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
    var iconArray :[String] = []

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
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
        
        self.iconArray = [
            "icon-armybuildings",
            "icon-armyhomes",
            "icon-food",
            "icon-restrooms",
            "icon-landmarks",
            "icon-openspaces",
            "icon-pointsofinterest",
            "icon-recreation"
        ]
        
        configureTableView()
        styleNavigationBar()
        
    }
    
    func styleNavigationBar() {
        self.navigationItem.title = "Explore"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 210.0/255.0, green: 35.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 18.0)!, NSForegroundColorAttributeName:UIColor.whiteColor()]
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.allowsSelection = true
        tableView.separatorStyle = .None
        tableView.separatorInset = UIEdgeInsetsZero
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.revealViewController().rearViewRevealWidth = 140

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
        
        exploreCell.imageView?.image = UIImage(named:self.iconArray[indexPath.row])
        
        return exploreCell
       
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailExploreViewController = storyboard.instantiateViewControllerWithIdentifier("ExploreDetailTableViewController") as! ExploreDetailTableViewController
         
        detailExploreViewController.populateTableWithIndex(indexPath.row as Int)
        
        self.navigationController?.pushViewController(detailExploreViewController, animated: true)
        
    }


}

