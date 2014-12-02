//  Created by Chris Harding on 15/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGModel : NSObject {
    
    // Basic SMG properties
    var backgroundColour:UIColor = UIColor.redColor() {
        didSet {
            smudgeModel.backgroundColour = self.backgroundColour
            barModel.backgroundColour = self.backgroundColour
        }
    }
    var iconTitleFont:UIFont = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
    
    // Child model objects
    let menuItems:SMGMenuItemsModel = SMGMenuItemsModel()
    let smudgeModel:SMGSmudgeModel = SMGSmudgeModel()
    let barModel:SMGBarModel = SMGBarModel()
}

typealias SMGBackButtonBlock = (Void -> Void)

class SMGMenuItemsModel : NSObject {
    
    dynamic var currentItemId:String?
    var backButtonStacks:Dictionary<String, [SMGBackButtonBlock]> = Dictionary<String, [SMGBackButtonBlock]>()
}

class SMGSmudgeModel : NSObject {
    
    var backgroundColour:UIColor = UIColor.redColor()
    
    dynamic var handleAPoint: CGPoint = CGPoint(x: 0, y: 0)
    dynamic var handleBPoint: CGPoint = CGPoint(x: 0, y: 0)

    dynamic var startPoint: CGPoint = CGPoint(x: 0, y: 0)
    dynamic var endPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    dynamic var minX:CGFloat = 0
    dynamic var minY:CGFloat = 0
    dynamic var maxX:CGFloat = 0
    dynamic var maxY:CGFloat = 0
    
    dynamic var progress:CGFloat = 0
    
    var bezierCurve:SMGBezierCurve {
        return SMGBezierCurve(startPoint,controlPointA,controlPointB,endPoint)
    }
    var curveAmount:CGFloat = 40
    
    /* 
        Calculated Bezier curve control points.
    */
    
    var controlPointA:CGPoint {
        // Watch out for case of points being equal
        if startPoint == endPoint { return startPoint }
        
        // Interpolate between start and finish
        var controlPoint = startPoint.interpolate(endPoint, value:0.3)
        var endStartSeparationDistance = (endPoint - startPoint).magnitude
        
        // Calculate amount to curve
        var curveFactor = squared(endStartSeparationDistance / 300) * curveAmount
        
        // Move in direction perpendicalr to start <-> finish vector
        var unitNormal = (endPoint - startPoint).unitNormal
        controlPoint.x += (unitNormal.x * curveFactor)
        controlPoint.y += (unitNormal.y * curveFactor)
        return controlPoint
    }
    
    var controlPointB:CGPoint {
        // Watch out for case of points being equal
        if startPoint == endPoint { return startPoint }
        
        // Interpolate between start and finish
        var controlPoint = startPoint.interpolate(endPoint, value:0.7)
        var endStartSeparationDistance = (endPoint - startPoint).magnitude
        
        // Calculate amount to curve
        var curveFactor = squared(endStartSeparationDistance / 300) * curveAmount
        
        // Move in direction perpendicalr to start <-> finish vector
        var unitNormal = (endPoint-startPoint).unitNormal
        controlPoint.x += (unitNormal.x * curveFactor)
        controlPoint.y += (unitNormal.y * curveFactor)
        return controlPoint
    }
    
    func squared(a:CGFloat) -> CGFloat {
        return a*a
    }
}

class SMGBarModel : NSObject {
    var backgroundColour:UIColor = UIColor.redColor()
}