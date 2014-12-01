//  Created by Chris Harding on 17/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

/*
    Observes and reacts to changes in smudge model, forwards notifications to UI layer.
*/

class SMGSmudgeCurveController: SMGModelObserveNotifyController {
    
    var smudgeModel:SMGSmudgeModel {return model as SMGSmudgeModel}
    
    override func keyPaths() -> [String] {
        return ["startPoint", "endPoint", "minX", "maxX"]
    }
    
    override func initialiseResponder(responder: SMGResponder) {
        notifyResponder(responder, keyPath: "startPoint")
    }
    
    override func notifyResponder(responder: SMGResponder, keyPath:String) {
        
        let curveResponder = responder as SMGCurveResponder
        
        switch keyPath {
        case "startPoint","endPoint"  :
            curveResponder.didUpdateCurve( smudgeModel.bezierCurve )
            
        case "minX","maxX" :
            var maxWidth = smudgeModel.maxX - smudgeModel.minX
            curveResponder.didUpdateMaxCurveWidth?(maxWidth)
            
        default : ()
        }
    }
}
