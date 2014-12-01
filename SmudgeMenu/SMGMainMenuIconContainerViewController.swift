//  Created by Chris Harding on 28/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGMainMenuIconContainerViewController : SMGIconContainerViewController {
    
    var openCloseUpdater:SMGSmudgeOpenCloseUpdater?
    
    var iconViewController:UIViewController! {
        didSet {
            self.addChildViewControllerHelper(self.iconViewController)
            self.iconViewController.view.userInteractionEnabled = false
        }
    }
    
    override func didTap(tg: UITapGestureRecognizer) {
        openCloseUpdater?.openHandles()
    }
}

extension SMGMainMenuIconContainerViewController : SMGTransitionResponder {
    
    func didUpdateTransitionProgress(newProgress: CGFloat) {
        self.view.alpha = 1 - 4*newProgress
    }
}