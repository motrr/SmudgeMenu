//  Created by Chris Harding on 16/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGSmudgeMenuViewController : UIViewController, SMGMenuItemsObserver {
    
    let handleInitOffset = CGPoint(x: 200, y: 200)
    let handleSize = CGSize(width: 100, height: 100)
    
    var smudgeViewController:SMGSmudgeViewController! {
        didSet {addChildViewControllerHelper(smudgeViewController)}
    }
    
    var iconViewControllers = Dictionary<String, SMGSmudgeMenuIconViewController>()
    
    var startHandleViewController:SMGSmudgeHandleViewController!  {
        didSet {addChildViewControllerHelper(startHandleViewController)}
    }
    var endHandleViewController:SMGSmudgeHandleViewController!  {
        didSet {addChildViewControllerHelper(endHandleViewController)}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        smudgeViewController = SMGSmudgeViewController()
        
        startHandleViewController = SMGSmudgeHandleViewController()
        endHandleViewController = SMGSmudgeHandleViewController()
    
        for (handle,handleOffset) in [
                (startHandleViewController, handleInitOffset),
                (endHandleViewController, handleInitOffset)
            ] {
                handle.xConstraint = centerX(handle.view) => left(self.view) + handleOffset.x
                handle.yConstraint = centerY(handle.view) => top(self.view) + handleOffset.y
                handle.view.snp_makeConstraints { make in
                    make.size.equalTo(self.handleSize); return
                }
        }
    }
}
extension SMGSmudgeMenuViewController : SMGMenuItemsObserver {}

class SMGSmudgeMenuIconViewController : UIViewController {}
extension SMGSmudgeMenuIconViewController : SMGSmudgeObserver {}
extension SMGSmudgeMenuIconViewController : SMGMenuItemsObserver {}

class SMGSmudgeViewController : UIViewController {}
extension SMGSmudgeViewController : SMGSmudgeObserver {}


