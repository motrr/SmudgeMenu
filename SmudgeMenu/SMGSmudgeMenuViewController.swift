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
        didSet {addFullscreenChildViewController(handlesViewController)}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        smudgeViewController = SMGSmudgeViewController()
        iconsViewController = SMGSmudgeIconsViewController()
        smudgeDebugViewController = SMGSmudgeDebugViewController()
        handlesViewController = SMGSmudgeHandlesViewController()
        
        /*
            Show and hide view for debugging purposes.
        */
        
        smudgeDebugViewController.view.hidden = true
        //iconsViewController.view.hidden = true
        //smudgeViewController.view.hidden = true
        
        
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
        
        for iconContainer in iconsViewController.iconContainers {
            if tapTest(iconContainer, sender: sender) {break}
        }
        
        if (iconsViewController.mainMenuIconContainer != nil) {
            tapTest(iconsViewController.mainMenuIconContainer!, sender: sender)
        }
    }
    
    func tapTest(iconContainer:SMGIconContainerViewController, sender:UITapGestureRecognizer) -> Bool {
        let tapLocation = sender.locationInView(iconContainer.view)
        if iconContainer.view.hitTest(tapLocation, withEvent: nil) == iconContainer.view {
            iconContainer.didTap(sender)
            return true
        }
        return false
    }
}

