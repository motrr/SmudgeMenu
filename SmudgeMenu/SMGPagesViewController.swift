//  Created by Chris Harding on 16/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGPagesViewController : UIViewController {
    
    var currentPage:SMGPageContainerViewController?
    var pageContainers:Dictionary<String, SMGPageContainerViewController> = Dictionary<String, SMGPageContainerViewController>()
    
    var transitionInProgress = false
}

extension SMGPagesViewController : SMGMenuItemsResponder {
    
    func didUpdateCurrentMenuItem(newItemId: String) {
        
        var oldPageOrNil = currentPage
        if let newPage = pageContainers[newItemId] {

            if let oldPage = oldPageOrNil {
                if newPage.itemId != oldPage.itemId {
                    switchToNextPageAnimated(newPage, previousPage: oldPage)
                }
            }
            else {
                setupInitialPage(newPage)
            }
        }
        else { println( "Error - tried to update page to unknown ID") }
    }
    
    func didAddMenuPage(itemId: String, menuPage: UIViewController) {
        var pageContainer = SMGPageContainerViewController()
        pageContainer.itemId = itemId
        pageContainers[itemId] = pageContainer
        pageContainer.pageViewController = menuPage
    }
    
    func switchToNextPageAnimated(nextPage:SMGPageContainerViewController, previousPage:SMGPageContainerViewController) {
        
        if !transitionInProgress {
            transitionInProgress = true
            
            previousPage.willMoveToParentViewController(nil)
            self.addChildViewController(nextPage)
            
            self.transitionFromViewController( previousPage, toViewController: nextPage,
                duration: 0.1,
                options: UIViewAnimationOptions.TransitionCrossDissolve,
                animations: {
                    
                    // Set next page final size/layout
                    nextPage.view.snp_makeConstraints { make in
                        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero)
                        return
                    }
                    
                },
                completion: {_ in
                    
                    previousPage.removeFromParentViewController()
                    nextPage.didMoveToParentViewController(self)
                    
                    self.currentPage = nextPage
                    self.transitionInProgress = false
                }
            )
        }
    }
    
    func setupInitialPage(initialPage:SMGPageContainerViewController) {
        self.addFullscreenChildViewController(initialPage)
        currentPage = initialPage
    }
}

