//
//  LoginVC.swift
//  TableViewDemo
//
//  Created by nurdymuny on 05/10/15.
//  Copyright (c) 2015 nurdymuny. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth


class LoginVC: UIViewController, CLLocationManagerDelegate, CBCentralManagerDelegate, alertProtocol {

    @IBOutlet var txtEmail: UITextField!
    
    @IBOutlet var txtPassword: UITextField!
    
    @IBOutlet var btnLogin: UIButton!
    
    @IBOutlet var btnSignUp: UIButton!
    
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView()
    
    let locationManagerObj = CLLocationManager()
    
    var centralManager: CBCentralManager!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createUI()
        
        // Start up the CBCentralManager
        centralManager = CBCentralManager(delegate: self, queue: dispatch_get_main_queue())

//        txtEmail.becomeFirstResponder()
        
        
//        var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
//        actInd.frame = CGRectMake(0,0, screenWidth, screenHeight)
//        actInd.center = self.view.center
//        actInd.hidesWhenStopped = true
//        actInd.backgroundColor = UIColor.purpleColor()
//        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//        view.addSubview(actInd)
//        actInd.stopAnimating()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        txtEmail.text = ""
//        txtPassword.text = ""
        
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
        
        
        print(CLLocationManager.locationServicesEnabled())
        
        locationManagerObj.requestAlwaysAuthorization()
        
        locationManagerObj.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManagerObj.delegate = self
            locationManagerObj.desiredAccuracy = kCLLocationAccuracyBest
            locationManagerObj.startUpdatingLocation()
        }
        
        
       
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        txtEmail.text = ""
        txtPassword.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createUI()
    {
        let paddingView : UIView = UIView(frame: CGRectMake(0, 0, 40, 40))
        let paddingViewEmail : UIImageView = UIImageView()
        paddingViewEmail.frame = CGRectMake(10, 7, 20, 26)
        paddingViewEmail.image = UIImage(named: "emailUser")
        paddingView.addSubview(paddingViewEmail)
        
        txtEmail.leftView = paddingView
        txtEmail.leftViewMode = UITextFieldViewMode.Always
        
        txtEmail.layer.cornerRadius = 2
        txtEmail.clipsToBounds = true
        
        let paddingView1 : UIView = UIView(frame: CGRectMake(0, 0, 40, 40))
        let paddingViewPassword : UIImageView = UIImageView()
        paddingViewPassword.frame = CGRectMake(10, 7, 20, 26)
        paddingViewPassword.image = UIImage(named: "password")
        paddingView1.addSubview(paddingViewPassword)
        
        txtPassword.leftView = paddingView1
        txtPassword.leftViewMode = UITextFieldViewMode.Always
        
        txtPassword.layer.cornerRadius = 2
        txtPassword.clipsToBounds = true
    }
    
    // MARK: - Button Action
    
    @IBAction func loginAction(sender: UIButton) {
        
        let email : NSString = AtlasCommonMethod.trim(txtEmail.text!) as NSString
        
        let password : NSString = txtPassword.text! as NSString
        
        if email.length == 0 || password.length == 0
        {
            AtlasCommonMethod.alert("", message: "All fields are required.", view: self)
        }
        else if AtlasCommonMethod.isValidEmail(email as String) == false
        {
            AtlasCommonMethod.alert("", message: "Please enter a valid email address.", view: self)
        }
        else
        {
            let dictUserInfo : NSMutableDictionary = NSMutableDictionary()
            dictUserInfo.setObject(email, forKey: "email")
            dictUserInfo.setObject(password, forKey: "password")
            
            let finalDict : NSMutableDictionary = NSMutableDictionary()
            finalDict.setObject(dictUserInfo, forKey: "user")
            
            self.loginAPI(finalDict)
        }
    }
    
    @IBAction func forgotPasswordAction(sender: UIButton) {
        self.performSegueWithIdentifier("ForgotPasswordVCSegue", sender: self)
    }
    @IBAction func signUpAction(sender: UIButton) {
        
        self.performSegueWithIdentifier("SignUpVCSegue", sender: self)
    }
    
    
    func loginAPI(dict : NSDictionary)
    {
        actInd.startAnimating()
        
        UserViewManager.sharedInstance.loginUser(dict, success: { (getResponseDic) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                print("registrationsUser responseDict : \(getResponseDic)")
                
                let strResponse :Bool = getResponseDic.objectForKey("success")! as! Bool
                
                self.actInd.stopAnimating()
                
                if strResponse == true
                {
                    let authToken : String = getResponseDic.objectForKey("data")!.objectForKey("auth_token") as! String
                    let emailId : String = getResponseDic.objectForKey("user")!.objectForKey("email") as! String
                    let userId : Int = getResponseDic.objectForKey("user")!.objectForKey("id") as! Int
                    
                    NSUserDefaults.standardUserDefaults().setValue(authToken, forKey: "auth_token")
                    NSUserDefaults.standardUserDefaults().setValue(emailId, forKey: "email_id")
                    NSUserDefaults.standardUserDefaults().setValue("\(userId)", forKey: "user_id")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    self.performSegueWithIdentifier("UserSeatDetailVCSegue", sender: self)
                    
//                    self.performSegueWithIdentifier("MainVCSegueFromLogin", sender: self)
                    
//                    self.getAllSeatsDetail()
                }
                else
                {
                    AtlasCommonMethod.alert("", message: getResponseDic.objectForKey("info") as! String, view: self)
                }
            })
            
        }, failure:{ (error) -> Void in
             AtlasCommonMethod.alert("", message: "Something went wrong.Please try again!", view: self)
        })
    }
    
    
    //MARK:- Update user location delegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        
        print("location status : \(CLLocationManager.authorizationStatus())")
        
        let authstate = CLLocationManager.authorizationStatus()
        
        if(authstate == CLAuthorizationStatus.NotDetermined){
            print("Not Authorised")
            locationManagerObj.requestWhenInUseAuthorization()
        }
        else if(authstate == CLAuthorizationStatus.Denied){
            print("Not Authorised")
            locationManagerObj.requestWhenInUseAuthorization()
        }
        else if(authstate == CLAuthorizationStatus.Restricted){
            print("Not Authorised")
            locationManagerObj.requestWhenInUseAuthorization()
        }
        else if(authstate == CLAuthorizationStatus.AuthorizedAlways){
            print("Authorised")
            locationManagerObj.requestWhenInUseAuthorization()
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("error : \(error.localizedDescription)")
        
        print(" location : \(CLLocationManager.locationServicesEnabled())")
        
        print("location status : \(CLLocationManager.authorizationStatus())")
        
        let authstate = CLLocationManager.authorizationStatus()
        
        if(authstate == CLAuthorizationStatus.NotDetermined){
            print("Not Authorised")
            locationManagerObj.requestWhenInUseAuthorization()
        }
        else if(authstate == CLAuthorizationStatus.Denied){
            print("Not Authorised")
            locationManagerObj.requestWhenInUseAuthorization()
        }
        else if(authstate == CLAuthorizationStatus.Restricted){
            print("Not Authorised")
            locationManagerObj.requestWhenInUseAuthorization()
        }
        
    }
    
    
    //MARK:- Bluetooth Delegate
    //MARK: - delegates
    func centralManagerDidUpdateState(central: CBCentralManager)
    {
        if central.state == CBCentralManagerState.PoweredOff
        {
            return
//            self.checkBlueTooth()
        }
    }
    
//    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
//        if peripheral.state == CBPeripheralManagerState.PoweredOff {
//            print("Stopped")
//            self.checkBlueTooth()
//        } else if peripheral.state == CBPeripheralManagerState.Unsupported {
//            print("Unsupported")
//            self.checkBlueTooth()
//        } else if peripheral.state == CBPeripheralManagerState.Unauthorized {
//            print("This option is not allowed by your application")
//            self.checkBlueTooth()
//        }
//    }
    
    func checkBlueTooth()
    {
        AtlasCommonMethod.sharedInstance.delegateAlert = self
        AtlasCommonMethod.sharedInstance.getAlertMessage("Bluetooth Warning", messageStr: "Please turn on the bluetooth by tapping on setting, If it is turn off currently?", view: self)
    }
    
    // MARK: - Delegate textField
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == txtEmail
        {
            txtPassword.becomeFirstResponder()
        }
        else
        {
            txtPassword.resignFirstResponder()
        }
        
        return true
    }
    
    
    //MARK:- delegate AtlasCommonMethod
    func settingSelected()
    {
        UIApplication.sharedApplication().openURL(NSURL(string: "prefs:root=Bluetooth")!)
    }
    func cancelSelected()
    {
//        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: -prepareForSegue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == "SignUpVCSegue"
        {
            segue.destinationViewController as! SignUpVC
        }
        else if segue.identifier == "ForgotPasswordVCSegue"
        {
            segue.destinationViewController as! ForgotPasswordVC
        }
        else
        {
            segue.destinationViewController as! UserSeatDetailVC
        }
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
