//  Created by Chris Harding on 17/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

/*
    Responds to user input in UI layer smudge handles, updates model accordingly.
*/

private var uiContext = "uiContext"

class SMGSmudgeHandlesController : NSObject {
    
    var model:SMGSmudgeModel
    init(model:SMGSmudgeModel) {
        self.model = model
        super.init()
    }
}

extension SMGSmudgeHandlesController : SMGHandlesUpdater {
    
    func updateHandles(handleA: CGPoint, _ handleB: CGPoint) {

        // Update model with handle positions
        if handleA.x < handleB.x {
            model.startPoint = handleA
            model.endPoint = handleB
        }
        else {
            model.startPoint = handleB
            model.endPoint = handleA
        }
        
        // Update model with progress
        var seperation = abs(handleA.x - handleB.x)
        model.progress = (seperation - model.minX) / (model.maxX - model.minX)
        
    }
    
    func updateHandleBounds(minX: CGFloat, _ minY: CGFloat, _ maxX: CGFloat, _ maxY: CGFloat) {
        model.minX = minX
        model.minY = minY
        model.maxX = maxX
        model.maxY = maxY
    }
}