//
//  Angle.swift
//  LOC8
//
//  Created by Marwan Al Masri on 14/12/17.
//  Copyright © 2017 LOC8. All rights reserved.
//

import Foundation

/// :nodoc:
public typealias Angle = Double

/**
 The angle is the space between two intersecting lines or surfaces at or close to the point where they meet
 
 ### Discussion:
 In planar geometry, an angle is the figure formed by two rays, called the sides of the angle,
 sharing a common endpoint, called the vertex of the angle.
 Angles formed by two rays lie in a plane, but this plane does not have to be a Euclidean plane.
 
 [Read more](https://en.wikipedia.org/wiki/Angle) about angle.
 */
public extension Angle {
    
    /**
     The degree is the standard unit of angular measure.
     
     Generated as using the following roles:
     
     __degree = radian (180/π)__
     
     ### Discussion:
     
     Degree is a measurement of plane angle, representing 1⁄360 of a full rotation.
     
     - Returns: The angle in dgree unit asuming that the current value is in radian unit.
     */
    var degree: Angle {
        return self * 57.29577951308232286465
    }
    
    /**
     The radian is the standard unit of angular measure.
     
     Generated as using the following roles:
     
     __radian = degree (π/180)__
     
     ### Discussion:
     
     Radians is numerically equal to the length of a corresponding arc of a unit circle;
     one radian is just under 57.3 degrees (when the arc length is equal to the radius).
     
     - Returns: The angle in radian unit asuming that the current value is in dgree unit.
     */
    var radian: Angle {
        return self * 0.01745329251994329547
    }
}
