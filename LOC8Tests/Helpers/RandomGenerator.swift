//
//  RandomGenerator.swift
//  LOC8
//
//  Created by Marwan Al Masri on 6/6/16.
//  Copyright © 2016 LOC8. All rights reserved.
//

import Foundation

import LOC8

public class RandomGenerator {
    
    // MARK: Types and Numeric
    
    /**
     Random boolean
     
     Method that returns a random `Bool` value.
     - Returns: Random `Bool` value (__true__ or __false__).
     */
    public class func boolean() -> Bool {
        return arc4random_uniform(2) == 0 ? true: false
    }
    
    /**
     Random number
     
     Method that takes tow numbers values that represent a range, and return a random value within that range.
     
     ```swift
     number(-100, end: 100) //[-100 » 100]
     ```
     - Parameters:
         - start: A value represent the range start value. __Default value is -2000__
         - end: A value represent the range end value. __Default value is 2000__
     - Returns: Random value between start and end.
     - Note: if start value is greater than end value the values will swip, and the result will be in the range [end » start].
     */
    public class func integer(from start: Int = -2000, to end: Int = 2000) -> Int {
        
        // Inanity check
        if start == end {
            return start
        }
        
        var minimum = start
        
        var maximum = end
        
        // Prevent negative crashes
        if minimum > maximum { // swap minimum and maximum
            swap(&minimum, &maximum)
        }
        
        return Int(arc4random_uniform(UInt32(maximum - minimum + 1))) + minimum
    }
    
    /**
     Random floate number
     
     Method that takes tow `Float` values that represent a range, and return a random `Float` value within that range.
     
     ```swift
     float(-1.2, end: 10.9) // value in range [-1.2 » 10.9]
     ```
     - Parameters:
         - start: A `Float` value represent the range start value. __Default value is -2000__
         - end: A `Float` value represent the range end value. __Default value is 2000__
     - Returns: Random `Float` value between start and end.
     - Note: if start value is greater than end value the values will be swiped. The result will be in the range [end » start].
     */
    public class func float(from start: Float = -2000, to end: Float = 2000) -> Float {
        
        // Inanity check
        if start == end {
            return start
        }
        
        var minimum = start
        
        var maximum = end
        
        // Prevent negative crashes
        if minimum > maximum { // swap minimum and maximum
            swap(&minimum, &maximum)
        }
        
        // craete random number
        let random = Float(Int.max) / Float(arc4random())
        // find the range
        let range = abs(minimum - maximum)
        // find the range sign either 1 or -1
        let sign = range / abs(minimum - maximum)
        
        return sign * Float(Int(random) % Int(range)) + minimum
    }
    
    /**
     Random double number
     
     Method that takes tow `Double` values that represent a range, and return a random `Double` value within that range.
     
     ```swift
     double(-134.652, end: 301.794) // value in range [-134.652 » 301.794]
     ```
     - Parameters:
         - start: A `Double` value represent the range start value. __Default value is -2000__
         - end: A `Double` value represent the range end value. __Default value is 2000__
     - Returns: Random `Double` value between start and end.
     - Note: if start value is greater than end value the values will be swiped. The result will be in the range [end » start].
     */
    public class func double(from start: Double = -2000, to end: Double = 2000) -> Double {
        
        // Inanity check
        if start == end {
            return start
        }
        
        var minimum = start
        
        var maximum = end
        
        // Prevent negative crashes
        if minimum > maximum { // swap minimum and maximum
            swap(&minimum, &maximum)
        }
        
        // craete random number
        let random = Double(Int.max) / Double(arc4random())
        // find the range
        let range = abs(minimum - maximum)
        // find the range sign either 1 or -1
        let sign = range / abs(minimum - maximum)
        
        return sign * random.truncatingRemainder(dividingBy: range) + minimum
    }
    
    // MARK: Angels
    
    /**
     Random Angel
     
     Method that takes tow angles in `Angle` and return a random angle in `Angle`.
     
     ```swift
     angel(30, max: 60) // angle is [30˚ » 60˚]
     angel(60, max: 30) // angle is [60˚ » 360˚ » 30˚]
     ```
     - Parameters:
         - min: `Angle` value represent minimum angle. __Default value is 0˚__
         - max: `Angle` value represent maximum angle. __Default value is 360˚__
     - Returns: Random angle in degree between min and max.
     - Note: if minimum value is greater than maximum the result will be in the range [min » 360˚] & [0˚ » max].
     */
    public class func angel(min: Angle = 0, max: Angle = 360) -> Angle {
        
        // Inanity check
        if min == max {
            return min
        }
        
        if min < max {// the value is bettween [min, max]
            let angle = Angle(arc4random_uniform(UInt32(max - min))) + min
            return angle
        }
        else {// the value is between [min, (0˚ = 360˚), max]
            if self.boolean() {
                return self.angel(min: 0, max: max)
            }
            else {
                return self.angel(min: min, max: 360)
            }
        }
    }
    
    /**
     Random Angel
     
     Method that takes an angle and a deference in `Angle`, and return a random angle in `Angle` withun the range (angle ± deference).
     
     ```swift
     angel(60, deference: 30) // angle is [30˚ » 90˚]
     angel(0, deference: 30) // angle is [330˚ » 30˚]
     ```
     - Parameters:
         - angle: `Angle` value represent the base angle.
         - deference: `Angle` value represent the deference for the result range _(angle ± deference)_. __Default value is 0˚__
     - Returns: Random angle in `Angle` between min and max.
     - Note: if minimum value is greater than maximum the result will be in the range [min » 360˚] & [0˚ » max].
     */
    public class func angel(angle: Angle, deference: Angle = 0) -> Angle {
        
        // Inanity check
        if deference == 0 {
            return angle
        }
        
        
        
        let min = Geometry.rotate(value: angle - deference, min:0, max:360)
        let max = Geometry.rotate(value: angle + deference, min:0, max:360)
        
        let result = self.angel(min: min, max: max)
        
        return result
        
    }
    
    // MARK: Geometry
    
    /**
     Random vector
     
     Method that returns a random `Vector3D` object.
     - Returns: Random `Vector3D` object.
     */
    public class func vector() -> Vector3D {
        return Vector3D(
            x: RandomGenerator.double(from: -1000000, to: 1000000),
            y: RandomGenerator.double(from: -1000000, to: 1000000),
            z: RandomGenerator.double(from: -1000000, to: 1000000)
        )
    }
    
    /**
     Random vector
     
     Method that returns a random `Vector3D` object.
     - Returns: Random `Vector3D` object.
     */
    public class func rotation() -> Rotation3D {
        return Rotation3D(
            roll: RandomGenerator.angel(),
            pitch: RandomGenerator.angel(),
            yaw: RandomGenerator.angel()
        )
    }
    
}
