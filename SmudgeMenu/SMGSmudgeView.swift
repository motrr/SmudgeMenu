//  Created by Chris Harding on 20/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGSmudgeView : SMGCurveView {
    
    let minRadius:CGFloat = 25
    let maxRadius:CGFloat = 70
    
    var progress:CGFloat = 0
    
    func setupSmudgeView() {
        colour = UIColor.redColor()
        radius = minRadius
    }
    
    override init() {super.init();setupSmudgeView()}
    required init(coder aDecoder: NSCoder) {super.init(coder: aDecoder);setupSmudgeView()}
    override init(frame: CGRect) {super.init(frame: frame);setupSmudgeView()}
}

extension SMGSmudgeView : SMGTransitionResponder {
    
    func didUpdateTransitionProgress(newProgress: CGFloat) {
        
        self.progress = newProgress
        
        // Update radius based on transition progress
        self.radius = minRadius + (maxRadius - minRadius) * self.progress
        
        self.setNeedsDisplay()
    }
}