//  Created by Chris Harding on 17/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

@objc protocol SMGSmudgeObserver  {
    
    optional func didUpdateMainMenuIcon( icon:SMGMainMenuIconModel )
    optional func didUpdateBackgroundColour( newColour:UIColor )
    optional func didUpdateStartEndPoints( startPont:CGPoint, endPoint:CGPoint )
}

class SMGSmudgeController : NSObject {
    
    var smudgeModel:SMGSmudgeModel
    init(smudgeModel:SMGSmudgeModel) {
        self.smudgeModel = smudgeModel
        super.init()
    }
    
    func addSmudgeObserversFrom(smudgeMenuViewController:SMGSmudgeMenuViewController) {
        
        for observer:SMGSmudgeObserver in [
            smudgeMenuViewController.startHandleViewController,
            smudgeMenuViewController.endHandleViewController,
            smudgeMenuViewController.smudgeViewController
            ] {
                addSmudgeObserver( observer )
        }
        
        for (iconId, iconViewController) in smudgeMenuViewController.iconViewControllers {
            addSmudgeObserver( iconViewController )
        }
    }

    func addSmudgeObserver( observer:SMGSmudgeObserver ) {
        
    }
}

// TODO - observe and react to changes in smudge model, forward notifications to registered observers