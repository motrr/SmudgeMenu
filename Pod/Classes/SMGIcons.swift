//  Created by Chris Harding on 21/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGIcons : NSObject  {
    
    var model:SMGModel!
    var icons:[SMGIconView] = Array()
    
    init(model:SMGModel) {
        super.init()
        self.model = model
        
        // Create temporary icons
        for i in 0..<4 {
            icons.append(SMGIconView(elementIndex:i))
        }
        
    }
    
    func setupIconsInView(aView:UIView) {
     
        for icon in icons {
            aView.addSubview(icon as UIView)
        }
    }
}

extension SMGIcons : SMGModelDelegate {
    
    func smudgeModelDidUpdate() {

        var minAlpha:CGFloat = 0.0
        var maxAlpha:CGFloat = 1.0
        for icon:SMGIconView in icons  {
            icon.centre = model.interpolateElementPosition(icon.elementIndex, elementCount: icons.count)
            icon.alpha = minAlpha + (maxAlpha - minAlpha) * model.progress
        }
        
    }
}

class SMGIconView : UIView {
    
    var elementIndex:Int = 0
    
    init(elementIndex:Int) {
        super.init()
        self.elementIndex = elementIndex
        
        self.backgroundColor = UIColor.blackColor()
        self.width = 50
        self.height = 50
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    
}