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

class SMGMenuItemsModel : NSObject {
    var currentItemId:String?
    var itemsDictionary:Dictionary<String, SMGMenuItemModel> = Dictionary<String, SMGMenuItemModel>()
}

class SMGMenuItemModel : NSObject {
    var itemId:String
    var pageModel:SMGPageModel
    var iconModel:SMGIconModel
    
    init(itemId:String, pageModel:SMGPageModel, iconModel:SMGIconModel) {
        self.itemId = itemId
        self.pageModel = pageModel
        self.iconModel = iconModel
    }
}

class SMGSmudgeModel : NSObject {
    
    var backgroundColour:UIColor = UIColor.redColor()
    var mainMenuIcon:SMGMainMenuIconModel?

    dynamic var startPoint: CGPoint = CGPoint(x: 0, y: 0)
    dynamic var endPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    var curveAmount:CGFloat = 30
    
    /* 
        Calculated Bezier curve control points.
    */
    var controlPointA:CGPoint {
        // Watch out for case of points being equal
        if startPoint == endPoint { return startPoint }
        
        // Interpolate 25% between start and finish
        var controlPoint = startPoint.interpolate(endPoint, value:0.25)
        var endStartSeparationDistance = (endPoint - startPoint).magnitude
        
        // Calculate amount to curve
        var curveFactor = (endStartSeparationDistance / 300) * curveAmount
        
        // Move in direction perpendicalr to start <-> finish vector
        var unitNormal = (endPoint - startPoint).unitNormal
        controlPoint.x += (unitNormal.x * curveFactor)
        controlPoint.y += (unitNormal.y * curveFactor)
        return controlPoint
    }
    
    var controlPointB:CGPoint {
        // Watch out for case of points being equal
        if startPoint == endPoint { return startPoint }
        
        // Interpolate 75% between start and finish
        var controlPoint = startPoint.interpolate(endPoint, value:0.75)
        var endStartSeparationDistance = (endPoint - startPoint).magnitude
        
        // Calculate amount to curve
        var curveFactor = (endStartSeparationDistance / 300) * curveAmount
        
        // Move in direction perpendicalr to start <-> finish vector
        var unitNormal = (endPoint-startPoint).unitNormal
        controlPoint.x += (unitNormal.x * curveFactor)
        controlPoint.y += (unitNormal.y * curveFactor)
        return controlPoint
    }
}

class SMGBarModel : NSObject {
    var backgroundColour:UIColor = UIColor.redColor()
}