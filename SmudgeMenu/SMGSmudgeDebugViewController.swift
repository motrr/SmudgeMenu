//  Created by Chris Harding on 18/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

typealias ConstraintPair = (x:NSLayoutConstraint, y:NSLayoutConstraint)

class SMGSmudgeDebugViewController : UIViewController {
    
    var startPointIndicatorView = SMGPointIndicatorView()
    var controlPointAIndicatorView = SMGPointIndicatorView()
    var controlPointBIndicatorView = SMGPointIndicatorView()
    var endPointIndicatorView = SMGPointIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for indicatorView in [startPointIndicatorView, controlPointAIndicatorView, controlPointBIndicatorView, endPointIndicatorView] {
            self.view.addSubview(indicatorView)
            indicatorView.snp_makeConstraints { make in
                make.size.equalTo(CGSize(width: 20, height: 20)); return
            }
        }
    }
}

extension SMGSmudgeDebugViewController : SMGCurveResponder {
    
    func updateCurve(startPoint: CGPoint, controlPointA: CGPoint, controlPointB: CGPoint, endPoint: CGPoint) {

        startPointIndicatorView.center = startPoint
        controlPointAIndicatorView.center = controlPointA
        controlPointBIndicatorView.center = controlPointB
        endPointIndicatorView.center = endPoint
    }
}