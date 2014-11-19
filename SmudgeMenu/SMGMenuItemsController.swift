//  Created by Chris Harding on 16/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGMenuItemsController : NSObject {
    
    var menuItemsModel:SMGMenuItemsModel
    init(menuItemsModel:SMGMenuItemsModel) {
        self.menuItemsModel = menuItemsModel
        super.init()
    }
    
    func loadUI(pagesViewController:SMGPagesViewController) {
        
    }
    
    func loadUI(smudgeMenuViewController:SMGSmudgeMenuViewController) {
        
    }
}

// TODO - observe and react to changes in menu items model, forward notifications to registered observers