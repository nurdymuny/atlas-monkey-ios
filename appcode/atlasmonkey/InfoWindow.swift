//
//  InfoWindow.swift
//  atlasmonkey
//
//  Created by nurdymuny on 22/10/15.
//  Copyright (c) 2015 nurdymuny. All rights reserved.
//

import UIKit

class InfoWindow: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var lblVenue : UILabel = UILabel()
    
    var lblSeat : UILabel = UILabel()
    
    var lblBlock : UILabel = UILabel()
    
    
    func initWithFrameSize() {
        
        lblVenue.frame = CGRectMake(0, 10, self.frame.size.width, 20)
//        lblVenue.text = "Venue"
        lblVenue.textAlignment = NSTextAlignment.Center
        lblVenue.textColor = UIColor.whiteColor()
        self.addSubview(lblVenue)
        
        lblSeat.frame = CGRectMake(0, lblVenue.frame.origin.y+lblVenue.frame.size.height+10, self.frame.size.width, 20)
//        lblSeat.text = "Seat"
        lblSeat.textAlignment = NSTextAlignment.Center
        lblSeat.textColor = UIColor.whiteColor()
        self.addSubview(lblSeat)
        
        lblBlock.frame = CGRectMake(0, lblSeat.frame.origin.y+lblSeat.frame.size.height+10, self.frame.size.width, 20)
//        lblBlock.text = "Block"
        lblBlock.textAlignment = NSTextAlignment.Center
        lblBlock.textColor = UIColor.whiteColor()
        self.addSubview(lblBlock)
        
        
    }
    

}
