//
//  Heading.swift
//  LOC8
//
//  Created by Marwan Al Masri on 05/12/2015.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation

//MARK:- Direction

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
    case North = 0
    
    ///North East (NE): 45° in (x, y) plane
    case NorthEast = 1
    
    ///East (E): 90° in (x, y) plane
    case East = 2
    
    ///South East (SE): 135° in (x, y) plane
    case SouthEast = 3
    
    ///South (S): 180° in (x, y) plane
    case South = 4
    
    ///South West (SW): 225° in (x, y) plane
    case SouthWest = 5
    
    ///West (W): 270° in (x, y) plane
    case West = 6
    
    ///North West (NW): 315° in (x, y) plane
    case NorthWest = 7
    
    ///Up (U): 0° = 360° in (z, x) plane
    case Up = 8
    
    ///Down (D): 180° in (z, x) plane
    case Down = 9
    
    /**
     Initialize `Direction` object with `Radian` angle.
     
     - Parameter angle: `Radian` value represent the direction angle.
     */
    public init(angle: Radian) {
        
        let d = wrap(angle / (M_PI / 4))
        
        switch d {
        case 1:
            self = .NorthEast
        case 2:
            self = .East
        case 3:
            self = .SouthEast
        case 4:
            self = .South
        case 5:
            self = .SouthWest
        case 6:
            self = .West
        case 7:
            self = .NorthWest
        default:
            self = .North
        }
    }
    
}

extension Direction:  CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .North:
            return "North"
        case .NorthEast:
            return "North East"
        case .East:
            return "East"
        case .SouthEast:
            return "South East"
        case .South:
            return "South"
        case .SouthWest:
            return "South West"
        case .West:
            return "West"
        case .NorthWest:
            return "North West"
        case .Up:
            return "Up"
        case .Down:
            return "Down"
        }
    }
}


//MARK:- Heading


/**
 # Heading
 
   ### Discussion:
    In a contemporary land navigation context, heading is measured with true north, magnetic north, or grid north being 0° in a 360-degree system.
 
    This object contains distance and waight also to present the repetition of the object along distance.
 */
public class Heading: Measurement {
    
    //MARK: Properties
    
    ///Direction value prosent the direction of the heading.
    public var direction: Direction = .North
    
    ///Double value present the distance for the heading.
    public var distance: Double = 0
    
    ///Integer value present the wight of the heading.
    public var wight: UInt = 0
    
    
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
        direction = Direction(rawValue: aDecoder.decodeIntegerForKey("direction"))!
        distance = aDecoder.decodeDoubleForKey("distance")
        wight = UInt(aDecoder.decodeIntegerForKey("wight"))
    }
    
    public override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeInteger(direction.rawValue, forKey: "direction")
        aCoder.encodeDouble(distance, forKey: "distance")
        aCoder.encodeInteger(Int(wight), forKey: "wight")
    }
    
    public override var description: String {
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

//MARK:- Heading Operators

//MARK:Logical operators
public func ==(lhs: Heading, rhs: Heading) -> Bool { return lhs.direction == rhs.direction }

public func !=(lhs: Heading, rhs: Heading) -> Bool { return lhs.direction != rhs.direction }

