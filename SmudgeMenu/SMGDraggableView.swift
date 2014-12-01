//  Created by Chris Harding on 18/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

protocol SMGDraggableViewDelegate {

    func viewDidStartDragging() -> Void
    func viewWasDragged(translation:CGPoint)
    func viewDidFinishDragging() -> Void
}

class SMGDraggableView : UIView {
 
    var delegate:SMGDraggableViewDelegate?
    var draggable:Bool = true
    
    private var panRecognizer:UIPanGestureRecognizer!
    
    override init() {
        super.init()
        setupPanRecogniser()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPanRecogniser()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPanRecogniser()
    }
    
    func setupPanRecogniser() {
        panRecognizer = UIPanGestureRecognizer(target:self, action:"didPan:")
        self.addGestureRecognizer(panRecognizer)
    }
    
    func didPan(pg:UIPanGestureRecognizer) {
        
        if (draggable) {
            if pg.state == UIGestureRecognizerState.Began {
                if delegate != nil {
                    delegate!.viewDidStartDragging()
                }
            }
            if ((pg.state == UIGestureRecognizerState.Began || pg.state == UIGestureRecognizerState.Changed)
                && (pg.numberOfTouches() == 1)) {
                    
                    var translation = pg.translationInView(self)
                    if delegate != nil {
                        delegate!.viewWasDragged(translation)
                    }
                    
            }
            else if (pg.state == UIGestureRecognizerState.Ended || pg.state == UIGestureRecognizerState.Cancelled) {
                
                if delegate != nil {
                    delegate!.viewDidFinishDragging()
                }
            }
        }
    }
    
}
