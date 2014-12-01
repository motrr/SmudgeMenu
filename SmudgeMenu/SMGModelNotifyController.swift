//  Created by Chris Harding on 17/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

/*
    Base class for notifying responderes in the UI layer.

    Sometimes we maintian a list of responders to be notified, but don't actually need to observe the model - we act directly on messages from the UI layer with no need to update the model. We subclass SMGModelObserveNotifyController and override with empty methods (since we can't use multiple inheritance). This means responders can only be triggered manually from the responders array, which is the desired behavior.
*/

class SMGModelNotifyController : SMGModelObserveNotifyController {
    
    override func keyPaths() -> [String] {
        // Nothing to do.
        return []
    }
    override func initialiseResponder(responder: SMGResponder) {
        // Nothing to do
    }
    override func notifyResponder(responder: SMGResponder, keyPath:String) {
        // Nothing to do
    }
}