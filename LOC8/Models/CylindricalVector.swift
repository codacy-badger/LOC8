//
//  PolarVector.swift
//  LOC8
//
//  Created by Marwan Al Masri on 13/12/17.
//  Copyright © 2017 LOC8. All rights reserved.
//

import Foundation

/**
 # CylindricalVector
 
 ### Discussion:
 Type represent a cylindrical coordinate in three-dimensional coordinate system.
 If v is an instance of `CylindricalVector`, mathematically it represents the
 following vector: __v = (𝜌, 𝛷, 𝑧)__
 
 where 𝜌 ∈ [0, ∞), θ ∈ [0, +π], 𝑧 ∈ (-∞, +∞)
 
 [Read more](https://en.wikipedia.org/wiki/Cylindrical_coordinate_system) about cylindrical coordinate.
 
 */
public struct CylindricalVector: CustomStringConvertible {
    
    /// `Double` value represent the radial distance
    /// 𝜌 is the Euclidean distance in xy-plane for the vector.
    ///
    /// __𝜌 ∈ [0, ∞) (𝜌 ≥ 0)__
    private(set) var rho: Double = 0.0
    
    /// `Angle` value represent the azimuthal angle between the projection on xy-plan and the x-axis. measured in radian
    ///
    /// __𝛷 ∈ [0, 2π) rad (0° ≤ 𝛷 < 360°)__
    private(set) var phi: Angle = 0.0
    
    /// `Double` value represent the height z which the signed distance from the chosen plane to the vector.
    private(set) var height: Double = 0.0
    
    /**
     `CartesianVector` object represent the vector in cartesian form.
     
     __𝑥 = 𝜌 cos⁡(𝛷)__
     
     __𝑦 = 𝜌 sin⁡(𝛷)__
     
     __𝑧 = 𝑧__
     */
    public var cartesianVector: CartesianVector {
        let x = rho * cos(phi)
        let y = rho * sin(phi)
        let z = self.height
        
        return CartesianVector(x: x, y: y, z: z)
    }
    
    /**
     `SphericalVector` object represent the vector in spherical form.
     
     __𝑟 = ²√[ 𝜌² + 𝑧²]__
     
     __𝜃 = cos⁻¹(𝑧 / 𝜌)__
     
     __𝛷 = 𝛷__
     
     */
    public var sphericalVector: SphericalVector {
        let radial = sqrt(pow(rho, 2) + pow(height, 2))
        let theta = acos(height / radial)
        
        return SphericalVector(radial: radial, theta: theta, phi: phi)
    }
    
    //MARK: Initialaization
    
    /**
     `CartesianVector` Default initializer.
     */
    public init() {
        // Nothing to do here.
    }
    
    /**
     Initialize `CylindricalVector` object
     
     - Parameter rho: `Double` value represent the magnitude of the vector.
     - Parameter phi: `Angle` value represent the azimuthal angle between the projection on xy-plan and the x-axis.
     - Parameter height: `Double` value represent the height z which the signed distance from the chosen plane to the point P.
     */
    public init(rho: Double, phi: Angle, height: Double) {
        self.rho = rho
        self.phi = phi
        self.height = height
    }
    
    //CustomStringConvertible Protocall
    public var description: String {
        return String(format: "Cylindrical(%.2f, %.2f˚, %.2f)", Float(self.rho), Float(self.phi.degree), Float(self.height))
    }
}

