//  Created by Chris Harding on 25/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGBezierCurve : NSObject {
    
    var a:CGPoint
    var b:CGPoint
    var c:CGPoint
    var d:CGPoint
    
    init(_ a:CGPoint,_ b:CGPoint,_ c:CGPoint,_ d:CGPoint) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    
    func interpolateElementPosition(elementIndex:Int, elementCount:Int) -> CGPoint {
        
        var t:CGFloat
        if elementCount <= 1 { t = 0 }
        else {t = CGFloat(elementIndex) / CGFloat(elementCount-1) }
        
        return bezierInterpolationEvenXSpacing(t)
    }
    
    func bezierInterpolationEvenXSpacing(t:CGFloat) -> CGPoint {
        
        return CGPoint(
            x: a.interpolate(d, value: t).x,
            y: bezierInterpolationSingleAxis(t, a.y, b.y, c.y, d.y)
        )
    }
    
    func bezierInterpolation(t:CGFloat) -> CGPoint {
        
        return CGPoint(
            x: bezierInterpolationSingleAxis(t, a.x, b.x, c.x, d.x),
            y: bezierInterpolationSingleAxis(t, a.y, b.y, c.y, d.y)
        )
    }
    
    func bezierInterpolationSingleAxis(t:CGFloat,_ e:CGFloat,_ f:CGFloat,_ g:CGFloat,_ h:CGFloat) -> CGFloat {
        var t2:CGFloat = t * t
        var t3:CGFloat = t2 * t
        return e + (-e * 3 + t * (3 * e - e * t)) * t
            + (3 * f + t * (-6 * f + f * 3 * t)) * t
            + (g * 3 - g * 3 * t) * t2
            + h * t3
    }
}