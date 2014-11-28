//  Created by Chris Harding on 28/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGMainMenuIconContainerViewController : SMGIconContainerViewController {
    
}

extension SMGMainMenuIconContainerViewController : SMGTransitionResponder {
    
    func didUpdateTransitionProgress(newProgress: CGFloat) {
        self.view.alpha = 1 - 4*newProgress
    }
}