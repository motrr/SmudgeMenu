//  Created by Chris Harding on 03/12/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

enum SMGStackItemPosition {
    case Left, Centre, Right
}

class SMGStackItemViewController : SMGXYConstraintViewController {
    
    var buttonOffset:CGFloat = 50
    
    func positionButton(position:SMGStackItemPosition) {
        
        switch position {
        case .Left :
            view.alpha = 0
            xConstraint.constant = -buttonOffset
            
        case .Centre :
            view.alpha = 1
            xConstraint.constant = 0

        case .Right :
            view.alpha = 0
            xConstraint.constant = buttonOffset
            
        }
        
        self.view.layoutIfNeeded()
    }
}
