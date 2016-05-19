//
//  SelectTableViewCell.swift
//  GovIsland
//
//  Created by janice on 4/1/16.
//  Copyright © 2016 Janice. All rights reserved.
//

import UIKit

class SelectTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleSwitch: UISwitch!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var filterButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
