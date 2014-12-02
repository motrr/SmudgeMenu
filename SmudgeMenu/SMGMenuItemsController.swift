//  Created by Chris Harding on 17/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

/*
    Observes and reacts to changes in menu items model, forwards notifications to UI layer.
*/

class SMGMenuItemsController : SMGModelObserveNotifyController {
    
    var menuItemsModel:SMGMenuItemsModel {return model as SMGMenuItemsModel}
    
    override func keyPaths() -> [String] {
        return ["currentItemId"]
    }
    
    override func initialiseResponder(responder: SMGResponder) {
        // Nothing to initialise now, wait until first item is added
    }
    
    override func notifyResponder(responder: SMGResponder, keyPath:String) {
        
        let menuItemsResponder = responder as SMGMenuItemsResponder

        switch keyPath {
        case "currentItemId" :
            if menuItemsModel.currentItemId != nil {
                menuItemsResponder.didUpdateCurrentMenuItem?(menuItemsModel.currentItemId!)
            }
            
        default : ()
        }
    }
}

extension SMGMenuItemsController {
    
    func createMainMenuIconFromModel(iconModel:SMGMainMenuIconModel) {
        let icon:UIViewController = generateMainMenuIconViewController(iconModel)
        createMainMenuIcon(icon)
    }
    
    func createMainMenuIcon(icon:UIViewController) {
        for responder in responders {
            let menuItemsResponder = responder as SMGMenuItemsResponder
            menuItemsResponder.didSetMainMenuIcon?(icon)
        }
    }
    
    func createMenuItem(itemId:String, iconTitle:String, iconFont:UIFont, icon:UIViewController, page:UIViewController) {

        for responder in responders {
            
            let menuItemsResponder = responder as SMGMenuItemsResponder
            menuItemsResponder.didAddMenuIcon?(itemId, iconTitle:iconTitle, iconFont:iconFont, menuIcon: icon)
            menuItemsResponder.didAddMenuPage?(itemId, menuPage: page)
        }
    }
    
    func createMenuItem(newItemId:String, newItemModel:SMGMenuItemModel) {
    
        var newItemTitleText = newItemModel.iconModel.titleText
        var newItemTitleFont = newItemModel.iconModel.titleFont
        var newItemIconViewController = generateIconViewController(newItemModel)
        var newItemPageViewController = generatePageViewController(newItemModel)
        
        createMenuItem(newItemId, iconTitle:newItemTitleText, iconFont: newItemTitleFont, icon: newItemIconViewController, page: newItemPageViewController)
    }
    
    func generateIconViewController(menuItemModel:SMGMenuItemModel) -> UIViewController {
        
        var storyboardId = menuItemModel.iconModel.storyboardId
        var iconId = menuItemModel.iconModel.viewControllerId
        return generateViewController(storyboardId, viewControllerId: iconId)
    }
    
    func generatePageViewController(menuItemModel:SMGMenuItemModel) -> UIViewController {
        
        var storyboardId = menuItemModel.pageModel.storyboardId
        var pageId = menuItemModel.pageModel.viewControllerId
        return generateViewController(storyboardId, viewControllerId: pageId)
    }
    
    func generateMainMenuIconViewController(mainMenuIconModel:SMGMainMenuIconModel) -> UIViewController {
        
        var storyboardId = mainMenuIconModel.storyboardId
        var iconId = mainMenuIconModel.viewControllerId
        return generateViewController(storyboardId, viewControllerId: iconId)
    }
    
    func generateViewController(storyboardId:String, viewControllerId:String) -> UIViewController {
        var storyboard = UIStoryboard(name:storyboardId , bundle: NSBundle.mainBundle())
        var viewController = storyboard.instantiateViewControllerWithIdentifier(viewControllerId) as UIViewController
        return viewController
    }
}

extension SMGMenuItemsController : SMGCurrentMenuItemUpdater {
    
    func updateCurrentMenuItem(newItemId: String) {
        menuItemsModel.currentItemId = newItemId
    }
}

