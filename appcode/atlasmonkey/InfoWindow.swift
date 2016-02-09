import UIKit

@objc protocol delegateAlertForSeatInfo
{
    optional func hideInfoWindow(_: UIView)
}


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
    
    var delegate:delegateAlertForSeatInfo?
    
    func initWithFrameSize( dict : NSMutableDictionary) {
        
        self.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255, alpha: 0.3)
        //        self.layer.cornerRadius = 3.0
        //        self.clipsToBounds = true
        
        let containterView : UIView = UIView()
        containterView.frame = CGRectMake(20, screenHeight/2-80, screenWidth-40, 160)
        containterView.backgroundColor = UIColor(red: 246.0/255.0, green: 0.0/255.0, blue: 147.0/255, alpha: 1.0)
        containterView.layer.cornerRadius = 3.0
        containterView.clipsToBounds = true
        self.addSubview(containterView)
        
        
        lblVenue.frame = CGRectMake(0, 10, self.frame.size.width, 20)
        lblVenue.text = "Venue"
        lblVenue.textAlignment = NSTextAlignment.Center
        lblVenue.textColor = UIColor.whiteColor()
        containterView.addSubview(lblVenue)
        
        lblSeat.frame = CGRectMake(0, lblVenue.frame.origin.y+lblVenue.frame.size.height+10, containterView.frame.size.width, 20)
        lblSeat.text = "Seat"
        lblSeat.textAlignment = NSTextAlignment.Center
        lblSeat.textColor = UIColor.whiteColor()
        containterView.addSubview(lblSeat)
        
        lblBlock.frame = CGRectMake(0, lblSeat.frame.origin.y+lblSeat.frame.size.height+15, containterView.frame.size.width, 20)
        lblBlock.text = "Block"
        lblBlock.textAlignment = NSTextAlignment.Center
        lblBlock.textColor = UIColor.whiteColor()
        containterView.addSubview(lblBlock)
        
        let btnOk : UIButton = UIButton(type: UIButtonType.Custom)
        btnOk.frame = CGRectMake(containterView.frame.size.width/2-80, lblBlock.frame.origin.y+lblBlock.frame.size.height+10, 160, 40)
        btnOk.setTitle("OK", forState: UIControlState.Normal)
        btnOk.layer.cornerRadius = 5.0
        btnOk.clipsToBounds = true
        btnOk.layer.borderColor = UIColor.whiteColor().CGColor
        btnOk.layer.borderWidth = 1.0
        btnOk.addTarget(self, action: "hideView:", forControlEvents: UIControlEvents.TouchUpInside)
        containterView.addSubview(btnOk)
        
    }
    
    
    func hideView(sender: UIButton)
    {
        delegate?.hideInfoWindow!(self)
    }
    
}