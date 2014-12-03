//  Created by Chris Harding on 03/12/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGMainIconViewController : UIViewController {
    
    var backButtonUpdater:SMGBackButtonUpdater? {
        didSet {stackContainer.backButtonUpdater = self.backButtonUpdater}
    }
    var openCloseUpdater:SMGSmudgeOpenCloseUpdater?  {
        didSet {stackContainer.openCloseUpdater = self.openCloseUpdater}
    }
    
    var mainIconContainerSize = CGSize(width:90, height:90)
    
    var stackContainer:SMGMainIconStackContainerViewController! {
        didSet {addChildViewControllerHelper(stackContainer)}
    }
    
    override func loadView() {
        self.view = SMGNoHitView()
    }
    
    override func viewDidLoad() {
        
        stackContainer = SMGMainIconStackContainerViewController()
        stackContainer.view.snp_makeConstraints() {make in
            make.size.equalTo(self.mainIconContainerSize); return
        }
        stackContainer.xConstraint = centerX(stackContainer.view) => left(self.view)
        stackContainer.yConstraint = centerY(stackContainer.view) => top(self.view)

    }
}

extension SMGMainIconViewController : SMGBackButtonResponder {
    
    func didPopBackButton() {
        stackContainer.didPopBackButton()
    }
    
    func didPushBackButton() {
        stackContainer.didPushBackButton()
    }
    
    func didUpdateBackButtonStackHeight(newHeight: Int) {
        stackContainer.didUpdateBackButtonStackHeight(newHeight)
    }
}

extension SMGMainIconViewController : SMGCurveResponder {
    
    func didUpdateCurve(curve: SMGBezierCurve) {
        stackContainer.pointFromConstraints = curve.a
    }
}

extension SMGMainIconViewController : SMGTransitionResponder {
    
    func didUpdateTransitionProgress(newProgress: CGFloat) {
        stackContainer.view.alpha = 1 - 4*newProgress
    }
}



