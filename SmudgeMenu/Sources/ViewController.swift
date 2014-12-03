//  Created by Chris Harding on 18/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var menu = SMGMenuViewController()
        self.addFullscreenChildViewControllerHelper(menu)
        
        for sharedId in ["PageA","PageB","PageC","PageD"] {
            var page = instantiateViewController("Pages", viewControllerId:sharedId )
            var icon = instantiateViewController("Icons", viewControllerId:sharedId )
            var titleText = "Sample Text"
            var iconFont = UIFont.systemFontOfSize(UIFont.systemFontSize())
            menu.addMenuItem(sharedId, iconTitle: titleText, iconFont: iconFont, icon: icon, page: page)
        }
        
        var menuButtonViewController = instantiateViewController("Icons", viewControllerId:"MainMenu" )
        //var backButtonViewController = instantiateViewController("Icons", viewControllerId:"" )
        //menu.setMenuButtonIcon(menuButtonViewController.view)
        
    }
    
    func instantiateViewController(storyboardId:String, viewControllerId:String) -> UIViewController {
        var storyboard = UIStoryboard(name:storyboardId , bundle: NSBundle.mainBundle())
        var viewController = storyboard.instantiateViewControllerWithIdentifier(viewControllerId) as UIViewController
        return viewController
    }
}