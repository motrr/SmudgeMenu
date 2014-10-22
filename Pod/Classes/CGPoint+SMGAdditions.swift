//  Created by Chris Harding on 21/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

extension CGPoint {
    
    func subtractPoint(p:CGPoint) -> CGPoint {
        return CGPoint(x: self.x - p.x, y: self.y-p.y)
    }
    
    var magnitude:CGFloat {
        get {
            var k = self
            return sqrt((k.x*k.x) + (k.y*k.y))
        }
    }
    
    var unitPerpendicular:CGPoint {
        get {
            var returnValue:CGPoint = self
            var length = self.magnitude
            
            // Rotate 90 degrees
            returnValue.x = self.y
            returnValue.y = -self.x
            
            // Normalise to unit vector
            returnValue.x /= length
            returnValue.y /= length
            
            return returnValue
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
