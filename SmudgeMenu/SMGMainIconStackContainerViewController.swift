//  Created by Chris Harding on 03/12/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGMainIconStackContainerViewController : SMGXYConstraintViewController {
    
    var backButtonUpdater:SMGBackButtonUpdater?
    var openCloseUpdater:SMGSmudgeOpenCloseUpdater?
    
    var tappableView:SMGTappableView!
    var stack:[SMGStackItemViewController] = []

    let menuButtonSize = CGSize(width: 20, height: 15)
    let backButtonSize = CGSize(width: 25, height: 25)
    
    var mainButtonIconImage:UIImage?
    var backButtonIconImage:UIImage?
    
    override func viewDidLoad() {
        
        tappableView = SMGTappableView()
        tappableView.delegate = self
        tappableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(tappableView)
        tappableView.snp_makeConstraints() {make in
            make.edges.equalTo( self.view )
            return
        }
        
        stack.append( createNewMenuButton() )
    }
    
    func createNewMenuButton() -> SMGMenuButtonViewController {
        
        let newMenuButton = SMGMenuButtonViewController()
        setupNewButton( newMenuButton, buttonSize: menuButtonSize )
        newMenuButton.iconImage = mainButtonIconImage
        return newMenuButton
    }
    
    func createNewBackButton() -> SMGBackButtonViewController {
        
        let newBackButton = SMGBackButtonViewController()
        setupNewButton( newBackButton, buttonSize: backButtonSize )
        newBackButton.iconImage = backButtonIconImage
        return newBackButton
    }
    
    func setupNewButton(button:SMGStackItemViewController, buttonSize:CGSize) {
        
        self.addChildViewControllerHelper(button)
        
        button.view.snp_makeConstraints { maker in
            maker.width.equalTo( buttonSize )
            maker.height.equalTo( buttonSize )
        }
        
        button.xConstraint = centerX(button.view) => centerX(self.view)
        button.yConstraint = centerY(button.view) => centerY(self.view)
    }
}

extension SMGMainIconStackContainerViewController : SMGTappableViewDelegate {
    
    func viewWasTapped(location: CGPoint) {
        /*
            Hitting the main menu button has two actions depending on the state of the menu. Normally tapping will open the menu, however if the app has pushed navigation views (and corresponding back button blocks to the menu) then the main menu button functions as a navigation bar back button. This prevents the using from being required to reach to the top corner of the screen for navigation.
        */
        
        if stack.count > 1 {
            backButtonUpdater?.popBackButton(true)
        }
        else {
            openCloseUpdater?.openHandles()
        }
    }
}

extension SMGMainIconStackContainerViewController : SMGIconConfigResponder {
    
    func didSetMenuButtonIcon(iconImage: UIImage) {
        mainButtonIconImage = iconImage
        stack.first?.iconImage = mainButtonIconImage
    }
    
    func didSetBackButtonIcon(iconImage: UIImage) {
        backButtonIconImage = iconImage
        
        for (index, stackItem) in enumerate(stack) {
            if index != 0 {
                stackItem.iconImage = backButtonIconImage
            }
        }
    }
}

extension SMGMainIconStackContainerViewController : SMGBackButtonResponder {
    
    func didPushBackButton() {
        
        let currentItem = stack[stack.count-1]
        let nextItem = createNewBackButton()
        
        let completion = {
            self.stack.append(nextItem)
        }
        
        animateSlideItem(nextItem, .Right, outgoing: currentItem, .Left, completion: completion)
    }
    
    func didPopBackButton() {
        
        if stack.count >= 2 {
            
            let currentItem = stack[stack.count-1]
            let previousItem = stack[stack.count-2]
            
            var completion:(Void -> Void) = {
               self.removeChildViewControllerHelper( self.stack.removeLast() )
            }

            animateSlideItem(previousItem, .Left, outgoing: currentItem, .Right, completion: completion)
        }
    }
    
    func didUpdateBackButtonStackHeight(newHeight: Int) {
        
        // Since we also have the main menu icon in the stack we adjust the input height
        let adjustedNewHeight = newHeight + 1
        
        while stack.count > adjustedNewHeight {
            removeChildViewControllerHelper( self.stack.removeLast() )
            stack.last?.positionButton(.Centre)
        }
        
        while stack.count < adjustedNewHeight {
            stack.last?.positionButton(.Left)
            stack.append( createNewBackButton() )
        }
    }
    
    func animateSlideItem(
        incoming:SMGStackItemViewController, _ initialPosition:SMGStackItemPosition,
        outgoing:SMGStackItemViewController, _ finalPosition:SMGStackItemPosition,
        completion:(Void -> Void))
    {
        
        incoming.positionButton(initialPosition)
        outgoing.positionButton(.Centre)
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations:
            {
                incoming.positionButton(.Centre)
                outgoing.positionButton(finalPosition)
                
            }) { success in
                completion()
        }
    }
}