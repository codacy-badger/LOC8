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
 the following vector: __v = (𝑥 ,𝑦 ,𝑧)__
 
 [Read more](https://en.wikipedia.org/wiki/Cartesian_coordinate_system) about cartesian coordinate
 
 - Attention: this structure derives from the right hand rule.
 */
public struct CartesianVector: CustomStringConvertible {
    
    /// `Double` value represent the projection on x-axis.
    private(set) var x: Double = 0.0
    
    /// `Double` value represent the projection on y-axis.
    private(set) var y: Double = 0.0
    
    /// `Double` value represent the projection on z-axis.
    private(set) var z: Double = 0.0
    
    /**
     `SphericalVector` object represent the vector in spherical form.
     
     __𝑟 = ²√[ 𝑥² + 𝑦² + 𝑧²]__
     
     __𝜃 = cos⁻¹(𝑧 / 𝑟)__
     
     __𝛷 = tan⁻¹⁡( 𝑦 / 𝑥 )__
     
     */
    public var sphericalVector: SphericalVector {
        let radial = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2))
        let theta = acos(z / radial)
        let phi = atan2(y, x)
        
        return SphericalVector(radial: radial, theta: theta, phi: phi)
    }
    
    /**
     `CylindricalVector` object represent the vector in cylindrical form.
     
     __𝜌 = ²√[ 𝑥² + 𝑦²]__
     
     __𝛷 = tan⁻¹⁡( 𝑦 / 𝑥 )__
     
     __𝑧 = 𝑧__
     
     */
    public var cylindricalVector: CylindricalVector {
        let rho = sqrt(pow(x, 2) + pow(y, 2))
        let phi = atan2(y, x)
        
        return CylindricalVector(rho: rho, phi: phi, height: z)
    }
    
    //MARK: Initialaization
    
    /**
     `CartesianVector` Default initializer.
     */
    public init() {
        // Nothing to do here.
    }
    
    /**
     Initialize `CartesianVector` object
     
     - Parameter x: `Double` value represent the projection on x-axis.
     - Parameter y: `Double` value represent the projection on y-axis.
     - Parameter z: `Double` value represent the projection on z-axis.
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
