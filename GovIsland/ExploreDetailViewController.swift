//
//  ExploreDetailViewController.swift
//  GovIsland
//
//  Created by janice on 4/28/16.
//  Copyright © 2016 Janice. All rights reserved.
//

import UIKit
import MapKit

class ExploreDetailViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var locationDetail :Location = Location(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), title: "", subtitle: "", categoryId: 0, thumbnailUrl: "")
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load local webview html
        let url = NSBundle.mainBundle().URLForResource("webView", withExtension: "html")
        let requestObj = NSURLRequest(URL: url!)
        
        // load url remotely
        // let url = NSURL (string: "http://www.google.com")
        // let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj)
        
        updatePage()
        
        let barButton = UIBarButtonItem(image: UIImage(named: "pinpoint"), landscapeImagePhone: nil, style: .Done, target: self, action: #selector(ExploreDetailViewController.filterButtonDidSelect))
        self.navigationItem.setRightBarButtonItem(barButton, animated: true)
    }
    
    func filterButtonDidSelect() {
        if let mapViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mapViewIdentifier") as? MapViewController {
            
            let navController = UINavigationController(rootViewController: mapViewController)
            navController.setViewControllers([mapViewController], animated:true)
            
            self.revealViewController().setFrontViewController(navController, animated: true)
            mapViewController.locationDetailToUpdate = locationDetail
            mapViewController.didUpdateFromLocation = true
        }
    }
    
    
    func updatePage() {
        
        let thumbnailUrl :String = locationDetail.thumbnailUrl!
        let title :String = locationDetail.title!
        let copy :String = locationDetail.subtitle!
        
        print("thumbnailUrl : \(thumbnailUrl)")
        print("title : \(title)")
        print("copy : \(copy)")

        
        let path = NSBundle.mainBundle().pathForResource("webView", ofType: "html")
        
        var html: String?
        do {
            html = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        } catch _ {
            html = nil
        }
        
        html = html!.stringByReplacingOccurrencesOfString("<!-- image -->", withString: thumbnailUrl)
        
         html = html!.stringByReplacingOccurrencesOfString("<!-- title -->", withString: title)
        
        html = html!.stringByReplacingOccurrencesOfString("<!-- body -->", withString: copy)
        
        self.webView.loadHTMLString(html!, baseURL: nil)
        
    }

}
