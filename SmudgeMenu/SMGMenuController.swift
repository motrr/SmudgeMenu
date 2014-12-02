//  Created by Chris Harding on 15/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

protocol SMGMenu {
    
    func setMainMenuIconFromModel(iconModel: SMGMainMenuIconModel)
    func setMainMenuIcon(icon: UIViewController)
    
    func addMenuItem(newItem:SMGMenuItemModel)
    func addMenuItem(itemId: String, iconTitle: String, iconFont: UIFont, icon: UIViewController, page: UIViewController)
    
    func selectMenuItem(itemId:String)
    
    func pushBackButton( backButtonBlock:SMGBackButtonBlock )
    func popBackButton()
}

class SMGMenuController : NSObject {
    
    let model = SMGModel()
    var menuItemsModel:SMGMenuItemsModel { return model.menuItems }
    var smudgeModel:SMGSmudgeModel { return model.smudgeModel }
    
    var menuItemsController:SMGMenuItemsController!
    var smudgeHandlesController:SMGSmudgeHandlesController!
    var smudgeCurveController:SMGSmudgeCurveController!
    var smudgeTransitionController:SMGSmudgeTransitionController!
    var backButtonController:SMGBackButtonController!
    
    var menuViewController:SMGMenuViewController!
    
    var pagesViewController:SMGPagesViewController
        {return menuViewController.pagesViewController}
    var smudgeMenuViewController:SMGSmudgeMenuViewController
        {return menuViewController.smudgeMenuViewController}
    var iconsViewController:SMGSmudgeIconsViewController
        {return smudgeMenuViewController.iconsViewController}
    var smudgeDebugViewController:SMGSmudgeDebugViewController
        {return smudgeMenuViewController.smudgeDebugViewController}
    var smudgeView:SMGSmudgeView
        {return smudgeMenuViewController.smudgeViewController.smudgeView}
    var handlesViewController:SMGSmudgeHandlesViewController
        {return smudgeMenuViewController.handlesViewController}
    var mainMenuIconContainer:SMGMainMenuIconContainerViewController
        {return iconsViewController.mainMenuIconContainer!}

    init(menuViewController:SMGMenuViewController) {
        super.init()
        
        menuItemsController = SMGMenuItemsController( model: menuItemsModel )
        smudgeCurveController = SMGSmudgeCurveController( model: smudgeModel )
        smudgeHandlesController = SMGSmudgeHandlesController( model: smudgeModel )
        smudgeTransitionController = SMGSmudgeTransitionController( model: smudgeModel )
        backButtonController = SMGBackButtonController( model:menuItemsModel )

        loadUI(menuViewController)
    }
    
    func loadUI(menuViewController:SMGMenuViewController) {
        
        self.menuViewController = menuViewController

        menuItemsController.addResponder( iconsViewController )
        menuItemsController.addResponder( pagesViewController )
        iconsViewController.currentMenuItemUpdater = menuItemsController
        
        smudgeCurveController.addResponder( smudgeDebugViewController )
        smudgeCurveController.addResponder( smudgeView )
        smudgeCurveController.addResponder( iconsViewController )
        handlesViewController.handlesUpdater = smudgeHandlesController
        
        smudgeHandlesController.addResponder( handlesViewController )
        iconsViewController.openCloseUpdater = smudgeHandlesController

        smudgeTransitionController.addResponder( smudgeView )
        smudgeTransitionController.addResponder( iconsViewController )
        smudgeTransitionController.addResponder( pagesViewController )
    }
}

extension SMGMenuController : SMGMenu {
    
    func setMainMenuIconFromModel(iconModel: SMGMainMenuIconModel) {
        menuItemsController.createMainMenuIconFromModel(iconModel)

        backButtonController.addResponder( mainMenuIconContainer )
    }
    
    func setMainMenuIcon(icon: UIViewController) {
        menuItemsController.createMainMenuIcon(icon)
        
        backButtonController.addResponder( mainMenuIconContainer )
    }
    
    func addMenuItem(newItem:SMGMenuItemModel) {
        
        menuItemsController.createMenuItem(newItem.itemId, newItemModel: newItem)
        
        if (menuItemsModel.currentItemId == nil) {
            menuItemsModel.currentItemId = newItem.itemId
        }
    }
    
    func addMenuItem(itemId: String, iconTitle: String, iconFont: UIFont, icon: UIViewController, page: UIViewController) {
        
        menuItemsController.createMenuItem(itemId, iconTitle: iconTitle, iconFont: iconFont, icon: icon, page: page)
        
        if (menuItemsModel.currentItemId == nil) {
            menuItemsModel.currentItemId = itemId
        }
    }
    
    func selectMenuItem(itemId:String) {
        menuItemsModel.currentItemId = itemId
    }
    
    func pushBackButton( backButtonBlock:SMGBackButtonBlock ) {
        backButtonController.pushBackButton(backButtonBlock)
    }
    
    func popBackButton() {
        backButtonController.popBackButton()
    }
}