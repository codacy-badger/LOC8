//
//  SphericalVectore.swift
//  LOC8
//
//  Created by Marwan Al Masri on 15/12/17.
//  Copyright © 2017 LOC8. All rights reserved.
//

import Foundation

/**
 # SphericalVector
 
 ### Discussion:
 Type represent a spherical coordinate in three-dimensional coordinate system.
 
 
 Spherical coordinates as commonly used in physics (ISO convention)
 If v is an instance of `SphericalVector`, mathematically it represents the
 following vector: __v = (r, 𝜃, 𝛷)__
 
 [Read more](https://en.wikipedia.org/wiki/Spherical_coordinate_system) about spherical coordinate
 */
public struct SphericalVector: CustomStringConvertible {
    
    /// `Double` value represent the magnitude of the vector.
    /// radial distance r _(𝜌 (rho) is often used instead)_
    ///
    /// __r ≥ 0__
    private(set) var radial : Double = 0.0
    
    /// `Angle` value represent the polar angle between the z-axis and the vector.
    ///
    /// __0° ≤ 𝜃 ≤ 180° ([0, π] rad)__
    private(set) var theta: Angle = 0.0
    
    /// `Angle` value represent the azimuthal angle between the projection on xy-plan and the x-axis.
    ///
    /// __-180° ≤ 𝛷 < 180° ([-π, +π] rad)__
    private(set) var phi: Angle = 0.0
    
    /**
     `CartesianVector` object represent the vector in cartesian form.
     
     __𝑥 = 𝑟 sin⁡(𝜃) cos⁡(𝛷)__
     
     __𝑦 = 𝑟 sin⁡(𝜃) sin⁡(𝛷)__
     
     __𝑧 = 𝑟 cos⁡(𝜃)__
     
     */
    public var cartesianVector: CartesianVector {
        let x = radial * sin(theta) * cos(phi)
        let y = radial * sin(theta) * sin(phi)
        let z = radial * sin(phi)
        
        return CartesianVector(x: x, y: y, z: z)
    }
    
    /**
     `CylindricalVector` object represent the vector in cylindrical form.
     
     __𝜌 = 𝑟 cos(𝜃)__
     
     __𝛷 = 𝛷__
     
     __𝑧 = 𝑟 sin(𝜃)__
     
     */
    public var cylindricalVector: CylindricalVector {
        let rho = radial * cos(theta)
        let height = radial * sin(theta)
        
        return CylindricalVector(radial: rho, phi: phi, height: height)
    }
    
    //MARK: Initialaization
    
    /**
     `SphericalVector` Default initializer.
     */
    public init() {
        // Nothing to do here.
    }
    
    /**
     Initialize `SphericalVector` object
     
     - Parameter radial: `Double` value represent the magnitude of the vector.
     - Parameter theta: `Angle` value represent the polar angle between the z-axis and the vector.
     - Parameter phi: `Angle` value represent the azimuthal angle between the projection on xy-plan and the x-axis.
     */
    public init(radial: Double, theta: Angle, phi: Angle) {
        self.radial = radial
        self.theta = theta
        self.phi = phi
    }
    
    //CustomStringConvertible Protocall
    public var description: String {
        return String(format: "Spherical(%.2f, %.2f˚, %.2f˚)", Float(radial), Float(theta.degree), Float(phi.degree))
    }
}
