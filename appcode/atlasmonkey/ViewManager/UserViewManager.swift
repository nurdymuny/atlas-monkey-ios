//
//  UserViewManager.swift
//  Atlas
//
//  Created by Brian on 27/03/15.
//  Copyright (c) 2015 com.nurdymuny. All rights reserved.
//
//self.delegateDeshBoard?.getFeedsResultArr!(getFeedArr)


import UIKit

//@objc protocol logInProtocol
//{
//    //optional func someMethod(NSArray)
//    optional func getAuthTokenArr(NSArray)
//    optional func getUserLoginSuccessInfoArr(NSArray)
//    optional func getUserLoginNotSuccess(NSArray)
//    optional func userLogOutSuccess(NSArray)
//    optional func userLogOutError(NSArray)
//}
//
//@objc protocol signupProtocol
//{
//    optional func userSignupSuccess(NSArray)
//    optional func userSignupError(NSArray)
//    optional func userSignupSaveInfoSuccess(NSArray)
//    optional func userSignupSaveInfoError(NSArray)
//}

class UserViewManager: NSObject {
    
    //let baseURL = "http://localhost:3000/api/v1/"
    
    let baseURL = "http://52.5.49.148/api/v1/"
    
//    var delegateLogin:logInProtocol?
//    var delegateSignup:signupProtocol?
    
    
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
        let UrlWithSearchKeyword = "\(baseURL)registrations"
        webObj.postRequestWithEndPoint(UrlWithSearchKeyword, parameters: usrInfoDic, success: { (data) -> Void in
            
            do
            {
                let getResponseDic: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                success(getResponseDic)
            }
            catch
            {
                print("error : getRestaurantLayout")
            }
            
            }, failure: { (error) -> Void in
                
                failure(error)
                print("Error : \(error.localizedDescription)")
        })
    }
    
    
    func loginUser(usrInfoDic : NSDictionary, success:(NSDictionary) -> Void , failure:(NSError) -> Void) -> Void
    {
        let UrlWithSearchKeyword = "\(baseURL)login"
        webObj.postRequestWithEndPoint(UrlWithSearchKeyword, parameters: usrInfoDic, success: { (data) -> Void in
            
            do
            {
                let getResponseDic: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                success(getResponseDic)
            }
            catch
            {
                print("error : getRestaurantLayout")
            }
            }, failure: { (error) -> Void in
                failure(error)
                print("Error : \(error.localizedDescription)")
        })
        
    }
    
    
    func logOutUser(usrInfoDic : NSDictionary, success:(NSDictionary) -> Void, failure:(NSError) -> Void) -> Void
    {
        let UrlWithSearchKeyword = "\(baseURL)logout"
        
        webObj.requestWithHeaderMethodAndParameter("DELETE", urlString: UrlWithSearchKeyword, header: NSUserDefaults.standardUserDefaults().objectForKey("auth_tokrn") as! String, parameters: usrInfoDic, success: {(data) -> Void in
            
            do
            {
                let getResponseDic: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                success(getResponseDic)
            }
            catch
            {
                print("error : getRestaurantLayout")
            }
            }, failure: {(error) -> Void in
                failure(error)
                print("Error : \(error.localizedDescription)")
        })
        
    }
    
    //MARK:-user Forget Password API
    
    func getPasswordRecover(usrInfoDic : NSDictionary, success:(NSDictionary) -> Void, failure:(NSError) -> Void) -> Void
    {
        let UrlWithSearchKeyword = "\(baseURL)forget_password"
        webObj.postRequestWithEndPoint(UrlWithSearchKeyword, parameters: usrInfoDic, success: { (data) -> Void in
            
            do
            {
                let getResponseDic: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                success(getResponseDic)
            }
            catch
            {
                print("error : getRestaurantLayout")
            }
            
            }, failure: { (error) -> Void in
                failure(error)
                print("Error : \(error.localizedDescription)")
        })
    }
    
    
    
    
    func updateUserInfo(usrInfoDic : NSDictionary, success :(NSArray) -> Void, failure : (NSError) -> Void ) -> Void
    {
        
        let UrlWithSearchKeyword = "\(baseURL)update"
        webObj.requestWithMethodAndParameter("PATCH", urlString: UrlWithSearchKeyword, parameters: usrInfoDic, success: { (data) -> Void in
//
//            let getResponseDic: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
//            
//            //            print(getResponseDic)
//            
//            var responseArr : NSArray = NSArray(object: getResponseDic)
//            success(responseArr)
            
            do
            {
                let getResponseDic: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                let responseArr : NSArray = NSArray(object: getResponseDic)
                success(responseArr)
            }
            catch
            {
                print("error : getRestaurantLayout")
            }
            
            
            }, failure: {(error) -> Void in
                failure(error)
                print("Error : \(error.localizedDescription)")
                
        })
        
    }
    
    
    //MARK:-Add Ticket Detail API
    func addTicketDetail(userInfoDict : NSDictionary, success:(NSArray)-> Void, failure:(NSError) -> Void) -> Void
    {
        let UrlWithSearchKeyword = "\(baseURL)add_ticket_detail"
        webObj.requestWithMethodAndParameter("POST", urlString: UrlWithSearchKeyword, parameters: userInfoDict, success: {(data) -> Void in
            
//            let getResponseDic: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
//            
//            //            print(getResponseDic)
//            let getResponse : NSArray = NSArray(object: getResponseDic)
//            success(getResponse)
            
            
            do
            {
                let getResponseDic: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                let responseArr : NSArray = NSArray(object: getResponseDic)
                success(responseArr)
            }
            catch
            {
                print("error : getRestaurantLayout")
            }
            
            }, failure: {(error) -> Void in
                failure(error)
                print("Error : \(error.localizedDescription)")
        })
    }
    
    //MARK:-Get Seat Detail API
    
    func getTicketDetail(userInfoDict : NSDictionary, success:(NSDictionary)-> Void, failure:(NSError) -> Void) -> Void
    {
        let UrlWithSearchKeyword = "\(baseURL)get_ticket_detail"
        
        webObj.requestWithMethodAndParameter("GET", urlString: UrlWithSearchKeyword, parameters: userInfoDict, success: {(data) -> Void in
            
            do
            {
                let getResponseDic: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                success(getResponseDic)
            }
            catch
            {
                print("error : getRestaurantLayout")
            }
            
            }, failure: {(error) -> Void in
                failure(error)
                print("Error : \(error.localizedDescription)")
        })
        
    }
    
    //MARK:-Get Seat Detail user logged in API
    
    func getAllSeatsDetailUserLoggedIn(userInfoDict : NSDictionary, success:(NSDictionary)-> Void, failure:(NSError) -> Void) -> Void
    {
        let UrlWithSearchKeyword = "\(baseURL)get_all_seat_details"
        
        webObj.requestWithMethodAndParameter("GET", urlString: UrlWithSearchKeyword, parameters: userInfoDict, success: {(data) -> Void in
            
            do
            {
                let getResponseDic: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                success(getResponseDic)
            }
            catch
            {
                print("error : getRestaurantLayout")
            }
            }, failure: {(error) -> Void in
                failure(error)
                print("Error : \(error.localizedDescription)")
        })
    }
    
    
    func getSeatsDetailUserLoggedIn(userInfoDict : NSDictionary, success:(NSDictionary)-> Void, failure:(NSError) -> Void) -> Void
    {
//        var email_id : String = userInfoDict.objectForKey("email") as! String
        let UrlWithSearchKeyword = "\(baseURL)get_seat_detail.json"
        
        webObj.requestWithMethodAndParameter("GET", urlString: UrlWithSearchKeyword, parameters: userInfoDict, success: {(data) -> Void in
            
            do
            {
                let getResponseDic: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                success(getResponseDic)
            }
            catch
            {
                print("error : getRestaurantLayout")
            }
            
            }, failure: {(error) -> Void in
                failure(error)
                print("Error : \(error.localizedDescription)")
        })
    }
    
    
    //MARK:-All Levels of Venue API
    
    func getAllLevelssDetail(venues_id: String, success:(NSDictionary)-> Void, failure:(NSError) -> Void) -> Void
    {
        // http://52.5.49.148/api/v1/venues/:venue_id/levels
        
        let UrlWithSearchKeyword = "\(baseURL)venues/\(venues_id)/levels"
        
        webObj.getRequestWithEndPoint(UrlWithSearchKeyword, parameters: nil, success: {(data) -> Void in
            
            do
            {
                let getResponseDic: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                success(getResponseDic)
            }
            catch
            {
                print("error : getRestaurantLayout")
            }
            }, failure: {(error) -> Void in
                failure(error)
                print("Error : \(error.localizedDescription)")
        })
    }
    
    
    
    //MARK:-All block list API
    
    func getAllBlocksDetail(venues_id: String, level_id: String, success:(NSDictionary)-> Void, failure:(NSError) -> Void) -> Void
    {
        //http://52.5.49.148/api/v1/venues/:venue_id/blocks
        //http://52.5.49.148/api/v1/venues/:venue_id/levels/:level_id/blocks
        
        let UrlWithSearchKeyword = "\(baseURL)venues/\(venues_id)/levels/\(level_id)/blocks"
        
        webObj.getRequestWithEndPoint(UrlWithSearchKeyword, parameters: nil, success: {(data) -> Void in
            
            do
            {
                let getResponseDic: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                success(getResponseDic)
            }
            catch
            {
                print("error : getRestaurantLayout")
            }
            
            }, failure: {(error) -> Void in
                failure(error)
                print("Error : \(error.localizedDescription)")
        })
    }
    
    //Mark:- Get all seat list
    
    func getAllSeatsDetail(venue_id: String, level_id: String,block_id: String, success:(NSDictionary)-> Void, failure:(NSError) -> Void) -> Void
    {
        //http://52.5.49.148/api/v1/block/seats/:venue_id/:block_id
        //http://52.5.49.148/api/v1/venues/:venue_id/levels/:level_id/blocks/:block_id/seats
        let UrlWithSearchKeyword = "\(baseURL)venues/\(venue_id)/levels/\(level_id)/blocks/\(block_id)/seats"
        
        print(UrlWithSearchKeyword)
        
        webObj.getRequestWithEndPoint(UrlWithSearchKeyword, parameters: nil, success: {(data) -> Void in
            
            do
            {
                let getResponseDic: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                success(getResponseDic)
            }
            catch
            {
                print("error : getRestaurantLayout")
            }
            
            }, failure: {(error) -> Void in
                failure(error)
                print("Error : \(error.localizedDescription)")
        })
    }
    
    
    //Mark:- Get all seat list
    
    func getAllPathsOfDetail(venue_id: String, level_id: String, success:(NSDictionary)-> Void, failure:(NSError) -> Void) -> Void
    {
        //http://52.5.49.148/api/v1/venues/2
        //http://52.5.49.148/api/v1/venues/:venue_id/levels/:level_id
        let UrlWithSearchKeyword = "\(baseURL)venues/\(venue_id)/levels/\(level_id)"
        
        print("Get All Paths : \(UrlWithSearchKeyword)")
        
        webObj.getRequestWithEndPoint(UrlWithSearchKeyword, parameters: nil, success: {(data) -> Void in
            
            do
            {
                let getResponseDic: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                success(getResponseDic)
            }
            catch
            {
                print("error : getRestaurantLayout")
            }
            
            }, failure: {(error) -> Void in
                failure(error)
                print("Error : \(error.localizedDescription)")
        })
        
    }
    
    
    func getUserSeatInfoWithUUID(success:(NSDictionary)-> Void, failure:(NSError) -> Void) -> Void
    {
//        let UrlWithSearchKeyword = "http://112.196.19.154/api/v4/venue/get_user_seat_info.json"
        let UrlWithSearchKeyword = "\(baseURL)get_user_seat_info.json"
        webObj.getRequestWithEndPoint(UrlWithSearchKeyword, parameters: nil, success: {(data) -> Void in
            
            do
            {
                let getResponseDic: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                success(getResponseDic)
            }
            catch
            {
                print("error : getRestaurantLayout")
                failure(error as NSError)
            }
            
            }, failure: {(error) -> Void in
                failure(error)
                print("Error : \(error.localizedDescription)")
        })
    }
    
    
    func getVenueLayOut(success:(NSDictionary)-> Void, failure:(NSError) -> Void) -> Void
    {
        let UrlWithSearchKeyword = "http://112.196.19.154/api/v4/venue/layout/get"
        webObj.getRequestWithEndPoint(UrlWithSearchKeyword, parameters: nil, success: {(data) -> Void in
            
            do
            {
                let getResponseDic: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                success(getResponseDic)
            }
            catch
            {
                print("error : getRestaurantLayout")
                failure(error as NSError)
            }
            
            }, failure: {(error) -> Void in
                failure(error)
                print("Error : \(error.localizedDescription)")
        })
    }
    
}