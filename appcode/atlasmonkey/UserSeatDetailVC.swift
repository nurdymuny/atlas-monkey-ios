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
        
        if sender.tag == 25
        {
            AtlasCommonMethod.alert("Warning", message: "Seat not allocate to you by admin.", view: self)
        }
        else
        {
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
    }
    
    
    func alertForWrning()
    {
        AtlasCommonMethod.alert("Location not enabled.", message: "Concert monkey required to access your location. Please goto Setting -> Concert monkey -> Location -> Always", view: self)
    }
    
    
    //MARK:- API for getting user seat info
    
    func getInfoOfSeat()
    {
        self.actInd.startAnimating()
        let defaults = NSUserDefaults.standardUserDefaults()
        let user_id = defaults.objectForKey("user_id") as? String
        
        UserViewManager.sharedInstance.getUserSeatInfoWithUUID(user_id!, success: { (getResponseDic) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                print("getSeatsDetailUserLoggedIn responseDict : \(getResponseDic)")
                
                self.actInd.stopAnimating()
                
                //                self.btnViewSeat.userInteractionEnabled = false
                
                self.btnViewSeat.tag = 25
                
                if let strResponse :Bool = getResponseDic.objectForKey("success") as? Bool
                {
                    if strResponse == true
                    {
                        self.userSeatDict = getResponseDic["seats"] as! NSMutableDictionary
                        
                        let UserBlockId : String = String(self.userSeatDict["block_id"] as! Int)
                        
                        let userSeatNumber : Int = self.userSeatDict["seat_id"] as! Int
                        
                        let xNSNumber = userSeatNumber as NSNumber
                        
                        let xString : String = xNSNumber.stringValue
                        
                        self.lblSeatNo.text =  xString
                        
                        self.lblBlockNo.text = UserBlockId
                        
                        venue_name = self.userSeatDict["venue_name"] as! String
                        
                        self.lblVenue.text = venue_name as String
                        
                        //                        self.btnViewSeat.userInteractionEnabled = true
                        
                        self.btnViewSeat.tag = 50
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
            
            }) { (error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    //                    self.btnViewSeat.userInteractionEnabled = false
                    
                    self.btnViewSeat.tag = 25
                    
                    self.actInd.stopAnimating()
                    
                    AtlasCommonMethod.alert("", message: "Something went wrong.Please try again!", view: self)
                })
        }
        
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
