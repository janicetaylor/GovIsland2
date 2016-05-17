//
//  AboutViewController.swift
//  GovIsland
//
//  Created by janice on 5/17/16.
//  Copyright © 2016 Janice. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load local webview html
        let url = NSBundle.mainBundle().URLForResource("webViewAbout", withExtension: "html")
        let requestObj = NSURLRequest(URL: url!)
        
        // load url remotely
        // let url = NSURL (string: "http://www.google.com")
        // let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj)
        
        updatePage()

    }
    
    
    func updatePage() {
        
        let thumbnailUrl :String = "http://www.meladori.com/work/govisland/govisland-book-small.jpg"
//        let copy :String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi ut dictum orci. Nam vehicula suscipit lacus, ac condimentum velit convallis vel.<br><a href=\"https://itunes.apple.com/us/book/governors-island-explorers/id1097228665?mt=11\"You can buy the book on the iTunes Store here.</a>"
        
        let copy :String = "xxx yyy"
        
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
