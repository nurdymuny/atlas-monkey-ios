//
//  SeatLocationViewController.swift
//  Atlas
//
//  Created by attmac101 on 24/04/15.
//  Copyright (c) 2015 nurdymuny. All rights reserved.
//

import UIKit
import Foundation

class LocationPoints
{
    var latitude:Int = 0
    var longitude:Int = 0
    var distance:CGFloat = 0
    
    init(lat:Int,lng:Int)
    {
        latitude = lat
        longitude = lng
    }
    
    init(lat:Int,lng:Int,dis:CGFloat)
    {
        latitude = lat
        longitude = lng
        distance = dis
    }
}


class SeatLocationViewController: UIViewController {

    
   // @IBOutlet var mainView: DrawPathView!
  //  @IBOutlet var btn101: CategoryForButtonClass!
  //  @IBOutlet var btn102: CategoryForButtonClass!
  //  @IBOutlet var btn103: CategoryForButtonClass!
  //  @IBOutlet var btn104: CategoryForButtonClass!
  //  @IBOutlet var btn105: CategoryForButtonClass!
  //  @IBOutlet var btn106: CategoryForButtonClass!
    
    
    @IBOutlet var btnUser: CategoryForButtonClass!
    @IBOutlet var granadaTheatreMapView: DrawPathView!
    
    
    
    //let screenSize: CGRect = UIScreen.mainScreen().bounds.width
    
    //288:405 == 1000:1500
    //1:1 == 3.47:307
    
    let screenWidth = UIScreen.mainScreen().bounds.width  //320,375,414
    let screenHeight = UIScreen.mainScreen().bounds.height //568,667,736
    
    var pathPointsArr : NSMutableArray!
    
    var locationId:Int = 0
    
    var blockId = "A2"
    
    var pathPoints = [CGPoint]()
    
    var outerPaths =  Dictionary<Int, LocationPoints>()
    
    var iPhone6RatioLat : CGFloat = 1.20
    var iPhone6RatioLong : CGFloat = 1.245
    
    var userLocation = LocationPoints(lat: Int(140*1.20), lng: Int(380*1.245))
    
    //var userLocation = LocationPoints(lat: 140, lng: 380)
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(userLocation)
        
        if screenWidth == 320 && screenHeight == 568
        {
            userLocation = LocationPoints(lat: Int(140), lng: Int(380))
            
            iPhone6RatioLat = 1.0
            iPhone6RatioLong = 1.0
            
            var latlong = LocationPoints(lat: 65,lng: 320)
            outerPaths.updateValue(latlong, forKey: 0)
            
            var latlong1 = LocationPoints(lat: 115, lng: 345)
            outerPaths.updateValue(latlong1, forKey: 1)
            
            var latlong2 = LocationPoints(lat: 170, lng: 345)
            outerPaths.updateValue(latlong2, forKey: 2)
            
            var latlong3 = LocationPoints(lat: 210, lng: 322)
            outerPaths.updateValue(latlong3, forKey: 3)
            
        }
        else if screenWidth == 375 && screenHeight == 667
        {
            userLocation = LocationPoints(lat: Int(140*1.20), lng: Int(380*1.245))
            
            iPhone6RatioLat = 1.20
            iPhone6RatioLong = 1.245
            
            var latlong = LocationPoints(lat: Int(65*1.20), lng: Int(320*1.245))
            outerPaths.updateValue(latlong, forKey: 0)
            
            var latlong1 = LocationPoints(lat: Int(115*1.20), lng: Int(345*1.245))
            outerPaths.updateValue(latlong1, forKey: 1)
            
            var latlong2 = LocationPoints(lat: Int(170*1.20), lng: Int(345*1.245))
            outerPaths.updateValue(latlong2, forKey: 2)
            
            var latlong3 = LocationPoints(lat: Int(210*1.20), lng: Int(322*1.245))
            outerPaths.updateValue(latlong3, forKey: 3)
        }
        else
        {
            userLocation = LocationPoints(lat: Int(140*1.30), lng: Int(380*1.43))
            
            iPhone6RatioLat = 1.30
            iPhone6RatioLong = 1.43
            
            var latlong = LocationPoints(lat: Int(65*1.30), lng: Int(320*1.43))
            outerPaths.updateValue(latlong, forKey: 0)
            
            var latlong1 = LocationPoints(lat: Int(115*1.30), lng: Int(345*1.43))
            outerPaths.updateValue(latlong1, forKey: 1)
            
            var latlong2 = LocationPoints(lat: Int(170*1.30), lng: Int(345*1.43))
            outerPaths.updateValue(latlong2, forKey: 2)
            
            var latlong3 = LocationPoints(lat: Int(210*1.30), lng: Int(322*1.43))
            outerPaths.updateValue(latlong3, forKey: 3)
        }
        
        
        var(lat ,lng) = calulateMinDistancePoint()
        
        var startPoint1 : CGPoint = CGPoint(x: userLocation.latitude, y: userLocation.longitude)
        var endPoint1 : CGPoint = CGPoint(x: lat, y: lng)
        
        self.createPath(startPoint1, lastPoint: endPoint1)
        
        self.drawLineWithStartPoint(startPoint1, endPoint: endPoint1, myColor: UIColor.whiteColor())
        
        
        //   var seatArr : NSArray = [btn101, btn102, btn103, btn104, btn105, btn106]
       // print(seatArr)
        
       // var predicate = NSPredicate(format: "getBtnTitle == %@",btnUser.titleLabel!.text!)
        
       // var resultFilterCategoryArr : NSArray = seatArr.filteredArrayUsingPredicate(predicate)
        
      //  let btnSearched : CategoryForButtonClass = resultFilterCategoryArr.objectAtIndex(0) as! CategoryForButtonClass
        
      //  btnSearched.backgroundColor = UIColor.greenColor()
        
        
//        var btnClass = CategoryForButtonClass()
//        btnClass.findTag = btnSearched.tag
//        btnClass.drawRect(btnSearched.bounds)
        
       // var startPoint1 : CGPoint = CGPoint(x: btnUser.frame.origin.x, y: btnUser.frame.origin.y)
       // var endPoint1 : CGPoint = CGPoint(x: btnSearched.frame.origin.x, y: btnSearched.frame.origin.y)
        
       // self.drawLineWithStartPoint(startPoint1, endPoint: endPoint1, myColor: UIColor.greenColor())
        
        
        // Do any additional setup after loading the view.
    }
    
    func calulateMinDistancePoint() ->  (Int, Int)
    {
        var distanceDict =  Dictionary<Int, LocationPoints>()
        
        print(distanceDict)
        
        var i:Int = 0;
        
        for point in outerPaths
        {
            var lat:Int = point.1.latitude
            var lng:Int = point.1.longitude
            
            var xDist:CGFloat  =  CGFloat(point.1.latitude) - CGFloat(userLocation.latitude)
            var yDist:CGFloat  = (CGFloat(point.1.longitude) - CGFloat(userLocation.longitude))
            
            var distance:CGFloat  = sqrt((xDist * xDist) + (yDist * yDist))
            
            var locPoint = LocationPoints(lat: lat, lng: lng, dis: distance)
            
            i++
            
            distanceDict.updateValue(locPoint, forKey: i)
        }
        
        var minDistance = 10000
        
        for distance in distanceDict {
            
            var distance:Int =  Int(distance.1.distance)
            
            minDistance = min(minDistance,distance)
        }
        
        var nearlat:Int = 0
        
        var nearlng:Int = 0
        
        for distance in distanceDict {
            
            if Int(distance.1.distance) == minDistance
            {
                nearlat = distance.1.latitude
                nearlng = distance.1.longitude
            }
        }
        
        print("\(nearlat)","\(nearlng)")
        
        return(nearlat,nearlng)
        
    }
    
    func createPath(userPoisition : CGPoint,lastPoint : CGPoint)
    {
        print("\(lastPoint.x) ,\(lastPoint.y)")
        if Int(lastPoint.x) == Int(115.0*iPhone6RatioLat) && Int(lastPoint.y) == Int(345.0*iPhone6RatioLong)
        {
            pathPoints = [userPoisition, lastPoint, CGPoint(x: 123.0*iPhone6RatioLat, y: 293.0*iPhone6RatioLong)]
            self.blockToBlock("gateNo1")

        }
        else if Int(lastPoint.x) == Int(170.0*iPhone6RatioLat) && Int(lastPoint.y) == Int(345.0*iPhone6RatioLong)
        {
            pathPoints = [userPoisition, lastPoint, CGPoint(x: 160.0*iPhone6RatioLat, y: 293.0*iPhone6RatioLong)]
            self.blockToBlock("gateNo2")
        }
    }
    
    func blockToBlock(gateNumberStr : String)
    {
        switch(gateNumberStr)
        {
        case "gateNo1":
            if blockId == "A2"
            {
                pathPoints.append(CGPoint(x: 130.0*iPhone6RatioLat, y: 271.0*iPhone6RatioLong))
                pathPoints.append(CGPoint(x: 130.0*iPhone6RatioLat, y: 225.0*iPhone6RatioLong))
            }
            else if blockId == "B2"
            {
                pathPoints.append(CGPoint(x: 130.0*iPhone6RatioLat, y: 271.0*iPhone6RatioLong))
                pathPoints.append(CGPoint(x: 130.0*iPhone6RatioLat, y: 225.0*iPhone6RatioLong))
            }
            else if blockId == "A3"
            {
                pathPoints.append(CGPoint(x: 130.0*iPhone6RatioLat, y: 271.0*iPhone6RatioLong))
            }
            else if blockId == "C2"
            {
                pathPoints.append(CGPoint(x: 155.0*iPhone6RatioLat, y: 222.0*iPhone6RatioLong))
            }
            else if blockId == "C3"
            {
                pathPoints.append(CGPoint(x: 155.0*iPhone6RatioLat, y: 271.0*iPhone6RatioLong))
            }
            break
            
        case "gateNo2":
            if blockId == "A2"
            {
                pathPoints.append(CGPoint(x: 130.0*iPhone6RatioLat, y: 225.0*iPhone6RatioLong))
            }
            else if blockId == "B2"
            {
                pathPoints.append(CGPoint(x: 155.0*iPhone6RatioLat, y: 271.0*iPhone6RatioLong))
                pathPoints.append(CGPoint(x: 155.0*iPhone6RatioLat, y: 222.0*iPhone6RatioLong))
            }
            else if blockId == "A3"
            {
                pathPoints.append(CGPoint(x: 130.0*iPhone6RatioLat, y: 271.0*iPhone6RatioLong))
            }
            else if blockId == "C2"
            {
                pathPoints.append(CGPoint(x: 155.0*iPhone6RatioLat, y: 271.0*iPhone6RatioLong))
                pathPoints.append(CGPoint(x: 155.0*iPhone6RatioLat, y: 222.0*iPhone6RatioLong))
            }
            else if blockId == "C3"
            {
                pathPoints.append(CGPoint(x: 155.0*iPhone6RatioLat, y: 271.0*iPhone6RatioLong))
            }
            
            break
            
        default:
            break
            
        }
    }
    
    func drawLineWithStartPoint(startPoint : CGPoint, endPoint: CGPoint, myColor: UIColor)
    {
        print(startPoint)
        print(endPoint)
        
        print(pathPoints)
    
        granadaTheatreMapView.startPoints = startPoint
        granadaTheatreMapView.endPoints = endPoint
        
        granadaTheatreMapView.pathPoints = pathPoints
        granadaTheatreMapView.setNeedsDisplay()

    }

    @IBAction func backBtnAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
