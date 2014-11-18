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
    
    private var initDragPosition:CGPoint!

    override func loadView() {
        self.view = SMGSmudgeHandleView()
        handleView.strokeWidth = 0
        handleView.delegate = self
    }
}

extension SMGSmudgeHandleViewController : SMGSmudgeObserver {
    func didUpdateStartEndPoints( startPont:CGPoint, endPoint:CGPoint ) {
        
    }
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
            xConstraint!.constant = initDragPosition.x + translation.x
            yConstraint!.constant = initDragPosition.y + translation.y
        }
    }

    func viewDidFinishDragging() {
        initDragPosition = nil
    }
}

class SMGSmudgeHandleView : SMGDraggableCircleView {
    
    func setupSmudgeHandleView() {
        strokeWidth = 0.0
    }
    
    override init() {
        super.init()
        setupSmudgeHandleView()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSmudgeHandleView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSmudgeHandleView()
    }
}