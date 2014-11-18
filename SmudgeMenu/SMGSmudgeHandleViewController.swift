//  Created by Chris Harding on 17/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGSmudgeHandleViewController : UIViewController {
    
    var handleView:SMGSmudgeHandleView {
        return self.view as SMGSmudgeHandleView
    }
    
    var xConstraint:NSLayoutConstraint?
    var yConstraint:NSLayoutConstraint?
    var edgeInsets = UIEdgeInsetsZero
    
    var delegate:SMGSmudgeHandleViewControllerDelegate?
    
    private var initDragPosition:CGPoint!

    override func loadView() {
        self.view = SMGSmudgeHandleView()
        handleView.delegate = self
    }
}

extension SMGSmudgeHandleViewController : SMGSmudgeObserver {
    func didUpdateStartEndPoints( startPont:CGPoint, endPoint:CGPoint ) {
        
    }
}

protocol SMGSmudgeHandleViewControllerDelegate {
    func handleDidMove(handle:SMGSmudgeHandleViewController)
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
            
            if delegate != nil { delegate!.handleDidMove(self) }
        }
    }

    func viewDidFinishDragging() {
        initDragPosition = nil
        
        let superviewWidth = self.view.superview!.frame.size.width
        if xConstraint!.constant > superviewWidth / 2.0 {
            xConstraint!.constant = superviewWidth - edgeInsets.right
        }
        else {
            xConstraint!.constant = edgeInsets.left
        }
        
        if delegate != nil { delegate!.handleDidMove(self) }
    }
}

class SMGSmudgeHandleView : SMGDraggableCircleView {
    
    func setupSmudgeHandleView() {
        strokeWidth = 0.0
    }
    
    override init() {super.init();setupSmudgeHandleView()}
    required init(coder aDecoder: NSCoder) {super.init(coder: aDecoder);setupSmudgeHandleView()}
    override init(frame: CGRect) {super.init(frame: frame);setupSmudgeHandleView()}
}