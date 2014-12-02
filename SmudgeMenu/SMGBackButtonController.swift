//  Created by Chris Harding on 02/12/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

/*
    Observes and reacts to current menu item, forwards notifications to back button responders in UI layer.
*/

class SMGBackButtonController: SMGModelObserveNotifyController {
    
    var menuItemsModel:SMGMenuItemsModel {return model as SMGMenuItemsModel}
    
    override func keyPaths() -> [String] {
        return ["currentItemId"]
    }
    
    override func initialiseResponder(responder: SMGResponder) {
        // Nothing to initialise
    }
    
    override func notifyResponder(responder: SMGResponder, keyPath:String) {
        
        let backButtonResponder = responder as SMGBackButtonResponder
        
        switch keyPath {
        case "currentItemId" :
            if menuItemsModel.currentItemId != nil {

                // Update stack height based on new current menu item
                var currentStack:[SMGBackButtonBlock]
                if let itemId = menuItemsModel.currentItemId {
                    if menuItemsModel.backButtonStacks[itemId] != nil {
                        currentStack = menuItemsModel.backButtonStacks[itemId]!
                    }
                    else {currentStack = []}
                    
                    backButtonResponder.didUpdateBackButtonStackHeight(currentStack.count)
                }
            }
            
        default : ()
        }
    }
}

extension SMGBackButtonController {
    
    func pushBackButton(backButtonBlock:SMGBackButtonBlock) {
        
        var currentStack:[SMGBackButtonBlock]
        if let itemId = menuItemsModel.currentItemId {
            if menuItemsModel.backButtonStacks[itemId] != nil {
                currentStack = menuItemsModel.backButtonStacks[itemId]!
            }
            else {currentStack = []}

            currentStack.append(backButtonBlock)
            menuItemsModel.backButtonStacks[itemId] = currentStack
            
            for responder in responders {
                let backButtonResponder = responder as SMGBackButtonResponder
                backButtonResponder.didPushBackButton()
            }
        }
    }
    
    func popBackButton() {
        var currentStack:[SMGBackButtonBlock]
        if let itemId = menuItemsModel.currentItemId {
            if menuItemsModel.backButtonStacks[itemId] != nil {
                currentStack = menuItemsModel.backButtonStacks[itemId]!
                if currentStack.count > 0 {
                    
                    var backButtonBlock:SMGBackButtonBlock = currentStack.removeLast()
                    menuItemsModel.backButtonStacks[itemId] = currentStack
                    
                    backButtonBlock()
                    
                    for responder in responders {
                        let backButtonResponder = responder as SMGBackButtonResponder
                        backButtonResponder.didPopBackButton()
                    }
                }
            }
        }
    }
}