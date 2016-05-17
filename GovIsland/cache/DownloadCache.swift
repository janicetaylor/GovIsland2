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
                                
                                let mylatitude = tertiaryJson["latitude"].doubleValue
                                let mylongitude = tertiaryJson["longitude"].doubleValue
                                let title = tertiaryJson["name"].stringValue
                                                                
                                let mycoordinate = CLLocationCoordinate2D(latitude:mylatitude, longitude:mylongitude)
                                
                                let location = Location(coordinate: mycoordinate, title: title, subtitle: "", categoryId: categoryId)
                                
                                self.locationArray.append(location)
                                
                            }
                        }
                    }
        
                
                // Now parse the data using SwiftyJSON
                // This will come from your custom cache if it is not expired,
                // and from the network if it is expired
                
                print("locationArray : \(self.locationArray)")
        }
                
    }

}
