//  Created by Chris Harding on 18/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SmudgeView : UIView {
    
    var model:SmudgeModel!
    var colour:UIColor = motrrYellowColour()
    
    var radius:CGFloat = 10  {
        didSet {
            self.sizeAndPositionFrame()
        }
    }
    var diameter:CGFloat {
        get {return 2*radius}
        set {radius = diameter/2}
    }
    

    let boundingBoxMargin:CGFloat = 40
    

    
    func sizeAndPositionFrame() {
        
        // Size the frame to contain start and end points, plus an external margin
        frame.size.width = fabs(model.endPoint.x - model.startPoint.x) + 2*radius + 2*boundingBoxMargin
        frame.size.height = fabs(model.endPoint.y - model.startPoint.y) + 2*radius + 2*boundingBoxMargin
        
        // Position frame so that the start point is in the required position
        frame.origin.x = model.startPoint.x - self.startPointInView.x
        frame.origin.y = model.startPoint.y - self.startPointInView.y
        
    }
    
    init(colour:UIColor, model:SmudgeModel) {
        super.init()
        self.colour = colour
        self.model = model
        self.clipsToBounds = false
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
        
        // Setup drawing parameters
        CGContextSetLineWidth(context, 0.0)
        CGContextSetStrokeColorWithColor(context, colour.CGColor)
        CGContextSetFillColorWithColor(context, colour.CGColor)
        
        // Draw the start point
        var startPointRect = CGRect(x: startPointInView.x-radius, y:startPointInView.y-radius, width: diameter, height:diameter )
        CGContextFillEllipseInRect(context, startPointRect)
        
        // Draw the end point
        var endPointRect = CGRect(x: endPointInView.x-radius, y:endPointInView.y-radius, width: diameter, height:diameter )
        CGContextFillEllipseInRect(context, endPointRect)

        // Draw curved bezier path between start and end points
        var path:UIBezierPath = UIBezierPath()
        path.lineWidth = diameter
        path.moveToPoint(startPointInView)
        path.addCurveToPoint(endPointInView, controlPoint1: controlPointAInView, controlPoint2: controlPointBInView)
        path.stroke()

        // Turn off AA
        CGContextSetAllowsAntialiasing(context, false)
        CGContextRestoreGState(context)
    }
    
}

// Smudge model delegate
extension SmudgeView : SmudgeModelDelegate {
    
    func smudgeModelDidUpdate() {
        
        // Adjust parameters according to transition progress
        var minRadius:CGFloat = 40
        var maxRadius:CGFloat = 70
        self.radius = minRadius + (maxRadius - minRadius) * model.progress
        
        // Reframe the view
        self.sizeAndPositionFrame()
        
        // Redraw the smudge shape
        self.setNeedsDisplay()
    }
    
}


// Helpful calculated properties
extension SmudgeView {
    
    var startPointInView:CGPoint {
        get {
            var marginPlusRadius = boundingBoxMargin+radius
            var returnValue:CGPoint = CGPoint(x:marginPlusRadius, y:marginPlusRadius)
            if (model.startPoint.x > model.endPoint.x) {
                returnValue.x = frame.width - marginPlusRadius
            }
            if (model.startPoint.y > model.endPoint.y) {
                returnValue.y = frame.height - marginPlusRadius
            }
            return returnValue
        }
    }
    
    var endPointInView:CGPoint {
        get {
            var marginPlusRadius = boundingBoxMargin+radius
            var returnValue:CGPoint = CGPoint(x: marginPlusRadius, y: marginPlusRadius)
            if (model.startPoint.x < model.endPoint.x) {
                returnValue.x = frame.width - marginPlusRadius
            }
            if (model.startPoint.y < model.endPoint.y) {
                returnValue.y = frame.height - marginPlusRadius
            }
            return returnValue
        }
    }
    
    var controlPointAInView:CGPoint {
        get {
            var returnValue = CGPoint()
            returnValue.x = self.startPointInView.x + (model.curveControlPointA.x - model.startPoint.x)
            returnValue.y = self.startPointInView.y + (model.curveControlPointA.y - model.startPoint.y)
            return returnValue
        }
    }
    
    var controlPointBInView:CGPoint {
        get {
            var returnValue = CGPoint()
            returnValue.x = self.startPointInView.x + (model.curveControlPointB.x - model.startPoint.x)
            returnValue.y = self.startPointInView.y + (model.curveControlPointB.y - model.startPoint.y)
            return returnValue
        }
    }



}