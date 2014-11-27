//  Created by Chris Harding on 16/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGPagesViewController : UIViewController {
    
    var currentPage:SMGPageContainerViewController?
    var pageContainers:Dictionary<String, SMGPageContainerViewController> = Dictionary<String, SMGPageContainerViewController>()
    

    
}

extension SMGPagesViewController : SMGMenuItemsResponder {
    
    func didUpdateCurrentMenuItem(newItemId: String) {
        
        var previousPage = currentPage
        if let nextPage = pageContainers[newItemId] {

            self.addFullscreenChildViewController(nextPage, previousChild: previousPage)
            currentPage = nextPage
        }
        else { println( "Error - tried to update page to unknown ID") }
    }
    
    func didAddMenuPage(itemId: String, menuPage: UIViewController) {
        var pageContainer = SMGPageContainerViewController()
        pageContainers[itemId] = pageContainer
        pageContainer.pageViewController = menuPage
    }
}

