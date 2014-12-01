//  Created by Chris Harding on 17/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

/*
    Responds to user input in UI layer smudge handles, updates model accordingly.

    Also responsible for opening and closing the handles.

    Note that we don't actually observe the model, but we do maintain a list of handles responders that are informed when the handles are opened or closed.
*/

class SMGSmudgeHandlesController : SMGModelNotifyController {
    var smudgeModel:SMGSmudgeModel {return model as SMGSmudgeModel}
}

extension SMGSmudgeHandlesController : SMGHandlesUpdater {
    
    func updateHandles(handleA: CGPoint, _ handleB: CGPoint) {
        
        // Update model start/end positions
        if handleA.x < handleB.x {
            smudgeModel.startPoint = handleA
            smudgeModel.endPoint = handleB
        }
        else {
            smudgeModel.startPoint = handleB
            smudgeModel.endPoint = handleA
        }
        
        // Update model with progress
        let seperation = abs(handleA.x - handleB.x)
        let maxSeperation = abs(smudgeModel.minX - smudgeModel.maxX)
        smudgeModel.progress = seperation / maxSeperation
    }
    
    func updateHandleBounds(minX: CGFloat, _ minY: CGFloat, _ maxX: CGFloat, _ maxY: CGFloat) {

        smudgeModel.minX = minX
        smudgeModel.minY = minY
        smudgeModel.maxX = maxX
        smudgeModel.maxY = maxY
    }
}

extension SMGSmudgeHandlesController : SMGSmudgeOpenCloseUpdater {

    func openHandles() {
        for responder in responders {
            let handlesResponder = responder as SMGSmudgeOpenCloseResponder
            handlesResponder.didOpenHandles()
        }
    }
    
    func closeHandles() {
        for responder in responders {
            let handlesResponder = responder as SMGSmudgeOpenCloseResponder
            handlesResponder.didCloseHandles()
        }
    }
}