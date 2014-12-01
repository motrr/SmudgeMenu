//  Created by Chris Harding on 17/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

/*
    Base class for observing and reacting to changes in model layer and notifying responders in the UI layer
*/

class SMGModelObserveNotifyController: SMGModelObserveController {
    
    var responders:[SMGResponder] = []
    
    func addResponder(responder:SMGResponder) {
        responders.append( responder )
        self.initialiseResponder(responder)
    }
    
    override func modelDidChange(keyPath:String) {
        for responder in responders {
            notifyResponder(responder, keyPath:keyPath)
        }
    }
    
    func initialiseResponder(responder:SMGResponder) {
        fatalError("Override this method in your subclass to initialise UI responders accordingly")

    }
    func notifyResponder(responder:SMGResponder, keyPath:String) {
        fatalError("Override this method in your subclass to update UI responders accordingly")
    }
}
