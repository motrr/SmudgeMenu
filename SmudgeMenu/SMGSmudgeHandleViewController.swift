//  Created by Chris Harding on 17/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGSmudgeHandleViewController : SMGXYConstraintViewController {
    
    var handleView:SMGSmudgeHandleView {
        return self.view as SMGSmudgeHandleView
    }
    
    var edgeInsets = UIEdgeInsetsZero
    
    var delegate:SMGSmudgeHandleViewControllerDelegate?
    
    private var initDragPosition:CGPoint!

    override func loadView() {
        self.view = SMGSmudgeHandleView()
        handleView.delegate = self
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        coordinator.animateAlongsideTransition({context in
            self.viewDidFinishDragging()
            }, completion: nil)
    }
}

protocol SMGSmudgeHandleViewControllerDelegate {
    func handleDidMove(handle:SMGSmudgeHandleViewController)
    func handleDidFinishMoving(handle:SMGSmudgeHandleViewController)
}

extension SMGSmudgeHandleViewController : SMGDraggableViewDelegate {
    
    func viewDidStartDragging() {
        if xConstraint != nil && yConstraint != nil {
            initDragPosition = CGPoint(
                    x: xConstraint!.constant,
                    y: yConstraint!.constant)
        }
    }
 
    func viewWasDragged(translation:CGPoint) {
        if initDragPosition != nil {
            
            let newPosition = initDragPosition + translation
            let adjustedNewPosition =
                newPosition.confineToSizeWithEdgeInset(self.view.superview!.frame.size, insets: edgeInsets)
            
            xConstraint!.constant = adjustedNewPosition.x
            yConstraint!.constant = adjustedNewPosition.y

            delegate?.handleDidMove(self)
        }
    }

    func viewDidFinishDragging() {
        
        initDragPosition = nil
        
        var position = CGPoint(x: xConstraint!.constant, y: yConstraint!.constant)
        let superviewWidth = self.view.superview!.frame.size.width
        
        if position.x > superviewWidth / 2.0 {
            position.x = superviewWidth - edgeInsets.right
        }
        else {
            position.x = edgeInsets.left
        }
        
        let adjustedNewPosition =
            position.confineToSizeWithEdgeInset(self.view.superview!.frame.size, insets: edgeInsets)
        xConstraint!.constant = adjustedNewPosition.x
        yConstraint!.constant = adjustedNewPosition.y
        
        delegate?.handleDidFinishMoving(self)
    }
}