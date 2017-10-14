//
//  SSHTTPClient.swift
//  SSHTTPClient
//
//  Created by Susim on 11/17/14.
//  Copyright (c) 2014 Susim. All rights reserved.
//

import Foundation
public typealias SSHTTPResponseHandler = (_ responseObject : Any? , _ error : Error?) -> Void

open class SSHTTPClient : NSObject {
    
    var httpMethod,url,httpBody: String?
    var headerFieldsAndValues : [String:String]?
    
    //Initializer Method with url string , method, body , header field and values
    public init(url:String?, method:String?, httpBody: String?, headerFieldsAndValues: [String:String]?) {
        self.url =  url
        self.httpMethod = method
        self.httpBody = httpBody
        self.headerFieldsAndValues = headerFieldsAndValues
    }
    //Get formatted JSON
    public func getJsonData(_ httpResponseHandler : @escaping SSHTTPResponseHandler) {
        getResponseData { (data, error) in
            if error != nil {
                httpResponseHandler(nil,error)
            }else if let datObject = data as? Data {
                let json = try? JSONSerialization.jsonObject(with: datObject, options: [])
                httpResponseHandler(json,nil)
            }
        }
    }
    //Get Response in Data format
    public func getResponseData(_ httpResponseHandler : @escaping SSHTTPResponseHandler) {
        var request: URLRequest?
        if let urlString = self.url {
            if let url = URL(string: urlString) {
                request = URLRequest(url: url)
            }
        }
        if let method = self.httpMethod {
            request?.httpMethod =  method
        }
        if let headerKeyValues = self.headerFieldsAndValues {
            for key in headerKeyValues.keys {
                request?.setValue(headerKeyValues[key] , forHTTPHeaderField: key)
            }
        }
        if let body = self.httpBody {
            request?.httpBody = body.data(using: String.Encoding.utf8)
        }
        if let requestObject = request {
            let session = URLSession.shared
            let task = session.dataTask(with: requestObject, completionHandler: { (data, response, error) in
                if error != nil {
                    httpResponseHandler(nil,error)
                }else {
                    httpResponseHandler (data as Any?, nil)
                }
            })
            task.resume()
        }
    }
    
    //Cancel Request
    open func cancelRequest()->Void{
        let session = URLSession.shared
        session.invalidateAndCancel()
    }
}

