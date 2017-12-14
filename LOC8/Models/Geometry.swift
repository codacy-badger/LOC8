//
//  Geometry.swift
//  LOC8
//
//  Created by Marwan Al Masri on 3/27/16.
//  Copyright © 2016 LOC8. All rights reserved.
//

import Foundation


//MARK: Generics


/**
  Clamping of a value to a range of [max - min].
 
 
 ### Discussion:
    Clamping is the process of limiting a position to an area.To read more abut clamping [Wikipedia](https://en.wikipedia.org/wiki/Clamping_(graphics))
 
  - Parameter value: the current value.
  - Parameter min: the minimum value.
  - Parameter max: the maximum value.

  - Returns: A value between max and min.
 
 */
public func clamp<T: Comparable>(_ value: T, min: T, max: T) -> T {
    //insanaty check
    if max < min {
        return value
    }
    
    if value > max {
        return max
    } else if value < min {
        return min
    } else {
        return value
    }
}

/**
 Wrapping of a value to a range of [0 - 1].
 
 ### Discussion:
    Wrapping is the process of limiting a position to an area.
 
  - Parameter value: a double represent the value to be wraped.
 
  - Returns: An integer value wrapped.
 */
public func wrap(_ value: Double) -> Int {
    let intValue = Int(value)
    let delta = value - Double(intValue)
    return delta >= 0.5 ? intValue + 1 : intValue
}

/**
  # Radian

  ### Discussion:
    The radian is the standard unit of angular measure.

    Radians is numerically equal to the length of a corresponding arc of a unit circle;
    one radian is just under 57.3 degrees (when the arc length is equal to the radius).
 */
public typealias Radian = Double

public extension Radian {
    ///Return the angle in degree.
    public var degree: Degree {
        return self * 57.29577951308232286465
    }
}

/**
  # Degree

  ### Discussion:
    The degree is the standard unit of angular measure.

    Degree is a measurement of plane angle, representing 1⁄360 of a full rotation.
 */
public typealias Degree = Double

public extension Degree {
    
    ///Returns the angle in radian.
    public var radian: Radian {
        return self * 0.01745329251994329547
    }
}







