//  Created by Chris Harding on 16/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

@objc protocol SMGMenuItemsObserver {
    
    optional func didUpdateCurrentItem( itemId:String )
    optional func didUpdateItems( itemsDictionary:Dictionary<String, SMGMenuItemModel> )
}

class SMGMenuItemsController : NSObject {
    
    var smudgeController:SMGSmudgeController?
    
    var menuItemsModel:SMGMenuItemsModel
    init(menuItemsModel:SMGMenuItemsModel) {
        self.menuItemsModel = menuItemsModel
        super.init()
    }
    
    func addMenuItemsObserversFrom(pagesViewController:SMGPagesViewController) {
        
    }
    
    func addMenuItemsObserversFrom(smudgeMenuViewController:SMGSmudgeMenuViewController) {
        
        addMenuItemsObserver( smudgeMenuViewController )
        
        for (iconId, iconViewController) in smudgeMenuViewController.iconViewControllers {
            addMenuItemsObserver( iconViewController )
        }
    }
    
    func addMenuItemsObserver( observer:SMGMenuItemsObserver ) {
        
    }
}

// TODO - observe and react to changes in menu items model, forward notifications to registered observers