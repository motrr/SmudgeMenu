//  Created by Chris Harding on 15/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

protocol SMGMenu {
    func setMainMenuIcon(icon: SMGMainMenuIconModel)
    func addMenuItem(newItem:SMGMenuItemModel)
    func selectMenuItem(itemId:String)
}

extension SMGMenuController : SMGMenu {
    
    func setMainMenuIcon(icon: SMGMainMenuIconModel) {
        smudgeModel.mainMenuIcon = icon
    }
    
    func addMenuItem(newItem:SMGMenuItemModel) {
        menuItemsModel.itemsDictionary[newItem.itemId] = newItem
    }
    
    func selectMenuItem(itemId:String) {
        menuItemsModel.currentItemId = itemId
    }
}

class SMGMenuController : NSObject {
    
    let model = SMGModel()
    var menuItemsModel:SMGMenuItemsModel { return model.menuItems }
    var smudgeModel:SMGSmudgeModel { return model.smudgeModel }
    
    var menuItemsController:SMGMenuItemsController!
    var smudgeHandlesController:SMGSmudgeHandlesController!
    var smudgeCurveController:SMGSmudgeCurveController!
    
    init(menuViewController:SMGMenuViewController) {
        super.init()
        
        menuItemsController = SMGMenuItemsController(menuItemsModel: menuItemsModel)
        smudgeCurveController = SMGSmudgeCurveController(smudgeModel: smudgeModel)
        smudgeHandlesController = SMGSmudgeHandlesController(smudgeModel: smudgeModel)

        loadUI(menuViewController)
    }
    
    func loadUI(menuViewController:SMGMenuViewController) {
        
        menuItemsController.loadUI( menuViewController.pagesViewController )
        smudgeHandlesController.loadUI( menuViewController.smudgeMenuViewController.handlesViewController )
        smudgeCurveController.loadUI( menuViewController.smudgeMenuViewController.smudgeDebugViewController )
    }
}