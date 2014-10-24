//  Created by Chris Harding on 22/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKIt

class SMGMenuItem : NSObject {
    
    var iconViewController:UIViewController?
    var pageViewController:UIViewController?
    
    let icon:SMGIcon
    let page:SMGPage
    
    convenience init(
        iconStoryboardId:String,
        pageStoryboardId:String,
        itemId:String) {
            
            var iconsStoryboard = UIStoryboard(name: iconStoryboardId, bundle: NSBundle.mainBundle())
            var pagesStoryboard = UIStoryboard(name: pageStoryboardId, bundle: NSBundle.mainBundle())
            var iconViewController:UIViewController = iconsStoryboard.instantiateViewControllerWithIdentifier(itemId) as UIViewController
            var pageViewController:UIViewController = pagesStoryboard.instantiateViewControllerWithIdentifier(itemId) as UIViewController
            
            self.init(
                iconViewController: iconViewController,
                pageViewController: pageViewController)
    }
    
    convenience init(
        iconView:UIView,
        pageView:UIView) {
            
            self.init(
                iconView: iconView,
                pageView: pageView,
                iconViewController: nil,
                pageViewController: nil)
    }
    
    convenience init(
        iconViewController:UIViewController,
        pageViewController:UIViewController) {
            
            self.init(
                iconView: iconViewController.view,
                pageView: pageViewController.view,
                iconViewController: iconViewController,
                pageViewController: pageViewController)
    }
    
    init(iconView:UIView,
        pageView:UIView,
        iconViewController:UIViewController?,
        pageViewController:UIViewController?) {
            
            self.icon = SMGIcon(iconView: iconView)
            self.page = SMGPage(pageView: pageView)
            
            self.iconViewController = iconViewController
            self.pageViewController = pageViewController
            
            super.init()
    }
    
}
