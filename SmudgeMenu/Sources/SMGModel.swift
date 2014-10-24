//  Created by Chris Harding on 21/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import Foundation

protocol SMGModelCurveDelegate {

    func didUpdateCurve()
}


class SMGModel : NSObject {
    
    // Settable handle curve start/end points and properties
    var startPoint:CGPoint = CGPoint(x:0,y:0)
    var endPoint:CGPoint = CGPoint(x:0,y:0)
    var curveAmount:CGFloat = 30
    
    // Transition progress. 0.0 -> closed, 1.0 -> open
    var progress:CGFloat = 0
    
    // Menu items
    var menuItems:[SMGMenuItem] = []
    var currentMenuItemIndex:Observable<Int>?
    
    // Bezier curve control points
    var curveControlPointA:CGPoint {
        get {
            // Watch out for case of points being equal
            if startPoint == endPoint { return startPoint }
            
            // Interpolate 25% between start and finish
            var controlPoint = startPoint.interpolate(endPoint, value:0.25)
            var endStartSeperationDistance = endPoint.subtractPoint(startPoint).magnitude
            
            // Calculate amount to curve
            var curveFactor = (endStartSeperationDistance / 300) * curveAmount
            
            // Move in direction perpendicalr to start <-> finish vector
            var unitPerpendicular = endPoint.subtractPoint(startPoint).unitPerpendicular
            controlPoint.x += (unitPerpendicular.x * curveFactor)
            controlPoint.y += (unitPerpendicular.y * curveFactor)
            return controlPoint
        }
    }
    
    var curveControlPointB:CGPoint {
        get {
            // Watch out for case of points being equal
            if startPoint == endPoint { return startPoint }
            
            // Interpolate 75% between start and finish
            var controlPoint = startPoint.interpolate(endPoint, value:0.75)
            var endStartSeperationDistance = endPoint.subtractPoint(startPoint).magnitude
            
            // Calculate amount to curve
            var curveFactor = (endStartSeperationDistance / 300) * curveAmount
            
            // Move in direction perpendicalr to start <-> finish vector
            var unitPerpendicular = endPoint.subtractPoint(startPoint).unitPerpendicular
            controlPoint.x += (unitPerpendicular.x * curveFactor)
            controlPoint.y += (unitPerpendicular.y * curveFactor)
            return controlPoint
        }
    }
    
    // Interpolated points on the curve
    func interpolateElementPosition(elementIndex:Int, elementCount:Int) -> CGPoint {
        
        var t:CGFloat
        if elementCount <= 1 {
            t = 0 }
        else
            {t = CGFloat(elementIndex) / CGFloat(elementCount-1) }
        
        return bezierInterpolationEvenXSpacing(t, a: startPoint, b: curveControlPointA, c: curveControlPointB, d: endPoint)
    }
    
    func bezierInterpolationEvenXSpacing(t:CGFloat, a:CGPoint, b:CGPoint,c:CGPoint,d:CGPoint) -> CGPoint {
        
        return CGPoint(
            x: a.interpolate(d, value: t).x,
            y: bezierInterpolationSingleAxis(t, a: a.y, b: b.y, c: c.y, d: d.y)
        )
    }
    
    func bezierInterpolation(t:CGFloat, a:CGPoint, b:CGPoint,c:CGPoint,d:CGPoint) -> CGPoint {
        
        return CGPoint(
            x: bezierInterpolationSingleAxis(t, a: a.x, b: b.x, c: c.x, d: d.x),
            y: bezierInterpolationSingleAxis(t, a: a.y, b: b.y, c: c.y, d: d.y)
        )
    }
    
    func bezierInterpolationSingleAxis(t:CGFloat, a:CGFloat, b:CGFloat,c:CGFloat,d:CGFloat) -> CGFloat {
        var t2:CGFloat = t * t
        var t3:CGFloat = t2 * t
        return a + (-a * 3 + t * (3 * a - a * t)) * t
            + (3 * b + t * (-6 * b + b * 3 * t)) * t
            + (c * 3 - c * 3 * t) * t2
            + d * t3
    }
    
}