//
//  ViewController.swift
//  Shorty
//
//  Created by John Alstru on 8/28/15.
//  Copyright (c) 2015 nilpoint.sample. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
  @IBOutlet var urlField: UITextField!
  @IBOutlet var webView: UIWebView!
  
  @IBOutlet var shortenButton: UIBarButtonItem!
  @IBOutlet var shortLabel: UIBarButtonItem!
  @IBOutlet var clipboardButton: UIBarButtonItem!
  
  let GoDaddyAccountKey = "YourApiKey"
  var shortenURLConnection: NSURLConnection?
  var shortURLData: NSMutableData?

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
  
  @IBAction func shortenURL(AnyObject) {
    if let toShorten = webView.request?.URL?.absoluteString {
      let encodedURL = toShorten.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
      // https://shortener.godaddy.com/v1/?apikey={ api key }[&domain={ short domain }]&url=%@
      var urlString = "https://shortener.godaddy.com/v1/?apikey=\(GoDaddyAccountKey)&url=\(encodedURL!)"
      var url = NSURL(string:urlString)
    
      shortURLData = NSMutableData()
      let request = NSURLRequest(URL: url!)
      shortenURLConnection = NSURLConnection(request: request, delegate: self)
      shortenButton.enabled = false
    }
  }
  
  // NSURLConnectionDelegate methods
  func connection(connection: NSURLConnection, didFailWithError error: NSError) {
    shortLabel.title = "failed"
    clipboardButton.enabled = false
    shortenButton.enabled = true
  }
  
  // NSURLConnectionDataDelegate methods
  func connection(connection: NSURLConnection, didReceiveData data: NSData) {
    shortURLData?.appendData(data)
  }
  
  func connectionDidFinishLoading(connection: NSURLConnection) {
    if let data = shortURLData {
      let shortURLString = NSString(data: data, encoding: NSUTF8StringEncoding)
      shortLabel.title = shortURLString as? String
      clipboardButton.enabled = true
    }
  }
  
  // UIWebViewDelegate methods
  func webViewDidStartLoad(webView: UIWebView) {
    shortenButton.enabled = false
  }
  
  func webViewDidFinishLoad(webView: UIWebView) {
    shortenButton.enabled = true
    urlField.text = webView.request?.URL?.absoluteString
  }
  
  func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
    var message = "The page couldn't be loaded. " + error.localizedDescription
    
    let alert = UIAlertController(title: "Could not load url", message: message, preferredStyle: .Alert);
    let okAction = UIAlertAction(title: "That's sad", style: .Default, handler: nil)
    alert.addAction(okAction)
    
    presentViewController(alert, animated: true, completion: nil)
  }
}

