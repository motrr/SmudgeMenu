//  Created by Chris Harding on 18/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

// This class will ensure that subviews recieve gestures even when the subview is out of bounds of containing view
class SubviewGesturesView : UIView {
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        
        for iSubView:UIView in reverse(self.subviews) as [UIView] {
            
            var viewWasHit = iSubView.hitTest(self.convertPoint(point, toView: iSubView), withEvent: event)
            if (viewWasHit != nil) {
                return viewWasHit
            }
            
        }
        return super.hitTest(point, withEvent: event)
    }
    
}