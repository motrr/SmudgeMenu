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
}

extension SMGMenuItemsController : SMGCurrentMenuItemUpdater {
    
    func updateCurrentMenuItem(newItemId: String) {
        menuItemsModel.currentItemId = newItemId
    }
}

