//  Created by Chris Harding on 25/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKIt

class SMGPageContainerViewController : UIViewController {
    
    var pageViewController:UIViewController! {
        didSet {
            self.addFullscreenChildViewController(self.pageViewController)
        }
    }
}