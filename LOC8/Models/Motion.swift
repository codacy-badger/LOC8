//
//  Motion.swift
//  LOC8
//
//  Created by Marwan Al Masri on 14/12/17.
//  Copyright © 2017 LOC8. All rights reserved.
//

import Foundation

/**
 An object the represent a motion in three dimensions.
 
 ### Discussion:
 In physics, motion is a description of the position of an object over time. Motion may be described in terms of displacement, distance, velocity, acceleration, time and speed.
 
 This object contains distance and waight also to present the repetition of the object along distance.
 */
open class Motion: Measurement {
    
    //MARK: Properties
    
    ///Direction value prosent the direction of the motion.
    open var direction: Direction = .north
    
    ///Double value present the distance for the motion.
    open var distance: Double = 0
    
    ///Integer value present the wight of the motion.
    open var wight: UInt = 0
    
    
    //MARK: Initialization
    
    /**
     Initialize Motion object with an angel
     
     - Parameter angle: the angel of the motion in radian.
     */
    public init(angle: Angle) {
        super.init()
        self.direction = Direction(angle: angle)
    }
    
    /**
     Initialize Motion object with an angel
     
     - Parameter direction: the direction of the motion.
     */
    public init(direction: Direction) {
        super.init()
        self.direction = direction
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        direction = Direction(rawValue: aDecoder.decodeInteger(forKey: "direction"))
        distance = aDecoder.decodeDouble(forKey: "distance")
        wight = UInt(aDecoder.decodeInteger(forKey: "wight"))
    }
    
    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(direction.rawValue, forKey: "direction")
        aCoder.encode(distance, forKey: "distance")
        aCoder.encode(Int(wight), forKey: "wight")
    }
    
    open override var description: String {
        var result = ""
        if distance == 0 {
            result = "Motion \(self.direction) with wight \(wight)."
        } else {
            let distance = NSString(format: "%.2f", self.distance)
            result = "[\(self.direction), \(wight), \(distance)]"
        }
        
        return result
    }
    
    //MARK: Logical operators
    
    public static func ==(lhs: Motion, rhs: Motion) -> Bool {
        return lhs.direction == rhs.direction
    }
    
    public static func !=(lhs: Motion, rhs: Motion) -> Bool {
        return lhs.direction != rhs.direction
    }
}

