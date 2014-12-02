//  Created by Chris Harding on 15/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

/*
    These model objects are created, configured and then passed to the menu during and afer initilisation. The are used by the menu to construct it's MVC hierarchy.
*/

class SMGMenuItemModel : NSObject {
    
    var itemId:String
    var pageModel:SMGPageModel
    var iconModel:SMGIconModel
    
    init(itemId:String, pageModel:SMGPageModel, iconModel:SMGIconModel) {
        self.itemId = itemId
        self.pageModel = pageModel
        self.iconModel = iconModel
    }
}

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
    var titleFont:UIFont = UIFont.systemFontOfSize(UIFont.systemFontSize())
    var titleText:String = ""
}

class SMGMainMenuIconModel : SMGStoryboardVCModel {}
