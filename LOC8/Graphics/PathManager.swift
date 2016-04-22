//
//  PathManager.swift
//  LOC8Display
//
//  Created by Marwan Al Masri on 12/5/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation
import SceneKit

class PathManager {
    
    let startPoint = SCNVector3Make(0, 0, 0)
    var movements: [Movement] = []

    init() {
//        self.initData()
    }
    
    func initData(data: [Heading]) {
        
        self.movements = []
        
        for heading in data {
            movements.append(Movement(heading: heading))
        }
        
        self.movements = [
            Movement(distance: 10, direction: .North),
            Movement(distance: 10, direction: .East),
            Movement(distance: 2, direction: .East),
            Movement(distance: 3, direction: .Up),
            Movement(distance: 5, direction: .North),
            Movement(distance: 2, direction: .West),
            Movement(distance: 2, direction: .Down),
            Movement(distance: 4, direction: .South)
        ]
    }
    
    
    
}

extension PathManager {
    class var sharedInstance: PathManager {
        struct Signleton {
            static let instance = PathManager()
        }
        
        return Signleton.instance
    }
}