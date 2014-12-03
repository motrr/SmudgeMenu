//  Created by Chris Harding on 17/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGMenuViewController : UIViewController {
    
    var menuColour:UIColor {
        get {
            return self.smudgeMenuViewController.smudgeViewController.smudgeView.colour
        }
        set {
            self.smudgeMenuViewController.smudgeViewController.smudgeView.colour = newValue
        }
    }
    
    var menuBackgroundColour:UIColor {
        get {
            return self.view.backgroundColor!
        }
        set {
            self.view.backgroundColor = newValue
        }
    }
    
    var menuController:SMGMenuController!
    
    var pagesViewController:SMGPagesViewController! {
        didSet {addFullscreenChildViewControllerHelper(pagesViewController)}
    }
    var smudgeMenuViewController:SMGSmudgeMenuViewController! {
        didSet {addFullscreenChildViewControllerHelper(smudgeMenuViewController)}
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

    func addMenuItem(itemId: String, iconTitle: String, iconFont: UIFont, icon: UIViewController, page: UIViewController)
        {menuController.addMenuItem(itemId, iconTitle:iconTitle, iconFont:iconFont, icon:icon, page:page)}
    func selectMenuItem(itemId:String) { menuController.selectMenuItem(itemId) }
    
    func setMenuButtonIcon(iconImage: UIImage) {menuController.setMenuButtonIcon(iconImage)}
    func setBackButtonIcon(iconImage: UIImage) {menuController.setBackButtonIcon(iconImage)}
    
    func pushBackButton( backButtonBlock:SMGBackButtonBlock ) { menuController.pushBackButton(backButtonBlock) }
    func popBackButton()  { menuController.popBackButton() }
}