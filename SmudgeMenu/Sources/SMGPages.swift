//  Created by Chris Harding on 22/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGPages : NSObject {
    
    var model:SMGModel? {
        didSet {
            
            // Add observer for current index property
            var didSet: Observable<Int>.DidSet = {
                (oldValue:Int?,currentValue:Int?) -> () in
                if currentValue != nil {
                    self.switchToPage(currentValue!, oldPageIndex: oldValue)
                }
            }
            var observer: Observable<Int>.Observer = ({_ in}, didSet)
            model!.currentMenuItemIndex?.addObserver("SMGPagesObserver", observer: observer)
            
        }
    }
    var pagesSuperview:UIView?
    
    func setupPagesInView(aView:UIView) {
        pagesSuperview = aView
    }
    
    func setupInitialPage(pageIndex:Int) {
        
        if (model != nil && pagesSuperview != nil) {
            self.setPageAsCurrent( pageIndex )
        }
    }
    
    func switchToPage(newPageIndex:Int, oldPageIndex:Int?) {
        
        if model != nil {
            if (oldPageIndex != nil) {
                if pagesSuperview != nil {
                    
                    removePageAsCurrent( oldPageIndex! )
                    setPageAsCurrent( newPageIndex )
                }
            }
            else { self.setupInitialPage(newPageIndex) }
        }
    }
    
    func setPageAsCurrent(pageIndex:Int) {
        
        var menuItem = model!.menuItems[pageIndex]
        var pageView = menuItem.page.pageView as UIView
        pageView.size = pagesSuperview!.size
        pagesSuperview!.insertSubview(pageView, atIndex: 0)
    }
    
    func removePageAsCurrent(pageIndex:Int) {
        
        var previousMenuItem = model!.menuItems[pageIndex]
        var previousPageView = previousMenuItem.page.pageView as UIView
        previousPageView.removeFromSuperview()
    }
    
}

class SMGPage : NSObject {
    
    var pageView:UIView
    
    init(pageView:UIView) {
        
        self.pageView = pageView
        super.init()
    }
}