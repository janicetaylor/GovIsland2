//
//  AboutViewController.swift
//  GovIsland
//
//  Created by janice on 5/17/16.
//  Copyright © 2016 Janice. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.delegate = self
        
        self.navigationItem.title = "Shop"
        
        // load local webview html
        let url = NSBundle.mainBundle().URLForResource("webViewAbout", withExtension: "html")
        let requestObj = NSURLRequest(URL: url!)
        
        // load url remotely
//         let url = NSURL (string: "http://www.google.com")
//         let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj)
        
    }

     func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }
    
    
}
