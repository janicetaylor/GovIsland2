//
//  DownloadCache.swift
//  GovIsland
//
//  Created by janice on 4/20/16.
//  Copyright © 2016 Janice. All rights reserved.
//

import Foundation
import UIKit

class DownloadCache: NSObject
{
    
    func downloadJson() {
        let cache = Cache<JSON>(name: "github")
        let URL = NSURL(string: "https://api.github.com/users/haneke")!
        
        cache.fetch(URL: URL).onSuccess { JSON in
            print(JSON.dictionary?["bio"])
        }
    }

}
