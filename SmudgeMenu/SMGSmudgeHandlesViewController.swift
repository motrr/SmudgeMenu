//  Created by Chris Harding on 16/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGSmudgeHandlesViewController : UIViewController {
    
    var handleObserver:SMGHandleObserver?
    
    let handleInitOffset = CGPoint(x: 200, y: 200)
    let handleSize = CGSize(width: 100, height: 100)
    let helperSize = CGSize(width: 50, height: 50)
    
    let handleVEdgeInsets:CGFloat = 80
    let handleHEdgeInsets:CGFloat = 40
    var handleEdgeInsets:UIEdgeInsets {
        return UIEdgeInsetsMake(handleVEdgeInsets, handleHEdgeInsets, handleVEdgeInsets, handleHEdgeInsets)
    }
    
    let maxVSeparationToHSeperationRatio:CGFloat = 0.5

    var handleAViewController:SMGSmudgeHandleViewController!  {
        didSet {addChildViewControllerHelper(handleAViewController)}
    }
    var handleBViewController:SMGSmudgeHandleViewController!  {
        didSet {addChildViewControllerHelper(handleBViewController)}
    }
    
    var handleAHelperView = SMGHandleHelperView()
    var handleBHelperView = SMGHandleHelperView()
    
    private var animator:UIDynamicAnimator!
    private var dynamicProperties:UIDynamicItemBehavior!
    private var handleAAttachment:UIAttachmentBehavior!
    private var handleBAttachment:UIAttachmentBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHelperViews()
        setupHandles()
        setupDynamicBehaviors()
    }
    
    func setupHelperViews() {
        for helperView in [handleAHelperView, handleBHelperView] {
            self.view.addSubview( helperView )
            helperView.frame.size = helperSize
        }
    }
    
    func setupHandles() {
        
        handleAViewController = SMGSmudgeHandleViewController()
        handleBViewController = SMGSmudgeHandleViewController()
        for (handle,handleOffset) in [
            (handleAViewController, handleInitOffset),
            (handleBViewController, handleInitOffset)
            ] {
                handle.delegate = self
                handle.xConstraint = centerX(handle.view) => left(self.view) + handleOffset.x
                handle.yConstraint = centerY(handle.view) => top(self.view) + handleOffset.y
                handle.view.snp_makeConstraints { make in
                    make.size.equalTo(self.handleSize); return
                }
                handle.edgeInsets = handleEdgeInsets
        }
    }
    
    func setupDynamicBehaviors() {
        
        // Initialise animator
        if (animator == nil) {animator = UIDynamicAnimator(referenceView: self.view)}
        animator.removeAllBehaviors()
        
        // Add resistance
        dynamicProperties = UIDynamicItemBehavior(items: [handleAHelperView, handleBHelperView])
        dynamicProperties.resistance = 100.0
        dynamicProperties.allowsRotation = false
        animator.addBehavior(dynamicProperties)
        
        handleAAttachment = UIAttachmentBehavior(item: handleAHelperView, attachedToAnchor: handleAViewController.view.center)
        handleAAttachment.frequency = 200.0
        handleAAttachment.damping = 50.0
        handleAAttachment.action = {
           self.informObserver()
        }
        animator.addBehavior(handleAAttachment)
        
        handleBAttachment = UIAttachmentBehavior(item: handleBHelperView, attachedToAnchor: handleAViewController.view.center)
        handleBAttachment.frequency = 200.0
        handleBAttachment.damping = 50.0
        handleBAttachment.action = {
            self.informObserver()
        }
        animator.addBehavior(handleBAttachment)
    }
    
    func updateDyanmics() {
        handleAAttachment.anchorPoint = handleAViewController.centrePointFromConstraints!
        handleAAttachment.length = 0
        handleBAttachment.anchorPoint = handleBViewController.centrePointFromConstraints!
        handleBAttachment.length = 0
    }
    
    func informObserver() {
        if self.handleObserver != nil {
            self.handleObserver!.didUpdateHandles(self.handleAHelperView.center, self.handleBHelperView.center)
        }
    }
}

extension SMGSmudgeHandlesViewController : SMGSmudgeHandleViewControllerDelegate {
    
    func handleDidMove(handle: SMGSmudgeHandleViewController) {
        
        var otherHandle = handleBViewController
        if handle == handleBViewController {otherHandle = handleAViewController}
        
        /*
            Limit vertical seperation of the two handles, based on their horizontal seperation
        */
        
        var hSep:CGFloat = handle.xConstraint!.constant - otherHandle.xConstraint!.constant
        var vSep:CGFloat = handle.yConstraint!.constant - otherHandle.yConstraint!.constant
        
        if vSep > maxVSeparationToHSeperationRatio * fabs(hSep)
            { otherHandle.yConstraint!.constant = handle.yConstraint!.constant - maxVSeparationToHSeperationRatio * fabs(hSep) }
        else if vSep < -maxVSeparationToHSeperationRatio * fabs(hSep)
            { otherHandle.yConstraint!.constant = handle.yConstraint!.constant + maxVSeparationToHSeperationRatio * fabs(hSep) }
        
        updateDyanmics()
    }
}





