//  Created by Chris Harding on 20/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

protocol SmudgeHandlesDelegate {
    
    func handlesDidStartDragging() -> Void
    func handlesDidMove() -> Void
    func handlesDidFinishDragging() -> Void
    
}

class SmudgeHandles : NSObject, SmudgeHandleViewDelegate {
    
    var delegate:SmudgeHandlesDelegate?
    
    var startHandle:SmudgeHandleView = SmudgeHandleView(colour: UIColor.redColor())
    var endHandle:SmudgeHandleView = SmudgeHandleView(colour: UIColor.redColor())
    
    var startHandleHelper:CircleView = CircleView(colour: UIColor.blueColor())
    var endHandleHelper:CircleView = CircleView(colour: UIColor.yellowColor())
    
    var startPoint:CGPoint {
        get {
            return startHandleHelper.centre
        }
    }
    var endPoint:CGPoint {
        get {
            return endHandleHelper.centre
        }
    }
    
    var margin:CGFloat = 50
    let radius:CGFloat = 100
    var diameter:CGFloat {
        get {return 2*radius}
    }
    
    let vhSepRatio:CGFloat = 0.5
    
    private var animator:UIDynamicAnimator!
    private var dynamicProperties:UIDynamicItemBehavior!
    
    private var startPointAttachment:UIAttachmentBehavior!
    private var endPointAttachment:UIAttachmentBehavior!
    
    override init() {
        super.init()
        
        endHandle.draggable = true
        endHandle.delegate = self
        
        startHandle.draggable = false
        startHandle.delegate = nil
        
        for handle in [startHandle, endHandle] {
            handle.radius = self.radius
        }
        
        for handle in [startHandleHelper, endHandleHelper] {
            handle.radius = 20.0
        }
    }
    
    func setupHandlesInView(aView:UIView) {
        
        // Add subview to superview
        for view in [startHandle, startHandleHelper, endHandle, endHandleHelper] {
            aView.addSubview(view)
        }
        
        // Initially place handles centrally aligned on the left hand edge of the view
        for view in [startHandle, endHandle] {
            view.centre = aView.centre
            view.centre.x = margin
            view.alpha = 0.2
        }
        
        // Place helper views
        startHandleHelper.centre = startHandle.centre
        endHandleHelper.centre = endHandle.centre
        
        // Hide helper views
        for view in [startHandleHelper, endHandleHelper] {
            view.hidden = true
        }
        
        // Start dragging behavour
        setDynamicBehaviorsForSmudgeOpening()
    }

    func setDynamicBehaviorsForSmudgeOpening() {
        
        // Initialise animator
        if (animator == nil) {animator = UIDynamicAnimator(referenceView: startHandle.superview!)}
        animator.removeAllBehaviors()
        
        // Add resistance
        dynamicProperties = UIDynamicItemBehavior(items: [startHandleHelper, endHandleHelper])
        dynamicProperties.resistance = 100.0
        dynamicProperties.allowsRotation = false
        animator.addBehavior(dynamicProperties)

        startPointAttachment = UIAttachmentBehavior(item: startHandleHelper, attachedToAnchor: startHandle.centre)
        startPointAttachment.frequency = 200.0
        startPointAttachment.damping = 50.0
        startPointAttachment.action = {
            if (self.delegate != nil) { self.delegate?.handlesDidMove() }
        }
        animator.addBehavior(startPointAttachment)
        
        endPointAttachment = UIAttachmentBehavior(item: endHandleHelper, attachedToAnchor: endHandle.centre)
        endPointAttachment.frequency = 200.0
        endPointAttachment.damping = 50.0
        endPointAttachment.action = {
            if (self.delegate != nil) { self.delegate?.handlesDidMove() }
        }
        animator.addBehavior(endPointAttachment)

    }
}

extension SmudgeHandles {
    
    
    func viewDidStartDragging() {
        if (self.delegate != nil) { self.delegate?.handlesDidStartDragging() }
    }
    
    func viewWasDragged() {
        
        // Ensure we don't pan past the left margin since this is awkward
        if endHandle.centre.x < margin { endHandle.centre.x = margin }
        
        // Ensure vertical seperation does not exceed horizontal
        var hSep:CGFloat = self.endHandle.centre.x - self.startHandle.centre.x
        var vSep:CGFloat = self.endHandle.centre.y - self.startHandle.centre.y
        if vSep > vhSepRatio * fabs(hSep)
            { self.startHandle.centre.y = self.endHandle.centre.y - vhSepRatio * fabs(hSep) }
        else if vSep < -vhSepRatio * fabs(hSep)
            { self.startHandle.centre.y = self.endHandle.centre.y + vhSepRatio * fabs(hSep) }

        self.updateDyanmics()
    }
    
    func viewDidFinishDragging() {
        
        if endHandle.centre.x > endHandle.superview?.centre.x {
            if (endHandle.centre.x < endHandle.superview!.width - margin)
                { endHandle.centre.x = endHandle.superview!.width - margin }
        }
        else {
            endHandle.centre = startHandle.centre
        }
        
        self.updateDyanmics()
        
        if (self.delegate != nil) { self.delegate?.handlesDidFinishDragging() }
    }
    
    func updateDyanmics() {
        
        // Update UIKit Dynamics
        startPointAttachment.anchorPoint = startHandle.centre
        startPointAttachment.length = 0
        endPointAttachment.anchorPoint = endHandle.centre
        endPointAttachment.length = 0
        animator.updateItemUsingCurrentState(endHandle)
    }
}
