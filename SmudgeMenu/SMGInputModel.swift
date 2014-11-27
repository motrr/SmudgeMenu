//  Created by Chris Harding on 15/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import Foundation

/*
    These model objects are created, configured and then passed to the menu during and afer initilisation. The are used by the menu to construct it's MVC hierarchy.
*/

class SMGStoryboardVCModel : NSObject {
    var storyboardId:String
    var viewControllerId:String
    init(storyboardId:String, viewControllerId:String) {
        self.storyboardId = storyboardId
        self.viewControllerId = viewControllerId
    }
}

class SMGPageModel : SMGStoryboardVCModel {}
class SMGIconModel : SMGStoryboardVCModel {
    var titleText:String = ""
}

class SMGMainMenuIconModel : SMGStoryboardVCModel {}
