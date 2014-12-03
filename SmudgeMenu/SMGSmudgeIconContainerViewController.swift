//  Created by Chris Harding on 21/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGSmudgeIconContainerViewController : SMGXYConstraintViewController {

    var currentMenuItemUpdater:SMGCurrentMenuItemUpdater?
    var openCloseUpdater:SMGSmudgeOpenCloseUpdater?
    
    var itemId:String!
    var iconViewController:UIViewController!
    var iconTitleLabel:UILabel!
    
    var tappableView:SMGTappableView {return self.view as SMGTappableView}
    
    override func loadView() {
        self.view = SMGTappableView()
        tappableView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
    }
    
    func setIcon(iconViewController:UIViewController, title:String, font:UIFont) {
        
        self.iconViewController = iconViewController
        
        self.addChildViewControllerHelper(self.iconViewController)
        self.iconViewController.view.userInteractionEnabled = false
        
        iconTitleLabel = UILabel()
        iconTitleLabel.text = title
        iconTitleLabel.font = font
        iconTitleLabel.numberOfLines = 0
        iconTitleLabel.textAlignment = NSTextAlignment.Center
        
        self.view.addSubview(iconTitleLabel)
        
        self.iconTitleLabel.snp_makeConstraints {make in
            make.left.right.and.top.equalTo(self.view)
            return
        }
        
        self.iconViewController.view.snp_makeConstraints {make in
            make.top.equalTo(self.iconTitleLabel.snp_bottom)
            make.left.right.and.bottom.equalTo(self.view)
            return
        }
    }
}

extension SMGSmudgeIconContainerViewController : SMGTappableViewDelegate {
    
    func viewWasTapped(location: CGPoint) {
        currentMenuItemUpdater?.updateCurrentMenuItem(itemId)
        openCloseUpdater?.closeHandles()
    }
}

extension SMGSmudgeIconContainerViewController : SMGTransitionResponder {

    func didUpdateTransitionProgress(newProgress: CGFloat) {
        self.view.alpha = newProgress
    }
}