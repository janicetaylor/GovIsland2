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
    var urlArray :[String] = []
    
    func loadArraysFromPlist() {
        if let path = NSBundle.mainBundle().pathForResource("govisland", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
                let baseUrl = dict["baseUrl"] as! String
                let urlArrayList = dict["urlPrefixes"] as! Array<String>
                for urlString in urlArrayList {
                    urlArray.append("\(baseUrl)\(urlString).json")
                }
            }
        }
        
      
    }

    
    func prefetchData() {
        
        loadArraysFromPlist()
        
        for url in urlArray {
            downloadJsonWithUrl(url, categoryId: urlArray.indexOf(url)!)
        }
        
    }
    
    func downloadJsonWithUrl(urlString:String, categoryId:Int) {
        
        print("prefetching json : \(urlString) with categoryId : \(categoryId)")
        
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
        NSURLCache.setSharedURLCache(cache)
        
        // Create your own manager instance that uses your custom configuration
        let manager = Alamofire.Manager.sharedInstance
        
        // manager = Alamofire.Manager(configuration: configuration)
        
        // Make your request with your custom manager that is caching your requests by default
        manager.request(.GET, urlString, parameters: nil, encoding: .URL)
            .response { (request, response, data, error) in
                
                print("error: \(error)")
                
                let cachedURLResponse = NSCachedURLResponse(response: response!, data: (data! as NSData), userInfo: nil, storagePolicy: .Allowed)
                NSURLCache.sharedURLCache().storeCachedResponse(cachedURLResponse, forRequest: request!)
                
                let userinfo :Dictionary = ["categoryId" : String(categoryId), "urlString" : urlString]
                
                print("storing response for url \(urlString)")
                
            NSNotificationCenter.defaultCenter().postNotificationName("storingCacheFinished", object:self, userInfo:userinfo)
               
        }
        
        
    }
    
    
    
    
  
}
