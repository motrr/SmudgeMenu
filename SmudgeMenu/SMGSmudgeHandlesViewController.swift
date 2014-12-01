//  Created by Chris Harding on 16/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

enum SMGPreferredEdge {
    case Left, Right
}

class SMGSmudgeHandlesViewController : UIViewController {
    
    var handlesUpdater:SMGHandlesUpdater? {
        didSet {
            // Initialise the handle bounds
            informUpdaterOfHandleBounds( self.view.frame.size )
        }
    }
    
    let handleRadius:CGFloat = 70
    let helperRadius:CGFloat = 25
    
    let handleVEdgeInsets:CGFloat = 80
    let handleHEdgeInsets:CGFloat = 50
    var handleEdgeInsets:UIEdgeInsets {
        return UIEdgeInsetsMake(handleVEdgeInsets, handleHEdgeInsets, handleVEdgeInsets, handleHEdgeInsets)
    }
    
    var handleInitPoint:CGPoint!
    
    var preferredEdge:SMGPreferredEdge = .Left
    var handleLeftSnapPoint:CGPoint?
    var handleRightSnapPoint:CGPoint?
    
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
        
        handleInitPoint = CGPoint(x: handleHEdgeInsets, y: handleVEdgeInsets)
        
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
            helperView.center = handleInitPoint
        }
    }
    
    func setupHandles() {
        
        handleAViewController = SMGSmudgeHandleViewController()
        handleBViewController = SMGSmudgeHandleViewController()
        for handle in [ handleAViewController, handleBViewController ] {
                handle.delegate = self
                handle.xConstraint = centerX(handle.view) => left(self.view) + handleInitPoint.x
                handle.yConstraint = centerY(handle.view) => top(self.view) + handleInitPoint.y
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

        // Increase responsiveness of manually-moved handle, at the cost of smoother animation.
        //helper.center = handle.centrePointFromConstraints!
        //animator.updateItemUsingCurrentState(helper)
        
        // Limit vertical seperation of the two handles, based on their horizontal seperation
        var hSep:CGFloat = handle.xConstraint!.constant - otherHandle.xConstraint!.constant
        var vSep:CGFloat = handle.yConstraint!.constant - otherHandle.yConstraint!.constant
        
        if vSep > maxVSeparationToHSeperationRatio * fabs(hSep)
            { otherHandle.yConstraint!.constant = handle.yConstraint!.constant - maxVSeparationToHSeperationRatio * fabs(hSep) }
        else if vSep < -maxVSeparationToHSeperationRatio * fabs(hSep)
            { otherHandle.yConstraint!.constant = handle.yConstraint!.constant + maxVSeparationToHSeperationRatio * fabs(hSep) }
        
        updateDyanmics()
    }
    
    func handleDidFinishMoving(handle: SMGSmudgeHandleViewController) {
       
        handleDidMove(handle)
        
        var otherHandle = handleBViewController
        if handle == handleBViewController {
            otherHandle = handleAViewController
        }
        
        if handle.xConstraint?.constant != otherHandle.xConstraint?.constant {
            handlesSnappedOpen(handle, anchoredHandle: otherHandle)
        }
        else {
            handlesSnappedClosed(handle, anchoredHandle: otherHandle)
        }
    }
    
    func handlesSnappedOpen(freeHandle:SMGSmudgeHandleViewController, anchoredHandle:SMGSmudgeHandleViewController) {
        
        if freeHandle.xConstraint?.constant < anchoredHandle.xConstraint?.constant {
            handleLeftSnapPoint = freeHandle.centrePointFromConstraints
            handleRightSnapPoint = anchoredHandle.centrePointFromConstraints
        }
        else {
            handleLeftSnapPoint = anchoredHandle.centrePointFromConstraints
            handleRightSnapPoint = freeHandle.centrePointFromConstraints
        }
    }
    
    func handlesSnappedClosed(freeHandle:SMGSmudgeHandleViewController, anchoredHandle:SMGSmudgeHandleViewController) {
        
        if freeHandle.xConstraint?.constant < self.view.frame.size.width / 2 {
            preferredEdge = .Left
            handleLeftSnapPoint = freeHandle.centrePointFromConstraints
            handleRightSnapPoint = nil
        }
        else {
            preferredEdge = .Right
            handleLeftSnapPoint = nil
            handleRightSnapPoint = freeHandle.centrePointFromConstraints
        }
    }
}

extension SMGSmudgeHandlesViewController : SMGSmudgeOpenCloseResponder {
    
    func didOpenHandles() {
        
        generateSnapPoints()
        
        handleAViewController.centrePointFromConstraints = handleLeftSnapPoint
        handleBViewController.centrePointFromConstraints = handleRightSnapPoint
        
        updateAnimatorWithHandles()
    }
    
    func didCloseHandles() {
        
        generateSnapPoints()
        
        var closePoint:CGPoint
        if self.preferredEdge == SMGPreferredEdge.Left {closePoint = handleLeftSnapPoint!}
        else {closePoint = handleRightSnapPoint!}
        
        handleAViewController.centrePointFromConstraints = closePoint
        handleBViewController.centrePointFromConstraints = closePoint
        
        updateAnimatorWithHandles()
    }
    
    func updateAnimatorWithHandles() {
        animator?.updateItemUsingCurrentState(handleAViewController.view)
        animator?.updateItemUsingCurrentState(handleBViewController.view)
        updateDyanmics()
    }
    
    func generateSnapPoints() {
        
        if handleRightSnapPoint == nil && handleLeftSnapPoint == nil {
            handleLeftSnapPoint = handleInitPoint
            handleLeftSnapPoint?.y += 30
        }
        
        if handleRightSnapPoint == nil {
            handleRightSnapPoint = handleLeftSnapPoint
            handleRightSnapPoint?.y += 30
            handleRightSnapPoint?.x = self.view.frame.size.width - handleEdgeInsets.right
        }
        
        if handleLeftSnapPoint == nil {
            handleLeftSnapPoint = handleRightSnapPoint
            handleLeftSnapPoint?.y += 30
            handleLeftSnapPoint?.x = handleEdgeInsets.left
        }
    }
}





