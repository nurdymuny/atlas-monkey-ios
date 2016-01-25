//
//  LoginVC.swift
//  TableViewDemo
//
//  Created by nurdymuny on 05/10/15.
//  Copyright (c) 2015 nurdymuny. All rights reserved.
//

import UIKit
//import GoogleMaps

class LoginVC: UIViewController {

    @IBOutlet var txtEmail: UITextField!
    
    @IBOutlet var txtPassword: UITextField!
    
    @IBOutlet var btnLogin: UIButton!
    
    @IBOutlet var btnSignUp: UIButton!
    
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createUI()

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
            AtlasCommonMethod.alertViewCustom("", messageStr: "All fields are required.")
        }
        else if AtlasCommonMethod.isValidEmail(email as String) == false
        {
            AtlasCommonMethod.alertViewCustom("", messageStr: "Please enter a valid email address.")
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
                    AtlasCommonMethod.alertViewCustom("", messageStr: getResponseDic.objectForKey("info") as! String)
                }
            })
            
        }, failure:{ (error) -> Void in
            AtlasCommonMethod.alertViewCustom("", messageStr: "Something went wrong.Please try again!")
        })
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
