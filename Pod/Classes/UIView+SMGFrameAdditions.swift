//  Created by Chris Harding on 18/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

extension UIView {
    
    var height:CGFloat {
        get {
            return self.frame.size.height
        }
        
        set {
            self.frame.size.height = newValue
        }
    }
    
    var width:CGFloat {
        get {
            return self.frame.size.width
        }
        
        set {
            self.frame.size.width = newValue
        }
    }
    
    var x:CGFloat {
        get {
            return self.frame.origin.x
        }
        
        set {
            self.frame.origin.x = newValue
        }
    }
    
    var y:CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var centreX:CGFloat {
        get {
            return self.frame.origin.x + (self.frame.size.width/2.0)
        }
        
        set {
            self.frame.origin.x = newValue - (frame.size.width / 2.0);
        }
    }
    
    var centreY:CGFloat {
        get {
            return self.frame.origin.y + (self.frame.size.height/2.0)
        }
        
        set {
            self.frame.origin.y = newValue - (frame.size.height / 2.0);
        }
    }
    
    var size:CGSize {
        get {
            return self.frame.size
        }
        
        set {
            self.width = newValue.width;
            self.height = newValue.height;
        }
    }
    
    var centre:CGPoint {
        get {
            return CGPointMake(self.centreX, self.centreY)
        }
        
        set {
            self.centreX = newValue.x;
            self.centreY = newValue.y;
        }
    }
    
    var origin:CGPoint {
        get {
            return CGPointMake(self.x, self.y);
        }
        
        set {
            self.x = newValue.x;
            self.y = newValue.y;
        }
    }

}