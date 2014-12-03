//  Created by Chris Harding on 28/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGXYConstraintViewController : UIViewController {
    
    var xConstraint:NSLayoutConstraint!
    var yConstraint:NSLayoutConstraint!
    
    var pointFromConstraints:CGPoint? {
        get {
            if xConstraint != nil && yConstraint != nil {
                return CGPoint(x: xConstraint!.constant, y: yConstraint!.constant)
            } else { return nil }
        }
        set {
            if newValue != nil && xConstraint != nil && yConstraint != nil {
                xConstraint?.constant = newValue!.x
                yConstraint?.constant = newValue!.y
            }
        }
    }
}

