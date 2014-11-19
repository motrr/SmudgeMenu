//  Created by Chris Harding on 19/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGSmudgeMenuViewController : UIViewController {
    
    /*
    var smudgeViewController:SMGSmudgeViewController! {
        didSet {addFullscreenChildViewController(smudgeViewController)}
    }
    */
    
    var smudgeDebugViewController:SMGSmudgeDebugViewController! {
        didSet {addFullscreenChildViewController(smudgeDebugViewController)}
    }
    
    var iconViewControllers = Dictionary<String, SMGSmudgeMenuIconViewController>()

    var handlesViewController:SMGSmudgeHandlesViewController!  {
        didSet {addChildViewControllerHelper(handlesViewController)}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        smudgeDebugViewController = SMGSmudgeDebugViewController()
        handlesViewController = SMGSmudgeHandlesViewController()
    }
}

class SMGSmudgeMenuIconViewController : UIViewController {}

