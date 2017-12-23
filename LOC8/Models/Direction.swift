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
 An object the hold a geometrical dirction in three dimensions.
 
 ### Discussion:
 The four cardinal directions or cardinal points are the directions of north, east, south, and west, commonly denoted by their initials: __N, E, S, W__.
 East and west are at right angles to north and south, with east being in the clockwise direction of rotation from north and west being directly opposite east.
 
 Intermediate points between the four cardinal directions form the points of the compass. The intermediate (intercardinal, or ordinal) directions are:
 
 - Northeast __NE__
 - Northwest __NW__
 - Southeast __SE__
 - Southwest __SW__
 
 Alos the two vertical directions or cardinal points are the directions of up and down, commonly denoted by their initials: __U, D__
 
 __Up Diraction__
 - Up           __U__
 - North Up     __NU__
 - Northeast Up __NEU__
 - East Up      __EU__
 - Southeast Up __SEU__
 - South Up     __SU__
 - Southwest Up __SWU__
 - West Up      __WU__
 - Northwest Up __NWU__
 
 __Down Diraction__
 - Down           __D__
 - North Down     __ND__
 - Northeast Down __NED__
 - East Down      __ED__
 - Southeast Down __SED__
 - South Down     __SD__
 - Southwest Down __SWD__
 - West Down      __WD__
 - Northwest Down __NWD__
 
 */
public struct Direction: OptionSet, CustomStringConvertible {
    
    //MARK:-
    //MARK: Main directions
    
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
    
    
    //MARK:-
    
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
    
    //MARK:-
    //MARK: Methods
    
    public let rawValue : Int
    
    public init(rawValue:Int){
        self.rawValue = rawValue
    }
    
    public init(nilLiteral: ()) {
        self.rawValue = 0
    }
    
    /**
     Initialize `Direction` object with `Angle` angle in (x, y) plaen.
     
     - Parameter angle: `Angle` value represent the direction angle in (x, y) plaen.
     */
    public init(angle: Angle) {
        
        self = []
        
        let phi = angle
        func isBetween(_ min: Angle, _ max: Angle) -> Bool {
            return phi >= min.radian && phi <= max.radian
        }
        
        if isBetween(-67.5, 67.5) {
            self.insert(.north)
        } else if isBetween(-180.0, -112.5) || isBetween(112.5, 180.0) {
            self.insert(.south)
        }
        
        if isBetween(22.5, 157.5) {
            self.insert(.east)
        } else if isBetween(-157.5, -22.5) {
            self.insert(.west)
        }
    }
    
    /**
     Initialize `Direction` object with two `Angle` angles in (x, y, z) coordenet.
     
     - Parameter theta: Angle value represent the angle in (x, y) plaen.
     - Parameter lambda: Angle value represent the angle in (p, z) plane where p is the projection in (x, y) plane.
     */
    public init(theta: Angle, phi: Angle) {
        
        func isBetween(_ min: Angle, _ max: Angle) -> Bool {
            return theta >= min.radian && theta <= max.radian
        }
        
        if isBetween(0, 22.5) {
            self = .up
            return
        } else if isBetween(157.5, 180.0) {
            self = .down
            return
        }
        
        self = Direction(angle: phi)
        
        if isBetween(22.5, 67.5) {
            self.insert(.up)
        } else if isBetween(112.5, 157.5) {
            self.insert(.down)
        }
    }
    
    public var description: String {
        
        if self == .none {
            return "No diriction"
        }
        
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
