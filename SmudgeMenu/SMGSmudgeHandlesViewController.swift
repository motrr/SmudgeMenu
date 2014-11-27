//  Created by Chris Harding on 16/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGSmudgeHandlesViewController : UIViewController {
    
    var handlesUpdater:SMGHandlesUpdater? {
        didSet {
            // Initialise the handle bounds
            informUpdaterOfHandleBounds( self.view.frame.size )
        }
    }
    
    let handleInitOffset = CGPoint(x: 200, y: 200)
    let handleRadius:CGFloat = 70
    let helperRadius:CGFloat = 25
    
    let handleVEdgeInsets:CGFloat = 80
    let handleHEdgeInsets:CGFloat = 50
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
    
    override func loadView() {
        self.view = SMGNoHitView(frame: UIScreen.mainScreen().applicationFrame)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHelperViews()
        setupHandles()
        setupDynamicBehaviors()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        coordinator.animateAlongsideTransition({context in
            
            // Update the handle bounds
            self.informUpdaterOfHandleBounds( size )
            
        }, completion: nil)
    }
    
    func setupHelperViews() {
        for helperView in [handleAHelperView, handleBHelperView] {
            self.view.addSubview( helperView )
            helperView.circleRadius = helperRadius
            helperView.center = handleInitOffset
        }
    }
    
    func setupHandles() {
        
        handleAViewController = SMGSmudgeHandleViewController()
        handleBViewController = SMGSmudgeHandleViewController()
        for handle in [ handleAViewController, handleBViewController ] {
                handle.delegate = self
                handle.xConstraint = centerX(handle.view) => left(self.view) + handleInitOffset.x
                handle.yConstraint = centerY(handle.view) => top(self.view) + handleInitOffset.y
                handle.view.snp_makeConstraints { make in
                    make.size.equalTo(CGSize(width:2*self.handleRadius, height:2*self.handleRadius)); return
                }
                handle.edgeInsets = handleEdgeInsets
        }
    }
    
    func setupDynamicBehaviors() {
        
        if (animator == nil) {animator = UIDynamicAnimator(referenceView: self.view)}
        animator.removeAllBehaviors()
        
        dynamicProperties = UIDynamicItemBehavior(items: [handleAHelperView, handleBHelperView])
        dynamicProperties.resistance = 100.0
        dynamicProperties.allowsRotation = false
        animator.addBehavior(dynamicProperties)
        
        handleAAttachment = UIAttachmentBehavior(item: handleAHelperView, attachedToAnchor: handleAViewController.view.center)
        handleAAttachment.frequency = 200.0
        handleAAttachment.damping = 50.0
        handleAAttachment.action = {
           self.informUpdaterOfHandlesUpdate()
        }
        animator.addBehavior(handleAAttachment)
        
        handleBAttachment = UIAttachmentBehavior(item: handleBHelperView, attachedToAnchor: handleAViewController.view.center)
        handleBAttachment.frequency = 200.0
        handleBAttachment.damping = 50.0
        handleBAttachment.action = {
            self.informUpdaterOfHandlesUpdate()
        }
        animator.addBehavior(handleBAttachment)
    }
    
    func updateDyanmics() {
        handleAAttachment.anchorPoint = handleAViewController.centrePointFromConstraints!
        handleAAttachment.length = 0
        handleBAttachment.anchorPoint = handleBViewController.centrePointFromConstraints!
        handleBAttachment.length = 0
    }
    
    func informUpdaterOfHandlesUpdate() {
        self.handlesUpdater?.updateHandles(self.handleAHelperView.center, self.handleBHelperView.center)
    }
    
    func informUpdaterOfHandleBounds(size:CGSize) {
        
        var topLeft = CGPoint(x: self.handleEdgeInsets.left, y: self.handleEdgeInsets.top)
        var bottomRight = CGPoint(
            x: size.width - self.handleEdgeInsets.right,
            y: size.height - self.handleEdgeInsets.bottom
        )
        
        self.handlesUpdater?.updateHandleBounds(topLeft.x, topLeft.y, bottomRight.x, bottomRight.y)
    }
}

extension SMGSmudgeHandlesViewController : SMGSmudgeHandleViewControllerDelegate {
    
    func handleDidMove(handle: SMGSmudgeHandleViewController) {

        var helper = handleAHelperView
        var otherHandle = handleBViewController
        if handle == handleBViewController {
            helper = handleBHelperView
            otherHandle = handleAViewController
        }
        
        /* 
            Increase responsiveness of manually-moved handle, at the cost of a little elegance.
        */
        
        //helper.center = handle.centrePointFromConstraints!
        //animator.updateItemUsingCurrentState(helper)
        
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





