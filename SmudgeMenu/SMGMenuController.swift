//  Created by Chris Harding on 15/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

protocol SMGMenu {
    
    func addMenuItem(itemId: String, iconTitle: String, iconFont: UIFont, icon: UIViewController, page: UIViewController)
    func selectMenuItem(itemId:String)
    
    func setMenuButtonIcon(iconImage: UIImage)
    func setBackButtonIcon(iconImage: UIImage)
    
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
    var smudgeIconsViewController:SMGSmudgeIconsViewController
        {return smudgeMenuViewController.smudgeIconsViewController}
    var mainIconViewController:SMGMainIconViewController
        {return smudgeMenuViewController.mainIconViewController}
    var smudgeDebugViewController:SMGSmudgeDebugViewController
        {return smudgeMenuViewController.smudgeDebugViewController}
    var smudgeView:SMGSmudgeView
        {return smudgeMenuViewController.smudgeViewController.smudgeView}
    var handlesViewController:SMGSmudgeHandlesViewController
        {return smudgeMenuViewController.handlesViewController}

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

        // Menu Items
        menuItemsController.addResponder( smudgeIconsViewController )
        menuItemsController.addResponder( pagesViewController )
        smudgeIconsViewController.currentMenuItemUpdater = menuItemsController
        
        // Curve for Smudge Menu
        smudgeCurveController.addResponder( smudgeDebugViewController )
        smudgeCurveController.addResponder( smudgeView )
        smudgeCurveController.addResponder( smudgeIconsViewController )
        smudgeCurveController.addResponder( mainIconViewController )
        handlesViewController.handlesUpdater = smudgeHandlesController
        
        // Handles for Smudge Menu
        smudgeHandlesController.addResponder( handlesViewController )
        smudgeIconsViewController.openCloseUpdater = smudgeHandlesController
        mainIconViewController.openCloseUpdater = smudgeHandlesController

        // Open/close transition for Smudge Menu
        smudgeTransitionController.addResponder( smudgeView )
        smudgeTransitionController.addResponder( smudgeIconsViewController )
        smudgeTransitionController.addResponder( pagesViewController )
        smudgeTransitionController.addResponder( mainIconViewController )
        
        // Back button icon stack for Smudge Menu
        backButtonController.addResponder( mainIconViewController )
        mainIconViewController.backButtonUpdater = backButtonController
    }
}

extension SMGMenuController : SMGMenu {
    
    func addMenuItem(itemId: String, iconTitle: String, iconFont: UIFont, icon: UIViewController, page: UIViewController) {
        
        menuItemsController.createMenuItem(itemId, iconTitle: iconTitle, iconFont: iconFont, icon: icon, page: page)
        
        if (menuItemsModel.currentItemId == nil) {
            menuItemsModel.currentItemId = itemId
        }
    }
    
    func selectMenuItem(itemId:String) {
        menuItemsModel.currentItemId = itemId
    }
    
    
    
    func setMenuButtonIcon(iconImage: UIImage) {
        mainIconViewController.didSetMenuButtonIcon(iconImage)
    }
    
    func setBackButtonIcon(iconImage: UIImage) {
        mainIconViewController.didSetBackButtonIcon(iconImage)
    }
    
    
    
    func pushBackButton( backButtonBlock:SMGBackButtonBlock ) {
        backButtonController.pushBackButton(backButtonBlock)
    }
    
    func popBackButton() {
        backButtonController.popBackButton(false)
    }
}