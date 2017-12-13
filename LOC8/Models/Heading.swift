//
//  Heading.swift
//  LOC8
//
//  Created by Marwan Al Masri on 05/12/2015.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation

/**
  # Direction
 
  ### Discussion:
    The four cardinal directions or cardinal points are the directions of north, east, south, and west, commonly denoted by their initials: N, E, S, W. East and west are at right angles to north and south, with east being in the clockwise direction of rotation from north and west being directly opposite east. 
 
    Intermediate points between the four cardinal directions form the points of the compass. The intermediate (intercardinal, or ordinal) directions are northeast (NE), southeast (SE), southwest (SW), and northwest (NW).
 
    Alos the two vertical directions or cardinal points are the directions of up and down.
 
  - North
  - NorthEast
  - East
  - SouthEast
  - South
  - SouthWest
  - West
  - NorthWest
  - Up
  - Down
 */
public enum Direction: Int {
    
    ///North (N): 0° = 360° in (x, y) plane
    case north = 0
    
    ///North East (NE): 45° in (x, y) plane
    case northEast = 1
    
    ///East (E): 90° in (x, y) plane
    case east = 2
    
    ///South East (SE): 135° in (x, y) plane
    case southEast = 3
    
    ///South (S): 180° in (x, y) plane
    case south = 4
    
    ///South West (SW): 225° in (x, y) plane
    case southWest = 5
    
    ///West (W): 270° in (x, y) plane
    case west = 6
    
    ///North West (NW): 315° in (x, y) plane
    case northWest = 7
    
    ///Up (U): 0° = 360° in (z, x) plane
    case up = 8
    
    ///Down (D): 180° in (z, x) plane
    case down = 9
    
    /**
     Initialize `Direction` object with `Radian` angle.
     
     - Parameter angle: `Radian` value represent the direction angle.
     */
    public init(angle: Radian) {
        
        let d = wrap(angle / (Double.pi / 4))
        
        switch d {
        case 1:
            self = .northEast
        case 2:
            self = .east
        case 3:
            self = .southEast
        case 4:
            self = .south
        case 5:
            self = .southWest
        case 6:
            self = .west
        case 7:
            self = .northWest
        default:
            self = .north
        }
    }
    
}

extension Direction:  CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .north:
            return "North"
        case .northEast:
            return "North East"
        case .east:
            return "East"
        case .southEast:
            return "South East"
        case .south:
            return "South"
        case .southWest:
            return "South West"
        case .west:
            return "West"
        case .northWest:
            return "North West"
        case .up:
            return "Up"
        case .down:
            return "Down"
        }
    }
}


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
        direction = Direction(rawValue: aDecoder.decodeInteger(forKey: "direction"))!
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
public func ==(lhs: Heading, rhs: Heading) -> Bool { return lhs.direction == rhs.direction }

public func !=(lhs: Heading, rhs: Heading) -> Bool { return lhs.direction != rhs.direction }

