//  Created by Chris Harding on 28/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGIconContainerViewController : UIViewController {
    
    var xConstraint:NSLayoutConstraint!
    var yConstraint:NSLayoutConstraint!
    
    var iconViewController:UIViewController! {
        didSet {
            self.addFullscreenChildViewController(self.iconViewController)
            self.iconViewController.view.userInteractionEnabled = false
        }
    }
    
}