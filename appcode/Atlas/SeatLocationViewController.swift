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
    
    var locationId:Int = 0
    
    var outerPaths =  Dictionary<Int, LocationPoints>()
    
    var userLocation = LocationPoints(lat: 228,lng: 492)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var latlong = LocationPoints(lat: 82,lng: 462)
        
        outerPaths.updateValue(latlong, forKey: 0)
        
        var latlong1 = LocationPoints(lat: 132, lng: 483)
        
        outerPaths.updateValue(latlong1, forKey: 1)
        
        var latlong2 = LocationPoints(lat: 185, lng: 482)
        
        outerPaths.updateValue(latlong2, forKey: 2)
        
        var latlong3 = LocationPoints(lat: 229, lng: 459)
        
        outerPaths.updateValue(latlong3, forKey: 3)
        
        var(lat ,lng) = calulateMinDistancePoint()
        
         var startPoint1 : CGPoint = CGPoint(x: userLocation.latitude, y: userLocation.longitude)
         var endPoint1 : CGPoint = CGPoint(x: lat, y: lng)
        
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
        
        return(nearlat,nearlng)
    }
    
    
    func drawLineWithStartPoint(startPoint : CGPoint, endPoint: CGPoint, myColor: UIColor)
    {
    
        
        
     /*   print(startPoint)
        print(endPoint)
        
        var context  = UIGraphicsGetCurrentContext()
        
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor);
        
        // Draw them with a 2.0 stroke width so they are a bit more visible.
        CGContextSetLineWidth(context, 2.0);
        
        CGContextMoveToPoint(context, 50.0, 0.0); //start at this point
        
        CGContextAddLineToPoint(context, 100.0, 100.0); //draw to this point
        
        // and now draw the Path!
        CGContextStrokePath(context);
        */
        var plusPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        plusPath.lineWidth = 10
        
    
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.moveToPoint(startPoint)
        
        //add a point to the path at the end of the stroke
        plusPath.addLineToPoint(endPoint)
        
        UIColor.greenColor().setFill()
        UIColor.whiteColor().setStroke()
        UIColor.purpleColor().setStroke()
        
        plusPath.fill()
        
        //draw the stroke
        plusPath.stroke()
        
        //set the stroke color
       
    }
    
    
//    -(void)drawLineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint WithColor:(UIColor *)color
//    {
//    UIBezierPath *aPath = [UIBezierPath bezierPath];
//    
//    // Set the starting point of the shape.
//    [aPath moveToPoint:startpoint;
//    
//    // Draw the lines.
//    [aPath addLineToPoint:endPoint;
//    [aPath closePath];
//    aPath.lineWidth = 2;
//    [aPath fill];
//    [aPath stroke];
//    
//    }

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
