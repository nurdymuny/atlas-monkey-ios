//
//  UserSeatDetailVC.swift
//  Concert monkey
//
//  Created by nurdymuny on 03/11/15.
//  Copyright (c) 2015 nurdymuny. All rights reserved.
//

import UIKit
import CoreLocation

class UserSeatDetailVC: UIViewController {

    @IBOutlet var lblVenue: UILabel!
    
    @IBOutlet var lblBlockNo: UILabel!
    
    @IBOutlet var lblSeatNo: UILabel!
    
    @IBOutlet var btnViewSeat: UIButton!
    
    var block_id : NSString!
    
    var seat_id : NSString!
    
    var userSeatDict :NSMutableDictionary = NSMutableDictionary()
    
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actInd.frame = CGRectMake(0,0, screenWidth, screenHeight)
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.backgroundColor = UIColor.clearColor()
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        view.addSubview(actInd)
        actInd.stopAnimating()
        
        let lblActInd : UILabel = UILabel()
        lblActInd.frame = CGRectMake(0, actInd.frame.size.height/2+50, actInd.frame.size.width, 50)
        lblActInd.text = "Please wait. Locating your Seat..."
        lblActInd.textAlignment = NSTextAlignment.Center
        lblActInd.textColor = UIColor.whiteColor()
        actInd.addSubview(lblActInd)
        
        self.getInfoOfSeat()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnLogoutAction(sender: UIButton) {
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func btnShowUserSeatAction(sender: UIButton) {
        
        let authstate = CLLocationManager.authorizationStatus()
        
        if(authstate == CLAuthorizationStatus.NotDetermined || authstate == CLAuthorizationStatus.Denied || authstate == CLAuthorizationStatus.Restricted)
        {
            print("Not Authorised")
            
            self.alertForWrning()
        }
        else if(authstate == CLAuthorizationStatus.AuthorizedAlways)
        {
            print("Authorised")
            
            self.performSegueWithIdentifier("MapVCSegue", sender: self)
        }
    }
    
    
    func alertForWrning()
    {
        AtlasCommonMethod.alert("Location not enabled.", message: "Concert monkey required to access your location. Please goto Setting -> Concert monkey -> Location -> Always", view: self)
    }
    
    
    func getInfoOfSeat()
    {
        self.actInd.startAnimating()
        
        UserViewManager.sharedInstance.getUserSeatInfoWithUUID({ (getResponseDic) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                print("getSeatsDetailUserLoggedIn responseDict : \(getResponseDic)")
                
                self.actInd.stopAnimating()
                
//                self.btnViewSeat.userInteractionEnabled = false
                
                if let strResponse :Bool = getResponseDic.objectForKey("success") as? Bool
                {
                    if strResponse == true
                    {
                        self.userSeatDict = getResponseDic["seats"] as! NSMutableDictionary
                        
                        let UserBlockId : String = String(self.userSeatDict["block_id"] as! Int)
                        
                        let userRowNumber : String = self.userSeatDict["row"] as! String
                        
                        let userSeatNumber : Int = self.userSeatDict["seat_number"] as! Int
                        
                        self.lblSeatNo.text = "\(userRowNumber)-\(userSeatNumber)"
                        
                        self.lblBlockNo.text = UserBlockId
                        
//                        self.btnViewSeat.userInteractionEnabled = true
                    }
                    else
                    {
                        AtlasCommonMethod.alert("", message: "Something went wrong.Please try again!", view: self)
                    }
                }
                else
                {
                    AtlasCommonMethod.alert("Server Response Error", message: "Something went wrong.Please try again!", view: self)
                }
                
            })
            
            }, failure:  { (error) -> Void in
                 dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
//                    self.btnViewSeat.userInteractionEnabled = false
                    
                    self.actInd.stopAnimating()
                    
                    AtlasCommonMethod.alert("", message: "Something went wrong.Please try again!", view: self)
                })
        })
        
        /*
        
        let dictUserInfo : NSMutableDictionary = NSMutableDictionary()
        dictUserInfo.setObject(NSUserDefaults.standardUserDefaults().objectForKey("email_id") as! String, forKey: "email")
        
        UserViewManager.sharedInstance.getSeatsDetailUserLoggedIn(dictUserInfo, success: { (getResponseDic) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                print("getSeatsDetailUserLoggedIn responseDict : \(getResponseDic)")
                
                self.actInd.stopAnimating()
//                
                let strResponse :Bool = getResponseDic.objectForKey("success")! as! Bool
                
                if strResponse == true
                {
                    self.userSeatDict = (getResponseDic["data"] as! NSMutableDictionary)["seat"] as! NSMutableDictionary
                    
                    print("userSeatDict :\(self.userSeatDict)")
                    
                    self.btnViewSeat.userInteractionEnabled = true
                    
                    print(((getResponseDic["data"] as! NSDictionary)["seat"] as! NSDictionary)["seat_number"] as! NSString)
                    
                    let userSeatNumber : NSString = ((getResponseDic["data"] as! NSDictionary)["seat"] as! NSDictionary)["seat_number"] as! NSString
                    
                    self.seat_id = userSeatNumber
                    
                    self.lblSeatNo.text = userSeatNumber as String
                    
                    let user_block_number = (((getResponseDic["data"] as! NSDictionary)["seat"] as! NSDictionary)["block_id"] as! Int)
                    
                    self.block_id = String(user_block_number)
                    
                    self.lblBlockNo.text = String(user_block_number)
                    
                    venue_name = ((getResponseDic["data"] as! NSDictionary)["seat"] as! NSDictionary)["venue_name"] as! String
                    
                    self.lblVenue.text = venue_name as String
                    
                    venue_id = String(((getResponseDic["data"] as! NSDictionary)["seat"] as! NSDictionary)["venue_id"] as! Int)
                    
                }
                else
                {
//                    self.btnViewSeat.userInteractionEnabled = false
                    
                    self.btnViewSeat.userInteractionEnabled = true
                    
                    AtlasCommonMethod.alert("", message: "No ticket found.", view: self)
                }
            })
            }, failure: { (error) -> Void in
                
                AtlasCommonMethod.alert("", message: "Something went wrong.Please try again!", view: self)
        }) */
    }
    
    
    
    // MARK: -prepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let vcObj = segue.destinationViewController as! ViewController
        
        print(userSeatDict)
        vcObj.dictForUserSeatInfo = userSeatDict
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
