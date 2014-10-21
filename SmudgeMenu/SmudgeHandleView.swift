//  Created by Chris Harding on 18/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

protocol SmudgeHandleViewDelegate {
    
    func viewDidStartDragging() -> Void
    func viewWasDragged() -> Void
    func viewDidFinishDragging() -> Void
    
}

class SmudgeHandleView : CircleView {
    
    var delegate:SmudgeHandleViewDelegate?
    var draggable:Bool = true
    
    private var panRecognizer:UIPanGestureRecognizer?
    
    override init(colour: UIColor) {
        super.init(colour: colour)
        
        // Initialization code
        var panRecognizer = UIPanGestureRecognizer(target:self, action:"didPan:")
        self.gestureRecognizers = [panRecognizer]
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func didPan(pg:UIPanGestureRecognizer) {
        
        if (draggable) {
            if ((pg.state == UIGestureRecognizerState.Began || pg.state == UIGestureRecognizerState.Changed)
                && (pg.numberOfTouches() == 1)) {
                    
                    var panLocation = pg.locationInView(superview)
                    var panTranslation = pg.translationInView(self)
                    
                    if (pg.state == UIGestureRecognizerState.Began) {
                        if delegate != nil {
                            delegate!.viewDidStartDragging()
                        }
                    }
                    
                    // Move view, subtracting inital location to account for finger offset
                    self.centre.x = panLocation.x
                    self.centre.y = panLocation.y
                    
                    if delegate != nil {
                        delegate!.viewWasDragged()
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
