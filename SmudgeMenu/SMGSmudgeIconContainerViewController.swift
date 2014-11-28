//  Created by Chris Harding on 21/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGSmudgeIconContainerViewController : SMGIconContainerViewController {
    
    var currentMenuItemUpdater:SMGCurrentMenuItemUpdater?
    var itemId:String!
    
    var tapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture = UITapGestureRecognizer(target: self, action: Selector("didTap:"))
        self.view.addGestureRecognizer(tapGesture)
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    func didTap(sender:UITapGestureRecognizer) {
        currentMenuItemUpdater?.updateCurrentMenuItem(itemId)
    }
}

extension SMGSmudgeIconContainerViewController : SMGTransitionResponder {

    func didUpdateTransitionProgress(newProgress: CGFloat) {
        self.view.alpha = newProgress
    }
}