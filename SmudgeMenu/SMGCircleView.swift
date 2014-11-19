//  Created by Chris Harding on 18/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGCircleView : UIView {
    
    var strokeWidth:CGFloat = 1.0
    var fillColour:UIColor = UIColor.redColor()
    var strokeColour:UIColor = UIColor.blueColor()
    
    override init() {
        super.init()
        initalSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initalSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initalSetup()
    }
    
    private func initalSetup() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        self.drawRectForCircle(rect, strokeWidth:strokeWidth, fillColour:fillColour, strokeColour:strokeColour)
    }
}

