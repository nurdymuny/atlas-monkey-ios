//
//  ViewController.swift
//  atlasmonkey
//
//  Created by nurdymuny on 20/10/15.
//  Copyright (c) 2015 nurdymuny. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, ABBeaconManagerDelegate, alertProtocol, delegateAlertForSeatInfo
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
    
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView()
    
    var dictForUserSeatInfo : NSDictionary = NSDictionary()
    
    
    
    //MARK:- Life cycle of VC
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        startDate = NSDate()
        
        beaconManager = ABBeaconManager.init()
        
        beaconManager.delegate = self
        
        beaconManager.requestAlwaysAuthorization()
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillDisappear(true)
        
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
        
        self.getVenueLayout()
    }
    
    
    @IBAction func btnBackAction(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:- API get seats layout
    func getVenueLayout()
    {
        //        print(dictForUserSeatInfo)
        
        let venue_id = String(dictForUserSeatInfo.valueForKey("venue_id") as! NSNumber)
        
        let level_Id = String(dictForUserSeatInfo.valueForKey("level_id") as! NSNumber)
        
        actInd.startAnimating()
        
        UserViewManager.sharedInstance.getVenueLayOut(venue_id, level_id: level_Id as String, success: { (response) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.actInd.stopAnimating()
                
                if let success : Int = response.valueForKey("success") as? Int
                {
                    if success == 1
                    {
                        let dict = response.valueForKey("levels")
                        
                        let gridDict : NSDictionary = dict!.valueForKey("grid") as! NSDictionary
                        
                        self.gridRow = (gridDict.valueForKey("x")?.integerValue)!
                        
                        self.gridColoumn = gridDict.valueForKey("y")!.integerValue
                        
                        let width =  CGFloat(self.gridColoumn * self.gridWidth)
                        
                        let height = CGFloat(self.gridRow * self.gridHeight)
                        
                        self.scrollView.contentSize = CGSizeMake(width , height);
                        
                        self.seatsArray = (dict!.valueForKey("seats")?.mutableCopy())! as! NSMutableArray
                        //                        print(self.seatsArray)
                        
                        self.gridView()
                    }
                    else
                    {
                        AtlasCommonMethod.alert("", message: response.valueForKey("message") as! String, view: self)
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
    
    
    //MARK:- Plot all seat in layout
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
                        
                        
                        let btnSeatInfo : UIButton = UIButton(type: UIButtonType.Custom)
                        btnSeatInfo.frame = seatView.bounds
                        btnSeatInfo.tag = indexValue+3000
                        btnSeatInfo.addTarget(self, action: "getSeatInfo:", forControlEvents: UIControlEvents.TouchUpInside)
                        seatView.addSubview(btnSeatInfo)
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
        //        print(seatsArray)
        //        print(mySeatDict)
        //        print(userNearestDict);
        
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
        
        //        print("userDict\(self.mySeatDict)")
        //        print("userNearestDict\(userNearestDict)")
        
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
        
        //        print("My step\(x)")
        //        print("My step\(y)")
        //
        //        print("My destination Path\(destiantionX)")
        //        print("My destination Path\(destiantionY)")
        //
        //
        if(destiantionX == x && destiantionY == y){
            
            if(!isSuccess){
                isSuccess = true
                print("this is my, path")
                //                print(actualPathArray)
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
        //        print(actualPathArray);
        
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
                    let proximityUUID: NSUUID = NSUUID.init(UUIDString: AtlasCommonMethod.trim(obj["uuid"] as! NSString) as String)!
                    
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
        // your long procedure
        
        let endDate: NSDate = NSDate()
        
        let dateComponents: NSDateComponents = (NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)?.components(NSCalendarUnit.Nanosecond, fromDate: startDate, toDate: endDate, options:[]))!
        
        startDate = NSDate()
        
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
                //                print("numberOfBeacons : \(numberOfBeacons) - arrBeaconRange count : \(arrBeaconRange.count) - \(arrBeaconRange) arrBeaconRange count :\(arrBeaconUUID.count) - \(arrBeaconUUID)")
                
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
                return true
            }
            return false
        }
        
        print("numMin : \(numMin)")
        
        let Index = arr.indexOf{$0 === numMin}
        
        let nearestBeaconUUID : String = (arrBeaconUUID[Index!]["uuid"] as? String)!
        
        //        let nearestBeaconMajor = arrBeaconUUID[Index!]["major"]
        //
        //        let nearestBeaconMinor = arrBeaconUUID[Index!]["minor"]
        //
        //        print("nearestBeaconUUID : \(nearestBeaconUUID) ---- nearestBeaconMajor : \(nearestBeaconMajor) ---- nearestBeaconMinor :\(nearestBeaconMinor)")
        
        let uuidNearest = nearestBeaconUUID
        
        let predicateForNearestUUID: NSPredicate = NSPredicate(format: "uuid==%@", uuidNearest)
        
        let resultArr: NSArray = seatsArray.filteredArrayUsingPredicate(predicateForNearestUUID)
        
        let successObj : Bool = resultArr.count > 0
        
        if successObj
        {
            let IndexOfSeat = seatsArray.indexOfObject(resultArr.objectAtIndex(0))
            
            //            print("User Beacon Info successObj : \(successObj) - \(resultArr) - Index :\(IndexOfSeat) - IndexOfNearestSeat :\(IndexOfNearestSeat)")
            
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
                
                let viewSeat : UIView = scrollView.viewWithTag(1000+IndexOfSeat)!   //arrForSeatsView.objectAtIndex(IndexOfSeat) as! UIView
                
                let seatColor = viewSeat.viewWithTag(999)
                
                if resultArr.objectAtIndex(0).objectForKey("uuid") as! String == dictForUserSeatInfo.objectForKey("uuid") as! String
                {
                    seatColor?.backgroundColor = UIColor.greenColor()               //purpleColor()
                }
                else
                {
                    seatColor?.backgroundColor = UIColor.grayColor()                //seatColor?.backgroundColor = UIColor.redColor()
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
    
    
    //MARK:- Seat pop-up methods
    func getSeatInfo(sender : UIButton)
    {
        print(sender.tag)
        
        let tagIndex = sender.tag-3000
        
        print(tagIndex)
        
        let dictSeatInfo : NSMutableDictionary = seatsArray.objectAtIndex(tagIndex) as! NSMutableDictionary
        
        self.seatInfoWithPopup(dictSeatInfo)
    }
    
    
    func seatInfoWithPopup(dict : NSMutableDictionary)
    {
        //        print("Seat dict : \(dict)")
        
        let infoWindowObj : InfoWindow = InfoWindow(frame: self.view.bounds)
        
        infoWindowObj.delegate = self
        
        infoWindowObj.initWithFrameSize(dict)
        
        self.view.addSubview(infoWindowObj)
        
        let block_Id = String(dict.valueForKey("block_id") as! Int)
        
        let seat_Id = String(dict.valueForKey("seat_number") as! Int)
        
        infoWindowObj.lblVenue.attributedText = AtlasCommonMethod.getAttributeString("Venue : \(venue_name)", searchStringForRange: "Venue :")
        
        infoWindowObj.lblBlock.attributedText = AtlasCommonMethod.getAttributeString("Block : \(block_Id)", searchStringForRange: "Block :")
        
        infoWindowObj.lblSeat.attributedText = AtlasCommonMethod.getAttributeString("Seat : \(seat_Id)", searchStringForRange: "Seat :")
        
    }
    
    
    //MARK:- delegate of InfoWindow
    func hideInfoWindow(viewObj : UIView)
    {
        viewObj.removeFromSuperview()
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
