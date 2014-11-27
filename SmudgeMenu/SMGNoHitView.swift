//  Created by Chris Harding on 26/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGNoHitView : UIView {
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        var view = super.hitTest(point, withEvent: event)
        if view == self { return nil }
        return view
    }
}