//
//  ExploreDetailViewController.swift
//  GovIsland
//
//  Created by janice on 4/28/16.
//  Copyright © 2016 Janice. All rights reserved.
//

import UIKit

class ExploreDetailViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load local webview html
        let url = NSBundle.mainBundle().URLForResource("webView", withExtension: "html")
        let requestObj = NSURLRequest(URL: url!)
        
        // load url remotely
        // let url = NSURL (string: "http://www.google.com")
        // let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj)

    }

}
