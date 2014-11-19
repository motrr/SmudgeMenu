//  Created by Chris Harding on 17/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

/*
    Observes and reacts to changes in smudge model, forwards notifications to UI layer.
*/

private var modelContext = "modelContext"

class SMGSmudgeCurveController : NSObject {
    
    let curveKeyPaths = ["startPoint","endPoint"]
    var curveResponder:SMGCurveResponder?
    
    var smudgeModel:SMGSmudgeModel
    init(smudgeModel:SMGSmudgeModel) {
        self.smudgeModel = smudgeModel
        super.init()
        addModelObservers()
    }
    deinit {
        removeModelObservers()
    }
    
    func loadUI(curveResponder:SMGCurveResponder) {
        self.curveResponder = curveResponder
    }
    
    private func addModelObservers() {
        for keyPath in curveKeyPaths {
            smudgeModel.addObserver(self, forKeyPath: keyPath, options: .New, context: &modelContext)
        }
    }
    private func removeModelObservers() {
        for keyPath in curveKeyPaths {
            smudgeModel.removeObserver(self, forKeyPath: keyPath)
        }
    }
    
    override func observeValueForKeyPath(
        keyPath: String,
        ofObject object: AnyObject,
        change: [NSObject: AnyObject],
        context: UnsafeMutablePointer<Void>)
    {
        if context == &modelContext {
            
            switch keyPath {
                
            case "startPoint", "endPoint" :
                self.curveResponder?.updateCurve(
                    smudgeModel.startPoint,
                    controlPointA: smudgeModel.controlPointA,
                    controlPointB: smudgeModel.controlPointB,
                    endPoint: smudgeModel.endPoint)
                
            default:
                super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            }
        }
    }
    

}
