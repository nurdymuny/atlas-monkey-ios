//
//  UserViewManager.swift
//  Swoppler
//
//  Created by Brian on 27/03/15.
//  Copyright (c) 2015 com.trend. All rights reserved.
//
//self.delegateDeshBoard?.getFeedsResultArr!(getFeedArr)


import UIKit

@objc protocol logInProtocol
{
    //optional func someMethod(NSArray)
    optional func getAuthTokenArr(NSArray)
    optional func getUserLoginSuccessInfoArr(NSArray)
    optional func getUserLoginNotSuccess(NSArray)
    optional func userLogOutSuccess(NSArray)
    optional func userLogOutError(NSArray)
}

@objc protocol signupProtocol
{
    
    optional func userSignupSuccess(NSArray)
    optional func userSignupError(NSArray)
    optional func userSignupSaveInfoSuccess(NSArray)
    optional func userSignupSaveInfoError(NSArray)
}

class UserViewManager: NSObject {
    
    //let baseURL = "http://localhost:3000/api/v1/"
    
    var delegateLogin:logInProtocol?
    var delegateSignup:signupProtocol?
    
    
    class var sharedInstance: UserViewManager {
        struct Static {
            static var instance: UserViewManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = UserViewManager()
        }
        
        return Static.instance!
    }
    
    var webObj:WebRequestViewManager = WebRequestViewManager()
    
    //MARK:- User registration, Login, Logout and Update info respectivaly
    
    func registrationsUser(usrInfoDic : NSDictionary, success:(NSDictionary) -> Void, failure:(NSError) -> Void) -> Void
    {
        var UrlWithSearchKeyword = "\(baseURL)registrations"
        webObj.postRequestWithEndPoint(UrlWithSearchKeyword, parameters: usrInfoDic, success: { (data) -> Void in
            
            let getResponseDic: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            
            print(getResponseDic)
            success(getResponseDic)
           
            
            
            
            
//            let strResponse :Bool = getResponseDic.objectForKey("success")! as! Bool
//            
//            if strResponse == true
//            {
//                
//                var authToken : String = getResponseDic.objectForKey("data")!.objectForKey("auth_token") as! String
//                NSUserDefaults.standardUserDefaults().setValue(authToken, forKey: "auth_token")
//                NSUserDefaults.standardUserDefaults().synchronize()
//
//                let getResponse : NSArray = NSArray(object: getResponseDic.objectForKey("user")!)
//                self.delegateLogin?.getUserLoginSuccessInfoArr!(getResponse)
//                
//            }
//            else
//            {
//                let getResponse : NSArray = NSArray()
//                self.delegateLogin?.getUserLoginNotSuccess!(getResponse)
//            }
            
            }, failure: { (error) -> Void in
                
                println("Error : \(error.localizedDescription)")
        })
    }
    
    func loginUser(usrInfoDic : NSDictionary, success:(NSArray) -> Void , failure:(NSError) -> Void) -> Void
    {
        var UrlWithSearchKeyword = "\(baseURL)login"
        webObj.postRequestWithEndPoint(UrlWithSearchKeyword, parameters: usrInfoDic, success: { (data) -> Void in
            
            let getResponseDic: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            
            print(getResponseDic)
            
            var responseArr : NSArray = NSArray(object: getResponseDic)
            success(responseArr)
            
//            let strResponse :Bool = getResponseDic.objectForKey("success")! as! Bool
//            
//            if strResponse == true
//            {
//                var authToken : String = getResponseDic.objectForKey("data")!.objectForKey("auth_token") as! String
//                NSUserDefaults.standardUserDefaults().setValue(authToken, forKey: "auth_token")
//                NSUserDefaults.standardUserDefaults().synchronize()
//                
//                let getResponse : NSArray = NSArray(object: getResponseDic.objectForKey("user")!)
//                self.delegateLogin?.getUserLoginSuccessInfoArr!(getResponse)
//            }
//            else
//            {
//                let getResponse : NSArray = NSArray()
//                self.delegateLogin?.getUserLoginNotSuccess!(getResponse)
//            }
            
            
            }, failure: { (error) -> Void in
                
                println("Error : \(error.localizedDescription)")
        })
        
    }
    
    
    func logOutUser(usrInfoDic : NSDictionary, success:(NSDictionary) -> Void, failure:(NSError) -> Void) -> Void
    {
        var UrlWithSearchKeyword = "\(baseURL)logout"
        
        webObj.requestWithHeaderMethodAndParameter("DELETE", urlString: UrlWithSearchKeyword, header: NSUserDefaults.standardUserDefaults().objectForKey("auth_tokrn") as! String, parameters: usrInfoDic, success: {(data) -> Void in
        
            let getResponseDic: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            
            print(getResponseDic)
            
            success(getResponseDic)
            }, failure: {(error) -> Void in
                println("Error : \(error.localizedDescription)")
        })
        
//        webObj.requestWithMethodAndParameter("DELETE", urlString: UrlWithSearchKeyword, parameters: usrInfoDic, success: { (data) -> Void in
//            
//            let getResponseDic: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
//            
//            print(getResponseDic)
//            
//            success(getResponseDic)
//            
////            let strResponse :Bool = getResponseDic.objectForKey("success")! as! Bool
//            
//            }, failure: {(error) -> Void in
//                println("Error : \(error.localizedDescription)")
//                
//                
//        })
        
    }
    
    func updateUserInfo(usrInfoDic : NSDictionary, success :(NSArray) -> Void, failure : (NSError) -> Void ) -> Void
    {
        
        var UrlWithSearchKeyword = "\(baseURL)update"
        webObj.requestWithMethodAndParameter("PATCH", urlString: UrlWithSearchKeyword, parameters: usrInfoDic, success: { (data) -> Void in
            
            let getResponseDic: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            
            print(getResponseDic)
            
            var responseArr : NSArray = NSArray(object: getResponseDic)
            success(responseArr)
            
            let strResponse :Bool = getResponseDic.objectForKey("success")! as! Bool
            
            //            if strResponse == true
            //            {
            //
            //                var authToken : String = getResponseDic.objectForKey("data")!.objectForKey("auth_token") as! String
            //                NSUserDefaults.standardUserDefaults().setValue(authToken, forKey: "auth_token")
            //                NSUserDefaults.standardUserDefaults().synchronize()
            //
            //                let getResponse : NSArray = NSArray(object: getResponseDic.objectForKey("user")!)
            //                self.delegateSignup?.userSignupSaveInfoSuccess!(getResponse)
            //
            //            }
            //            else
            //            {
            //                let getResponse : NSArray = NSArray()
            //                self.delegateSignup?.userSignupSaveInfoError!(getResponse)
            //            }
            
            
            }, failure: {(error) -> Void in
                println("Error : \(error.localizedDescription)")
                
                
        })
        
    }
    
    //MARK:-user Forget Password API
    
    
    
    
    //MARK:-Add Ticket Detail API
    func addTicketDetail(userInfoDict : NSDictionary, success:(NSArray)-> Void, failure:(NSError) -> Void) -> Void
    {
        var UrlWithSearchKeyword = "\(baseURL)add_ticket_detail"
        webObj.requestWithMethodAndParameter("POST", urlString: UrlWithSearchKeyword, parameters: userInfoDict, success: {(data) -> Void in
            
            let getResponseDic: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            
            println(getResponseDic)
            let getResponse : NSArray = NSArray(object: getResponseDic)
            success(getResponse)
            
            
            }, failure: {(error) -> Void in
                println("Error : \(error.localizedDescription)")
        })
    }
    
    //MARK:-Get Seat Detail API
    
    func getTicketDetail(userInfoDict : NSDictionary, success:(NSDictionary)-> Void, failure:(NSError) -> Void) -> Void
    {
        var UrlWithSearchKeyword = "\(baseURL)get_ticket_detail"
        webObj.requestWithMethodAndParameter("GET", urlString: UrlWithSearchKeyword, parameters: userInfoDict, success: {(data) -> Void in
            
            let getResponseDic: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            
            println(getResponseDic)
            success(getResponseDic)
//            let getResponse : NSArray = NSArray(object: getResponseDic)
//            success(getResponse)
            
            
            }, failure: {(error) -> Void in
                println("Error : \(error.localizedDescription)")
        })
        
    }
    
    
    //MARK:-All block list API
    
    func getAllBlocksDetail( success:(NSDictionary)-> Void, failure:(NSError) -> Void) -> Void
    {
        var UrlWithSearchKeyword = "\(baseURL)venues/1/blocks"
        
        webObj.getRequestWithEndPoint(UrlWithSearchKeyword, parameters: nil, success: {(data) -> Void in
            
            let getResponseDic: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            
            println(getResponseDic)
            success(getResponseDic)
            
            }, failure: {(error) -> Void in
                println("Error : \(error.localizedDescription)")
        })

        
        
//        webObj.requestWithMethodAndParameter("GET", urlString: UrlWithSearchKeyword, parameters: userInfoDict, success: {(data) -> Void in
//            
//            let getResponseDic: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
//            
//            println(getResponseDic)
//            let getResponse : NSArray = NSArray(object: getResponseDic)
//            success(getResponse)
//            
//            
//            }, failure: {(error) -> Void in
//                println("Error : \(error.localizedDescription)")
//        })
        
    }
}