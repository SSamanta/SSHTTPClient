//
//  SSHTTPClient.swift
//  SSHTTPClient
//
//  Created by Susim on 11/17/14.
//  Copyright (c) 2014 Susim. All rights reserved.
//

import Foundation
typealias SSHTTPResponseHandler = (obj : AnyObject? , error : NSError?) -> Void
@objc class SSHTTPClient : NSObject {
    var httpMethod,urlStr,httpBody: NSString?
    var headerFieldsAndValues : NSDictionary?
    init(url:NSString, method:NSString, httpBody: NSString, headerFieldsAndValues: NSDictionary  ) {
        self.urlStr =  url;
        self.httpMethod = method;
        self.httpBody = httpBody;
        self.headerFieldsAndValues = headerFieldsAndValues
    }
    func getJsonData(httpResponseHandler : SSHTTPResponseHandler) {
        let request = NSMutableURLRequest(URL: NSURL(string:self.urlStr! as String)!)
        request.HTTPMethod =  self.httpMethod! as String
        self.headerFieldsAndValues?.enumerateKeysAndObjectsUsingBlock({ (key, value, stop) -> Void in
            request.setValue(value as! NSString as String, forHTTPHeaderField: key as! NSString as String)
        })
        request.HTTPBody = self.httpBody?.dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response , error) -> Void in
            if (error == nil) {
                var jsonError : NSError?
                var json : AnyObject?
                do {
                    json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves)
                } catch let error as NSError {
                    jsonError = error
                    json = nil
                } catch {
                    fatalError()
                }
                if let object = json as? Array <AnyObject> {
                    httpResponseHandler(obj: object ,error: nil)
                }else if let object = json as? Dictionary <String, AnyObject> {
                    httpResponseHandler(obj: object ,error: nil)
                }else {
                    httpResponseHandler(obj: nil,error:jsonError)
                }
            }else {
                httpResponseHandler(obj: nil,error: error)
            }
        })
        task.resume()
    }
    func getResponseData(urlString :NSString?,httpResponseHandler : SSHTTPResponseHandler) {
        let request = NSMutableURLRequest(URL: NSURL(string:self.urlStr! as String)!)
        request.HTTPMethod =  self.httpMethod! as String
        self.headerFieldsAndValues?.enumerateKeysAndObjectsUsingBlock({ (key, value, stop) -> Void in
            request.setValue(value as? String, forHTTPHeaderField: key as! NSString as String)
        })
        request.HTTPBody = self.httpBody?.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response , error) -> Void in
            if (error == nil) {
               httpResponseHandler (obj: data, error: nil)
            }else {
               httpResponseHandler(obj: nil,error: error)
            }
        })
        task.resume()
    }
    
    func finishRequest()->Void{
        let session = NSURLSession.sharedSession()
		session.invalidateAndCancel()
    }

}