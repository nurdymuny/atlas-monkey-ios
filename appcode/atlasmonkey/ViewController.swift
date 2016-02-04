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

class ViewController: UIViewController, ABBeaconManagerDelegate, alertProtocol
{
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var btnBack: UIButton!
    
    var beaconManager: ABBeaconManager!
    
    var arrBeaconUUID: NSMutableArray = NSMutableArray()
    
    var arrBeaconRange: NSMutableArray = NSMutableArray()
    
    var seatsArray:NSMutableArray = NSMutableArray()
    var nearestEmptySeats:NSMutableArray = NSMutableArray()
    var mySeatDict:NSMutableDictionary = NSMutableDictionary()
    var actualPathArray : NSMutableArray = NSMutableArray()
    var userNearestDict:NSDictionary = NSDictionary()

    
    var gridRow = 0
    var gridColoumn = 0
    var gridHeight = 20
    var gridWidth = 20
    
    var orignal_x:Int = 0
    var orignal_y:Int = 0
    


    
    var IndexOfNearestSeat : Int = -1
    
    var numberOfBeacons : Int = 0
    
    var startDate: NSDate!
    
    var isSuccess:Bool =  false
    
    //////////////////////////////
    
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
    
    var shouldShowInfoWindow : Bool!
    
    var infoWindow : InfoWindow!
    
    var isRepeat : Bool?
    
    
    
    
    
    //MARK:- Life cycle of VC
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        startDate = NSDate()
        
        beaconManager = ABBeaconManager.init()
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
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillDisappear(true)
        
        //        isRepeat = false
        
//        self.startRangeBeacons()                                                       //
    }
    
    override func viewWillDisappear(animated: Bool)
    {
//        self.stopRangeBeacons()                                                        //
        
        super.viewWillDisappear(true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool)
    {
        btnBack.layer.cornerRadius = 3
        btnBack.clipsToBounds = true
        
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.scrollEnabled = true
        
        self.getVenueLayout()
        
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
    
    
    @IBAction func btnBackAction(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func getVenueLayout()
    {
        
        print(dictForUserSeatInfo)
        
       let venue_id = String(dictForUserSeatInfo.valueForKey("venue_id") as! NSNumber)
        
        let level_Id = String(dictForUserSeatInfo.valueForKey("level_id") as! NSNumber)
        
        UserViewManager.sharedInstance.getVenueLayOut(venue_id, level_id: level_Id as String, success: { (response) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if let success : Int = response.valueForKey("success") as? Int
                {
                    if success == 1
                    {
                        let dict = response.valueForKey("levels")
                        print("dict : \(dict)")
                        let gridDict : NSDictionary = dict!.valueForKey("grid") as! NSDictionary
                        
                        self.gridRow = (gridDict.valueForKey("x")?.integerValue)!
                        self.gridColoumn = gridDict.valueForKey("y")!.integerValue
                        
                        let width =  CGFloat(self.gridColoumn * self.gridWidth)
                        let height = CGFloat(self.gridRow * self.gridHeight)
                        self.scrollView.contentSize = CGSizeMake(width , height);
                        
                        self.seatsArray = (dict!.valueForKey("seats")?.mutableCopy())! as! NSMutableArray
                        print(self.seatsArray)
                        
                        self.gridView()
                    }
                    else
                    {
                        AtlasCommonMethod.alert("", message: "Something Went wrong", view: self)
                    }
                }
                else
                {
                    AtlasCommonMethod.alert("", message: "Something Went wrong", view: self)
                }
            })
            
            }) { (NSError) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.actInd.stopAnimating()
                    
                    AtlasCommonMethod.alert("", message: "Something Went wrong", view: self)
                })
        }

    }
    
    func gridView()
    {
        var row = 0
        var coloumn = 0
        var indexValue = 0;
        
        for(row = 0 ; row < gridRow ; row++)
        {
            for(coloumn = 0 ; coloumn < gridColoumn ; coloumn++)
            {
                if(indexValue < (gridRow * gridColoumn))
                {
                    let seatView:UIView = UIView()
                    seatView.frame = CGRectMake(CGFloat(coloumn * gridWidth), CGFloat(row * gridHeight), CGFloat(gridWidth), CGFloat(gridHeight))
                    //seatView.backgroundColor = UIColor.blackColor()
                    seatView.tag = 1000+indexValue
                    
                    seatView.clipsToBounds = true
                    self.scrollView.addSubview(seatView)
                    let dict = seatsArray.objectAtIndex(indexValue)
                    if(dict.valueForKey("is_path")?.boolValue ==  false)
                    {
                        
                       
                        let imageView:UIImageView = UIImageView()
                        imageView.frame = CGRectMake(3, 3, 14, 14)
                        
                        if dictForUserSeatInfo["uuid"] as! String == dict.valueForKey("uuid") as! String
                        {
                            imageView.backgroundColor = UIColor.greenColor()
                        }
                        else
                        {
                            imageView.backgroundColor = UIColor.grayColor()
                        }
                        
                        imageView.layer.cornerRadius = 3
                        imageView.clipsToBounds = true
                        imageView.tag = 999
                        seatView.addSubview(imageView)
                    }
                    else
                    {
                        seatView.backgroundColor = UIColor.whiteColor()
                    }

                    
                    indexValue++
                }
            }
        }
        
        self.startRangeBeacons()
    }
    
    
    func getMySeats(nearestDict:NSDictionary)
    {
        isSuccess = false
        self.mySeatDict.removeAllObjects()
        self.mySeatDict = dictForUserSeatInfo.mutableCopy() as! NSMutableDictionary
        self.getNearestEmptySeat(nearestDict)
    }
    
    
    func getNearestEmptySeat(nearestDict:NSDictionary)
    {
        userNearestDict = nearestDict
        print(seatsArray)
        print(mySeatDict)
        print(userNearestDict);
        
        let dict = userNearestDict.valueForKey("grid")
        let nearestXCordinate = dict?.valueForKey("x")
        let nearestYCordinate = dict?.valueForKey("y")
        
        
        let x:Int = Int((nearestXCordinate?.integerValue)!) + 1
        let y:Int = Int((nearestYCordinate?.integerValue)!)
        
        self.getpathUsingAddX(x, y: y)
        
        let x1:Int = Int((nearestXCordinate?.integerValue)!)
        let y1:Int = Int((nearestYCordinate?.integerValue)!) + 1
        
        self.getpathUsingAddY(x1, y: y1)
        
        
        let x2:Int = Int((nearestXCordinate?.integerValue)!) - 1
        let y2:Int = Int((nearestYCordinate?.integerValue)!)
        
        self.getpathUsingMinusX(x2, y: y2)
        
        let x3:Int = Int((nearestXCordinate?.integerValue)!)
        let y3:Int = Int((nearestYCordinate?.integerValue)!) - 1
        
        self.getpathUsingMinusY(x3, y: y3)
    }
    
    
    func getpathUsingAddX( x:Int, y:Int)
    {
        nearestEmptySeats.removeAllObjects()
        
        
        let resultPredicate = NSPredicate(format: "is_path = 1")
        let searchResults:NSArray = seatsArray.filteredArrayUsingPredicate(resultPredicate)
        let xPredicate = NSPredicate(format: "grid.x = %d",x)
        let yPredicate = NSPredicate(format: "grid.y = %d",y)
        let compound  = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [yPredicate, xPredicate])
        let resultY:NSArray = searchResults.filteredArrayUsingPredicate(compound)
        if(resultY.count > 0){
            
            nearestEmptySeats.addObject(resultY.objectAtIndex(0))
        }
        
        
    }
    
    func getpathUsingMinusX( x:Int, y:Int){
        
        let resultPredicate = NSPredicate(format: "is_path = 1")
        let searchResults:NSArray = seatsArray.filteredArrayUsingPredicate(resultPredicate)
        let xPredicate = NSPredicate(format: "grid.x = %d",x)
        let yPredicate = NSPredicate(format: "grid.y = %d",y)
        let compound  = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [yPredicate, xPredicate])
        let resultY:NSArray = searchResults.filteredArrayUsingPredicate(compound)
        if(resultY.count > 0){
            
            nearestEmptySeats.addObject(resultY.objectAtIndex(0))
        }
        
        
    }
    
    func getpathUsingAddY( x:Int, var y:Int){
        
        let resultPredicate = NSPredicate(format: "is_path = 1")
        let searchResults:NSArray = seatsArray.filteredArrayUsingPredicate(resultPredicate)
        let xPredicate = NSPredicate(format: "grid.x = %d",x)
        let yPredicate = NSPredicate(format: "grid.y = %d",y)
        let compound  = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [yPredicate, xPredicate])
        let resultY:NSArray = searchResults.filteredArrayUsingPredicate(compound)
        if(resultY.count > 0){
            
            nearestEmptySeats.addObject(resultY.objectAtIndex(0))
        }
        else{
            
            y = y + 1
            self.getpathUsingAddY(x , y: y)
        }
        
        
    }
    
    func getpathUsingMinusY( x:Int, var y:Int){
        
        let resultPredicate = NSPredicate(format: "is_path = 1")
        let searchResults:NSArray = seatsArray.filteredArrayUsingPredicate(resultPredicate)
        let xPredicate = NSPredicate(format: "grid.x = %d",x)
        let yPredicate = NSPredicate(format: "grid.y = %d",y)
        let compound  = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [yPredicate, xPredicate])
        let resultY:NSArray = searchResults.filteredArrayUsingPredicate(compound)
        if(resultY.count > 0){
            
            nearestEmptySeats.addObject(resultY.objectAtIndex(0))
            self.makingPath()
        }
        else{
            
            y = y - 1
            self.getpathUsingMinusY(x , y: y)
        }
        
    }
    
    func makingPath(){
        
        
        
        
        self.clearOldPath()

        print("userDict\(self.mySeatDict)")
        print("userNearestDict\(userNearestDict)")
        
        let mainDict = userNearestDict.valueForKey("grid")
        let nearestXCordinate = (mainDict!.valueForKey("x")?.integerValue)! - 1
        let nearestYCordinate = mainDict!.valueForKey("y")?.integerValue
        
        
        let resultPredicate = NSPredicate(format: "is_path = 1")
        let searchResults:NSArray = seatsArray.filteredArrayUsingPredicate(resultPredicate)
        let xPredicate = NSPredicate(format: "grid.x = %d",nearestXCordinate)
        let yPredicate = NSPredicate(format: "grid.y = %d",nearestYCordinate!)
        let compound  = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [yPredicate, xPredicate])
        let resultY:NSArray = searchResults.filteredArrayUsingPredicate(compound)
       
        
        if(resultY.count > 0){
            
            actualPathArray.addObject(resultY.objectAtIndex(0))
        }

        self.getNextStep(nearestXCordinate, y: nearestYCordinate!)
        
    }
    
    func getNextStep(var x:Int, var y:Int){
        
        
        //  print("my path\(actualPathArray)")
        
        
        let userDict = dictForUserSeatInfo.valueForKey("grid")
        let userXCordinate = userDict!.valueForKey("x")
        let userYCordinate = userDict!.valueForKey("y")
        
        let destiantionX:Int = Int(((userXCordinate?.integerValue)! - 1))
        let destiantionY:Int = Int((userYCordinate?.integerValue)!)
        
        print("My step\(x)")
        print("My step\(y)")

        print("My destination Path\(destiantionX)")
        print("My destination Path\(destiantionY)")
        
        
        if(destiantionX == x && destiantionY == y){

            if(!isSuccess){
                isSuccess = true
                print("this is my, path")
                print(actualPathArray)
                self.drawPathOnFloar()
                
            }

        }
        else
        {
            if(isSuccess){
                return
            }
            else{
                
                if(x > destiantionX)
                {
                    let resultPredicate = NSPredicate(format: "is_path = 1")
                    let searchResults:NSArray = seatsArray.filteredArrayUsingPredicate(resultPredicate)
                    let xPredicate = NSPredicate(format: "grid.x = %d",x - 1)
                    let yPredicate = NSPredicate(format: "grid.y = %d",y)
                    let compound  = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [yPredicate, xPredicate])
                    let resultY:NSArray = searchResults.filteredArrayUsingPredicate(compound)
                    
                    if(resultY.count > 0){
                        
                        orignal_x = x
                        x = x - 1
                        actualPathArray.addObject(resultY.objectAtIndex(0))
                        
                        if(!isSuccess){
                            self.getNextStep(x, y: y)}
                        else{
                        return
                        }
                    }
                    else{
                        
                        if(y > orignal_y){
                        let resultPredicate = NSPredicate(format: "is_path = 1")
                        let searchResults:NSArray = seatsArray.filteredArrayUsingPredicate(resultPredicate)
                        let xPredicate = NSPredicate(format: "grid.x = %d",x)
                        let yPredicate = NSPredicate(format: "grid.y = %d",y + 1)
                        let compound  = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [yPredicate, xPredicate])
                        let resultY:NSArray = searchResults.filteredArrayUsingPredicate(compound)
                        
                        if(resultY.count > 0){
                            
                            orignal_y = y
                            y = y + 1
                            actualPathArray.addObject(resultY.objectAtIndex(0))
                            
                            if(!isSuccess){
                                self.getNextStep(x, y: y)}
                            else{
                                return
                            }

                            }
                    }
                        else{
                            
                            let resultPredicate = NSPredicate(format: "is_path = 1")
                            let searchResults:NSArray = seatsArray.filteredArrayUsingPredicate(resultPredicate)
                            let xPredicate = NSPredicate(format: "grid.x = %d",x)
                            let yPredicate = NSPredicate(format: "grid.y = %d",y - 1)
                            let compound  = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [yPredicate, xPredicate])
                            let resultY:NSArray = searchResults.filteredArrayUsingPredicate(compound)
                            
                            if(resultY.count > 0){
                                
                                orignal_y = y
                                y = y - 1
                                actualPathArray.addObject(resultY.objectAtIndex(0))
                                
                                if(!isSuccess){
                                    self.getNextStep(x, y: y)}
                                else{
                                    return
                                }
                                
                            }

                        }
                    }
                    
                    
                    
                }
                
                if(x < destiantionX){
                    
                    let resultPredicate = NSPredicate(format: "is_path = 1")
                    let searchResults:NSArray = seatsArray.filteredArrayUsingPredicate(resultPredicate)
                    let xPredicate = NSPredicate(format: "grid.x = %d",x + 1 )
                    let yPredicate = NSPredicate(format: "grid.y = %d",y)
                    let compound  = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [yPredicate, xPredicate])
                    let resultY:NSArray = searchResults.filteredArrayUsingPredicate(compound)
                    
                    if(resultY.count > 0){
                        
                        orignal_x = x
                        x = x + 1
                        actualPathArray.addObject(resultY.objectAtIndex(0))
                        
                        
                        if(!isSuccess){
                            self.getNextStep(x, y: y)
                          }
                            else{
                                return
                            }
                        
                        
                    }
                    else
                    {
                        if(y < orignal_y){
                        let resultPredicate = NSPredicate(format: "is_path = 1")
                        let searchResults:NSArray = seatsArray.filteredArrayUsingPredicate(resultPredicate)
                        let xPredicate = NSPredicate(format: "grid.x = %d",x)
                        let yPredicate = NSPredicate(format: "grid.y = %d",y - 1)
                        let compound  = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [yPredicate, xPredicate])
                        let resultY:NSArray = searchResults.filteredArrayUsingPredicate(compound)
                        
                        if(resultY.count > 0){
                            
                            orignal_y = y
                            y = y - 1
                            actualPathArray.addObject(resultY.objectAtIndex(0))
                            
                            
                            if(!isSuccess){
                                self.getNextStep(x, y: y)
                            }
                            else{
                                return
                            }
                            
                            
                        }
                        }
                        else{
                            
                            let resultPredicate = NSPredicate(format: "is_path = 1")
                            let searchResults:NSArray = seatsArray.filteredArrayUsingPredicate(resultPredicate)
                            let xPredicate = NSPredicate(format: "grid.x = %d",x)
                            let yPredicate = NSPredicate(format: "grid.y = %d",y + 1)
                            let compound  = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [yPredicate, xPredicate])
                            let resultY:NSArray = searchResults.filteredArrayUsingPredicate(compound)
                            
                            if(resultY.count > 0){
                                
                                orignal_y = y
                                y = y + 1
                                actualPathArray.addObject(resultY.objectAtIndex(0))
                                
                                if(!isSuccess){
                                    self.getNextStep(x, y: y)}
                                else{
                                    return
                                }
                                
                            }
                        }
                    }
                    
                }
                
                if(y > destiantionY){
                    
                    let resultPredicate = NSPredicate(format: "is_path = 1")
                    let searchResults:NSArray = seatsArray.filteredArrayUsingPredicate(resultPredicate)
                    let xPredicate = NSPredicate(format: "grid.x = %d",x)
                    let yPredicate = NSPredicate(format: "grid.y = %d",y - 1)
                    let compound  = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [yPredicate, xPredicate])
                    let resultY:NSArray = searchResults.filteredArrayUsingPredicate(compound)
                    
                    if(resultY.count > 0){
                        
                        orignal_y = y
                        y = y - 1
                        actualPathArray.addObject(resultY.objectAtIndex(0))
                        
                        
                        if(!isSuccess){
                            self.getNextStep(x, y: y)
                        }
                        else{
                            return
                        }
                        
                        
                    }
                    else{
                        let resultPredicate = NSPredicate(format: "is_path = 1")
                        let searchResults:NSArray = seatsArray.filteredArrayUsingPredicate(resultPredicate)
                        let xPredicate = NSPredicate(format: "grid.x = %d",x + 1)
                        let yPredicate = NSPredicate(format: "grid.y = %d",y)
                        let compound  = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [yPredicate, xPredicate])
                        let resultY:NSArray = searchResults.filteredArrayUsingPredicate(compound)
                        
                        if(resultY.count > 0){
                            
                            orignal_x = x
                            x = x + 1
                            actualPathArray.addObject(resultY.objectAtIndex(0))
                            if(!isSuccess){
                                self.getNextStep(x, y: y)
                            }
                            else{
                                return
                            }
                    }
                    }
                    
                }
                
                if(y < destiantionY){
                    
                    let resultPredicate = NSPredicate(format: "is_path = 1")
                    let searchResults:NSArray = seatsArray.filteredArrayUsingPredicate(resultPredicate)
                    let xPredicate = NSPredicate(format: "grid.x = %d",x)
                    let yPredicate = NSPredicate(format: "grid.y = %d",y + 1)
                    let compound  = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [yPredicate, xPredicate])
                    let resultY:NSArray = searchResults.filteredArrayUsingPredicate(compound)
                    
                    if(resultY.count > 0){
                        
                        orignal_y = y
                        y = y + 1
                        actualPathArray.addObject(resultY.objectAtIndex(0))
                        if(!isSuccess){
                            self.getNextStep(x, y: y)
                        }
                        else{
                            return
                        }
                    }
                    else{
                        
                        let resultPredicate = NSPredicate(format: "is_path = 1")
                        let searchResults:NSArray = seatsArray.filteredArrayUsingPredicate(resultPredicate)
                        let xPredicate = NSPredicate(format: "grid.x = %d",x - 1)
                        let yPredicate = NSPredicate(format: "grid.y = %d",y)
                        let compound  = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [yPredicate, xPredicate])
                        let resultY:NSArray = searchResults.filteredArrayUsingPredicate(compound)
                        
                        if(resultY.count > 0){
                            
                            orignal_x = x
                            x = x - 1
                            actualPathArray.addObject(resultY.objectAtIndex(0))
                            if(!isSuccess){
                                self.getNextStep(x, y: y)
                            }
                            else{
                                return
                            }
                        }
                    }
                    
                }
                
                if(x == destiantionX){
                    
                    if (orignal_x < x){
                        
                        let resultPredicate = NSPredicate(format: "is_path = 1")
                        let searchResults:NSArray = seatsArray.filteredArrayUsingPredicate(resultPredicate)
                        let xPredicate = NSPredicate(format: "grid.x = %d",x + 1)
                        let yPredicate = NSPredicate(format: "grid.y = %d",y)
                        let compound  = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [yPredicate, xPredicate])
                        let resultY:NSArray = searchResults.filteredArrayUsingPredicate(compound)
                        
                        if(resultY.count > 0){
                            x = x + 1
                            actualPathArray.addObject(resultY.objectAtIndex(0))
                            if(!isSuccess){
                                self.getNextStep(x, y: y)
                            }
                            else{
                                return
                            }
                        }
                        
                    }
                    else{
                        
                        let resultPredicate = NSPredicate(format: "is_path = 1")
                        let searchResults:NSArray = seatsArray.filteredArrayUsingPredicate(resultPredicate)
                        let xPredicate = NSPredicate(format: "grid.x = %d",x - 1)
                        let yPredicate = NSPredicate(format: "grid.y = %d",y)
                        let compound  = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [yPredicate, xPredicate])
                        let resultY:NSArray = searchResults.filteredArrayUsingPredicate(compound)
                        
                        if(resultY.count > 0){
                            x = x - 1
                            actualPathArray.addObject(resultY.objectAtIndex(0))
                            if(!isSuccess){
                                self.getNextStep(x, y: y)
                            }
                            else{
                                return
                            }
                        }
                        
                    }
                    
                }
                if(y == destiantionY){
                    
                    if (orignal_y < y){
                        
                        let resultPredicate = NSPredicate(format: "is_path = 1")
                        let searchResults:NSArray = seatsArray.filteredArrayUsingPredicate(resultPredicate)
                        let xPredicate = NSPredicate(format: "grid.x = %d",x )
                        let yPredicate = NSPredicate(format: "grid.y = %d",y + 1)
                        let compound  = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [yPredicate, xPredicate])
                        let resultY:NSArray = searchResults.filteredArrayUsingPredicate(compound)
                        
                        if(resultY.count > 0){
                            y = y + 1
                            actualPathArray.addObject(resultY.objectAtIndex(0))
                            if(!isSuccess){
                                self.getNextStep(x, y: y)
                            }
                            else{
                                return
                            }
                        }
                        
                    }
                    else{
                        
                        let resultPredicate = NSPredicate(format: "is_path = 1")
                        let searchResults:NSArray = seatsArray.filteredArrayUsingPredicate(resultPredicate)
                        let xPredicate = NSPredicate(format: "grid.x = %d",x)
                        let yPredicate = NSPredicate(format: "grid.y = %d",y - 1)
                        let compound  = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [yPredicate, xPredicate])
                        let resultY:NSArray = searchResults.filteredArrayUsingPredicate(compound)
                        
                        if(resultY.count > 0){
                            y = y - 1
                            actualPathArray.addObject(resultY.objectAtIndex(0))
                            if(!isSuccess){
                                self.getNextStep(x, y: y)
                            }
                            else{
                                return
                            }
                        }
                        
                    }
                }

                
            }
        }
    }

    
    //MARK:- Path Draw & Clear
    func clearOldPath()
    {
        for (index,obj) in actualPathArray.enumerate()
        {
            print("\(index) - \(obj)")
            
            let index = seatsArray.indexOfObject(obj)
            
            let pathView = scrollView.viewWithTag(1000+index)
            
            pathView?.backgroundColor = UIColor.clearColor()
            
            
            let viewUserShow = pathView?.viewWithTag(666)
            let viewUserBlueDotShow = pathView?.viewWithTag(555)
            
            viewUserShow?.removeFromSuperview()
            viewUserBlueDotShow?.removeFromSuperview()
            
            let imgView = pathView?.viewWithTag(20000+index)
            imgView?.removeFromSuperview()
            
        }
        
        actualPathArray.removeAllObjects()
    }
    
    
    func drawPathOnFloar()
    {
        print(actualPathArray);
        
        let obj = actualPathArray.objectAtIndex(0)
        let dict = obj.valueForKey("grid")
        var orignal_x = (dict!.valueForKey("x")?.integerValue)! + 1
        var orignal_y = dict!.valueForKey("y")?.integerValue
        
        for (indexObj,obj) in actualPathArray.enumerate()
        {
            
            
            
            let dict = obj.valueForKey("grid")
            let x =  dict!.valueForKey("x")?.integerValue
            let y =  dict!.valueForKey("y")?.integerValue
            
            let index = seatsArray.indexOfObject(obj)
            let pathView = scrollView.viewWithTag(1000+index)
            

            
            if(x < orignal_x){
                
                orignal_x = x!
                
                let imgView:UIImageView = UIImageView()
                imgView.frame = CGRectMake(5, 5, 10, 10)
                imgView.tag = 20000 + index
               // imgView.backgroundColor = UIColor.blueColor()
                imgView.image = UIImage(named: "arrowup")
                pathView?.addSubview(imgView)
                
                
            }
            else if (x > orignal_x){
                
                orignal_x = x!
                
                let imgView:UIImageView = UIImageView()
                imgView.frame = CGRectMake(5, 5, 10, 10)
                 imgView.tag = 20000 + index
                imgView.image = UIImage(named: "arrowdown")
                pathView?.addSubview(imgView)

                
            }
            else if (y < orignal_y){
                
                orignal_y = y
                
                let imgView:UIImageView = UIImageView()
                imgView.frame = CGRectMake(5, 5, 10, 10)
                 imgView.tag = 20000 + index
                imgView.image = UIImage(named: "arrowleft")
                pathView?.addSubview(imgView)
                
            }
            else if (y > orignal_y){
                
                orignal_y = y
                
                let imgView:UIImageView = UIImageView()
                imgView.frame = CGRectMake(5, 5, 10, 10)
                 imgView.tag = 20000 + index
                imgView.image = UIImage(named: "arrowright")
                pathView?.addSubview(imgView)
                
            }
            
            
            if indexObj == 0
            {
                let userView : UIView = UIView()
                
                userView.frame = CGRectMake((pathView?.frame.size.width)!/2-5, (pathView?.frame.size.height)!/2-5, 10, 10)
                
                //                userView.backgroundColor = UIColor.greenColor()
                
                userView.tag = 666
                
                userView.layer.cornerRadius = userView.frame.size.width / 2
                
                userView.clipsToBounds = true
                
                userView.layer.borderColor = UIColor.greenColor().CGColor
                
                userView.layer.borderWidth = 2.0
                
                pathView?.addSubview(userView)
                
                let userBlueDotView : UIView = UIView()
                
                userBlueDotView.frame = CGRectMake((pathView!.frame.size.width)/2-5, (pathView!.frame.size.height)/2-5, 10, 10)
                
                userBlueDotView.backgroundColor = UIColor.blueColor()
                
                userBlueDotView.tag = 555
                
                userBlueDotView.layer.cornerRadius = userBlueDotView.frame.size.width / 2
                
                userBlueDotView.clipsToBounds = true
                
                pathView!.addSubview(userBlueDotView)
                
        
                
                UIView.animateWithDuration(2.0, delay:0, options: [.Repeat], animations: {
                    
                    userView.frame = CGRect(x: 0, y: 0, width: (pathView?.frame.size.width)!, height: (pathView?.frame.size.height)!)
                    
                    userView.layer.cornerRadius = userView.frame.size.width / 2
                    
                    userView.clipsToBounds = true
                    
                    userView.alpha = 0.3
                    
                    }, completion: nil)
            }
           
            
            
            //pathView?.backgroundColor = UIColor.blueColor()
            
        }
    }
    
    
    //MARK: -  Custom methods
    
    func startRangeBeacons()
    {

        for (_, obj) in seatsArray.enumerate()
        {
            if let isUUID : String = obj["uuid"] as? String
            {
                if isUUID != ""
                {

                    let proximityUUID: NSUUID = NSUUID.init(UUIDString: obj["uuid"] as! String)!
                    
                    let regionIdentifier: String = obj["uuid"] as! String
                    
                    var beaconRegion : ABBeaconRegion!
                    
                    beaconRegion =  ABBeaconRegion.init(proximityUUID: proximityUUID, identifier: regionIdentifier)
                    
                    beaconRegion.notifyOnEntry = true
                    
                    beaconRegion.notifyOnExit = true
                    
                    beaconRegion.notifyEntryStateOnDisplay = true
                    
                    numberOfBeacons++
                    
                    beaconManager.startRangingBeaconsInRegion(beaconRegion)
                }
            }
        }
    }
    
    
    func stopRangeBeacons()
    {
//        let tran: ABTransmitters = ABTransmitters.sharedTransmitters()
//        
//        for (index, obj) in tran.transmitters().enumerate()
        for (_, obj) in seatsArray.enumerate()
        {
            if let isUUID : String = obj["uuid"] as? String
            {
                if isUUID != ""
                {
                    let proximityUUID: NSUUID = NSUUID.init(UUIDString: obj["uuid"] as! String)!
                    
                    let regionIdentifier: String = obj["uuid"] as! String
                    
                    var beaconRegion : ABBeaconRegion!
                    
                    beaconRegion =  ABBeaconRegion.init(proximityUUID: proximityUUID, identifier: regionIdentifier)
                    
                    beaconManager.stopRangingBeaconsInRegion(beaconRegion)
                }
            }
        }
        return
    }
    
    
    //MARK:- iBeacon Delegates
    
    func beaconManager(manager: ABBeaconManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: ABBeaconRegion!)
    {
//        let timerr = RunningTimer.init()
//        print("Running: \(timerr) ")
//        let startDate: NSDate = NSDate()
        
        // your long procedure
        
        let endDate: NSDate = NSDate()
        
        let dateComponents: NSDateComponents = (NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)?.components(NSCalendarUnit.Nanosecond, fromDate: startDate, toDate: endDate, options:[]))!
        
        startDate = NSDate()
//
//        let dateComponents: NSDateComponents = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian).components(NSCalendarUnit.CalendarUnitNanosecond, fromDate: startDate, toDate: endDate, options: NSCalendarOptions(0))
        print("runtime is nanosecs : \(dateComponents.nanosecond)")
        
        print("iBeacons : \(beacons)")
        
        if(beacons.count != 0)
        {
            let closestBeacon = beacons[0] as! ABBeacon
            
            let strUUID: NSString = closestBeacon.proximityUUID.UUIDString
            
            let pred: NSPredicate = NSPredicate(format: "uuid==%@", strUUID)
            
            let result: NSArray = arrBeaconUUID.filteredArrayUsingPredicate(pred)
            
            let success : Bool = result.count > 0
            
            if success
            {
                print("numberOfBeacons : \(numberOfBeacons) - arrBeaconRange count : \(arrBeaconRange.count) - \(arrBeaconRange) arrBeaconRange count :\(arrBeaconUUID.count) - \(arrBeaconUUID)")
                
                if arrBeaconRange.count >= numberOfBeacons
                {
                    numberOfBeacons = 0
                    
                    self.stopRangeBeacons()
                    
                    self.getNearestBeacon()
                }
                else
                {
                    numberOfBeacons = 0
                    
                    self.stopRangeBeacons()
                    
                    self.clearBeaconInfo()
                }
            }
            else
            {
                if closestBeacon.distance as Double > 0.0
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
    }
    
    
    func beaconManager(manager: ABBeaconManager!, rangingBeaconsDidFailForRegion region: ABBeaconRegion!, withError error: NSError!)
    {
        if error != nil
        {
            print("Error : \(error.description)")
            
            AtlasCommonMethod.sharedInstance.delegateAlert = self
            AtlasCommonMethod.sharedInstance.getAlertMessage("Bluetooth Warning", messageStr: "Please turn on the bluetooth by tapping on setting, If it is turn off currently?", view: self)
        }
    }
    
    func clearBeaconInfo()
    {
        arrBeaconRange.removeAllObjects()
        arrBeaconUUID.removeAllObjects()
        //        arrBeacon.removeAllObjects()
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "startRangeBeacons", userInfo: nil, repeats: false)
    }
    
    func getNearestBeacon()
    {
        print("Repeat getNearestBeacon")
        
        //****************************    Find Nearest iBeacon    ****************************//
        let arr : Array = arrBeaconRange as Array
        
        let numMin = arr.minElement { (myObje, nextObj) -> Bool in
            
            if (myObje as! Double) < (nextObj as! Double)
            {
//                print(myObje)
                
                return true
            }
            return false
        }
        
        print("numMin : \(numMin)")
        
        let Index = arr.indexOf{$0 === numMin}
        
        let nearestBeaconUUID : String = (arrBeaconUUID[Index!]["uuid"] as? String)!
        
        let nearestBeaconMajor = arrBeaconUUID[Index!]["major"]
        
        let nearestBeaconMinor = arrBeaconUUID[Index!]["minor"]
        
        print("nearestBeaconUUID : \(nearestBeaconUUID) ---- nearestBeaconMajor : \(nearestBeaconMajor) ---- nearestBeaconMinor :\(nearestBeaconMinor)")
        
        let uuidNearest = nearestBeaconUUID
        
        let predicateForNearestUUID: NSPredicate = NSPredicate(format: "uuid==%@", uuidNearest)
        
        let resultArr: NSArray = seatsArray.filteredArrayUsingPredicate(predicateForNearestUUID)
        
        let successObj : Bool = resultArr.count > 0
        
        if successObj
        {
            let IndexOfSeat = seatsArray.indexOfObject(resultArr.objectAtIndex(0))
            
            print("User Beacon Info successObj : \(successObj) - \(resultArr) - Index :\(IndexOfSeat) - IndexOfNearestSeat :\(IndexOfNearestSeat)")
            
            if IndexOfNearestSeat != IndexOfSeat
            {
                if IndexOfNearestSeat != -1
                {
                    let viewSeat : UIView = scrollView.viewWithTag(1000+IndexOfNearestSeat)! //arrForSeatsView.objectAtIndex(IndexOfNearestSeat) as! UIView
                    
                    let seatColor = viewSeat.viewWithTag(999)
                    
                    if seatsArray.objectAtIndex(IndexOfNearestSeat).objectForKey("uuid") as! String == dictForUserSeatInfo.objectForKey("uuid") as! String
                    {
                        seatColor?.backgroundColor = UIColor.greenColor()
                    }
                    else
                    {
                        seatColor?.backgroundColor = UIColor.grayColor()
                    }
//                    IndexOfNearestSeat = IndexOfSeat
                }
                
                let viewSeat : UIView = scrollView.viewWithTag(1000+IndexOfSeat)! //arrForSeatsView.objectAtIndex(IndexOfSeat) as! UIView
                
                let seatColor = viewSeat.viewWithTag(999)
        
                if resultArr.objectAtIndex(0).objectForKey("uuid") as! String == dictForUserSeatInfo.objectForKey("uuid") as! String
                {
                    seatColor?.backgroundColor = UIColor.purpleColor()
                }
                else
                {
                    seatColor?.backgroundColor = UIColor.redColor()
                }
                
                IndexOfNearestSeat = IndexOfSeat
                
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    
                    self.getMySeats(resultArr.objectAtIndex(0) as! NSDictionary)
                }
            }
        }
        
        arrBeaconRange.removeAllObjects()
        arrBeaconUUID.removeAllObjects()
        //        arrBeacon.removeAllObjects()
        
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "startRangeBeacons", userInfo: nil, repeats: false)
//        self.startRangeBeacons()
    }
    
    
    //MARK:- Load google map
    
    func googleMap()
    {
        //        var camera = GMSCameraPosition.cameraWithLatitude(30.671555,
        //            longitude:76.7391794, zoom:25)
        
        print("dictForUserSeatInfo : \(dictForUserSeatInfo)")
        
        print(dictForUserSeatInfo.valueForKey("seat_number") as! NSString)
        
        let userSeatNumber : NSString = dictForUserSeatInfo.valueForKey("seat_number") as! NSString
        
        self.user_seat_number = userSeatNumber.integerValue
        
        self.user_seat_numberStr = userSeatNumber as String
        
        self.user_block_number = (dictForUserSeatInfo.valueForKey("block_id") as! Int)
        
        self.levelId = String(dictForUserSeatInfo.valueForKey("level_id") as! Int)
        
        let lati : Double = (dictForUserSeatInfo.valueForKey("latitude") as! NSString).doubleValue
        
        let longi : Double = (dictForUserSeatInfo.valueForKey("longitude") as! NSString).doubleValue
        
        let seatLatLong : CLLocation = CLLocation(latitude:lati , longitude:longi)
        
        print("seatLatLong : \(seatLatLong)")
       
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
                    
                    let userSeatNumber : NSString = ((getResponseDic["data"] as! NSDictionary)["seats"] as! NSArray)[0]["seat_number"] as! NSString
                    
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
            
            print("All Blocks responseDict : \(getResponseDic)")
            
            let strResponse :Bool = getResponseDic.objectForKey("success")! as! Bool
            
            let arrForBlocks : NSMutableArray = NSMutableArray()
            
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
    
    
    //MARK:- delegate AtlasCommonMethod
    func settingSelected()
    {
        UIApplication.sharedApplication().openURL(NSURL(string: "prefs:root=Bluetooth")!)
    }
    func cancelSelected()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}


struct RunningTimer: CustomStringConvertible {
    var begin:CFAbsoluteTime
    var end:CFAbsoluteTime
    
    init() {
        begin = CFAbsoluteTimeGetCurrent()
        end = 0
    }
    mutating func start() {
        begin = CFAbsoluteTimeGetCurrent()
        end = 0
    }
    mutating func stop() -> Double {
        if (end == 0) { end = CFAbsoluteTimeGetCurrent() }
        return Double(end - begin)
    }
    var duration:CFAbsoluteTime {
        get {
            if (end == 0) { return CFAbsoluteTimeGetCurrent() - begin }
            else { return end - begin }
        }
    }
    var description:String {
        let time = duration
        if (time > 100) {return " \(time/60) min"}
        else if (time < 1e-6) {return " \(time*1e9) ns"}
        else if (time < 1e-3) {return " \(time*1e6) µs"}
        else if (time < 1) {return " \(time*1000) ms"}
        else {return " \(time) s"}
    }
}

class ParkBenchTimer {
    
    let startTime:CFAbsoluteTime
    var endTime:CFAbsoluteTime?
    
    init() {
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func stop() -> CFAbsoluteTime {
        endTime = CFAbsoluteTimeGetCurrent()
        
        return duration!
    }
    
    var duration:CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
}