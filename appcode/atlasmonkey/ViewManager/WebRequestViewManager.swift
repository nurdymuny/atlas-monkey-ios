//
//  WebRequestViewManager.swift
//  Swoppler
//
//  Created by Brian on 27/03/15.
//  Copyright (c) 2015 com.trend. All rights reserved.
//

import UIKit

class WebRequestViewManager: NSObject {
    
    
    let baseURL = "http://52.1.228.216/api/v1/"
    var config : NSURLSessionConfiguration!
    
    var session : NSURLSession!
    
    override init()
    {
        config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)
    }
    
    
    //MARK:- Get request With Base URL
    
    //    func getRequest(urlString:NSString, parameters:NSDictionary?, success:(NSData!) -> Void, failure:(NSError!) -> Void) -> Void
    //    {
    //        var request:NSMutableURLRequest = self.requestWithMethodAndParam("GET", urlString: NSURL(string: baseURL)!.URLByAppendingPathComponent("sign_in.json").absoluteString!, parameters: parameters)
    //
    //        println("url is : \(request.URL?.absoluteString)")
    //
    //        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
    //
    //            var err: NSError
    //
    //            if (error == nil)
    //            {
    //                success(data)
    //            }
    //
    //            else
    //            {
    //                failure(error)
    //            }
    //        })
    //
    //        task.resume()
    //    }
    
    
    //MARK:- GET Request with endpoints
    
    
    
    
    func getRequestWithEndPoint(urlString:NSString, parameters:NSDictionary?, success:(NSData!) -> Void, failure:(NSError!) -> Void) -> Void
    {
         //print(urlString)
        let request:NSMutableURLRequest = self.requestWithMethodAndParam("GET", urlString: urlString, parameters: parameters)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            if (error == nil)
            {
                success(data)
            }
                
            else
            {
                failure(error)
            }
        })
        
        task.resume()
    }
    
    
    //MARK:- Post request With Base URL
    
    func postRequest(urlString:NSString, parameters:NSDictionary?, success:(NSData!) -> Void, failure:(NSError!) -> Void) -> Void
    {
        let request:NSMutableURLRequest = self.requestWithMethodAndParam("POST", urlString: NSURL(string: baseURL)!.URLByAppendingPathComponent(urlString as String).absoluteString, parameters: parameters)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            if (error == nil)
            {
                success(data)
            }
                
            else
            {
                failure(error)
            }
        })
        
        task.resume()
    }
    
    
    //MARK:- POST Request with endpoints
    
    func postRequestWithEndPoint(urlString:NSString, parameters:NSDictionary, success:(NSData!) -> Void, failure:(NSError!) -> Void) -> Void
    {
        let request:NSMutableURLRequest = self.requestWithMethodAndParam("POST", urlString: urlString, parameters: parameters)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            if (error == nil)
            {
                success(data)
            }
                
            else
            {
                failure(error)
            }
        })
        
        task.resume()
    }
    
    //MARK:-  Request with param&Method
    
    func requestWithMethodAndParameter(method:NSString, urlString:NSString, parameters:NSDictionary, success:(NSData!) -> Void, failure:(NSError!) -> Void) -> Void
    {
        let request:NSMutableURLRequest = self.requestWithMethodAndParam(method, urlString: urlString, parameters: parameters)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            if (error == nil)
            {
                success(data)
            }
                
            else
            {
                failure(error)
            }
        })
        
        task.resume()
    }
    
    
    //MARK:- Creating URLRequest
    
    func requestWithMethodAndParam(method:NSString, urlString:NSString, parameters:NSDictionary?) -> NSMutableURLRequest
    {
        let url:NSURL = NSURL(string: urlString as String)!
        
        let mutableRequest:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        mutableRequest.HTTPMethod = method as String
        mutableRequest.allowsCellularAccess = true;
        mutableRequest.cachePolicy = NSURLRequestCachePolicy.UseProtocolCachePolicy;
        mutableRequest.HTTPShouldHandleCookies = true;
        mutableRequest.HTTPShouldUsePipelining = false;
        mutableRequest.networkServiceType = NSURLRequestNetworkServiceType.NetworkServiceTypeDefault
        mutableRequest.timeoutInterval = 60;
        
        if (parameters != nil)
        {
            mutableRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
            
            if method.isEqualToString("POST")
            {
                mutableRequest.setValue("application/json; charset=\(charset)", forHTTPHeaderField: "Content-Type")
                //                getResponseDic = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String:AnyObject]
                
                do {
                    mutableRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameters!, options: [])
                }
                catch {
                    print("json error: \(error)")
                }
            }
                
            else if method.isEqualToString("PUT")
            {
                mutableRequest.setValue("application/json; charset=\(charset)", forHTTPHeaderField: "Content-Type")
                do {
                    mutableRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameters!, options: [])
                }
                catch {
                    print("json error: \(error)")
                }
            }
                
            else if method.isEqualToString("DELETE")
            {
                mutableRequest.setValue("application/json; charset=\(charset)", forHTTPHeaderField: "Content-Type")
                do {
                    mutableRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameters!, options: [])
                }
                catch {
                    print("json error: \(error)")
                }
            }
                
            else if method.isEqualToString("GET")
            {
                let urlStr:NSMutableString = urlString.mutableCopy() as! NSMutableString
                
                urlStr.appendString("?")
                
                for keys in parameters!.allKeys
                {
                    let keyString:NSString = keys as! NSString
                    
                    if (urlStr.substringFromIndex(urlStr.length - 1) == "?")
                    {
                        
                        urlStr.appendString("\(keyString)=\(parameters?.valueForKey(keyString as String) as! NSString)")
                    }
                    else
                    {
                        urlStr.appendString("&\(keyString)=\(parameters?.valueForKey(keyString as String) as! NSString)")
                    }
                }
                mutableRequest.URL = NSURL(string: urlStr as String)
            }
        }
        return mutableRequest;
    }
    
    
    
    
    /*=======================================*/
    
    //MARK:-Request with Header,Param & Method
    
    /*=======================================*/
    
    
    func requestWithHeaderMethodAndParameter(method:NSString, urlString:NSString, header:String, parameters:NSDictionary, success:(NSData!) -> Void, failure:(NSError!) -> Void) -> Void
    {
        let request:NSMutableURLRequest = self.requestWithHeaderMethodAndParam(method, urlString: urlString, header: header, parameters: parameters)
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            if (error == nil)
            {
                success(data)
            }
                
            else
            {
                failure(error)
            }
        })
        task.resume()
    }
    
    
    func requestWithHeaderMethodAndParam(method:NSString, urlString:NSString, header:String, parameters:NSDictionary?) -> NSMutableURLRequest
    {
        let url:NSURL = NSURL(string: urlString as String)!
        
        let mutableRequest:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        mutableRequest.HTTPMethod = method as String
        mutableRequest.allowsCellularAccess = true;
        mutableRequest.cachePolicy = NSURLRequestCachePolicy.UseProtocolCachePolicy;
        mutableRequest.HTTPShouldHandleCookies = true;
        mutableRequest.HTTPShouldUsePipelining = false;
        mutableRequest.networkServiceType = NSURLRequestNetworkServiceType.NetworkServiceTypeDefault
        mutableRequest.timeoutInterval = 60;
        if header != ""
        {
            mutableRequest.addValue(header, forHTTPHeaderField: "auth_token")
        }
        
        if (parameters != nil)
        {
            mutableRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
            
            if method.isEqualToString("POST")
            {
                mutableRequest.setValue("application/json; charset=\(charset)", forHTTPHeaderField: "Content-Type")
                //                getResponseDic = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String:AnyObject]
                
                do {
                    mutableRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameters!, options: [])
                }
                catch {
                    print("json error: \(error)")
                }
            }
                
            else if method.isEqualToString("PUT")
            {
                mutableRequest.setValue("application/json; charset=\(charset)", forHTTPHeaderField: "Content-Type")
                do {
                    mutableRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameters!, options: [])
                }
                catch {
                    print("json error: \(error)")
                }
            }
                
            else if method.isEqualToString("DELETE")
            {
                mutableRequest.setValue("application/json; charset=\(charset)", forHTTPHeaderField: "Content-Type")
                do {
                    mutableRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameters!, options: [])
                }
                catch {
                    print("json error: \(error)")
                }
            }
                
            else if method.isEqualToString("GET")
            {
                let urlStr:NSMutableString = urlString.mutableCopy() as! NSMutableString
                
                urlStr.appendString("?")
                
                for keys in parameters!.allKeys
                {
                    let keyString:NSString = keys as! NSString
                    
                    if (urlStr.substringFromIndex(urlStr.length - 1) == "?")
                    {
                        
                        urlStr.appendString("\(keyString)=\(parameters?.valueForKey(keyString as String) as! NSString)")
                    }
                    else
                    {
                        urlStr.appendString("&\(keyString)=\(parameters?.valueForKey(keyString as String) as! NSString)")
                    }
                }
                mutableRequest.URL = NSURL(string: urlStr as String)
            }
        }
        return mutableRequest;
    }
    
    
}
