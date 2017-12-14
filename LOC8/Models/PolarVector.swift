//
//  PolarVector.swift
//  LOC8
//
//  Created by Marwan Al Masri on 13/12/17.
//  Copyright © 2017 LOC8. All rights reserved.
//

import Foundation

/**
 # PolarVector
 
 ### Discussion:
 Type represent a polar coordinate in three-dimensional coordinate system.
 If v is an instance of `PolarVector`, mathematically it represents the
 following vector:
 
 ````
 v = (r, 𝜃, 𝜆)
 ````
 */
public struct PolarVector: CustomStringConvertible {
    
    ///Double value represent the distance of the vector.
    fileprivate(set) var magnitude: Double = 0.0
    
    ///Angle value represent the angle between the projection on xy-plan and x-axis.
    fileprivate(set) var theta: Angle = 0.0
    
    ///Angle value represent the angle between the projection on z-axis and xy-plan.
    fileprivate(set) var lambda: Angle = 0.0
    
    /**
     CartesianVector object represent the vector in cartesian form.
     
     ```
     x = cos(𝜃) * cos(𝜆) * r
     y = sin(𝜃) * cos(𝜆) * r
     z = sin(𝜆) * r
     ```
     */
    public var cartesianVector: CartesianVector {
        let x = cos(theta) * cos(lambda) * magnitude
        let y = sin(theta) * cos(lambda) * magnitude
        let z = sin(lambda) * magnitude
        
        return CartesianVector(x: x, y: y, z: z)
    }
    
    //MARK: Initialaization
    
    /**
     `PoolerVector` Default initializer.
     */
    public init() {
        // Nothing to do here.
    }
    
    /**
     Initialize PolarVector object
     
     - Parameter magnitude: Double value represent the vector magnitude.
     - Parameter theta: Angle value represent the vector theta.
     - Parameter lambda: Angle value represent the vector lambda.
     */
    public init(magnitude: Double, theta: Angle, lambda: Angle) {
        self.theta = theta
        self.lambda = lambda
        self.magnitude = magnitude
    }
    
    //CustomStringConvertible Protocall
    public var description: String {
        return String(format: "Polar(%.2f, %.2f, %.2f)", Float(magnitude), Float(theta.degree), Float(lambda.degree))
    }
}
