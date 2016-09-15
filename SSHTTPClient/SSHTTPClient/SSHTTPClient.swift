//
//  SSHTTPClient.swift
//  SSHTTPClient
//
//  Created by Susim on 11/17/14.
//  Copyright (c) 2014 Susim. All rights reserved.
//

import Foundation
public typealias SSHTTPResponseHandler = (_ obj : AnyObject? , _ error : NSError?) -> Void

open class SSHTTPClient : NSObject {
    
    var httpMethod,urlString,httpBody: NSString?
    var headerFieldsAndValues : NSDictionary?
    
    //Initializer Method with url string , method, body , header field and values
    public init(url:String?, method:String?, httpBody: NSString?, headerFieldsAndValues: NSDictionary?) {
        self.urlString =  url as NSString?
        self.httpMethod = method as NSString?
        if httpBody != nil {
            self.httpBody = httpBody!
        }
        if headerFieldsAndValues != nil {
            self.headerFieldsAndValues = headerFieldsAndValues!
        }
        
    }
    //Get formatted JSON
    open func getJsonData(_ httpResponseHandler : @escaping SSHTTPResponseHandler) {
        if self.urlString != nil {
            var request = URLRequest(url: URL(string:self.urlString! as String)!)
            request.httpMethod =  self.httpMethod! as String
            self.headerFieldsAndValues?.enumerateKeysAndObjects({ (key, value, stop) -> Void in
                request.setValue(value as! NSString as String, forHTTPHeaderField: key as! NSString as String)
            })
            request.httpBody = self.httpBody?.data(using: String.Encoding.utf8.rawValue)
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { (data, response , error) -> Void in
                if (error == nil) {
                    var jsonError : NSError?
                    var json : Any?
                    do {
                        json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves)
                    } catch let error as NSError {
                        jsonError = error
                        json = nil
                    } catch {
                        fatalError()
                    }
                    if let object = json as? Array <AnyObject> {
                        httpResponseHandler(object as AnyObject? ,nil)
                    }else if let object = json as? Dictionary <String, AnyObject> {
                        httpResponseHandler(object as AnyObject? ,nil)
                    }else {
                        httpResponseHandler(nil,jsonError)
                    }
                }else {
                    httpResponseHandler(nil,error as NSError?)
                }
            })
            task.resume()
        }else {
            httpResponseHandler(nil, nil)
        }
    }
    //Get Response in Data format
    open func getResponseData(_ httpResponseHandler : @escaping SSHTTPResponseHandler) {
        var request = URLRequest(url: URL(string:self.urlString! as String)!)
        request.httpMethod =  self.httpMethod! as String
        self.headerFieldsAndValues?.enumerateKeysAndObjects({ (key, value, stop) -> Void in
            request.setValue(value as? String, forHTTPHeaderField: key as! NSString as String)
        })
        request.httpBody = self.httpBody?.data(using: String.Encoding.utf8.rawValue)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data, response , error) -> Void in
            if (error == nil) {
               httpResponseHandler (data as AnyObject?, nil)
            }else {
               httpResponseHandler(nil,error as NSError?)
            }
        })
        task.resume()
    }
    
    //Cancel Request
    open func cancelRequest()->Void{
        let session = URLSession.shared
		session.invalidateAndCancel()
    }

}
