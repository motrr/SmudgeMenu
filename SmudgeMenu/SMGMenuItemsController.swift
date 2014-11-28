//  Created by Chris Harding on 17/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

/*
    Observes and reacts to changes in menu items model, forwards notifications to UI layer.
*/

class SMGMenuItemsController : SMGModelObserverNotifier {
    
    override func keyPaths() -> [String] {
        return ["currentItemId", "newestItemId", "mainMenuIcon"]
    }
    
    override func initialiseResponder(responder: SMGResponder) {
        // Nothing to initialise, dictionary will be empty
    }
    
    override func notifyResponder(responder: SMGResponder, keyPath:String) {
        
        let menuItemsResponder = responder as SMGMenuItemsResponder
        let menuItemsModel = model as SMGMenuItemsModel
        
        switch keyPath {
        case "currentItemId" :
            if menuItemsModel.currentItemId != nil {
                menuItemsResponder.didUpdateCurrentMenuItem?(menuItemsModel.currentItemId!)
            }
        case "newestItemId" :
            
            var itemsDictionary = menuItemsModel.itemsDictionary
            var newestItemId = menuItemsModel.newestItemId
            if newestItemId != nil {
                
                var newestItemModel = itemsDictionary[newestItemId!]!
                var newestItemTitleText = newestItemModel.iconModel.titleText
                var newestItemIconViewController = generateIconViewController(newestItemModel)
                var newestItemPageViewController = generatePageViewController(newestItemModel)
                
                menuItemsResponder.didAddMenuIcon?(newestItemId!, iconTitle:newestItemTitleText , menuIcon: newestItemIconViewController)
                menuItemsResponder.didAddMenuPage?(newestItemId!, menuPage: newestItemPageViewController)
            }
        
        case "mainMenuIcon" :
            if menuItemsModel.mainMenuIcon != nil {
                var mainMenuIcon = generateMainMenuIconViewController(menuItemsModel.mainMenuIcon!)
                menuItemsResponder.didSetMainMenuIcon?(mainMenuIcon)
            }
            
        default : ()
        }
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
        let menuItemsModel = model as SMGMenuItemsModel
        menuItemsModel.currentItemId = newItemId
    }
}

