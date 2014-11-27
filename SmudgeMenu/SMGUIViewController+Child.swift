//  Created by Chris Harding on 16/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addFullscreenChildViewController(child:UIViewController, previousChild:UIViewController?) {
        
        previousChild?.willMoveToParentViewController(nil)
        
        self.addChildViewController(child)
        self.view.addSubview(child.view)
        child.view.snp_makeConstraints { make in
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero)
            return
        }
        
        previousChild?.removeFromParentViewController()
        child.didMoveToParentViewController(self)
    }

    
    func addFullscreenChildViewController(child:UIViewController) {
        self.addChildViewController(child)
        self.view.addSubview(child.view)
        child.view.snp_makeConstraints { make in
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero)
            return
        }
        child.didMoveToParentViewController(self)
    }
    
    func addChildViewControllerHelper(child:UIViewController) {
        self.addChildViewController(child)
        self.view.addSubview(child.view)
        child.didMoveToParentViewController(self)
    }
}