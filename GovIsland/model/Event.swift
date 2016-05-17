//
//  Event.swift
//  GovIsland
//
//  Created by janice on 5/17/16.
//  Copyright © 2016 Janice. All rights reserved.
//

import UIKit

class Event: NSObject {
    
    var location: String?
    var about: String?
    var title: String?
    var url: String?
    var time: String!
    var date: NSDate!
    
    init(location: String, about: String, title: String, url: String, time: String, date: NSDate) {
        self.location = location
        self.title = title
        self.about = about
        self.url = url
        self.time = time
        self.date = date
    }

}
