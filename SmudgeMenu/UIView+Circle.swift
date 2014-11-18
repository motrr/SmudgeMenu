//  Created by Chris Harding on 18/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

extension UIView {
    
    var circleRadius:CGFloat {
        get {
            return self.frame.size.width / 2
        }
        set {
            self.frame.size.width = newValue*2
            self.frame.size.height = newValue*2
        }
    }
    var circleDiameter:CGFloat {
        get {return 2*circleRadius}
        set {circleRadius = circleDiameter/2}
    }
    
    func drawRectForCircle(rect: CGRect, strokeWidth:CGFloat, fillColour:UIColor, strokeColour:UIColor) {
        
        // Turn on AA
        var context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        CGContextSetShouldAntialias(context, true)
        CGContextSetAllowsAntialiasing(context, true)
        
        // Set the border width
        CGContextSetLineWidth(context, strokeWidth)
        
        // Set the cicle fill and stroke colour
        CGContextSetStrokeColorWithColor(context, strokeColour.CGColor)
        CGContextSetFillColorWithColor(context, fillColour.CGColor)
        
        // Calculate rect for stroke
        var strokeRect = rect
        strokeRect.size.width -= strokeWidth
        strokeRect.size.height -= strokeWidth
        strokeRect.origin.x += strokeWidth / 2.0
        strokeRect.origin.y += strokeWidth / 2.0
        
        // Draw the circle
        CGContextFillEllipseInRect(context, rect)
        CGContextStrokeEllipseInRect(context, strokeRect);
        
        // Turn off AA
        CGContextSetAllowsAntialiasing(context, false)
        CGContextRestoreGState(context)
    }
    
}