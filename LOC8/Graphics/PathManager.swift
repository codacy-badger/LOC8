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
    
    ///Get currently used PathManager, singleton pattern
    static let shared: PathManager  = PathManager()
    
    let startPoint = SCNVector3Make(0, 0, 0)
    var movements: [Movement] = []

    init() {
//        self.initData()
    }
    
    func initData(_ data: [Motion]) {
        
        self.movements = []
        
        for heading in data {
            movements.append(Movement(heading: heading))
        }
        
        self.movements = [
            Movement(distance: 10, direction: .north),
            Movement(distance: 10, direction: .east),
            Movement(distance: 2, direction: .east),
            Movement(distance: 3, direction: .up),
            Movement(distance: 5, direction: .north),
            Movement(distance: 2, direction: .west),
            Movement(distance: 2, direction: .down),
            Movement(distance: 4, direction: .south)
        ]
    }
    
    
    
}
