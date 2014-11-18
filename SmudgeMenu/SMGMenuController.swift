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
    var smudgeController:SMGSmudgeController!
    
    override init() {
        super.init()
        
        menuItemsController = SMGMenuItemsController(menuItemsModel: menuItemsModel)
        smudgeController = SMGSmudgeController(smudgeModel: smudgeModel)
        
        menuItemsController.smudgeController = smudgeController
    }
    
    func addObserversFrom(menuViewController:SMGMenuViewController) {
        
        menuItemsController.addMenuItemsObserversFrom( menuViewController.pagesViewController )
        smudgeController.addSmudgeObserversFrom( menuViewController.smudgeMenuViewController )
        
    }
}