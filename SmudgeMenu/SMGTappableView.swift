//  Created by Chris Harding on 18/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

protocol SMGTappableViewDelegate {
    
    func viewWasTapped(location:CGPoint)
}

class SMGTappableView : UIView {
    
    var delegate:SMGTappableViewDelegate?
    var tappable = true
    
    private var tapRecognizer:UITapGestureRecognizer!
    
    override init() {
        super.init()
        setupTapRecogniser()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTapRecogniser()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTapRecogniser()
    }
    
    func setupTapRecogniser() {
        tapRecognizer = UITapGestureRecognizer(target:self, action:"didTap:")
        self.addGestureRecognizer(tapRecognizer)
    }
    
    func didTap(tg:UITapGestureRecognizer) {
        
        if (tappable) {
           delegate!.viewWasTapped(tg.locationInView(self))
        }
    }
}
