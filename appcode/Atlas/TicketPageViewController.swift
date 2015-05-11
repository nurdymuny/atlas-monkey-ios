//
//  TicketPageViewController.swift
//  Atlas
//
//  Created by attmac101 on 23/04/15.
//  Copyright (c) 2015 nurdymuny. All rights reserved.
//

import UIKit
import CoreLocation

class TicketPageViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var vwCenterView: UIView!
    @IBOutlet var lblDateShow: UILabel!
    
    @IBOutlet var lblSeatNumberShow: UILabel!
    @IBOutlet var lblFee: UILabel!
    @IBOutlet var lblTimeShow: UILabel!
    @IBOutlet var lblBlockNumber: UILabel!
    
    //30.67151546° N, 76.73919589° E
    
    
    let locationManager = CLLocationManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ticketDetailDic : NSMutableDictionary = NSMutableDictionary()
        ticketDetailDic.setValue("12", forKey: "unique_ticket_id")
        
        UserViewManager.sharedInstance.getTicketDetail(ticketDetailDic, success: {(responseDic) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                print(responseDic)
                
                var successResult : Bool = responseDic.objectForKey("success") as! Bool
                if successResult == true
                {
                    var responseArr : NSArray = NSArray(object: responseDic.objectForKey("user")!)
                    print(responseArr)
                }
                else
                {
                    self.view.makeToast(message: "Seat Not Found")
                }
            })
            
            }, failure: {(error) -> Void in
                
                print("Error : \(error.localizedDescription)")
        })

        UserViewManager.sharedInstance.getAllBlocksDetail( {(responseDic) -> Void in
        
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                print(responseDic)
                
                var successResult : Bool = responseDic.objectForKey("success") as! Bool
                if successResult == true
                {
                    var responseArr : NSArray = NSArray(object: responseDic.objectForKey("data")!.objectForKey("venue")!)
                    print(responseArr)
                }
                else
                {
                    self.view.makeToast(message: "Seat Not Found")
                }
            })
        
        }, failure: {(error) -> Void in
                
                print("Error : \(error.localizedDescription)")
        })
        
        
        var startPoint1 : CGPoint = CGPoint(x: lblDateShow.frame.origin.x, y: lblDateShow.frame.origin.y)
        var endPoint1 : CGPoint = CGPoint(x: lblFee.frame.origin.x, y: lblFee.frame.origin.y)
        
        self.drawLineWithStartPoint(startPoint1, endPoint: endPoint1, whiteColor: UIColor.purpleColor())

        vwCenterView.layer.cornerRadius = 10
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLHeadingFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    override func viewWillDisappear(animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    
    @IBAction func nextBtnClicked(sender: UIButton) {
        
        self.performSegueWithIdentifier("SeatLocationVCSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == "SeatLocationVCSegue"
        {
            var seatLocationVC = segue.destinationViewController as! SeatLocationViewController
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var locationValue : CLLocationCoordinate2D = manager.location.coordinate
        
        var blockLocationValue : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 30.6715154579247, longitude: 76.739195887944)
        
        var userCurrnetLocation : CLLocation = CLLocation(latitude: locationValue.latitude, longitude: locationValue.longitude)
        var myBlockLocation : CLLocation = CLLocation(latitude: blockLocationValue.latitude, longitude: blockLocationValue.longitude)
        var distance : CLLocationDistance = userCurrnetLocation.distanceFromLocation(myBlockLocation)
        
        print(distance)
        
        lblHeader.text = "\(distance)"
        
        //lblHeader.text = "\(locValue.latitude)"+","+"\(locValue.longitude)"
        print(" ---- \(locationValue.latitude) " + ", ")
        print(locationValue.longitude)
        
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            println(locality)
            println(postalCode)
            println(administrativeArea)
            println(country)
            
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//            locationManager.distanceFilter = kCLHeadingFilterNone
//            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    func drawLineWithStartPoint(startPoint : CGPoint, endPoint: CGPoint, whiteColor: UIColor)
    {
        var aPath = UIBezierPath()
        aPath.addLineToPoint(startPoint)
        aPath.addLineToPoint(endPoint)
        aPath.closePath()
        aPath.lineWidth = 2
        UIColor.greenColor().setFill()
        aPath.fill()
        aPath.stroke()
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
