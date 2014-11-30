//  Created by Chris Harding on 15/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

protocol SMGMenu {
    func setMainMenuIcon(icon: SMGMainMenuIconModel)
    func addMenuItem(newItem:SMGMenuItemModel)
    func selectMenuItem(itemId:String)
}

class SMGMenuController : NSObject {
    
    let model = SMGModel()
    var menuItemsModel:SMGMenuItemsModel { return model.menuItems }
    var smudgeModel:SMGSmudgeModel { return model.smudgeModel }
    
    var menuItemsController:SMGMenuItemsController!
    var smudgeHandlesController:SMGSmudgeHandlesController!
    var smudgeCurveController:SMGSmudgeCurveController!
    var smudgeTransitionController:SMGSmudgeTransitionController!
    
    init(menuViewController:SMGMenuViewController) {
        super.init()
        
        menuItemsController = SMGMenuItemsController( model: menuItemsModel )
        smudgeCurveController = SMGSmudgeCurveController( model: smudgeModel )
        smudgeHandlesController = SMGSmudgeHandlesController( model: smudgeModel )
        smudgeTransitionController = SMGSmudgeTransitionController( model: smudgeModel )

        loadUI(menuViewController)
    }
    
    func loadUI(menuViewController:SMGMenuViewController) {
        
        let pagesViewController = menuViewController.pagesViewController
        let smudgeMenuViewController = menuViewController.smudgeMenuViewController
        let iconsViewController = smudgeMenuViewController.iconsViewController
        let smudgeDebugViewController = smudgeMenuViewController.smudgeDebugViewController
        let smudgeView = smudgeMenuViewController.smudgeViewController.smudgeView
        let handlesViewController = smudgeMenuViewController.handlesViewController
        
        menuItemsController.addResponder( iconsViewController )
        menuItemsController.addResponder( pagesViewController )
        
        smudgeCurveController.addResponder( smudgeDebugViewController )
        smudgeCurveController.addResponder( smudgeView )
        smudgeCurveController.addResponder( iconsViewController )
        
        handlesViewController.handlesUpdater = smudgeHandlesController
        
        smudgeTransitionController.addResponder( smudgeView )
        smudgeTransitionController.addResponder( iconsViewController )
        smudgeTransitionController.addResponder( pagesViewController )
        
        iconsViewController.currentMenuItemUpdater = menuItemsController
        
    }
}

extension SMGMenuController : SMGMenu {
    
    func setMainMenuIcon(icon: SMGMainMenuIconModel) {
        menuItemsModel.mainMenuIcon = icon
    }
    
    func addMenuItem(newItem:SMGMenuItemModel) {
        
        let itemId = newItem.itemId
        menuItemsModel.itemsDictionary[itemId] = newItem
        menuItemsModel.newestItemId = itemId
        if (menuItemsModel.itemsDictionary.count == 1) {
            menuItemsModel.currentItemId = itemId
        }
    }
    
    func selectMenuItem(itemId:String) {
        menuItemsModel.currentItemId = itemId
    }
}