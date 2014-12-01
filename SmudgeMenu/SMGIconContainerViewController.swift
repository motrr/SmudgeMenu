//  Created by Chris Harding on 28/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGIconContainerViewController : UIViewController {
    
    var xConstraint:NSLayoutConstraint!
    var yConstraint:NSLayoutConstraint!
    
    var tapRecognizer:UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapRecognizer = UITapGestureRecognizer(target:self, action:"didTap:")
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func didTap(tg:UITapGestureRecognizer) {
        fatalError( "Override this method to implement desired tap behavior" )
    }
}
