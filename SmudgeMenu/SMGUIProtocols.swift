//  Created by Chris Harding on 22/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

/*
These protocols are used throughout the UI layer. They qualify how non-UI controller objects should interact with the UI layer.
*/

// Call these responders when sending messages TO the UI layer.

@objc protocol SMGResponder {}

@objc protocol SMGMenuItemsResponder : SMGResponder {
    optional func didUpdateCurrentMenuItem( newItemId:String )
    optional func didAddMenuIcon(itemId:String, iconTitle:String, menuIcon:UIViewController )
    optional func didAddMenuPage(itemId:String, menuPage:UIViewController )
}

@objc protocol SMGCurveResponder : SMGResponder {
    func didUpdateCurve( curve:SMGBezierCurve )
    optional func didUpdateMaxCurveWidth(width:CGFloat)
}

@objc protocol SMGTransitionResponder : SMGResponder {
    func didUpdateTransitionProgress(newProgress:CGFloat)
}


// Implement these updater protocols when recieving messages FROM the UI layer.

protocol SMGHandlesUpdater {
    func updateHandles( handleA:CGPoint, _ handleB:CGPoint )
    func updateHandleBounds(minX:CGFloat, _ minY:CGFloat, _ maxX:CGFloat, _ maxY:CGFloat )
}

protocol SMGCurrentMenuItemUpdater {
    func updateCurrentMenuItem( newItemId:String )
}