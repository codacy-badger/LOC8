//
//  Path.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/16/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation
import SceneKit

public struct Movement {
    public var direction: Direction
    public let distance: Float
    
    public init(distance: Float, direction: Direction) {
        self.distance = distance / 2
        self.direction = direction
    }
    
    public init(heading: Heading) {
        self.distance = Float(heading.distance / 2.0)
        self.direction = heading.direction
    }
}
public class Path: NSObject {
    
    public let startPoint = SCNVector3Make(0, 0, 0)
    public var movements: [Movement] = []
    
    public override init() {
        super.init()
    }
    
    public convenience init(data: [Heading]) {
        self.init()
        
        self.movements = []
        
        for heading in data {
            movements.append(Movement(heading: heading))
        }
    }
}
