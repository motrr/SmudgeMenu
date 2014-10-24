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
    
    var smudgeView:SMGView?
    var smudgePages:SMGPages = SMGPages()
    var smudgeIcons:SMGIcons = SMGIcons()
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
    
    
    override init() {
        super.init()
        setupMenu()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupMenu()
    }
    
    func setupMenu() {
        
        // Perform all the setup we can before viewDidLoad
        model.currentMenuItemIndex = Observable<Int>(initialValue:0)
        smudgePages.model = self.model
        smudgeIcons.model = self.model
        smudgeHandles.delegate = self
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Create smudge view
        smudgeView = SMGView(colour:UIColor.redColor(), model:self.model)
        smudgeView!.radius = radius
        
        // Setup pages, icons and handles in view
        smudgePages.setupPagesInView(self.view)
        smudgeIcons.setupIconsInView(self.view)
        self.view.addSubview(smudgeView!)
        smudgeHandles.setupHandlesInView(self.view)
        
        // Setup initial page
        smudgePages.setupInitialPage(0)
        
        // Create tap gesture recogniser
        tap = UITapGestureRecognizer(target: self, action: Selector("closeMenu"))
        
        // Inform delegates of update
        if self.smudgeView != nil { smudgeView!.didUpdateCurve() }
        smudgeIcons.didUpdateCurve()

    }
    
    func addItem( menuItem:SMGMenuItem) {
        
        // Add item to array and update index
        menuItem.icon.iconIndex = model.menuItems.count
        model.menuItems.append(menuItem)
        
        // Add view controllers to hierarchy, if any were defined
        if (menuItem.pageViewController != nil) {
            self.addChildViewController(menuItem.pageViewController!)
        }
        if (menuItem.iconViewController != nil) {
            self.addChildViewController(menuItem.iconViewController!)
        }
        
        // Setup icons in view
        smudgeIcons.setupIconsInView(self.view)
        
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

        if self.smudgeView != nil { smudgeView!.didUpdateCurve() }
        smudgeIcons.didUpdateCurve()
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

