//  Created by Chris Harding on 19/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGSmudgeMenuViewController : UIViewController {
    
    var handleATapRecogniser:UITapGestureRecognizer!
    var handleBTapRecogniser:UITapGestureRecognizer!
    
    var smudgeViewController:SMGSmudgeViewController! {
        didSet {addFullscreenChildViewControllerHelper(smudgeViewController)}
    }
    var smudgeDebugViewController:SMGSmudgeDebugViewController!
    {
        didSet {addFullscreenChildViewControllerHelper(smudgeDebugViewController)}
    }
    var smudgeIconsViewController:SMGSmudgeIconsViewController! {
        didSet {addFullscreenChildViewControllerHelper(smudgeIconsViewController)}
    }
    var mainIconViewController:SMGMainIconViewController!  {
        didSet {addFullscreenChildViewControllerHelper(mainIconViewController)}
    }
    var handlesViewController:SMGSmudgeHandlesViewController!  {
        didSet {addFullscreenChildViewControllerHelper(handlesViewController)}
    }
    
    override func loadView() {
        self.view = SMGNoHitView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        smudgeViewController = SMGSmudgeViewController()
        smudgeIconsViewController = SMGSmudgeIconsViewController()
        mainIconViewController = SMGMainIconViewController()
        smudgeDebugViewController = SMGSmudgeDebugViewController()
        handlesViewController = SMGSmudgeHandlesViewController()
        
        /*
            Show and hide view for debugging purposes.
        */
        
        smudgeDebugViewController.view.hidden = true
        //iconsViewController.view.hidden = true
        //smudgeViewController.view.hidden = true
        //handlesViewController.view.hidden = true
        
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
        
        for iconContainer in smudgeIconsViewController.iconContainers {
            if tapTest(iconContainer.tappableView, sender: sender) {return}
        }
        tapTest(mainIconViewController.stackContainer.tappableView, sender: sender)
    }
    
    func tapTest(tappableView:SMGTappableView, sender:UITapGestureRecognizer) -> Bool {
        
        let tapLocation = sender.locationInView(tappableView)
        if tappableView.hitTest(tapLocation, withEvent: nil) == tappableView {
            tappableView.didTap(sender)
            return true
        }
        return false
    }
}

