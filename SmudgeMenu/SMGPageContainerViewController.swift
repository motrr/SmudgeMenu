//  Created by Chris Harding on 25/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKIt

class SMGPageContainerViewController : UIViewController {
    
    let maxScale:CGFloat = 1.0
    let minScale:CGFloat = 0.75
    
    var itemId:String!
    
    var pageViewController:UIViewController! {
        didSet {
            self.addFullscreenChildViewController(self.pageViewController)
        }
    }
}

extension SMGPageContainerViewController : SMGTransitionResponder {
    
    func didUpdateTransitionProgress(newProgress: CGFloat) {
        
        println( newProgress )
        
        let scale:CGFloat = CGFloat.interpolate(1-newProgress, min: minScale, max: maxScale)
        pageViewController?.view.transform = CGAffineTransformMakeScale(scale, scale)
    }
}