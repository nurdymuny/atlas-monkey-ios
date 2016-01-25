//
//  ViewController.swift
//  atlasmonkey
//
//  Created by nurdymuny on 20/10/15.
//  Copyright (c) 2015 nurdymuny. All rights reserved.
//

import UIKit
import CoreLocation
//import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate, ABBeaconManagerDelegate {
    
    var beaconManager: ABBeaconManager!
    var arrBeaconUUID: NSMutableArray = NSMutableArray()
    
    var arrBeaconRange: NSMutableArray = NSMutableArray()
    
    var timer: NSTimer!
    
    var dictForUserSeatInfo : NSDictionary = NSDictionary()
    
    var arrAllSeat : NSMutableArray = NSMutableArray()
    
    var arrForAllPaths : NSMutableArray = NSMutableArray()
    
    
    var user_seat_number : Int!
    
    var user_seat_numberStr: String!
    
    var user_block_number : Int!
    
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
    
    var levelId : NSString!
    
    let locationManager = CLLocationManager()

    
//    var currentMarker : GMSMarker!
    
    var shouldShowInfoWindow : Bool!
    
    var infoWindow : InfoWindow!
    
    var isRepeat : Bool?
    
    
    //MARK:- Life cycle of VC
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beaconManager = ABBeaconManager.init() //[[ABBeaconManager alloc] init];
        beaconManager.delegate = self
        
        beaconManager.requestAlwaysAuthorization()
        
        isRepeat = true
        
        getDist_Start = 0.0
        
        getDist_End = 0.0
        
        user_seat_number = 0
        
        user_seat_numberStr = "0"
        
        user_block_number = 0
        
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
        
//        self.googleMap()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillDisappear(true)
        
        //        isRepeat = false
        
        self.startRangeBeacons()                                                       //
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.stopRangeBeacons()                                                        //
        
        super.viewWillDisappear(true)
        
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
        
        var lblActInd : UILabel = UILabel()
        lblActInd.frame = CGRectMake(0, actInd.frame.size.height/2+50, actInd.frame.size.width, 50)
        lblActInd.text = "Please wait. Loading..."
        lblActInd.textAlignment = NSTextAlignment.Center
        lblActInd.textColor = UIColor.grayColor()
        actInd.addSubview(lblActInd)
    }
    
    
    //MARK:- Update user location delegate
    
   /* func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        //        print("didUpdateLocations Delegate")
        //        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        //        print("locations = \(locValue.latitude) \(locValue.longitude)")
        //
        //        self.pathDraw(locValue.latitude, longitude: locValue.longitude)
        //
        //        manager.stopUpdatingLocation()
        
        
        var location : CLLocation = locations.last as! CLLocation// lastObject
        
        
    }*/
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
    }
    
    func updateMyLocation(locations : CLLocation)
    {
    }
    
    
    
    
    //MARK: -  Custom methods
    
    func startRangeBeacons()
    {
        let tran: ABTransmitters = ABTransmitters.sharedTransmitters()
        
        for (index, obj) in tran.transmitters().enumerate() {
            // your code
            
            print("\(index) ------------ \(obj)")
            print(obj["uuid"])
            
            let proximityUUID: NSUUID = NSUUID.init(UUIDString: obj["uuid"] as! String)!//(value["uuid"])//[[NSUUID alloc] initWithUUIDString:obj[@"uuid"]];
            
            let regionIdentifier: String = obj["uuid"] as! String
            
            
            var beaconRegion : ABBeaconRegion!
            
            beaconRegion =  ABBeaconRegion.init(proximityUUID: proximityUUID, identifier: regionIdentifier)
            //[[ABBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:regionIdentifier];
            beaconRegion.notifyOnEntry = true
            
            beaconRegion.notifyOnExit = true
            
            beaconRegion.notifyEntryStateOnDisplay = true
            
            beaconManager.startRangingBeaconsInRegion(beaconRegion)
        }
    }
    
    
    func stopRangeBeacons()
    {
        
        let tran: ABTransmitters = ABTransmitters.sharedTransmitters()
        
        for (index, obj) in tran.transmitters().enumerate() {
            print("\(index)----------- \(obj)")
            print(obj["uuid"])
            
            let proximityUUID: NSUUID = NSUUID.init(UUIDString: obj["uuid"] as! String)!//(value["uuid"])//[[NSUUID alloc] initWithUUIDString:obj[@"uuid"]];
            
            let regionIdentifier: String = obj["uuid"] as! String
            
            var beaconRegion : ABBeaconRegion!
            
            beaconRegion =  ABBeaconRegion.init(proximityUUID: proximityUUID, identifier: regionIdentifier)
            
            beaconManager.stopRangingBeaconsInRegion(beaconRegion)
        }
    }
    
    
    func beaconManager(manager: ABBeaconManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: ABBeaconRegion!) {
        
        print("iBeacons : \(beacons)")
        
        
        if(beacons.count != 0)
        {
            //            let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
            //
            //            print("knownBeacons : \(knownBeacons)")
            
            let closestBeacon = beacons[0] as! ABBeacon
            
            let str: NSString = closestBeacon.proximityUUID.UUIDString
            
            let pred: NSPredicate = NSPredicate(format: "uuid==%@", str)
            
            let result: NSArray = arrBeaconUUID.filteredArrayUsingPredicate(pred)
            
            let success : Bool = result.count > 0
            
            if success
            {
                self.stopRangeBeacons()
                
                self.getNearestBeacon()
            }
            else
            {
                let dictionary : NSMutableDictionary = NSMutableDictionary()
                
                dictionary.setValue(closestBeacon.proximityUUID.UUIDString, forKey: "uuid")
                
                dictionary.setValue(closestBeacon.distance, forKey: "distance")
                
                dictionary.setValue(closestBeacon.major, forKey: "major")
                
                dictionary.setValue(closestBeacon.minor, forKey: "minor")
                
                arrBeaconUUID.addObject(dictionary)
                arrBeaconRange.addObject(closestBeacon.distance as Double)
            }
            
        }
        
        
    }
    
    func beaconManager(manager: ABBeaconManager!, rangingBeaconsDidFailForRegion region: ABBeaconRegion!, withError error: NSError!) {
        print("Error : \(error.description)")
    }
    
    
    func getNearestBeacon()
    {
        
        print("Repeat getNearestBeacon")
        
        //****************************    Find User iBeacon    ****************************//
        
        
        let str: NSString = "74278BDA-B644-4520-8F0C-720EAF059935"
        
        let pred: NSPredicate = NSPredicate(format: "uuid==%@", str)
        
        let result: NSArray = arrBeaconUUID.filteredArrayUsingPredicate(pred)
        
        let success : Bool = result.count > 0
        
        if success
        {
            print("User Beacon Info : \(result)")
            
//            lblUserBeaconUUID.text = result[0]["uuid"] as? String
//            
//            lblUserBeaconMajor.text = String(result[0]["major"] as! NSNumber)
//            
//            lblUserBeaconMinor.text = String(result[0]["minor"] as! NSNumber)
        }
        else
        {
            print("74278BDA-B644-4520-8F0C-720EAF059935 uuid did not find yet")
        }
        
        
        
        
        
        //****************************    Find Nearest iBeacon    ****************************//
        
        let arr : Array = arrBeaconRange as Array
        
        print(arr)
        
        //        let numMax = arr.maxElement { (myDouble, newDouble) -> Bool in
        //
        //            return true
        //
        //        }
        //
        //        print("numMax : \(numMax)")
        
        let numMin = arr.minElement { (myObje, nextObj) -> Bool in
            
            if (myObje as! Double) < (nextObj as! Double)
            {
                print(myObje)
                
                return true
            }
            return false
        }
        
        print("numMin : \(numMin)")
        
        let Index = arr.indexOf{$0 === numMin}
        
        print(Index)
        
        print(arrBeaconUUID[Index!])
        
        let nearestBeaconUUID : String = (arrBeaconUUID[Index!]["uuid"] as? String)!
        
        let nearestBeaconMajor = arrBeaconUUID[Index!]["major"]
        
        let nearestBeaconMinor = arrBeaconUUID[Index!]["minor"]
        
        print("nearestBeaconMajor : \(nearestBeaconMajor) ----- nearestBeaconMinor :\(nearestBeaconMinor)")
        
//        lblNearestBeacon.text = nearestBeaconUUID
        
        arrBeaconRange.removeAllObjects()
        arrBeaconUUID.removeAllObjects()
        //        arrBeacon.removeAllObjects()
        
        self.startRangeBeacons()
        
    }
    
    
    
    
    
    
    //MARK:- Load google map
    
    func googleMap()
    {
        //        var camera = GMSCameraPosition.cameraWithLatitude(30.671555,
        //            longitude:76.7391794, zoom:25)
        
        print("dictForUserSeatInfo : \(dictForUserSeatInfo)")
        
        print(dictForUserSeatInfo.valueForKey("seat_number") as! NSString)
        
        var userSeatNumber : NSString = dictForUserSeatInfo.valueForKey("seat_number") as! NSString
        
        self.user_seat_number = userSeatNumber.integerValue
        
        self.user_seat_numberStr = userSeatNumber as String
        
        self.user_block_number = (dictForUserSeatInfo.valueForKey("block_id") as! Int)
        
        self.levelId = String(dictForUserSeatInfo.valueForKey("level_id") as! Int)
        
        let lati : Double = (dictForUserSeatInfo.valueForKey("latitude") as! NSString).doubleValue
        
        let longi : Double = (dictForUserSeatInfo.valueForKey("longitude") as! NSString).doubleValue
        
        let seatLatLong : CLLocation = CLLocation(latitude:lati , longitude:longi)
        
       
        
        
        
        infoWindow = InfoWindow(frame: CGRectMake(20, screenHeight/2-50, screenWidth-40, 100))
        infoWindow.initWithFrameSize()
        infoWindow.backgroundColor = UIColor(red: 246.0/255.0, green: 0.0/255.0, blue: 147.0/255, alpha: 1.0)
        infoWindow.layer.cornerRadius = 3.0
        infoWindow.clipsToBounds = true
        self.view.addSubview(infoWindow)
        infoWindow.hidden = true
        shouldShowInfoWindow = false
        
    }
    
    func buttonRefreshAction(sender : UIButton)
    {
        self.refreshMapView()
    }
    
    
    func refreshMapView()
    {
        dist_a = nil
        
        dist_b = nil
        
        getDist_Start = 0.0
        
        getDist_End = 0.0
        
        isGetFinalPath = "no"
        
    
        
        self.markAllSeats()
    }
    
    
    func buttonBackAction(sender : UIButton)
    {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    
    
    
    //MARK:- APIs
    
    func getAllSeatsDetailOfUserLoggedIn()
    {
        self.actInd.startAnimating()
        
        let dictUserInfo : NSMutableDictionary = NSMutableDictionary()
        dictUserInfo.setObject(NSUserDefaults.standardUserDefaults().objectForKey("email_id") as! String, forKey: "email")
        
        UserViewManager.sharedInstance.getAllSeatsDetailUserLoggedIn(dictUserInfo, success: { (getResponseDic) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                print("getAllSeatsDetailUserLoggedIn responseDict : \(getResponseDic)")
                
                self.actInd.stopAnimating()
                
                let strResponse :Bool = getResponseDic.objectForKey("success")! as! Bool
                
                if strResponse == true
                {
                    print(((getResponseDic["data"] as! NSDictionary)["seats"] as! NSArray)[0]["seat_number"] as! NSString)
                    
                    var userSeatNumber : NSString = ((getResponseDic["data"] as! NSDictionary)["seats"] as! NSArray)[0]["seat_number"] as! NSString
                    
                    self.user_seat_number = userSeatNumber.integerValue
                    
                    self.user_seat_numberStr = userSeatNumber as String
                    
                    self.user_block_number = (((getResponseDic["data"] as! NSDictionary)["seats"] as! NSArray)[0]["block_id"] as! Int)
                    
                    self.levelId = String(((getResponseDic["data"] as! NSDictionary)["seats"] as! NSArray)[0]["level_id"] as! Int)
                    
                    self.getAllLevelsOfVenue()
                }
                else
                {
                    self.getAllLevelsOfVenue()
                    
                }
            })
            }, failure: { (error) -> Void in
                AtlasCommonMethod.alertViewCustom("", messageStr: "Something went wrong.Please try again!")
                
        })
    }

    
    func getAllLevelsOfVenue()
    {
        self.actInd.startAnimating()
        
        UserViewManager.sharedInstance.getAllLevelssDetail(venue_id, success: { (getResponseDic) -> Void in
            
            //            print("All Blocks responseDict : \(getResponseDic)")
            
            self.actInd.stopAnimating()
            
            let strResponse :Bool = getResponseDic.objectForKey("success")! as! Bool
            
            var arrForLevel : NSMutableArray = NSMutableArray()
            
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
            
            print("All Blocks responseDict : \(getResponseDic)")
            
            let strResponse :Bool = getResponseDic.objectForKey("success")! as! Bool
            
            var arrForBlocks : NSMutableArray = NSMutableArray()
            
            if strResponse == true
            {
                
                arrForBlocks.addObjectsFromArray(((getResponseDic["data"] as! NSDictionary)["level"] as! NSDictionary)["blocks"] as! NSArray as [AnyObject])
                
                for var i=0;i<arrForBlocks.count;i++
                {
                    let blockId: String = String(arrForBlocks.objectAtIndex(i).objectForKey("id") as! Int)
                    
                    print("levelId :\(levelId), blockId: \(blockId)")
                    
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
    
    
    
    //MARK:- Marker on google map for ploting the all chairs
    
    func markAllSeats()
    {   
        /*print(mapView)
        
        print(mapView.myLocation)
        
        if mapView.myLocation == nil
        {
            UIAlertView(title: "Location not enabled.", message: "Concert monkey required to access your location. Please goto Setting -> Concert monkey -> Location -> Always", delegate: nil, cancelButtonTitle: "OK").show()
            
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            
            return
        }

        if arrAllSeat.count > 0
        {
            for var i=0; i<arrAllSeat.count; i++
            {
                var chairLatitude : String = arrAllSeat.objectAtIndex(i).objectForKey("latitude") as! String
                var chairLongitude : String = arrAllSeat.objectAtIndex(i).objectForKey("longitude") as! String
                
                var seatNumber : NSString = arrAllSeat.objectAtIndex(i).objectForKey("seat_number") as! NSString
                
                var blockIdNumber : Int = arrAllSeat.objectAtIndex(i).objectForKey("block_id") as! Int
                
                var marker = GMSMarker()
                
                marker.position = CLLocationCoordinate2DMake((chairLatitude as NSString).doubleValue, (chairLongitude as NSString).doubleValue)
                
                marker.title = "Seat : \(seatNumber)"
                
                marker.snippet = "Block : \(blockIdNumber)"
                
            
                if user_seat_numberStr != "0"
                {
//                    if seatNumber.integerValue == user_seat_number && blockIdNumber == user_block_number
                    if seatNumber == user_seat_numberStr && blockIdNumber == user_block_number
                    {
                        marker.icon = UIImage(named: "chair_green")
                        
                        marker.infoWindowAnchor = CGPointMake(0.3, 0.3)
                        
                        userChairLocation = CLLocation(latitude: (chairLatitude as NSString).doubleValue, longitude: (chairLongitude as NSString).doubleValue)
                        
                        arrGetRightPath.removeAllObjects()
                        
                        print(mapView)
                        
                        print(mapView.myLocation)
                        
                        print(mapView.myLocation.coordinate)
                        
                        arrGetRightPath.addObject("\(mapView.myLocation.coordinate.latitude),\(mapView.myLocation.coordinate.longitude)")
                        
                        userLocation = CLLocation(latitude:mapView.myLocation.coordinate.latitude , longitude:mapView.myLocation.coordinate.longitude)
                        
                        ////////UserLocationAssign
                        
//                        userLocation = CLLocation(latitude:34.06134 , longitude:-118.308757)
//
//                        arrGetRightPath.addObject("\(34.06134),\(-118.308757)")
                        
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
            
        }
*/
        self.getAllPathsOfVenue()
    }
    
    
    func getAllPathsOfVenue()
    {
        self.actInd.startAnimating()
        
        UserViewManager.sharedInstance.getAllPathsOfDetail("\(venue_id)", level_id: "\(levelId)", success: { (getResponseDic) -> Void in
            
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