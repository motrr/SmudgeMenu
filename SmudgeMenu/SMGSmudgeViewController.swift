//  Created by Chris Harding on 19/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGSmudgeViewController : UIViewController {
    
    let smudgeView = SMGSmudgeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(smudgeView)
        smudgeView.snp_makeConstraints { make in
            make.edges.equalTo(self.view); return
        }

    }
}