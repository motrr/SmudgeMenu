//  Created by Chris Harding on 21/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGSmudgeIconContainerViewController : SMGIconContainerViewController {
    
    var currentMenuItemUpdater:SMGCurrentMenuItemUpdater?
    var itemId:String!
    var tapGesture: UITapGestureRecognizer!
    var iconViewController:UIViewController!
    var iconTitleLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture = UITapGestureRecognizer(target: self, action: Selector("didTap:"))
        self.view.addGestureRecognizer(tapGesture)
        self.view.backgroundColor = UIColor.clearColor()
    }
    
    func didTap(sender:UITapGestureRecognizer) {
        currentMenuItemUpdater?.updateCurrentMenuItem(itemId)
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
        
        self.view.setNeedsUpdateConstraints()
        self.view.setNeedsLayout()
        
        println( iconTitleLabel.frame )
    }
}

extension SMGSmudgeIconContainerViewController : SMGTransitionResponder {

    func didUpdateTransitionProgress(newProgress: CGFloat) {
        self.view.alpha = newProgress
    }
}