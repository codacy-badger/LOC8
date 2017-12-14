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
 Infinity is the maximum `Double` value.
 
 ### Discussion:
 __Infinity__ (symbol: ∞) is an abstract concept describing something without any bound or larger than any number.
 
 - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Infinity)
 */
public let infenity = Double.greatestFiniteMagnitude //DBL_MAX

/**
 Clamping of a value to a range of [max - min].
 
 
 ### Discussion:
 Clamping is the process of limiting a position to an area.
 
 - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Clamping_(graphics))
 
 - Warning: min must be less than or equel max.
 
 - Note: if min is grater than max the values will be swiped.
 
 - Parameter value: the current value.
 - Parameter min: the minimum value.
 - Parameter max: the maximum value.
 
 - Returns: A value if between max and min, otherwise max or min.
 
 */
public func clamp<T: Comparable>(value: T, min: T, max: T) -> T {
    
    //insanaty check
    if max == min {
        return min
    }
    
    var minimum = min
    
    var maximum = max
    
    //insanaty check
    if minimum > maximum { // swap minimum and maximum
        swap(&minimum, &maximum)
    }
    
    if value > maximum {// value is grater than the range
        return maximum
    }
    else if value < minimum {// value is less than the range
        return minimum
    }
    else {// value is within the range
        return value
    }
}


/**
 Wrapping of a value to a range of [0 - 1].
 
 ### Discussion:
 Wrapping is the process of limiting a position to an area.
 
 - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Wrapping_(graphics))
 
 - Parameter value: a double represent the value to be wraped.
 
 - Returns: An integer value wrapped.
 */
public func wrap(_ value: Double) -> Int {
    let intValue = Int(value)
    let delta = value - Double(intValue)
    return delta >= 0.5 ? intValue + 1 : intValue
}

/**
 Rotating a value in a range of [max - min].
 
 ### Discussion:
 Rotating is the process of limiting a position to an area by rotating the value within the range.
 
 - Parameters:
 - value: the current value.
 - min: the minimum value.
 - max: the maximum value.
 
 - Returns: A rotated value if between max and min.
 
 */
public func rotate(value: Double, min: Double, max: Double) -> Double {
    
    //insanaty check
    if max < min {
        return value
    }
    
    if value > max {// value is grater than the range
        return min + Double(Int(value - max) % Int(max - min))
    }
    else if value < min {// value is less than the range
        return max - Double(Int(min - value) % Int(max - min))
    }
    else {// value is within the range
        return value
    }
}

/**
 Truncating a number to a specified number after decimal places.
 
 ### Discussion:
 A method of approximating a decimal number by dropping all decimal places past a certain point without rounding.
 
 Example:
 
 ```swift
 let value = truncate(3.14159265, decimalPlaces: 4)
 // value will be 3.1415
 ```
 
 - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Truncation)
 
 - Parameters:
 - value: represent current value.
 - decimalPlaces: represent value to a specified number after decimal places.
 
 - Returns: the truncated value.
 */
public func truncate(value: Double, decimalPlaces place: UInt) -> Double {
    let v = abs(value)
    let sign = value < 0 ? -1.0 : 1.0
    return sign * Double(floor(pow(10.0, Double(place)) * v)/pow(10.0, Double(place)))
}



