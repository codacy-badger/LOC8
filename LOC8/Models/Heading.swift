//
//  Heading.swift
//  LOC8
//
//  Created by Marwan Al Masri on 05/12/2015.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation

/**
 # Heading
 
   ### Discussion:
    In a contemporary land navigation context, heading is measured with true north, magnetic north, or grid north being 0° in a 360-degree system.
 
    This object contains distance and waight also to present the repetition of the object along distance.
 */
open class Heading: Measurement {
    
    //MARK: Properties
    
    ///Direction value prosent the direction of the heading.
    open var direction: Direction = .north
    
    ///Double value present the distance for the heading.
    open var distance: Double = 0
    
    ///Integer value present the wight of the heading.
    open var wight: UInt = 0
    
    
    //MARK:Initialization
    
    /**
      Initialize Heading object with an angel
     
      - Parameter angle: the angel of the heading in radian.
     */
    public init(angle: Radian) {
        super.init()
        self.direction = Direction(angle: angle)
    }
    
    /**
      Initialize Heading object with an angel
     
      - Parameter direction: the direction of the heading.
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
            result = "Heading \(self.direction) with wight \(wight)."
        }
        else {
            let distance = NSString(format: "%.2f", self.distance)
            result = "[\(self.direction), \(wight), \(distance)]"
        }
        
        return result
    }
}

//MARK:Logical operators
public func ==(lhs: Heading, rhs: Heading) -> Bool {
    return lhs.direction == rhs.direction
}

public func !=(lhs: Heading, rhs: Heading) -> Bool {
    return lhs.direction != rhs.direction
}

