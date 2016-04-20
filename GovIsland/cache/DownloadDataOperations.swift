//
//  DownloadDataOperations.swift
//  GovIsland
//
//  Created by janice on 4/20/16.
//  Copyright © 2016 Janice. All rights reserved.
//

import Foundation
import UIKit

enum JSONState
{
    case New, Downloaded, Failed
}

class JSONInfo
{
    var name: String = ""
    var url: NSURL = NSURL()
    var state = JSONState.New
    
    init(name:String, url:NSURL) {
        self.name = name
        self.url = url
    }
    
}


class PendingOperations
{
    // tracks the status of each operation

    lazy var downloadsInProgress = [NSIndexPath:NSOperation]()
    lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "JSON download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}


//class JSONDownloader: NSOperation
//{
//    let jsonInfo: JSONInfo
//    
//    init(jsonData: JSONInfo) {
//        // self.jsonInfo = jsonInfo
//    }
//    
//    override func main() {
//        
//        // check for cancellation before starting
//        if self.cancelled {
//            return
//        }
//        
//        // start to download json 
//        
//        
//        // check for cancellation
//        
//        // if there is an object, change the state
//        
//        
//        
//    }
//    
//}


