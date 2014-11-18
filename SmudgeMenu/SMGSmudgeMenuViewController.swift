//  Created by Chris Harding on 16/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGSmudgeMenuViewController : UIViewController, SMGMenuItemsObserver {
    
    let handleInitOffset = CGPoint(x: 200, y: 200)
    let handleSize = CGSize(width: 100, height: 100)
    
    let handleVEdgeInsets:CGFloat = 80
    let handleHEdgeInsets:CGFloat = 40
    var handleEdgeInsets:UIEdgeInsets {
        return UIEdgeInsetsMake(handleVEdgeInsets, handleHEdgeInsets, handleVEdgeInsets, handleHEdgeInsets)
    }
    
    let maxVSeperatinToHSeperationRatio:CGFloat = 0.5
    
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
                handle.delegate = self
                handle.xConstraint = centerX(handle.view) => left(self.view) + handleOffset.x
                handle.yConstraint = centerY(handle.view) => top(self.view) + handleOffset.y
                handle.view.snp_makeConstraints { make in
                    make.size.equalTo(self.handleSize); return
                }
                handle.edgeInsets = handleEdgeInsets
        }
    }
}

extension SMGSmudgeMenuViewController : SMGSmudgeHandleViewControllerDelegate {
    
    func handleDidMove(handle: SMGSmudgeHandleViewController) {
        
        var otherHandle = endHandleViewController
        if handle == endHandleViewController {otherHandle = startHandleViewController}
        
        // Limit vertical seperation of the two handles
        var hSep:CGFloat = handle.xConstraint!.constant - otherHandle.xConstraint!.constant
        var vSep:CGFloat = handle.yConstraint!.constant - otherHandle.yConstraint!.constant
        
        if vSep > maxVSeperatinToHSeperationRatio * fabs(hSep)
            { otherHandle.yConstraint!.constant = handle.yConstraint!.constant - maxVSeperatinToHSeperationRatio * fabs(hSep) }
        else if vSep < -maxVSeperatinToHSeperationRatio * fabs(hSep)
            { otherHandle.yConstraint!.constant = handle.yConstraint!.constant + maxVSeperatinToHSeperationRatio * fabs(hSep) }
    }
}


extension SMGSmudgeMenuViewController : SMGMenuItemsObserver {}

class SMGSmudgeMenuIconViewController : UIViewController {}
extension SMGSmudgeMenuIconViewController : SMGSmudgeObserver {}
extension SMGSmudgeMenuIconViewController : SMGMenuItemsObserver {}

class SMGSmudgeViewController : UIViewController {}
extension SMGSmudgeViewController : SMGSmudgeObserver {}


