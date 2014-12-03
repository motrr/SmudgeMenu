//  Created by Chris Harding on 03/12/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

extension UIView {
    
    func deepCopy() -> UIView {
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        let copy = NSKeyedUnarchiver.unarchiveObjectWithData(data)!  as UIView
        
        return copy
    }
}