//
//  AppDelegate.swift
//  atlasmonkey
//
//  Created by nurdymuny on 20/10/15.
//  Copyright (c) 2015 nurdymuny. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var internetReachable: Reachability?
    
    //    let reachability = Reachability.reachabilityForInternetConnection()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //        GMSServices.provideAPIKey("AIzaSyA9KkhqJq-mXF-VrKv2TQ85UV-0aJ_gZgQ")
        // Override point for customization after application launch.
        
        //        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        internetReachable = Reachability.reachabilityForInternetConnection()//[Reachability reachabilityForInternetConnection];
        internetReachable?.startNotifier()
        //           [internetReachable startNotifie?r];
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkNetworkStatus:", name: kReachabilityChangedNotification, object: nil)
        //             [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
        
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func checkNetworkStatus(notice : NSNotification )
    {
        // called after network status changes
        
        let internetStatus : NetworkStatus = (internetReachable?.currentReachabilityStatus())!
        
        switch(internetStatus.rawValue)
        {
        case 0:
            print("The internet is down.")
            AtlasCommonMethod.alertViewCustom("", messageStr: "Your internet connection is down,Please check your internet connection!")
        case 1:
            AtlasCommonMethod.alertViewCustom("", messageStr: "Internet Connection is available.")
            return
        case 2:
            AtlasCommonMethod.alertViewCustom("", messageStr: "Internet Connection is available.")
            return
        default:
            print("Default")
            
        }
    }
}

