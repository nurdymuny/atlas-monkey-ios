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

    @IBOutlet var vwCenterView: UIView!
    @IBOutlet var lblDateShow: UILabel!
    
    @IBOutlet var lblSeatNumberShow: UILabel!
    @IBOutlet var lblFee: UILabel!
    @IBOutlet var lblTimeShow: UILabel!
    @IBOutlet var lblBlockNumber: UILabel!
    
    //30.7800° N, 76.6900° E
    
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var startPoint1 : CGPoint = CGPoint(x: lblDateShow.frame.origin.x, y: lblDateShow.frame.origin.y)
        var endPoint1 : CGPoint = CGPoint(x: lblFee.frame.origin.x, y: lblFee.frame.origin.y)
        
        self.drawLineWithStartPoint(startPoint1, endPoint: endPoint1, whiteColor: UIColor.purpleColor())

        vwCenterView.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func nextBtnClicked(sender: UIButton) {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.performSegueWithIdentifier("SeatLocationVCSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == "SeatLocationVCSegue"
        {
            var seatLocationVC = segue.destinationViewController as! SeatLocationViewController
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
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
//        print(startPoint)
//        print(endPoint)
//        
//        var plusPath = UIBezierPath()
//        
//        //set the path's line width to the height of the stroke
//        plusPath.lineWidth = 10
//        
//        //move the initial point of the path
//        //to the start of the horizontal stroke
//        plusPath.moveToPoint(startPoint)
//        
//        //add a point to the path at the end of the stroke
//        plusPath.addLineToPoint(endPoint)
//        
//        //set the stroke color
//        UIColor.purpleColor().setStroke()
//        plusPath.fill()
//        //draw the stroke
//        plusPath.stroke()
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
