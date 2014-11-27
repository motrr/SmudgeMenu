//  Created by Chris Harding on 18/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGSmudgeHandleView : SMGDraggableCircleView {
    
    func setupSmudgeHandleView() {
        strokeColour = UIColor.clearColor()
        fillColour = UIColor.clearColor()
        alpha = 0.3
    }
    
    override init() {super.init();setupSmudgeHandleView()}
    required init(coder aDecoder: NSCoder) {super.init(coder: aDecoder);setupSmudgeHandleView()}
    override init(frame: CGRect) {super.init(frame: frame);setupSmudgeHandleView()}
}