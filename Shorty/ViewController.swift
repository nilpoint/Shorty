//
//  ViewController.swift
//  Shorty
//
//  Created by John Alstru on 8/28/15.
//  Copyright (c) 2015 nilpoint.sample. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var urlField: UITextField!
  @IBOutlet var webView: UIWebView!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func loadLocation(AnyObject) {
    var urlText = urlField.text
    
    if !urlText.hasPrefix("http:") && !urlText.hasPrefix("https:") {
      if !urlText.hasPrefix("//") {
        urlText = "//" + urlText
      }
      urlText = "http:" + urlText
    }
    
    let url = NSURL(string: urlText)
    webView.loadRequest(NSURLRequest(URL: url!))
  }
}

