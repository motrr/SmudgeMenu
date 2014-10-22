//  Created by Chris Harding on 18/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGMenu: UIViewController, SMGHandlesDelegate {
    
    var model = SMGModel()
    
    var radius:CGFloat = 50.0
    var diameter:CGFloat {
        get {return 2*radius}
    }
    var margin:CGFloat = 10
    
    var smudgeView:SMGView!
    var smudgeIcons:SMGIcons!
    var smudgeHandles:SMGHandles = SMGHandles()

    var tap:UIGestureRecognizer!
    var tapView:UIView = UIView()
    var tapBlockView:UIView = UIView()
    
    var minX:CGFloat {
        get { return (margin+radius) }
    }
    var maxX:CGFloat {
        get { return self.view.width - (margin+radius) }
    }
    var progress:CGFloat {
        get { return (model.endPoint.x - self.minX) / (self.maxX - self.minX) }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Create smudge view
        smudgeView = SMGView(colour:UIColor.orangeColor(), model:self.model)
        smudgeView.radius = radius
        self.view.addSubview(smudgeView)
        
        // Create smudge icon
        smudgeIcons = SMGIcons(model: model)
        smudgeIcons.setupIconsInView(self.view)
        
        // Add smudge handles to the view
        smudgeHandles.delegate = self
        smudgeHandles.setupHandlesInView(self.view)
        
        // Create tap gesture recogniser
        tap = UITapGestureRecognizer(target: self, action: Selector("closeMenu"))
        
        // Inform smudge view of update
        smudgeView.smudgeModelDidUpdate()

    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        coordinator.animateAlongsideTransition({context in
            
            // Ensure the menu is updated for the new size
            
            }, completion: nil)
    }

}

extension SMGMenu {
    
    func handlesDidStartDragging() {
    
    }
    
    func handlesDidMove() {
        
        model.startPoint = startPointFromHandleStartPoint(smudgeHandles.startPoint)
        model.endPoint = endPointFromHandleEndPoint(smudgeHandles.endPoint)
        model.progress = progress

        smudgeView.smudgeModelDidUpdate()
        smudgeIcons.smudgeModelDidUpdate()
    }
    
    func startPointFromHandleStartPoint(handleStartPoint:CGPoint) -> CGPoint {
        return CGPoint(x: minX, y: handleStartPoint.y)
    }

    func endPointFromHandleEndPoint(handleEndPoint:CGPoint) -> CGPoint {
        var endPointX = handleEndPoint.x
        if endPointX < self.minX {endPointX = self.minX}
        if endPointX > self.maxX {endPointX = self.maxX}
        return CGPoint(x: endPointX, y: handleEndPoint.y)
    }
    
    func handlesDidFinishDragging() {

    }
}

