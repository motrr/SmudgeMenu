//  Created by Chris Harding on 28/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGMainMenuIconContainerViewController : SMGIconContainerViewController {
    
    var openCloseUpdater:SMGSmudgeOpenCloseUpdater?
    var backButtonStack:[SMGBackButtonView] = []
    
    let backButtonSize = CGSize(width: 50, height: 50)
    let backButtonOffset:CGFloat = 50
    
    var mainIconXConstraint:NSLayoutConstraint!
    var mainIconYConstraint:NSLayoutConstraint!
    
    var iconViewController:UIViewController! {
        didSet {
            self.addChildViewControllerHelper(self.iconViewController)
            self.iconViewController.view.userInteractionEnabled = false
        }
    }
    
    override func didTap(tg: UITapGestureRecognizer) {
        openCloseUpdater?.openHandles()
    }
    
}

extension SMGMainMenuIconContainerViewController : SMGBackButtonResponder {

    func didPushBackButton() {
        
        let nextBackButton = createNewBackButton()
        
        var completion:(Void -> Void) = {
            self.backButtonStack.append(nextBackButton)
        }
        
        if backButtonStack.count == 0 {
            animateSlideButtonFromRight(nextBackButton.xConstraint, currentButtonXConstraint:mainIconXConstraint, completion:completion)
        }
        else {
            let currentBackButton = backButtonStack[backButtonStack.count-1]
            animateSlideButtonFromRight(nextBackButton.xConstraint, currentButtonXConstraint:currentBackButton.xConstraint, completion:completion)
        }
    }
    
    func didPopBackButton() {
        if backButtonStack.count != 0 {
            
            var completion:(Void -> Void) = {
                self.backButtonStack.last?.removeFromSuperview()
                self.backButtonStack.removeLast()
            }
            
            if backButtonStack.count == 1 {
                let currentBackButton = backButtonStack[backButtonStack.count-1]
                animateSlideButtonFromLeft(mainIconXConstraint, currentButtonXConstraint:currentBackButton.xConstraint, completion:completion)
            }
            else {
                let currentBackButton = backButtonStack[backButtonStack.count-1]
                let previousBackButton = backButtonStack[backButtonStack.count-2]
                animateSlideButtonFromLeft(previousBackButton.xConstraint, currentButtonXConstraint:currentBackButton.xConstraint, completion:completion)
            }
        }
    }
    
    func didUpdateBackButtonStackHeight(newHeight: Int) {

        if newHeight == 0 {
            mainIconXConstraint.constant = 0
        }
        else {
            mainIconXConstraint.constant = -backButtonOffset
        }
        
        while backButtonStack.count > newHeight {
            self.backButtonStack.last?.removeFromSuperview()
            self.backButtonStack.removeLast()
            self.backButtonStack.last?.xConstraint.constant = 0
        }
        
        while backButtonStack.count < newHeight {
            self.backButtonStack.last!.xConstraint.constant = -backButtonOffset
            let nextBackButton = createNewBackButton()
            self.backButtonStack.append(nextBackButton)
        }
    }
    
    func createNewBackButton() -> SMGBackButtonView {
        
        let newBackButton = SMGBackButtonView()
        newBackButton.backgroundColor = UIColor.magentaColor()
        
        self.view.addSubview(newBackButton)
        
        newBackButton.snp_makeConstraints { maker in
            maker.width.equalTo( self.backButtonSize )
            maker.height.equalTo( self.backButtonSize )
        }
        
        newBackButton.xConstraint = centerX(newBackButton) => centerX(self.view)
        newBackButton.yConstraint = centerY(newBackButton) => centerY(self.view)
        
        return newBackButton
    }
    
    func animateSlideButtonFromRight(incomingButtonXConstraint:NSLayoutConstraint,
        currentButtonXConstraint:NSLayoutConstraint, completion:(Void -> Void)) {
            
            animateSlideButton(incomingButtonXConstraint, currentButtonXConstraint: currentButtonXConstraint, completion: completion, fromLeft: false)
    }
    
    func animateSlideButtonFromLeft(incomingButtonXConstraint:NSLayoutConstraint,
        currentButtonXConstraint:NSLayoutConstraint,
        completion:(Void -> Void)) {
            
            animateSlideButton(incomingButtonXConstraint, currentButtonXConstraint: currentButtonXConstraint, completion: completion, fromLeft: true)
    }
    
    func animateSlideButton(incomingButtonXConstraint:NSLayoutConstraint,
        currentButtonXConstraint:NSLayoutConstraint,
        completion:(Void -> Void), fromLeft:Bool) {
            
            var modifier:CGFloat = -1
            if fromLeft {modifier = 1}
            
            incomingButtonXConstraint.constant = -self.backButtonOffset * modifier
            currentButtonXConstraint.constant = 0
            self.view.layoutIfNeeded()
            
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                {
                    incomingButtonXConstraint.constant = 0
                    currentButtonXConstraint.constant = self.backButtonOffset * modifier
                    self.view.layoutIfNeeded()
                    
                }) { success in
                    completion()
            }
    }
}

extension SMGMainMenuIconContainerViewController : SMGTransitionResponder {
    
    func didUpdateTransitionProgress(newProgress: CGFloat) {
        self.view.alpha = 1 - 4*newProgress
    }
}

class SMGBackButtonView : UIView {
    
    var xConstraint:NSLayoutConstraint!
    var yConstraint:NSLayoutConstraint!
}