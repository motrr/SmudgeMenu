//
//  Created by Chris Harding on 18/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

func + (lhs:CGPoint, rhs:CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x+rhs.x, y: lhs.y+rhs.y)
}

func + (lhs:CGSize, rhs:CGSize) -> CGSize {
    return CGSize(
        width: lhs.width+rhs.width,
        height: lhs.height+rhs.height)
}

func - (lhs:CGPoint, rhs:CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x-rhs.x, y: lhs.y-rhs.y)
}

func - (lhs:CGSize, rhs:CGSize) -> CGSize {
    return CGSize(
        width: lhs.width-rhs.width,
        height: lhs.height-rhs.height)
}

extension CGPoint {

    func confineToSizeWithEdgeInset(size:CGSize, insets:UIEdgeInsets) -> CGPoint {
        
        var _p:CGPoint = self
        
        var minX = insets.left
        var minY = insets.top
        var maxX = size.width - insets.right
        var maxY = size.height - insets.bottom
        
        if _p.x < minX {_p.x = minX}
        if _p.y < minY {_p.y = minY}
        if _p.x > maxX {_p.x = maxX}
        if _p.y > maxY {_p.y = maxY}

        return _p
    }
    
    var magnitude:CGFloat {
        get {
            var k = self
            return sqrt((k.x*k.x) + (k.y*k.y))
        }
    }
    
    var unitTangent:CGPoint {
        get {
            var returnValue:CGPoint = self
            var length = self.magnitude
            
            // Normalise to unit vector
            returnValue.x /= length
            returnValue.y /= length
            
            return returnValue
        }
    }
    
    var unitNormal:CGPoint {
        get {
            var returnValue:CGPoint = self
            
            // Rotate 90 degrees
            returnValue.x = self.y
            returnValue.y = -self.x
            
            return returnValue.unitTangent
        }
    }
    
    func interpolate(b:CGPoint, value:CGFloat) -> CGPoint {
        var a:CGPoint = self
        var interpolatedPoint = CGPoint()
        interpolatedPoint.x = (value * b.x) + ((1-value) * a.x)
        interpolatedPoint.y = (value * b.y) + ((1-value) * a.y)
        return interpolatedPoint
    }
}