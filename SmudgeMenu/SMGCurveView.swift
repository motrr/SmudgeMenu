//  Created by Chris Harding on 18/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGCurveView : UIView {
    
    var startPoint:CGPoint = CGPoint(x: 100, y: 100)
    var controlPointA:CGPoint = CGPoint(x: 200, y: 100)
    var controlPointB:CGPoint = CGPoint(x: 300, y: 100)
    var endPoint:CGPoint = CGPoint(x: 300, y: 200)
    
    var colour:UIColor = UIColor.greenColor()
    var radius:CGFloat = 10
    var diameter:CGFloat {
        get {return 2*radius}
        set {radius = diameter/2}
    }
    
    override init() {
        super.init()
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
        var startPointRect = CGRect(x: startPoint.x-radius, y:startPoint.y-radius, width: diameter, height:diameter )
        CGContextFillEllipseInRect(context, startPointRect)
        
        // Draw the end point
        var endPointRect = CGRect(x: endPoint.x-radius, y:endPoint.y-radius, width: diameter, height:diameter )
        CGContextFillEllipseInRect(context, endPointRect)
        
        // Draw curved bezier path between start and end points
        var path:UIBezierPath = UIBezierPath()
        path.lineWidth = diameter
        path.moveToPoint(startPoint)
        path.addCurveToPoint(endPoint, controlPoint1: controlPointA, controlPoint2: controlPointB)
        path.stroke()
        
        // Turn off AA
        CGContextSetAllowsAntialiasing(context, false)
        CGContextRestoreGState(context)
    }
}


extension SMGCurveView : SMGCurveResponder {
    
    func didUpdateCurve(curve: SMGBezierCurve) {

        self.startPoint = curve.a
        self.controlPointA = curve.b
        self.controlPointB = curve.c
        self.endPoint = curve.d
        
        self.setNeedsDisplay()
    }
}