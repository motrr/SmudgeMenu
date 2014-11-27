//  Created by Chris Harding on 17/11/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

/*
    Generic class for observing and reacting to changes in model layer.
*/

private var modelContext = "modelContext"

class SMGModelObserver: NSObject {
    
    func keyPaths() -> [String] {
        fatalError("Override this method in your subclass to observe your desired key paths")
        return []
    }
    
    var model: NSObject
    init(model:NSObject) {
        self.model = model
        super.init()
        addModelObservers()
    }
    deinit {
        removeModelObservers()
    }
    
    private func addModelObservers() {
        for keyPath in keyPaths() {
            model.addObserver(self, forKeyPath: keyPath, options: .New, context: &modelContext)
        }
    }
    private func removeModelObservers() {
        for keyPath in keyPaths() {
            model.removeObserver(self, forKeyPath: keyPath)
        }
    }
    
    override func observeValueForKeyPath(
        keyPath: String,
        ofObject object: AnyObject,
        change: [NSObject: AnyObject],
        context: UnsafeMutablePointer<Void>)
    {
        if context == &modelContext {
            let validKeyPaths = keyPaths()
            switch keyPath {
            case let validKeyPath where contains(validKeyPaths, validKeyPath) :
                modelDidChange(validKeyPath)
                return
            default: ()
            }
        }
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
    
    func modelDidChange(keyPath:String) {
        fatalError("Override this method in your subclass to handle observation of key path")
    }
}
