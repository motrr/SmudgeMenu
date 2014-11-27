//  Created by Chris Harding on 19/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGSmudgeMenuViewController : UIViewController {
    
    var handleATapRecogniser:UITapGestureRecognizer!
    var handleBTapRecogniser:UITapGestureRecognizer!
    
    var smudgeViewController:SMGSmudgeViewController! {
        didSet {addFullscreenChildViewController(smudgeViewController)}
    }
    
    var smudgeDebugViewController:SMGSmudgeDebugViewController! {
        didSet {addFullscreenChildViewController(smudgeDebugViewController)}
    }
    
    var iconsViewController:SMGSmudgeIconsViewController! {
        didSet {addFullscreenChildViewController(iconsViewController)}
    }

    var handlesViewController:SMGSmudgeHandlesViewController!  {
        didSet {addChildViewControllerHelper(handlesViewController)}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        smudgeViewController = SMGSmudgeViewController()
        smudgeDebugViewController = SMGSmudgeDebugViewController()
        iconsViewController = SMGSmudgeIconsViewController()
        handlesViewController = SMGSmudgeHandlesViewController()
        
        smudgeDebugViewController.view.hidden = true
        
        /*
            To ensure that taps on the menu icon buttons are passed through the overlying handles,
            we recognise taps on the handles and forward them to icons.
        */
        
        let handleAView = handlesViewController.handleAViewController.view
        let handleBView = handlesViewController.handleBViewController.view
        
        handleATapRecogniser = UITapGestureRecognizer(target:self, action:Selector( "didTap:" ))
        handleBTapRecogniser = UITapGestureRecognizer(target:self, action:Selector( "didTap:" ))
        
        handleAView.addGestureRecognizer(handleATapRecogniser)
        handleBView.addGestureRecognizer(handleBTapRecogniser)
    }
    
    func didTap(sender:UITapGestureRecognizer) {
        
        for (itemIndex, iconContainer) in iconsViewController.iconContainers {
            
            let tapLocation = sender.locationInView(iconContainer.view)
            if iconContainer.view.hitTest(tapLocation, withEvent: nil) == iconContainer.view {
                iconContainer.didTap(sender)
                break
            }
        }
    }
}

