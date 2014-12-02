//  Created by Chris Harding on 18/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var menu = SMGMenuViewController()
        self.addFullscreenChildViewController(menu)
        
        for sharedId in ["PageA","PageB","PageC","PageD"] {
            var page = SMGPageModel(storyboardId:"Pages", viewControllerId:sharedId )
            var icon = SMGIconModel(storyboardId:"Icons", viewControllerId:sharedId )
            icon.titleText = "Sample Text"
            var item = SMGMenuItemModel(itemId: sharedId, pageModel:page, iconModel: icon)
            menu.addMenuItem( item )
        }
        
        var mainMenuIconModel = SMGMainMenuIconModel(storyboardId:"Icons", viewControllerId:"MainMenu")
        menu.setMainMenuIconFromModel( mainMenuIconModel )
    }
}