//  Created by Chris Harding on 19/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGHandleHelperView : SMGCircleView {
    
    func setupPointView() {
        strokeColour = UIColor.clearColor()
        fillColour = UIColor.clearColor()
    }
    
    override init() {super.init();setupPointView()}
    required init(coder aDecoder: NSCoder) {super.init(coder: aDecoder);setupPointView()}
    override init(frame: CGRect) {super.init(frame: frame);setupPointView()}
}