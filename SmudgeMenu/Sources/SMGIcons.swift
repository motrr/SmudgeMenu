//  Created by Chris Harding on 21/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGIcons : NSObject  {
    
    var model:SMGModel?

    func setupIconsInView(aView:UIView) {
        
        if (model != nil) {
            for menuItem in model!.menuItems {
                menuItem.icon.model = model
                aView.addSubview(menuItem.icon.iconContainerView as UIView)
            }
        }
    }
}

extension SMGIcons : SMGModelCurveDelegate {
    
    func didUpdateCurve() {
        if (model != nil) {
            
            var minAlpha:CGFloat = 0.0
            var maxAlpha:CGFloat = 1.0
            for menuItem in model!.menuItems {
                
                var icon = menuItem.icon
                icon.iconContainerView.centre = model!.interpolateElementPosition(
                    icon.iconIndex,
                    elementCount: model!.menuItems.count)
                icon.iconContainerView.alpha = minAlpha + (maxAlpha - minAlpha) * model!.progress
            }
            
        }
    }
}

class SMGIcon : NSObject {
    
    var model:SMGModel?
    
    var iconIndex:Int = 0
    var iconView:UIView
    var iconContainerView:SMGIconContainerView = SMGIconContainerView()
    var tapGesture: UITapGestureRecognizer!
    
    init(iconView:UIView) {
        
        self.iconView = iconView
        
        super.init()
        
        iconContainerView.addSubview(iconView)
        
        iconView.width = iconContainerView.width
        iconView.height = iconContainerView.height
        
        tapGesture = UITapGestureRecognizer(target: self, action: Selector("didTap"))
        iconContainerView.addGestureRecognizer(tapGesture)
        
    }
    
    func didTap() {
        if model != nil {
            if model?.currentMenuItemIndex != nil {
                model!.currentMenuItemIndex!.observableProperty = self.iconIndex
            }
            else {
                model!.currentMenuItemIndex = Observable<Int>(initialValue:self.iconIndex)
            }
        }
    }
}

class SMGIconContainerView : UIView {
    
    override init() {
        super.init()
        
        self.backgroundColor = UIColor.clearColor()
        
        self.width = 65
        self.height = 80
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    
}