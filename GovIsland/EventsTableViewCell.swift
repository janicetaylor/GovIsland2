//
//  EventsTableViewCell.swift
//  GovIsland
//
//  Created by janice on 5/17/16.
//  Copyright © 2016 Janice. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
