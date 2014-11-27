//  Created by Chris Harding on 20/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGSmudgeTransitionController : SMGModelObserverNotifier {
    
    override func keyPaths() -> [String] {
        return ["progress"]
    }
    
    override func initialiseResponder(responder: SMGResponder) {
        notifyResponder(responder, keyPath: "progress")
    }
    
    override func notifyResponder(responder: SMGResponder, keyPath:String) {
        
        let transitionResponder = responder as SMGTransitionResponder
        let smudgeModel = model as SMGSmudgeModel
        
        transitionResponder.didUpdateTransitionProgress( smudgeModel.progress )
    }
}