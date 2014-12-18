//  Created by Chris Harding on 17/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGSmudgeHandleViewController : SMGXYConstraintViewController {
    
    var handleView:SMGSmudgeHandleView {
        return self.view as SMGSmudgeHandleView
    }
    
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
    func handleDidMove(handle:SMGSmudgeHandleViewController, newPosition:CGPoint)
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
            delegate?.handleDidMove(self, newPosition: newPosition)
        }
    }

    func viewDidFinishDragging() {
        initDragPosition = nil
        delegate?.handleDidFinishMoving(self)
    }
}