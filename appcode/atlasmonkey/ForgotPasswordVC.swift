//
//  ForgotPasswordVC.swift
//  TableViewDemo
//
//  Created by nurdymuny on 07/10/15.
//  Copyright (c) 2015 nurdymuny. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet var txtEmail: UITextField!
    
    @IBOutlet var btnBack: UIButton!
    
    @IBOutlet var btnForgotPassword: UIButton!
    
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createUI()
        
        actInd.frame = CGRectMake(0,0, screenWidth, screenHeight)
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.backgroundColor = UIColor.clearColor()
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        view.addSubview(actInd)
        actInd.stopAnimating()
        // Do any additional setup after loading the view.
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
        
        btnForgotPassword.layer.cornerRadius = 5
        btnForgotPassword.clipsToBounds = true
        
        btnBack.layer.cornerRadius = 5
        btnBack.clipsToBounds = true
    }
    

    @IBAction func backAction(sender: UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func getPassword(sender: UIButton) {
        
        let email : NSString = AtlasCommonMethod.trim(txtEmail.text!) as NSString
        
        if email.length == 0
        {
            AtlasCommonMethod.alertViewCustom("", messageStr: "Please enter email id.")
        }
        else if AtlasCommonMethod.isValidEmail(email as String) == false
        {
            AtlasCommonMethod.alertViewCustom("", messageStr: "Please enter a valid email address.")
        }
        else
        {
            let dictUserInfo : NSMutableDictionary = NSMutableDictionary()
            dictUserInfo.setObject(email, forKey: "email")
            
            let finalDict : NSMutableDictionary = NSMutableDictionary()
            finalDict.setObject(dictUserInfo, forKey: "user")
            
            self.getPasswordRecover(finalDict)
        }
    }
    
    
    func getPasswordRecover(dict : NSDictionary)
    {
        actInd.startAnimating()
        
        UserViewManager.sharedInstance.getPasswordRecover(dict, success: { (getResponseDic) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                print("Recover Password : \(getResponseDic)")
                
                self.actInd.stopAnimating()
                
                let strResponse :Bool = getResponseDic.objectForKey("success")! as! Bool
                
                if strResponse == true
                {
                    let alert = UIAlertView()
                    alert.title = ""
                    alert.message = getResponseDic.objectForKey("info") as? String
                    alert.addButtonWithTitle("Ok")
                    alert.delegate = self
                    alert.show()
                    
                }
                else
                {
                    AtlasCommonMethod.alertViewCustom("", messageStr: getResponseDic.objectForKey("info") as! String)
                }
            })
            
            }, failure : { (error) -> Void in
                print("Error : \(error)")
                AtlasCommonMethod.alertViewCustom("", messageStr: "Something went wrong.Please try again!")
        })
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Delegate textField
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
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
