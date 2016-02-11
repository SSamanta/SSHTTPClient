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
    
    var httpMethod,urlString,httpBody: String?
    var headerFieldsAndValues : NSDictionary?
    
    init(url:String?, method:String?, httpBody: String?, headerFieldsAndValues: NSDictionary  ) {
        self.urlString =  url;
        self.httpMethod = method;
        self.httpBody = httpBody;
        self.headerFieldsAndValues = headerFieldsAndValues
    }
    
    func getJsonData(httpResponseHandler : SSHTTPResponseHandler) {
        if self.urlString != nil {
            let request = NSMutableURLRequest(URL: NSURL(string:self.urlString! as String)!)
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
        }else {
            httpResponseHandler(obj: nil, error: nil)
        }
    }
    func getResponseData(urlString :NSString?,httpResponseHandler : SSHTTPResponseHandler) {
        let request = NSMutableURLRequest(URL: NSURL(string:self.urlString! as String)!)
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
    
    func cancelRequest()->Void{
        let session = NSURLSession.sharedSession()
		session.invalidateAndCancel()
    }

}