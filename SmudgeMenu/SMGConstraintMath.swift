//  Created by Chris Harding on 17/10/2014.
//  Copyright (c) 2014 Motrr. All rights reserved.
//

import UIKit

infix operator + { precedence 150 }

func + (tuple:(UIView, NSLayoutAttribute),
    c:CGFloat) -> (UIView, NSLayoutAttribute, CGFloat) {
        return (tuple.0, tuple.1, c)
}

infix operator => {}

func => (lhs:(UIView, NSLayoutAttribute),
    rhs:(UIView, NSLayoutAttribute, CGFloat)) -> NSLayoutConstraint {
        var constraint = NSLayoutConstraint(
            item:lhs.0,
            attribute:lhs.1,
            relatedBy:.Equal,
            toItem:rhs.0,
            attribute:rhs.1,
            multiplier:1,
            constant:rhs.2 )
        rhs.0.addConstraint(constraint)
        return constraint
}

func => (lhs:(UIView, NSLayoutAttribute),
    rhs:(UIView, NSLayoutAttribute)) -> NSLayoutConstraint {
        return lhs => rhs + 0
}

// Not working for some reason :(
func => (lhs:(UIView, NSLayoutAttribute),
    rhs:(CGFloat)) -> NSLayoutConstraint {
        var constraint = NSLayoutConstraint(
            item:lhs.0,
            attribute:lhs.1,
            relatedBy:NSLayoutRelation.Equal,
            toItem:nil,
            attribute:NSLayoutAttribute.NotAnAttribute,
            multiplier:1,
            constant:rhs.0 )
        lhs.0.addConstraint(constraint)
        return constraint
}

func => (lhs:(UIView, NSLayoutAttribute, NSLayoutAttribute),
    rhs:(CGSize)) {
        (lhs.0, lhs.1) => rhs.width
        (lhs.0, lhs.2) => rhs.height
}

func centerX (v:UIView) -> (UIView, NSLayoutAttribute) { return (v, .CenterX) }
func centerY (v:UIView) -> (UIView, NSLayoutAttribute) { return (v, .CenterY) }

func width (v:UIView) -> (UIView, NSLayoutAttribute) { return (v, .Width) }
func height (v:UIView) -> (UIView, NSLayoutAttribute) { return (v, .Height) }

func size (v:UIView) -> (UIView, NSLayoutAttribute, NSLayoutAttribute) { return (v, .Width, .Height) }

func top (v:UIView) -> (UIView, NSLayoutAttribute) { return (v, .Top) }
func bottom (v:UIView) -> (UIView, NSLayoutAttribute) { return (v, .Bottom) }
func left (v:UIView) -> (UIView, NSLayoutAttribute) { return (v, .Left) }
func right (v:UIView) -> (UIView, NSLayoutAttribute) { return (v, .Right) }

// Convenience
func fullyContain(v1:UIView, v2:UIView) {
    top(v1) => top(v2)
    bottom(v1) => bottom(v2)
    left(v1) => left(v2)
    right(v1) => right(v2)
}
