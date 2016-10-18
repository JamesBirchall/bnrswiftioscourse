//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by James Birchall on 18/10/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit
import  WebKit

// bronze challange

class WebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        
        let webConfiguration = WKWebViewConfiguration()
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.uiDelegate = self   //required to show screen
        
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print("WebViewController loaded its view.")
        
        let myURL = URL(string: "http://www.bignerdranch.com")
        if let actualURL = myURL {
            let myRequest = URLRequest(url: actualURL)
            webView.load(myRequest)
            print("Request attempted...")
        } else {
            print("Load failed...")
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
}
