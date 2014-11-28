//  Created by Chris Harding on 21/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGSmudgeIconsViewController : UIViewController {
    
    var maxIconSize = CGSize(width:100, height:80)
    var maxCurveWidth:CGFloat = 0
    var curve:SMGBezierCurve!
    var iconContainers:[SMGSmudgeIconContainerViewController] = Array<SMGSmudgeIconContainerViewController>()
    
    override func loadView() {
        self.view = SMGNoHitView()
    }
    
    var currentMenuItemUpdater:SMGCurrentMenuItemUpdater? {
        didSet {
            for iconContainer in iconContainers {
                iconContainer.currentMenuItemUpdater = self.currentMenuItemUpdater
            }
        }
    }
    
    func updateIconSizes() {

        var widthDivisor = (iconContainers.count <= 1 ? 1 : iconContainers.count - 1)
        var iconWidthFromCurveWidth:CGFloat = maxCurveWidth / CGFloat(widthDivisor)
        var iconWidth:CGFloat = min(maxIconSize.width, iconWidthFromCurveWidth)
        
        for iconContainer in iconContainers {

            iconContainer.view.snp_remakeConstraints() { make in
                make.width.equalTo( iconWidth )
                make.height.equalTo( self.maxIconSize.height )
            }
        }
    }
    
    func updateIconPositions() {
        
        for (index, iconContainer) in enumerate(iconContainers) {
             
            var position = curve.interpolateElementPosition(index, elementCount: iconContainers.count)
            iconContainer.xConstraint.constant = position.x
            iconContainer.yConstraint.constant = position.y
        }
    }
    
}

extension SMGSmudgeIconsViewController : SMGMenuItemsResponder {
    
    func didAddMenuIcon(itemId: String, iconTitle: String, menuIcon: UIViewController) {
        
        var iconContainer = SMGSmudgeIconContainerViewController()
        iconContainer.itemId = itemId
 
        iconContainers.append( iconContainer )
        self.addChildViewControllerHelper(iconContainer)
        
        iconContainer.xConstraint = centerX(iconContainer.view) => left(self.view)
        iconContainer.yConstraint = centerY(iconContainer.view) => top(self.view)
        iconContainer.view.snp_makeConstraints() { make in
            make.width.equalTo( self.maxIconSize.width )
            make.height.equalTo( self.maxIconSize.height )
        }
        
        iconContainer.iconViewController = menuIcon
        iconContainer.currentMenuItemUpdater = self.currentMenuItemUpdater
        
        updateIconSizes()
    }
}

extension SMGSmudgeIconsViewController : SMGCurveResponder {
    
    func didUpdateCurve(curve: SMGBezierCurve) {
        self.curve = curve
        updateIconPositions()
    }
    
    func didUpdateMaxCurveWidth(curveWidth: CGFloat) {
        self.maxCurveWidth = curveWidth
        updateIconSizes()
        updateIconPositions()
    }
}

extension SMGSmudgeIconsViewController : SMGTransitionResponder {
    
    func didUpdateTransitionProgress(newProgress: CGFloat) {
        for iconContainer in iconContainers {
            iconContainer.didUpdateTransitionProgress(newProgress)
        }
    }
}

