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
        
        updatePage()

    }
    
    
    func updatePage() {
        
        let thumbnailUrl :String = "http://www.meladori.com/work/govisland/food/northIslandIceCream.jpg"
        
        let copy :String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque semper pulvinar sodales. Vestibulum ac ante est. Nam tortor arcu, commodo quis mattis sollicitudin, tristique id elit. Suspendisse ut lectus nisi. Phasellus ullamcorper tempor laoreet. Aenean aliquet nec erat et facilisis. Etiam id lorem leo. Nunc pharetra lacus sed suscipit elementum. Aenean quis pellentesque nisl, sed dictum mi. Sed sem massa, aliquet at lacinia sit amet, ullamcorper vitae metus. Ut porta, lacus non auctor maximus, felis arcu maximus erat, a sagittis felis augue sit amet lacus. Sed et tincidunt neque. Nunc ultricies lobortis scelerisque."
        
        let path = NSBundle.mainBundle().pathForResource("webView", ofType: "html")
        
        var html: String?
        do {
            html = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        } catch _ {
            html = nil
        }
        
        html = html!.stringByReplacingOccurrencesOfString("<!-- image -->", withString: thumbnailUrl)
        
        html = html!.stringByReplacingOccurrencesOfString("<!-- body -->", withString: copy)
        
        self.webView.loadHTMLString(html!, baseURL: nil)
        
    }

}
