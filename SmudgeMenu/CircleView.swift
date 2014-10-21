//  Created by Chris Harding on 18/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class CircleView : UIView {
    
    var colour:UIColor = motrrYellowColour()
    var radius:CGFloat {
        get {
            return self.width / 2
        }
        set {
            self.width = newValue*2
            self.height = newValue*2
        }
    }
    var diameter:CGFloat {
        get {return 2*radius}
        set {radius = diameter/2}
    }
    
    
    init(colour:UIColor) {
        super.init()
        self.colour = colour
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func drawRect(rect: CGRect) {

        // Turn on AA
        var context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        CGContextSetShouldAntialias(context, true)
        CGContextSetAllowsAntialiasing(context, true)
        
        // Set the border width
        CGContextSetLineWidth(context, 0.0)
        
        // Set the cicle fill and stroke colour to yellow
        //    CGContextSetStrokeColorWithColor(context, [[MotrrStyles motrrYellowColour] CGColor])
        CGContextSetFillColorWithColor(context, colour.CGColor)
        
        // Draw the circle
        //    CGContextStrokeEllipseInRect(context, circleRect);
        CGContextFillEllipseInRect(context, rect)
        
        // Turn off AA
        CGContextSetAllowsAntialiasing(context, false)
        CGContextRestoreGState(context)
    }

}