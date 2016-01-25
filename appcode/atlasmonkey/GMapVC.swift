//
//  GMapVC.swift
//  atlasmonkey
//
//  Created by nurdymuny on 20/10/15.
//  Copyright (c) 2015 nurdymuny. All rights reserved.
//

import UIKit
import CoreLocation
//import GoogleMaps


class GMapVC: UIViewController, CLLocationManagerDelegate {

    
    var timer: NSTimer!
    
    let locationManager = CLLocationManager()
    
    
    var arrAllSeat : NSMutableArray = NSMutableArray()
    
    var arrForAllPaths : NSMutableArray = NSMutableArray()
    
    
    var user_seat_number : Int!
    
    var userLocation : CLLocation!
    
    var userChairLocation : CLLocation!
    
    var dist_a : CLLocationDistance!
    var dist_b : CLLocationDistance!
    
    var getDist_Start : Double!
    var getDist_End : Double!
    var getDist_Total : Double!
    
    var arrGetRightPath : NSMutableArray = NSMutableArray()
    
    var getStartLatLongOfPath : NSString!
    var getEndtLatLongOfPath : NSString!
    
    var isGetFinalPath : String!
    
    var isUserSeatAvailable : Bool!
    
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    //MARK:- Life cycle of VC
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDist_Start = 0.0
        
        getDist_End = 0.0
        
        user_seat_number = 0
        
        isGetFinalPath = "no"
        
        isUserSeatAvailable = false
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        //        userLocation = CLLocation(latitude:30.671494026339 , longitude:76.7392091003361) // [[CLLocation alloc] initWithLatitude:-23.0002 longitude:-43.2438];
        //
        //        arrGetRightPath.addObject("\(30.671494026339),\(76.7392091003361)")
        
        //        self.setAllPaths()
        
        self.googleMap()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        actInd.frame = CGRectMake(0,0, screenWidth, screenHeight)
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.backgroundColor = UIColor.clearColor()
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(actInd)
        actInd.stopAnimating()
        
        let lblActInd : UILabel = UILabel()
        lblActInd.frame = CGRectMake(0, actInd.frame.size.height/2+50, actInd.frame.size.width, 50)
        lblActInd.text = "Please wait. Loading..."
        lblActInd.textAlignment = NSTextAlignment.Center
        lblActInd.textColor = UIColor.grayColor()
        actInd.addSubview(lblActInd)
    }
    
    
    //MARK:- Update user location delegate
    /*
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        //        print("didUpdateLocations Delegate")
        //        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        //        print("locations = \(locValue.latitude) \(locValue.longitude)")
        //
        //        self.pathDraw(locValue.latitude, longitude: locValue.longitude)
        //
        //        manager.stopUpdatingLocation()
        
        
        let location : CLLocation = locations.last as! CLLocation// lastObject
        
        
    } */
    
    func updateMyLocation(locations : CLLocation)
    {
//        var locationUpdate : GMSCameraUpdate = GMSCameraUpdate.setTarget(locations.coordinate, zoom: 25)
//        
//        mapView.animateWithCameraUpdate(locationUpdate)
    }
    
    //MARK:- Load google map
    
    func googleMap()
    {
        //        var camera = GMSCameraPosition.cameraWithLatitude(30.671555,
        //            longitude:76.7391794, zoom:25)
        
        
        /* var camera = GMSCameraPosition.cameraWithLatitude(34.06134,
            longitude:-118.308784, zoom:25)
        //        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera:camera)
        
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        
        mapView.delegate = self
        
        mapView.mapType = kGMSTypeNormal
        
        //        mapView.setMinZoom(12, maxZoom: mapView.maxZoom)
        
        mapView.myLocationEnabled = true
        
        mapView.settings.myLocationButton = true
        
        mapView.settings.indoorPicker = true
        
        mapView.settings.compassButton = true
        
        //        mapView.clear()
        
        mapView.indoorEnabled = true
        
        mapView.indoorDisplay
        
        self.view = mapView
        
        //        self.getAllLevelsOfVenue()
        
        //        self.getAllSeats()
        
        self.getAllSeatsDetailOfUserLoggedIn()
        
        
        let buttonRefresh:UIButton = UIButton(frame: CGRectMake(screenWidth/2-50, screenHeight-60, 100, 50))
        
        buttonRefresh.setImage(UIImage(named: "refreshBtn"), forState: UIControlState.Normal)
        
        buttonRefresh.addTarget(self, action: "buttonRefreshAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        buttonRefresh.tag = 1;
        
        mapView.addSubview(buttonRefresh)*/
        
        
    }
    
    func buttonRefreshAction(sender : UIButton)
    {
        dist_a = nil
        
        dist_b = nil
        
        getDist_Start = 0.0
        
        getDist_End = 0.0
        
        isGetFinalPath = "no"
        
//        mapView.clear()
        
        self.markAllSeats()
    }
    
    
    
    
    //MARK:- APIs
    
    func getAllLevelsOfVenue()
    {
        self.actInd.startAnimating()
        
        UserViewManager.sharedInstance.getAllLevelssDetail(venue_id, success: { (getResponseDic) -> Void in
            
            //            print("All Blocks responseDict : \(getResponseDic)")
            
            self.actInd.stopAnimating()
            
            let strResponse :Bool = getResponseDic.objectForKey("success")! as! Bool
            
            let arrForLevel : NSMutableArray = NSMutableArray()
            
            if strResponse == true
            {
                
                arrForLevel.addObjectsFromArray(((getResponseDic["data"] as! NSDictionary)["venue"] as! NSDictionary)["levels"] as! NSArray as [AnyObject])
                
                print("arrForLevel : \(arrForLevel)")
                
                for var i=0;i<arrForLevel.count;i++
                {
                    let levelId: String = String(arrForLevel.objectAtIndex(i).objectForKey("id") as! Int)
                    self.getAllBlocks(levelId)
                }
                
            }
            
            }, failure : { (error) -> Void in
                
                print("Error : \(error)")
                AtlasCommonMethod.alertViewCustom("", messageStr: "Something went wrong.Please try again!")
        })
    }
    
    
    func getAllBlocks(levelId : String)
    {
        self.actInd.startAnimating()
        
        UserViewManager.sharedInstance.getAllBlocksDetail(venue_id, level_id: levelId, success: { (getResponseDic) -> Void in
            
            self.actInd.stopAnimating()
            
            //            print("All Blocks responseDict : \(getResponseDic)")
            
            let strResponse :Bool = getResponseDic.objectForKey("success")! as! Bool
            
            let arrForBlocks : NSMutableArray = NSMutableArray()
            
            if strResponse == true
            {
                print(getResponseDic["data"])
                
                arrForBlocks.addObjectsFromArray(((getResponseDic["data"] as! NSDictionary)["level"] as! NSDictionary)["blocks"] as! NSArray as [AnyObject])
                
                print("arrForBlocks : \(arrForBlocks)")
                
                for var i=0;i<arrForBlocks.count;i++
                {
                    let blockId: String = String(arrForBlocks.objectAtIndex(i).objectForKey("id") as! Int)
                    self.getAllSeats(levelId, blockId: blockId)
                }
            }
            
            }, failure : { (error) -> Void in
                
                print("Error : \(error)")
                
                AtlasCommonMethod.alertViewCustom("", messageStr: "Something went wrong.Please try again!")
        })
    }
    
    
    func getAllSeats(levelId : String, blockId : String)
    {
        self.actInd.startAnimating()
        
        UserViewManager.sharedInstance.getAllSeatsDetail("\(venue_id)", level_id: levelId, block_id: blockId, success: { (getResponseDic) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.actInd.stopAnimating()
                
                let strResponse :Bool = getResponseDic.objectForKey("success")! as! Bool
                
                if strResponse == true
                {
                    self.arrAllSeat.addObjectsFromArray(((getResponseDic["data"] as! NSDictionary)["block"] as! NSDictionary)["seats"] as! NSArray as [AnyObject])
                    
                    self.markAllSeats()
                }
            })
            
            }, failure : { (error) -> Void in
                print("Error : \(error)")
                AtlasCommonMethod.alertViewCustom("", messageStr: "Something went wrong.Please try again!")
        })
    }
    
    
    
    
    func getAllSeatsDetailOfUserLoggedIn()
    {
        self.actInd.startAnimating()
        
        let dictUserInfo : NSMutableDictionary = NSMutableDictionary()
        dictUserInfo.setObject(NSUserDefaults.standardUserDefaults().objectForKey("email_id") as! String, forKey: "email")
        
        print(dictUserInfo)
        
        UserViewManager.sharedInstance.getAllSeatsDetailUserLoggedIn(dictUserInfo, success: { (getResponseDic) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                print("getAllSeatsDetailUserLoggedIn responseDict : \(getResponseDic)")
                
                self.actInd.stopAnimating()
                
                let strResponse :Bool = getResponseDic.objectForKey("success")! as! Bool
                
                if strResponse == true
                {
                    print(((getResponseDic["data"] as! NSDictionary)["seats"] as! NSArray)[0]["seat_number"] as! NSString)
                    
                    let userSeatNumber : NSString = ((getResponseDic["data"] as! NSDictionary)["seats"] as! NSArray)[0]["seat_number"] as! NSString
                    
                    self.user_seat_number = userSeatNumber.integerValue
                    
                    //                    self.getAllSeats()
                    self.getAllLevelsOfVenue()
                }
                else
                {
                    //                    self.getAllSeats()
                    self.getAllLevelsOfVenue()
                    
                }
            })
            }, failure: { (error) -> Void in
                
                AtlasCommonMethod.alertViewCustom("", messageStr: "Something went wrong.Please try again!")
                
        })
    }
    
    
    
    
    //MARK:- Marker on google map for ploting the all chairs
    
    func markAllSeats()
    {
    
        /*if arrAllSeat.count > 0
        {
            for var i=0; i<arrAllSeat.count; i++
            {
                var chairLatitude : String = arrAllSeat.objectAtIndex(i).objectForKey("latitude") as! String
                var chairLongitude : String = arrAllSeat.objectAtIndex(i).objectForKey("longitude") as! String
                
                var seatNumber : String = arrAllSeat.objectAtIndex(i).objectForKey("seat_number") as! String
                
                var marker = GMSMarker()
                
                marker.position = CLLocationCoordinate2DMake((chairLatitude as NSString).doubleValue, (chairLongitude as NSString).doubleValue)
                
                //                marker.flat = true
                
                if user_seat_number != 0
                {
                    if i == user_seat_number-1
                    {
                        marker.icon = UIImage(named: "chair_green")
                        
                        marker.title = "Chair No.\(user_seat_number)"
                        
                        marker.infoWindowAnchor = CGPointMake(0.3, 0.3)
                        
                        userChairLocation = CLLocation(latitude: (chairLatitude as NSString).doubleValue, longitude: (chairLongitude as NSString).doubleValue)
                        
                        userLocation = CLLocation(latitude:mapView.myLocation.coordinate.latitude , longitude:mapView.myLocation.coordinate.longitude)
                        
                        arrGetRightPath.removeAllObjects()
                        
                        arrGetRightPath.addObject("\(mapView.myLocation.coordinate.latitude),\(mapView.myLocation.coordinate.longitude)")
                        
                        //                        userLocation = CLLocation(latitude:34.061388 , longitude:-118.308882)
                        //
                        //                        arrGetRightPath.addObject("\(34.061388),\(-118.308882)")
                        
                        isUserSeatAvailable = true
                        
                    }
                    else
                    {
                        marker.icon = UIImage(named: "chair_gray")
                    }
                    
                }
                else
                {
                    marker.icon = UIImage(named: "chair_gray")
                }
                
                marker.map = mapView
            }
            
            if isUserSeatAvailable == true
            {
                self.getAllPathsOfVenue()
                
            }
            
        }*/
        
        self.getAllPathsOfVenue()
    }
    
    
    func getAllPathsOfVenue()
    {
        self.actInd.startAnimating()
        
        UserViewManager.sharedInstance.getAllPathsOfDetail("\(venue_id)", level_id: "\(5)", success: { (getResponseDic) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                print("getAllPathsOfDetail responseDict : \(getResponseDic)")
                
                self.actInd.stopAnimating()
                
                let strResponse :Bool = getResponseDic.objectForKey("success")! as! Bool
                
                if strResponse == true
                {
                    self.arrForAllPaths.removeAllObjects()
                    
                    self.arrForAllPaths.addObjectsFromArray(((getResponseDic["data"] as! NSDictionary)["level"] as! NSDictionary)["lat_longs"] as! NSArray as [AnyObject])
                    
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "update", userInfo: nil, repeats: false)
                    
                    //                    self.timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "allPathOnMap", userInfo: nil, repeats: false)
                }
            })
            }, failure: { (error) -> Void in
                
                print("Error : \(error.description)")
                
                AtlasCommonMethod.alertViewCustom("", messageStr: "Something went wrong.Please try again!")
                
        })
    }
 
    
   
    
    

}
