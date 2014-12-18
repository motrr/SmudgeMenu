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
    let handleBounds:UIEdgeInsets = UIEdgeInsetsMake(100, 50, 100, 50)
    let cornerSnapPoint = CGPoint(x: 50, y: 50)
    
    let minOpenTopDistance:CGFloat = 100
    
    var preferredEdge:SMGPreferredEdge = .Left
    var handleCloseSnapPoint:CGPoint?
    var handleLeftSnapPoint:CGPoint?
    var handleRightSnapPoint:CGPoint?
    
    let maxVSeparationToHSeperationRatio:CGFloat = 0.5
    var seperationToOpenThreshold:CGFloat = 100

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
        
        let screenSize = UIScreen.mainScreen().applicationFrame.size
        seperationToOpenThreshold = maxHandleSeperation(screenSize) / 2.0
        
        setupHelperViews()
        setupHandles()
        setupDynamicBehaviors()
    }
    
    func maxHandleSeperation(size:CGSize) -> CGFloat {
        return size.width - (handleBounds.left + handleBounds.right)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        coordinator.animateAlongsideTransition({context in
            
            self.seperationToOpenThreshold = self.maxHandleSeperation( size ) / 2.0
            self.informUpdaterOfHandleBounds( size )
            
        }, completion: nil)
    }
    
    func setupHelperViews() {
        for helperView in [handleAHelperView, handleBHelperView] {
            self.view.addSubview( helperView )
            helperView.circleRadius = helperRadius
            helperView.center = cornerSnapPoint
        }
    }
    
    func setupHandles() {
        
        handleAViewController = SMGSmudgeHandleViewController()
        handleBViewController = SMGSmudgeHandleViewController()
        for handle in [ handleAViewController, handleBViewController ] {
                handle.delegate = self
                handle.xConstraint = centerX(handle.view) => left(self.view) + cornerSnapPoint.x
                handle.yConstraint = centerY(handle.view) => top(self.view) + cornerSnapPoint.y
                handle.view.snp_makeConstraints { make in
                    make.size.equalTo(CGSize(width:2*self.handleRadius, height:2*self.handleRadius)); return
                }
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
        
        if handleAViewController.constraintsAsPoint!.y < handleBounds.top {
            handleAAttachment.anchorPoint = handleAViewController.constraintsAsPoint!.interpolate(cornerSnapPoint, value: 0.5)
        } else {
            handleAAttachment.anchorPoint = handleAViewController.constraintsAsPoint!
        }
        
        if handleBViewController.constraintsAsPoint!.y < handleBounds.top {
            handleBAttachment.anchorPoint = handleBViewController.constraintsAsPoint!.interpolate(cornerSnapPoint, value: 0.5)
        } else {
            handleBAttachment.anchorPoint = handleBViewController.constraintsAsPoint!
        }
        
        handleAAttachment.length = 0
        handleBAttachment.length = 0
    }
    
    func informUpdaterOfHandlesUpdate() {
        self.handlesUpdater?.updateHandles(self.handleAHelperView.center, self.handleBHelperView.center)
    }
    
    func informUpdaterOfHandleBounds(size:CGSize) {
        
        var topLeft = CGPoint(x: self.handleBounds.left, y: self.handleBounds.top)
        var bottomRight = CGPoint(
            x: size.width - self.handleBounds.right,
            y: size.height - self.handleBounds.bottom
        )
        
        self.handlesUpdater?.updateHandleBounds(topLeft.x, topLeft.y, bottomRight.x, bottomRight.y)
    }
    
    func getOtherHandle(handle:SMGSmudgeHandleViewController) -> SMGSmudgeHandleViewController {
        if handle == handleBViewController { return handleAViewController }
        else { return handleBViewController }
    }
    func getLeftHandle() -> SMGSmudgeHandleViewController {
        return getOtherHandle(getRightHandle())
    }
    func getRightHandle() -> SMGSmudgeHandleViewController {
        if handleAViewController.constraintsAsPoint!.x > handleBViewController.constraintsAsPoint!.x {
            return handleAViewController
        }
        else {return handleBViewController}
    }
}

extension SMGSmudgeHandlesViewController : SMGSmudgeHandleViewControllerDelegate {
    
    func handleDidMove(handle:SMGSmudgeHandleViewController, newPosition:CGPoint) {

        let otherHandle = getOtherHandle(handle)
        var otherHandleNewPosition = otherHandle.constraintsAsPoint!

        // Limit vertical seperation of the two handles, based on their horizontal seperation
        var hSep:CGFloat = newPosition.x - otherHandleNewPosition.x
        var vSep:CGFloat = newPosition.y - otherHandleNewPosition.y
        if vSep > maxVSeparationToHSeperationRatio * fabs(hSep)
            { otherHandleNewPosition.y = newPosition.y - maxVSeparationToHSeperationRatio * fabs(hSep) }
        else if vSep < -maxVSeparationToHSeperationRatio * fabs(hSep)
            { otherHandleNewPosition.y = newPosition.y + maxVSeparationToHSeperationRatio * fabs(hSep) }
        
        // Actually move the handles
        handle.constraintsAsPoint! = newPosition
        otherHandle.constraintsAsPoint! = otherHandleNewPosition
        
        updateDyanmics()
    }
    
    func handleDidFinishMoving(handle: SMGSmudgeHandleViewController) {
        
        var otherHandle = getOtherHandle(handle)
        
        // Determine if either of the handles is in the top snap zone
        var eitherHandleInTopSnapZone = false
        if handle.constraintsAsPoint!.y < handleBounds.top || handle.constraintsAsPoint!.y < handleBounds.top {
            eitherHandleInTopSnapZone = true
            handleRightSnapPoint = nil
            handleLeftSnapPoint = nil
            handleCloseSnapPoint = nil
        } else {
            handleCloseSnapPoint = otherHandle.constraintsAsPoint
        }
        
        // Determine if we should snap the handles together or apart
        if (otherHandle.constraintsAsPoint! - handle.constraintsAsPoint!).magnitude < seperationToOpenThreshold {
            snapHandlesClosed(handle, anchoredHandle: otherHandle, isInTopSnapZone:eitherHandleInTopSnapZone)
        }
        else {
            snapHandlesOpen(eitherHandleInTopSnapZone)
        }
        
        updateDyanmics()
    }
    
    func snapHandlesOpen(isInTopSnapZone:Bool) {
        
        let leftHandle = getLeftHandle()
        let rightHandle = getRightHandle()
        
        // In the top snap zone, we trivially snap the handles open to the edge of the top snap zone
        if isInTopSnapZone {
            leftHandle.constraintsAsPoint = CGPoint(x: handleBounds.left, y: handleBounds.top)
            rightHandle.constraintsAsPoint = CGPoint(x: self.view.frame.width - handleBounds.right, y: handleBounds.top)
        }
        else {
            leftHandle.constraintsAsPoint!.x = handleBounds.left
            rightHandle.constraintsAsPoint!.x = self.view.frame.width - handleBounds.right
            
            leftHandle.constraintsAsPoint = leftHandle.constraintsAsPoint?.confineToSizeWithEdgeInset(self.view.frame.size, insets: handleBounds)
            rightHandle.constraintsAsPoint = rightHandle.constraintsAsPoint?.confineToSizeWithEdgeInset(self.view.frame.size, insets: handleBounds)
            
            handleLeftSnapPoint = leftHandle.constraintsAsPoint
            handleRightSnapPoint = rightHandle.constraintsAsPoint
        }
    }
    
    func snapHandlesClosed(freeHandle:SMGSmudgeHandleViewController, anchoredHandle:SMGSmudgeHandleViewController, isInTopSnapZone:Bool) {
        
        let leftHandle = getLeftHandle()
        let rightHandle = getRightHandle()
        let midPoint = leftHandle.constraintsAsPoint!.interpolate(rightHandle.constraintsAsPoint!, value: 0.5)
        
        // In the top snap zone, we trivially snap both handles to the snap corner point
        if isInTopSnapZone {
            freeHandle.constraintsAsPoint = cornerSnapPoint
            anchoredHandle.constraintsAsPoint = cornerSnapPoint
        }
        else {
            if midPoint.x < (self.view.frame.size.width / 2) {
                preferredEdge = .Left
                leftHandle.constraintsAsPoint!.x = handleBounds.left
                rightHandle.constraintsAsPoint = leftHandle.constraintsAsPoint
                handleLeftSnapPoint = leftHandle.constraintsAsPoint
                handleRightSnapPoint = nil
            } else {
                preferredEdge = .Right
                rightHandle.constraintsAsPoint!.x = self.view.frame.size.width - handleBounds.right
                leftHandle.constraintsAsPoint = rightHandle.constraintsAsPoint
                handleLeftSnapPoint = nil
                handleRightSnapPoint = rightHandle.constraintsAsPoint
            }
            
            leftHandle.constraintsAsPoint = leftHandle.constraintsAsPoint?.confineToSizeWithEdgeInset(self.view.frame.size, insets: handleBounds)
            rightHandle.constraintsAsPoint = rightHandle.constraintsAsPoint?.confineToSizeWithEdgeInset(self.view.frame.size, insets: handleBounds)
        }
    }
}

extension SMGSmudgeHandlesViewController : SMGSmudgeOpenCloseResponder {
    
    func didOpenHandles() {
        
        generateSnapPoints()
        
        handleAViewController.constraintsAsPoint = handleLeftSnapPoint
        handleBViewController.constraintsAsPoint = handleRightSnapPoint
        
        updateAnimatorWithHandles()
    }
    
    func didCloseHandles() {
        
        if handleCloseSnapPoint == nil {handleCloseSnapPoint = cornerSnapPoint}
        
        handleAViewController.constraintsAsPoint = handleCloseSnapPoint
        handleBViewController.constraintsAsPoint = handleCloseSnapPoint
        
        updateAnimatorWithHandles()
    }
    
    func updateAnimatorWithHandles() {
        animator?.updateItemUsingCurrentState(handleAViewController.view)
        animator?.updateItemUsingCurrentState(handleBViewController.view)
        updateDyanmics()
    }
    
    func generateSnapPoints() {
        
        if handleRightSnapPoint == nil && handleLeftSnapPoint == nil {
            handleLeftSnapPoint = CGPoint( x: handleBounds.left, y: handleBounds.top )
        }
        
        if handleRightSnapPoint == nil {
            handleRightSnapPoint = handleLeftSnapPoint
            handleRightSnapPoint?.x = self.view.frame.size.width - handleBounds.right
        }
        
        if handleLeftSnapPoint == nil {
            handleLeftSnapPoint = handleRightSnapPoint
            handleLeftSnapPoint?.x = handleBounds.left
        }
        
        if handleRightSnapPoint!.y < minOpenTopDistance {
            handleRightSnapPoint!.y = minOpenTopDistance
        }
        if handleLeftSnapPoint!.y < minOpenTopDistance {
            handleLeftSnapPoint!.y = minOpenTopDistance
        }
    }
}





