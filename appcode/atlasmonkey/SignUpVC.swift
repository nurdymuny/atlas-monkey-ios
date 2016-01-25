//
//  SignUpVC.swift
//  TableViewDemo
//
//  Created by nurdymuny on 05/10/15.
//  Copyright (c) 2015 nurdymuny. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    
    @IBOutlet var txtEmail: UITextField!
    
    @IBOutlet var txtPassword: UITextField!
    
    @IBOutlet var txtConfirmPassword: UITextField!
    
    
    @IBOutlet var btnSignUp: UIButton!
    
    @IBOutlet var btnLogin: UIButton!
    
    
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.createUI()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        actInd.frame = CGRectMake(0,0, screenWidth, screenHeight)
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.backgroundColor = UIColor.clearColor()
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        view.addSubview(actInd)
        actInd.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func createUI()
    {
        let paddingView : UIView = UIView(frame: CGRectMake(0, 0, 40, 40))
        var paddingViewEmail : UIImageView = UIImageView()
        paddingViewEmail.frame = CGRectMake(10, 7, 20, 26)
        paddingViewEmail.image = UIImage(named: "emailUser")
        paddingView.addSubview(paddingViewEmail)
        
        txtEmail.leftView = paddingView
        txtEmail.leftViewMode = UITextFieldViewMode.Always
        
        txtEmail.layer.cornerRadius = 2
        txtEmail.clipsToBounds = true
        
        var paddingView1 : UIView = UIView(frame: CGRectMake(0, 0, 40, 40))
        var paddingViewPassword : UIImageView = UIImageView()
        paddingViewPassword.frame = CGRectMake(10, 7, 20, 26)
        paddingViewPassword.image = UIImage(named: "password")
        paddingView1.addSubview(paddingViewPassword)
        
        txtPassword.leftView = paddingView1
        txtPassword.leftViewMode = UITextFieldViewMode.Always
        
        txtPassword.layer.cornerRadius = 2
        txtPassword.clipsToBounds = true
        
        
        var paddingView2 : UIView = UIView(frame: CGRectMake(0, 0, 40, 40))
        var paddingViewConPassword : UIImageView = UIImageView()
        paddingViewConPassword.frame = CGRectMake(10, 7, 20, 26)
        paddingViewConPassword.image = UIImage(named: "password")
        paddingView2.addSubview(paddingViewConPassword)
        
        txtConfirmPassword.leftView = paddingView2
        txtConfirmPassword.leftViewMode = UITextFieldViewMode.Always
        
        txtConfirmPassword.layer.cornerRadius = 2
        txtConfirmPassword.clipsToBounds = true
        
    }
    
    
    
    // MARK: - Button Action
    
    @IBAction func signUpAction(sender: UIButton) {
        var email : NSString = AtlasCommonMethod.trim(txtEmail.text!) as NSString
        
        var password : NSString = txtPassword.text! as NSString
        
        var passwordConfirm : NSString = txtConfirmPassword.text! as NSString
        
        if email.length == 0 || password.length == 0 || passwordConfirm.length == 0
        {
            AtlasCommonMethod.alertViewCustom("", messageStr: "All fields are required.")
        }
        else if AtlasCommonMethod.isValidEmail(email as String) == false
        {
            AtlasCommonMethod.alertViewCustom("", messageStr: "Please enter a valid email address.")
        }
        else if password.length == 0 || passwordConfirm.length == 0
        {
            AtlasCommonMethod.alertViewCustom("", messageStr: "Password must be atleast 8 characters.")
        }
        else if password.length < 8 || passwordConfirm.length < 8
        {
            AtlasCommonMethod.alertViewCustom("", messageStr: "Password must be atleast 8 characters.")
        }
        else if password != passwordConfirm
        {
            AtlasCommonMethod.alertViewCustom("", messageStr: "Password must be match.Please enter again.")
        }
        else
        {
            var dictUserInfo : NSMutableDictionary = NSMutableDictionary()
            dictUserInfo.setObject(email, forKey: "email")
            dictUserInfo.setObject(password, forKey: "password")
            dictUserInfo.setObject(passwordConfirm, forKey: "password_confirmation")
            
            var finalDict : NSMutableDictionary = NSMutableDictionary()
            finalDict.setObject(dictUserInfo, forKey: "user")
            
            self.signupAPI(finalDict)
        }
    
    }
    
    
    @IBAction func loginAction(sender: UIButton) {
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func signupAPI(dict : NSDictionary)
    {
        actInd.startAnimating()
        
        UserViewManager.sharedInstance.registrationsUser(dict, success: { (getResponseDic) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                print("registrationsUser responseDict : \(getResponseDic)")
                
                self.actInd.stopAnimating()
                
                let strResponse :Bool = getResponseDic.objectForKey("success")! as! Bool
                
                if strResponse == true
                {
                    var authToken : String = getResponseDic.objectForKey("data")!.objectForKey("auth_token") as! String
                    var emailId : String = getResponseDic.objectForKey("user")!.objectForKey("email") as! String
                    var userId : Int = getResponseDic.objectForKey("user")!.objectForKey("id") as! Int
                    
                    NSUserDefaults.standardUserDefaults().setValue(authToken, forKey: "auth_token")
                    NSUserDefaults.standardUserDefaults().setValue(emailId, forKey: "email_id")
                    NSUserDefaults.standardUserDefaults().setValue("\(userId)", forKey: "user_id")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
//                    self.performSegueWithIdentifier("MainVCSegueFromSignUp", sender: self)
                }
                else
                {
                    if let errors:NSArray = getResponseDic.objectForKey("errors") as? NSArray
                    {
                        AtlasCommonMethod.alertViewCustom("", messageStr: errors.objectAtIndex(0) as! String)
                    }
                    else if let errors:String = getResponseDic.objectForKey("error") as? String
                    {
                        AtlasCommonMethod.alertViewCustom("", messageStr: getResponseDic.objectForKey("error") as! String)
                    }
                    else
                    {
                        AtlasCommonMethod.alertViewCustom("", messageStr: "Something went wrong. Please try again later.")
                    }
                }
            })
            
            }, failure : { (error) -> Void in
                print("Error : \(error)")
                
                AtlasCommonMethod.alertViewCustom("", messageStr: "Something went wrong!")
        })
    }
    
    
    // MARK: -prepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        segue.destinationViewController as! ViewController
    }
    
    
    // MARK: - Delegate textField
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == txtEmail
        {
            txtPassword.becomeFirstResponder()
        }
        else if textField == txtPassword
        {
            txtConfirmPassword.becomeFirstResponder()
        }
        else
        {
            txtConfirmPassword.resignFirstResponder()
        }
        
        return true
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
