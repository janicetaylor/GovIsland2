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
        
        let url = NSURL (string: "http://www.google.com")
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
