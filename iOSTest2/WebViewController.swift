//
//  WebViewController.swift
//  iOSTestForSiteDevel
//
//  Created by Yulminator on 6/24/17.
//  Copyright © 2017 YuraPetrov. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadRequest(URLRequest(url: URL(string: Users.array[SelectedItem.id].url)!))
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    print("webview did fail load with error: \(error)")
    }
}
