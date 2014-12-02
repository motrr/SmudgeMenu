//  Created by Chris Harding on 21/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGSmudgeIconsViewController : UIViewController {
    
    var mainMenuIconSize = CGSize(width:18, height:18)
    var mainMenuTapAreaSize = CGSize(width:90, height:90)
    
    var maxIconSize = CGSize(width:100, height:100)
    var maxCurveWidth:CGFloat = 0
    var curve:SMGBezierCurve!
    var iconContainers:[SMGSmudgeIconContainerViewController] = Array<SMGSmudgeIconContainerViewController>()
    var mainMenuIconContainer:SMGMainMenuIconContainerViewController?
    
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
    var openCloseUpdater:SMGSmudgeOpenCloseUpdater? {
        didSet {
            for iconContainer in iconContainers {
                iconContainer.openCloseUpdater = self.openCloseUpdater
            }
            mainMenuIconContainer?.openCloseUpdater = self.openCloseUpdater
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
        
        mainMenuIconContainer?.xConstraint.constant = curve.a.x
        mainMenuIconContainer?.yConstraint.constant = curve.a.y
    }
    
}

extension SMGSmudgeIconsViewController : SMGMenuItemsResponder {
    
    func didAddMenuIcon(itemId: String, iconTitle: String, iconFont:UIFont, menuIcon: UIViewController) {
        
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
        
        iconContainer.setIcon(menuIcon, title: iconTitle, font:iconFont)
        iconContainer.currentMenuItemUpdater = self.currentMenuItemUpdater
        iconContainer.openCloseUpdater = self.openCloseUpdater
        
        updateIconSizes()
    }
    
    func didSetMainMenuIcon(mainMenuIcon: UIViewController) {
        
        if let previousMainMenuIconContainer = mainMenuIconContainer {
            previousMainMenuIconContainer.willMoveToParentViewController(nil)
            previousMainMenuIconContainer.view.removeFromSuperview()
            previousMainMenuIconContainer.removeFromParentViewController()
        }
        
        mainMenuIconContainer = SMGMainMenuIconContainerViewController()
        self.addChildViewControllerHelper(mainMenuIconContainer!)
        
        mainMenuIconContainer!.xConstraint = centerX(mainMenuIconContainer!.view) => left(self.view)
        mainMenuIconContainer!.yConstraint = centerY(mainMenuIconContainer!.view) => top(self.view)
        mainMenuIconContainer!.view.snp_makeConstraints() { make in
            make.width.equalTo( self.mainMenuTapAreaSize.width )
            make.height.equalTo( self.mainMenuTapAreaSize.height )
        }
        
        mainMenuIconContainer!.iconViewController = mainMenuIcon
        mainMenuIconContainer!.iconViewController.view.snp_makeConstraints() { make in
            make.width.equalTo( self.mainMenuIconSize.width )
            make.height.equalTo( self.mainMenuIconSize.height )
        }
        
        mainMenuIconContainer!.mainIconXConstraint = centerX(mainMenuIcon.view) => centerX(self.mainMenuIconContainer!.view)
        mainMenuIconContainer!.mainIconYConstraint = centerY(mainMenuIcon.view) => centerY(self.mainMenuIconContainer!.view)
        
        mainMenuIconContainer?.openCloseUpdater = self.openCloseUpdater
        
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
        
        mainMenuIconContainer?.didUpdateTransitionProgress(newProgress)
    }
}

