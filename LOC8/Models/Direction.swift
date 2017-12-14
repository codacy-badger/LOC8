//
//  Direction.swift
//  LOC8
//
//  Created by Marwan Al Masri on 13/12/17.
//  Copyright © 2017 LOC8. All rights reserved.
//
//

import Foundation

/**
 # Direction
 
 ### Discussion:
 The four cardinal directions or cardinal points are the directions of north, east, south, and west, commonly denoted by their initials: __N, E, S, W__. East and west are at right angles to north and south, with east being in the clockwise direction of rotation from north and west being directly opposite east.
 
 Intermediate points between the four cardinal directions form the points of the compass. The intermediate (intercardinal, or ordinal) directions are:
 
 - Northeast __NE__
 - Northwest __NW__
 - Southeast __SE__
 - Southwest __SW__
 
 Alos the two vertical directions or cardinal points are the directions of up and down, commonly denoted by their initials: __U, D__
 
 - None
 - North
 - East
 - South
 - West
 - Up
 - Down
 */
public struct Direction: OptionSet, CustomStringConvertible {
    
    //MARK:- Main directions
    
    ///None
    public static let none = Direction(rawValue: 0)
    
    ///North (N): 0° = 360° in (x, y) plane
    public static let north = Direction(rawValue:1)
    
    ///East (E): 90° in (x, y) plane
    public static let east = Direction(rawValue:1 << 1)
    
    ///South (S): 180° in (x, y) plane
    public static let south = Direction(rawValue:1 << 2)
    
    ///West (W): 270° in (x, y) plane
    public static let west = Direction(rawValue:1 << 3)
    
    ///Up (U): 0° = 360° in (p, z) plane where p is the projection in (x, y) plane.
    public static let up = Direction(rawValue:1 << 4)
    
    ///Down (D): 180° in (p, z) plane where p is the projection in (x, y) plane.
    public static let down = Direction(rawValue:1 << 5)
    
    
    //MARK:- Extra directions
    
    //MARK: Horizantel direction
    
    ///North East (NE): 45° in (x, y) plane.
    public static let northEast = [Direction.north, Direction.east]
    
    ///South East (SE): 135° in (x, y) plane.
    public static let southEast = [Direction.south, Direction.east]
    
    ///South West (SW): 225° in (x, y) plane.
    public static let southWest = [Direction.south, Direction.west]
    
    ///North West (NW): 315° in (x, y) plane.
    public static let northWest = [Direction.north, Direction.west]
    
    //MARK: Vertical up directions
    
    ///North Up (NU): 0° = 360° in (x, y) plane
    ///and 0° = 360° in (p, z) plane where p is the projection in (x, y) plane.
    public static let northUp = [Direction.north, Direction.up]
    
    ///North East Up (NEU): 45° in (x, y) plane
    ///and 0° = 360° in (p, z) plane where p is the projection in (x, y) plane.
    public static let northEastUp = [Direction.north, Direction.east, Direction.up]
    
    ///East Up (EU): 90° in (x, y) plane
    ///and 0° = 360° in (p, z) plane where p is the projection in (x, y)
    public static let eastUp = [Direction.east, Direction.up]
    
    ///South East Up (SEU): 135° in (x, y) plane
    ///and 0° = 360° in (p, z) plane where p is the projection in (x, y)
    public static let southEastUp = [Direction.south, Direction.east, Direction.up]
    
    ///South UP (SU): 180° in (x, y) plane
    ///and 0° = 360° in (p, z) plane where p is the projection in (x, y)
    public static let southUp = [Direction.south, Direction.up]
    
    ///South West UP (SWU): 225° in (x, y) plane
    ///and 0° = 360° in (p, z) plane where p is the projection in (x, y)
    public static let southWestUp = [Direction.south, Direction.west, Direction.up]
    
    ///West UP (WU): 270° in (x, y) plane
    ///and 0° = 360° in (p, z) plane where p is the projection in (x, y)
    public static let westUp = [Direction.west, Direction.up]
    
    ///North West UP (NWU): 315° in (x, y) plane
    ///and 0° = 360° in (p, z) plane where p is the projection in (x, y)
    public static let northWestUp = [Direction.north, Direction.west, Direction.up]
    
    
    //MARK: Vertical down directions
    
    ///North Down (ND): 0° = 360° in (x, y) plane
    ///and 180° in (p, z) plane where p is the projection in (x, y) plane.
    public static let northDown = [Direction.north, Direction.down]
    
    ///North East Down (NED): 45° in (x, y) plane
    ///and 180° in (p, z) plane where p is the projection in (x, y) plane.
    public static let northEastDown = [Direction.north, Direction.east, Direction.down]
    
    ///East Down (ED): 90° in (x, y) plane
    ///and 180° in (p, z) plane where p is the projection in (x, y) plane.
    public static let eastDown = [Direction.east, Direction.down]
    
    ///South East Down (SED): 135° in (x, y) plane
    ///and 180° in (p, z) plane where p is the projection in (x, y) plane.
    public static let southEastDown = [Direction.south, Direction.east, Direction.down]
    
    ///South Down (SD): 180° in (x, y) plane
    ///and 180° in (p, z) plane where p is the projection in (x, y) plane.
    public static let southDown = [Direction.south, Direction.down]
    
    ///South West Down (SWD): 225° in (x, y) plane
    ///and 180° in (p, z) plane where p is the projection in (x, y) plane.
    public static let southWestDown = [Direction.south, Direction.west, Direction.down]
    
    ///West Down (WD): 270° in (x, y) plane
    ///and 180° in (p, z) plane where p is the projection in (x, y) plane.
    public static let westDown = [Direction.west, Direction.down]
    
    ///North West Down (NWD): 315° in (x, y) plane
    ///and 180° in (p, z) plane where p is the projection in (x, y) plane.
    public static let northWestDown = [Direction.north, Direction.west, Direction.down]
    
    //MARK:- Methods
    
    public let rawValue : Int
    
    public init(rawValue:Int){
        self.rawValue = rawValue
    }
    
    public init(nilLiteral: ()) {
        self.rawValue = 0
    }
    
    /**
     Initialize `Direction` object with `Radian` angle in (x, y) plaen.
     
     - Parameter angle: `Radian` value represent the direction angle in (x, y) plaen.
     */
    public init(angle: Radian) {
        
        let d_xy = wrap(angle / (Double.pi / 4)) % 8
        
        switch d_xy {
        case 0, 8:
            self = .north
        case 1:
            self = [.north, .east]
        case 2:
            self = .east
        case 3:
            self = [.south, .east]
        case 4:
            self = .south
        case 5:
            self = [.south, .west]
        case 6:
            self = .west
        case 7:
            self = [.north, .west]
        default:
            self = []
        }
    }
    
    /**
     Initialize `Direction` object with two `Radian` angles in (x, y, z) coordenet.
     
     - Parameter theta: Radian value represent the angle in (x, y) plaen.
     - Parameter lambda: Radian value represent the angle in (p, z) plane where p is the projection in (x, y) plane.
     */
    public init(theta: Radian, lambda: Radian) {
        
        let d_z = wrap(lambda / (Double.pi / 4)) % 4
            
        switch d_z {
        case 2://90.0
            self = .up
        case -2://-90.0
            self = .down
        case 1,3:// 45.0, 135.0
            self = Direction(angle: theta)
            self.insert(.up)
        case -1,-3:// -45.0, -135.0
            self = Direction(angle: theta)
            self.insert(.down)
        default:// 0.0, 180.0, -180.0
            self = Direction(angle: theta)
        }
    }
    
    public var description: String {
        
        var values: [String] = []
        var notations: [String] = []
        
        if self.contains(Direction.north) {
            values.append("North")
            notations.append("N")
        } else if self.contains(Direction.south) {
            values.append("South")
            notations.append("S")
        }
        
        if self.contains(Direction.east) {
            values.append("East")
            notations.append("E")
        } else if self.contains(Direction.west) {
            values.append("West")
            notations.append("W")
        }
        
        if self.contains(Direction.up) {
            values.append("Up")
            notations.append("U")
        } else if self.contains(Direction.down) {
            values.append("Down")
            notations.append("D")
        }
        
        return "\(values.joined(separator: " ")) (\(notations.joined(separator: "")))"
    }
}
