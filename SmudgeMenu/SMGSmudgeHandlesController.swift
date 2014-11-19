//  Created by Chris Harding on 17/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

/*
    Responds to user input in UI layer smudge handles, updates model accordingly.
*/

private var uiContext = "uiContext"

class SMGSmudgeHandlesController : NSObject {
    
    var smudgeModel:SMGSmudgeModel
    init(smudgeModel:SMGSmudgeModel) {
        self.smudgeModel = smudgeModel
        super.init()
    }
    
    func loadUI(smudgeHandlesViewController:SMGSmudgeHandlesViewController) {
        smudgeHandlesViewController.handleObserver = self
    }
}

extension SMGSmudgeHandlesController : SMGHandleObserver {
    
    func didUpdateHandles(handleA: CGPoint, _ handleB: CGPoint) {

        if handleA.x < handleB.x {
            smudgeModel.startPoint = handleA
            smudgeModel.endPoint = handleB
        }
        else {
            smudgeModel.startPoint = handleB
            smudgeModel.endPoint = handleA
        }
    }
}