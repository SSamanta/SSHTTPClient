//
//  ViewController.swift
//  SSHTTPClient
//
//  Created by Susim on 11/17/14.
//  Copyright (c) 2014 Susim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Sample service call
		let urlString = "http://itunes.apple.com/us/rss/topfreeapplications/limit=100/json"
        let sampleCall : SSHTTPClient  = SSHTTPClient(url: urlString , method: "GET", httpBody: "", headerFieldsAndValues: ["":""])
        sampleCall.getJsonData { (obj, error) -> Void in
            print(obj, terminator: "")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

