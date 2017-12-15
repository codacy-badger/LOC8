//
//  CartesianVector.swift
//  LOC8
//
//  Created by Marwan Al Masri on 13/12/17.
//  Copyright © 2017 LOC8. All rights reserved.
//

import Foundation

/**
 # CartesianVector
 
 ### Discussion:
 Type represent a cartesian coordinate in three-dimensional coordinate system.
 If v is an instance of `CartesianVector`, mathematically it represents
 the following vector:
 
 ````
 v = (x, y, z)
 ````
 */
public struct CartesianVector: CustomStringConvertible {
    
    ///Double value represent the projection on x-axis.
    private(set) var x: Double = 0.0
    
    ///Double value represent the projection on y-axis.
    private(set) var y: Double = 0.0
    
    ///Double value represent the projection on z-axis.
    private(set) var z: Double = 0.0
    
    /**
     PolarVector object represent the vector in poler form.
     
     ````
     .    _____________
     r = √ x² + y² + z²
     
     𝜃 = tan⁻¹(y / x)
     .              ________
     𝜆 = tan⁻¹(z / √ x² + y² )
     ````
     */
    public var polarVector: PolarVector {
        let magnitude = sqrt(x * x + y * y + z * z)
        let theta = atan2(y, x)
        let lambda = atan2(z, sqrt(x * x + y * y))
        
        return PolarVector(magnitude: magnitude, theta: theta, lambda: lambda)
    }
    
    //MARK: Initialaization
    
    /**
     `CartesianVector` Default initializer.
     */
    public init() {
        // Nothing to do here.
    }
    
    /**
     Initialize CartesianVector object
     
     - Parameter x: Double value represent the projection on x-axis.
     - Parameter y: Double value represent the projection on y-axis.
     - Parameter z: Double value represent the projection on z-axis.
     */
    public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }

    //CustomStringConvertible Protocall
    public var description: String {
        return String(format: "Cartesian(%.2f, %.2f, %.2f)", Float(x), Float(y), Float(z))
    }
}
