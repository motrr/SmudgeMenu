//  Created by Chris Harding on 18/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch (segue.identifier) {
        case "SmudgeMenuSegue" :
            
            var smudgeMenu = segue.destinationViewController as SMGMenu
            self.setupSmudgeMenu(smudgeMenu)
            
        default : ()
        }
    }
    
    // Setup the smudge menu with icons and pages, in this case pulled from storyboard files
    func setupSmudgeMenu(menu:SMGMenu) {
        
        // Pull icons and pages from storyboard
        for identifier in ["PageA", "PageB", "PageC", "PageD"] {
            
            var menuItem:SMGMenuItem = SMGMenuItem(
                iconStoryboardId: "Icons",
                pageStoryboardId: "Pages",
                itemId: identifier)
            
            menu.addItem( menuItem )
        }

    }
}

