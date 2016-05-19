//
//  DownloadCache.swift
//  GovIsland
//
//  Created by janice on 4/20/16.
//  Copyright © 2016 Janice. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit

class DownloadCache
{
    var manager :Manager = Manager()
    var locationArray :[Location] = []
    
    func downloadJsonWithUrl(urlString:String, categoryId:Int) {
        
        print("downloading json : \(urlString)")
        
        // Create a shared URL cache
        let memoryCapacity = 500 * 1024 * 1024; // 500 MB
        let diskCapacity = 500 * 1024 * 1024; // 500 MB
        let cache = NSURLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "shared_cache")
        
        // Create a custom configuration
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders
        configuration.HTTPAdditionalHeaders = defaultHeaders
        configuration.requestCachePolicy = .UseProtocolCachePolicy // this is the default
        configuration.URLCache = cache
        
        // Create your own manager instance that uses your custom configuration
        let manager = Alamofire.Manager.sharedInstance
        
        // let manager = Alamofire.Manager(configuration: configuration)
        
        // Make your request with your custom manager that is caching your requests by default
        manager.request(.GET, urlString, parameters: nil, encoding: .URL)
            .response { (request, response, data, error) in
                
                print("error: \(error)")
                
                let cachedURLResponse = NSCachedURLResponse(response: response!, data: (data! as NSData), userInfo: nil, storagePolicy: .Allowed)
                
                NSURLCache.sharedURLCache().storeCachedResponse(cachedURLResponse, forRequest: request!)
                
                    let json = JSON(data: data!)
                    
                    //If json is .Dictionary
                    for (_,subJson):(String, JSON) in json {
                        
                        for (_,secondaryJson):(String, JSON) in subJson {
                            
                            for(_, tertiaryJson):(String, JSON) in secondaryJson {
                                
                                // TODO: this is duplicate code, move it?
                                
                                let mylatitude = tertiaryJson["latitude"].doubleValue
                                let mylongitude = tertiaryJson["longitude"].doubleValue
                                let title = tertiaryJson["name"].stringValue
                                
                                let mycoordinate = CLLocationCoordinate2D(latitude:mylatitude, longitude:mylongitude)
                                
                                let location = Location(coordinate: mycoordinate, title: title, subtitle: "", categoryId: categoryId, thumbnailUrl: "")
                                
                                self.locationArray.append(location)
                                
                            }
                        }
                    }
        
                
                // Now parse the data using SwiftyJSON
                // This will come from your custom cache if it is not expired,
                // and from the network if it is expired
                
                // print("locationArray : \(self.locationArray)")
                
                let locationDictionary :[String:Array<Location>] = ["locations":self.locationArray]
                self.addValuesToPlistFile(locationDictionary)
    
        }
                
    }
    
    //1
    func getValuesInPlistFile() -> NSDictionary? {
        
        let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let destPath = (dir as NSString).stringByAppendingPathComponent("locations.plist") as String
        
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destPath) {
            guard let dict = NSDictionary(contentsOfFile: destPath) else { return .None }
            return dict
        } else {
            return .None
        }
    }
    
    //2
    func getMutablePlistFile() -> NSMutableDictionary? {
        
        let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let destPath = (dir as NSString).stringByAppendingPathComponent("locations.plist") as String
        
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destPath) {
            guard let dict = NSMutableDictionary(contentsOfFile: destPath) else { return .None }
            return dict
        } else {
            return .None
        }
    }
    
    //3
    func addValuesToPlistFile(dictionary : NSDictionary) {
        
        let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        var destPath = (dir as NSString).stringByAppendingPathComponent("locations.plist") as String
        let fileManager = NSFileManager.defaultManager()
        
        if !fileManager.fileExistsAtPath(destPath) {
            let plistPathInBundle = NSBundle.mainBundle().pathForResource("locations", ofType: "plist") as String!
            destPath = plistPathInBundle
        }
        
        print("destPath : \(destPath)")
        
        // TODO: plist isn't working hmmmmmm
        
        do {
            try dictionary.writeToFile(destPath, atomically: false)
        } catch{
            print("Error occurred while copying file to document \(error)")
        }
        
        
}
    
    
    
//    func loadDataPlist() {
//        
//        let paths :NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
//        let writePath = paths.stringByAppendingPathComponent("locations.plist")
//        
//        
//        let fileManager = NSFileManager.defaultManager()
//        if(!fileManager.fileExistsAtPath(writePath))
//        {
//            let bundle = NSBundle.mainBundle().pathForResource("locations", ofType: "plist")
//            
//            // copy locations.plist to documents directory so we can edit it
//            
//            do {
//                try NSFileManager.defaultManager().copyItemAtPath(bundle!, toPath:writePath)
//            } catch {
//                print("Error occurred while copying file to document \(error)")
//            }
//            
//        }
//        
//    
//        
//        [array writeToFile:filePath atomically:YES];
//        NSLog(@"file Stored at %@",filePath);
//        
//        let swiftArray = NSArray(contentsOfFile: writePath) as? [String]
//        if let swiftArray = swiftArray {
//            
//            // cast back to NSArray to write
//            (swiftArray as NSArray).writeToFile(writePath, atomically: true)
//        }
//        
//        print("locationArray : \(self.locationArray)")
//    }

}
