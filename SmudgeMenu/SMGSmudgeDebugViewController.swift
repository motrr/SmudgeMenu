//  Created by Chris Harding on 18/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGSmudgeDebugViewController : UIViewController {
    
    let startPointIndicatorView = SMGPointIndicatorView()
    let controlPointAIndicatorView = SMGPointIndicatorView()
    let controlPointBIndicatorView = SMGPointIndicatorView()
    let endPointIndicatorView = SMGPointIndicatorView()
    
    let indicatorViewRadius:CGFloat = 10
    
    let curveView = SMGCurveView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(curveView)
        curveView.snp_makeConstraints { make in
            make.edges.equalTo(self.view); return
        }
        curveView.radius = 5
        
        for indicatorView in [startPointIndicatorView, controlPointAIndicatorView, controlPointBIndicatorView, endPointIndicatorView] {
            self.view.addSubview(indicatorView)
            indicatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
            indicatorView.circleRadius = indicatorViewRadius
        }
    }
}

extension SMGSmudgeDebugViewController : SMGCurveResponder {
    
    func didUpdateCurve(curve: SMGBezierCurve) {

        startPointIndicatorView.center = curve.a
        controlPointAIndicatorView.center = curve.b
        controlPointBIndicatorView.center = curve.c
        endPointIndicatorView.center = curve.d
        
        curveView.didUpdateCurve(curve)
    }
}