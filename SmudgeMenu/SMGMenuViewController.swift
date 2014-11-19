//  Created by Chris Harding on 17/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGMenuViewController : UIViewController {
    
    var menuController:SMGMenuController!
    
    var pagesViewController:SMGPagesViewController! {
        didSet {addFullscreenChildViewController(pagesViewController)}
    }
    var smudgeMenuViewController:SMGSmudgeMenuViewController! {
        didSet {addFullscreenChildViewController(smudgeMenuViewController)}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagesViewController = SMGPagesViewController()
        smudgeMenuViewController = SMGSmudgeMenuViewController()
        
        menuController = SMGMenuController(menuViewController: self)
    }
}


/*
SMGViewController is the root object of the menu; this permits is to be used from a storyboard by setting a view controller's class name to SMGViewController; this also helps when programatically adding the menu to a project since the view/view-controller can be easily added to an existing view/view-controller hierarchy.

However, the main functions for manipulating the menu are performed by the menu controller object, in an effort to cleanly seperate the controller layer from the UI layer. Therefore, we expose these methods of the SMGMenuController (defined in the SMGMenu protocol) by wrapping them here in the SMGMenuViewController

*/

extension SMGMenuViewController : SMGMenu {
    func setMainMenuIcon(icon: SMGMainMenuIconModel) { menuController.setMainMenuIcon(icon) }
    func addMenuItem(newItem:SMGMenuItemModel) { menuController.addMenuItem(newItem) }
    func selectMenuItem(itemId:String) { menuController.selectMenuItem(itemId) }
}


/*
    These protocols are used throughout the UI layer. They qualify how non-UI controller objects should interact with the UI layer.
*/

// Responders; for sending messages TO the UI layer.

protocol SMGCurveResponder {
    func updateCurve( startPoint:CGPoint, controlPointA:CGPoint, controlPointB:CGPoint, endPoint:CGPoint )
}

// Observers; for recieving messages FROM the UI layer.

protocol SMGHandleObserver {
    func didUpdateHandles( handleA:CGPoint, _ handleB:CGPoint )
}