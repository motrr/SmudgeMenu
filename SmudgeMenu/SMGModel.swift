//  Created by Chris Harding on 15/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class SMGModel : NSObject {
    
    // Basic SMG properties
    var backgroundColour:UIColor = UIColor.redColor() {
        didSet {
            smudgeModel.backgroundColour = self.backgroundColour
            barModel.backgroundColour = self.backgroundColour
        }
    }
    var iconTitleFont:UIFont = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
    
    // Child model objects
    let menuItems:SMGMenuItemsModel = SMGMenuItemsModel()
    let smudgeModel:SMGSmudgeModel = SMGSmudgeModel()
    let barModel:SMGBarModel = SMGBarModel()
}

class SMGMenuItemsModel : NSObject {
    var currentItemId:String?
    var itemsDictionary:Dictionary<String, SMGMenuItemModel> = Dictionary<String, SMGMenuItemModel>()
}

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

class SMGSmudgeModel : NSObject {
    var backgroundColour:UIColor = UIColor.redColor()
    var startPoint: CGPoint = CGPoint(x: 0, y: 0)
    var endPoint: CGPoint = CGPoint(x: 0, y: 0)
    var mainMenuIcon:SMGMainMenuIconModel?
}

class SMGBarModel : NSObject {
    var backgroundColour:UIColor = UIColor.redColor()
}