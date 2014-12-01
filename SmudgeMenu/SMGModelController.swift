//  Created by Chris Harding on 17/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

/*
    Base class for performing updates to the model layer. 

    Currently, generic classes do not work with KVO, therefore this class seems redundant (no type checking on the model object, it is just an NSObject). Hopefully Apple will update this in a future release or some third-party workaround will become available. Once this happens this class should make more sense, it is an abstract base class used to tie a child class to a specific part of the model layer.
*/

class SMGModelController: NSObject {
    
    var model: NSObject
    init(model:NSObject) {
        self.model = model
        super.init()
    }
}
