//  Created by Chris Harding on 23/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import Foundation

class Observable<T> {
    
    typealias WillSet = (currentValue:T?,tobeValue:T?)->()
    typealias DidSet = (oldValue:T?,currentValue:T?)->()
    typealias Observer = (pre:WillSet,post:DidSet)
    
    var observers = Dictionary<String,Observer>()
    
    var observableProperty:T? {
        willSet(newValue){
            for (identifier,observer) in observers{
                observer.pre(currentValue: observableProperty,tobeValue: newValue)
            }
        }
        didSet{
            for (identifier,observer) in observers{
                observer.post(oldValue: oldValue,currentValue: observableProperty)
            }
        }
    }
    
    func addObserver(identifier:String, observer:Observer){
        observers[identifier] = observer
    }
    
    func removeObserver(identifer:String){
        observers.removeValueForKey(identifer)
    }
    
    init(initialValue:T?){
        observableProperty = initialValue
    }
}