//
//  SSHTTPClient.swift
//  SSHTTPClient
//
//  Created by Susim on 11/17/14.
//  Copyright (c) 2014 Susim. All rights reserved.
//

import Foundation
typealias SSHTTPResponseHandler = (obj : AnyObject? , error : NSError?) -> Void
class SSHTTPClient : NSObject {
    var httpMethod,urlStr,httpBody: NSString?
    var headerFieldsAndValues : NSDictionary?
    init(url:NSString, method:NSString, httpBody: NSString, headerFieldsAndValues: NSDictionary  ) {
        self.urlStr =  url;
        self.httpMethod = method;
        self.httpBody = httpBody;
        self.headerFieldsAndValues = headerFieldsAndValues
    }
    func getJsonData(httpResponseHandler : SSHTTPResponseHandler) {
        var request = NSMutableURLRequest(URL: NSURL(string:self.urlStr!)!)
        request.HTTPMethod =  self.httpMethod!
        self.headerFieldsAndValues?.enumerateKeysAndObjectsUsingBlock({ (key, value, stop) -> Void in
            request.setValue(value as NSString, forHTTPHeaderField: key as NSString)
        })
        request.HTTPBody = self.httpBody?.dataUsingEncoding(NSUTF8StringEncoding)
        
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request, completionHandler: { (data, response , error) -> Void in
            if (error == nil) {
                var jsonError : NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &jsonError) as? NSDictionary
                if (jsonError == nil) {
                    httpResponseHandler(obj: json as AnyObject?,error: nil)
                }else {
                    httpResponseHandler(obj: nil,error: jsonError)
                }
            }else {
                httpResponseHandler(obj: nil,error: error)
            }
        })
        task.resume()
    }
    func getResponseData(urlString :NSString?,httpResponseHandler : SSHTTPResponseHandler) {
        var request = NSMutableURLRequest(URL: NSURL(string:self.urlStr!)!)
        request.HTTPMethod =  self.httpMethod!
        self.headerFieldsAndValues?.enumerateKeysAndObjectsUsingBlock({ (key, value, stop) -> Void in
            request.setValue(value as NSString, forHTTPHeaderField: key as NSString)
        })
        request.HTTPBody = self.httpBody?.dataUsingEncoding(NSUTF8StringEncoding)
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request, completionHandler: { (data, response , error) -> Void in
            if (error == nil) {
               httpResponseHandler (obj: data, error: nil)
            }else {
               httpResponseHandler(obj: nil,error: error)
            }
        })
        task.resume()
    }
    
    func finishRequest() {
        var session = NSURLSession.sharedSession()
		session.invalidateAndCancel()
    }

}