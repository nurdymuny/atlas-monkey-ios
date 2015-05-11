//
//  SwopplerCommonMethod.swift
//  Swoppler
//
//  Created by attmac101 on 02/04/15.
//  Copyright (c) 2015 com.trend. All rights reserved.
//

import UIKit

class SwopplerCommonMethod: NSObject {
    
    class func trim(stringVar : NSString) -> NSString{
        return stringVar.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }

    class func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
    class func alertViewCustom(titleStr : NSString , messageStr : NSString) -> Void{
        //loadingIndicator.stopAnimating()
        let alert = UIAlertView()
        alert.title = titleStr as String
        alert.message = messageStr as String
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    class func isConnectedToNetwork()->Bool{
        
        var Status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        
        return Status
    }
    
    class func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    class func swopWithType(typeInt : Int) -> NSString{
    
        var swopWithStr : NSString!
        
        switch typeInt
        {
        case 1:
            swopWithStr = "Everyone"
            break
            
        case 2:
            swopWithStr = "Specific Individuals"
            break
            
        case 3:
            swopWithStr = "Geographic Area"
            break
            
        case 4:
            swopWithStr = "Swoppler Communities"
            break
            
        default:
            swopWithStr = "No Result"
            break
            
        }
        
        return swopWithStr
    }
    
    class func swopCategoryType(typeInt : Int) -> NSString{
        
        var swopWithStr : NSString!
        
        switch typeInt
        {
        case 1:
            swopWithStr = "Baby Sitting"
            break
            
        case 2:
            swopWithStr = "Dog Walking"
            break
            
        case 3:
            swopWithStr = "Teaching"
            break
            
        case 4:
            swopWithStr = "Old Book"
            break
           
        case 5:
            swopWithStr = "Repairing Bike"
            break
            
        default:
            swopWithStr = "No Result"
            break
        }
        
        return swopWithStr
    }
    
    func dateTimeCampare(dateStar : String) -> NSString
    {
        var dateReturn = ""
        
        
        let newDated = dateStar.stringByReplacingOccurrencesOfString("T", withString: " ")
        let finalDate = newDated.stringByReplacingOccurrencesOfString(".000Z", withString: "") as String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let startDate:NSDate = NSDate()
        let endDate:NSDate = dateFormatter.dateFromString(finalDate)!
        
        let elapsedTime = startDate.timeIntervalSinceDate(endDate)
  
        if(elapsedTime/86400 >= 7)
        {
            dateReturn = finalDate
        }
        else if (elapsedTime/86400 <= 7) && (elapsedTime/86400 >= 1)
        {
            var valueInt : Int = Int(elapsedTime/86400)
            dateReturn = NSString(format: "%d Day ago",valueInt) as String
        }
        else if(elapsedTime/3600 <= 24) && (elapsedTime/3600 >= 1)
        {
            var valueInt : Int = Int(elapsedTime/3600)
            dateReturn = NSString(format: "%d Hours ago",valueInt) as String
        }
        else if(elapsedTime/60 <= 60) && (elapsedTime/60 >= 1)
        {
            var valueInt : Int = Int(elapsedTime/60)
            dateReturn = NSString(format: "%d Minutes ago",valueInt) as String
        }
        else
        {
            var valueInt : Int = Int(elapsedTime)
            dateReturn = NSString(format: "%d Seconds ago",valueInt) as String
        }
        //println(dateReturn)
        
        return dateReturn
    }

    
}
