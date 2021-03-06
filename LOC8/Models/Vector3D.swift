//
//  Vector3D.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/10/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import CoreLocation
import Foundation

prefix operator ~
infix operator ~
infix operator ^

/**
 An object the hold a geometrical vector in three dimensions, in deferant forms.

 ### Discussion:
 A vector is an object that has both a magnitude and a direction. Geometrically.
 */
open class Vector3D: Measurement {
    
    // MARK: Cartesian Properties
    
    /// A `CartesianVector` object represent the vector in cartesian coordinate.
    private(set) var cartesianVector: CartesianVector
    
    /// `Double` value represent the projection on x-axis.
    open var x: Double {
        return cartesianVector.x
        
    }
    
    /// `Double` value represent the projection on y-axis.
    open var y: Double {
        return cartesianVector.y
        
    }
    
    /// `Double` value represent the projection on z-axis.
    open var z: Double {
        return cartesianVector.z
        
    }
    
    // MARK: Spherical Properties
    
    /// A `SphericalVector` object represent the vector in spherical coordinate.
    private(set) var sphericalVector: SphericalVector
    
    /// `Double` value represent the magnitude of the vector.
    /// radial distance r _(𝜌 (rho) is often used instead)_
    ///
    /// __r ∈ [0, ∞) (r ≥ 0)__
    open var radial: Double {
        return sphericalVector.radial
        
    }
    
    /// `Angle` value represent the inclination angle (or polar angle) between the z-axis and the vector. measured in radian
    ///
    /// __𝜃 ∈ [0, +π] rad ([0° ≤ 𝜃 ≤ 180°])__
    open var theta: Angle {
        return sphericalVector.theta
        
    }
    
    /// `Angle` value represent the azimuthal angle between the projection on xy-plan and the x-axis. measured in radian
    ///
    /// __𝛷 ∈ [-π, +π] rad ([-180° ≤ 𝛷 < 180°])__
    open var phi: Angle {
        return sphericalVector.phi
        
    }
    
    // MARK: Clyndrical Properties
    
    /// A `CylindricalVector` object represent the vector in cylindrical coordinate.
    private(set) var cylindricalVector: CylindricalVector
    
    /// `Double` value represent the radial distance
    /// ρ is the Euclidean distance in xy-plane for the vector.
    ///
    /// __𝜌 ∈ [0, ∞) (𝜌 ≥ 0)__
    open var rho: Double {
        return self.cylindricalVector.rho
    }
    
    /// `Double` value represent the height z which the signed distance from the chosen plane to the vector.
    open var height: Double {
        return self.cylindricalVector.height
    }
    
    // MARK: Vector Properties
    
    /// Return Direction that represent the vector heading.
    open var headingDirection: Direction {
        
        return Direction(theta: self.theta, phi: self.phi)
    }
    
    // MARK: Initialaization
    
    /**
     `Vector3D` Default initializer.
     */
    public override init() {
        self.cartesianVector = CartesianVector()
        self.sphericalVector = self.cartesianVector.sphericalVector
        self.cylindricalVector = self.cartesianVector.cylindricalVector
        super.init()
    }
    
    /**
      Initialize `Vector3D` object in cartesian form.
     
      - Parameter x: `Double` value represent the projection on x-axis.
      - Parameter y: `Double` value represent the projection on y-axis.
      - Parameter z: `Double` value represent the projection on z-axis.
     */
    public init(x: Double, y: Double, z: Double) {
        self.cartesianVector = CartesianVector(x: x, y: y, z: z)
        self.sphericalVector = self.cartesianVector.sphericalVector
        self.cylindricalVector = self.cartesianVector.cylindricalVector
        super.init()
    }
    
    /**
      Initialize `Vector3D` object in spherical form.
     
      - Parameter radial: `Double` value represent the magnitude of the vector..
      - Parameter theta: `Angle` value represent the polar angle between the z-axis and the vector.
      - Parameter phi: `Angle` value represent the azimuthal angle between the projection on xy-plan and the x-axis.
     */
    public init(radial: Double, theta: Angle, phi: Angle) {
        self.sphericalVector = SphericalVector(radial: radial, theta: theta, phi: phi)
        self.cartesianVector = self.sphericalVector.cartesianVector
        self.cylindricalVector = self.sphericalVector.cylindricalVector
        super.init()
    }
    
    /**
     Initialize `Vector3D` object in cylindrical form.
     
     - Parameter rho: `Double` value represent the magnitude of the vector.
     - Parameter phi: `Angle` value represent the azimuthal angle between the projection on xy-plan and the x-axis.
     - Parameter height: `Double` value represent the height z which the signed distance from the chosen plane to the point P.
     */
    public init(rho: Double, phi: Angle, height: Double) {
        self.cylindricalVector = CylindricalVector(rho: rho, phi: phi, height: height)
        self.cartesianVector = self.cylindricalVector.cartesianVector
        self.sphericalVector = self.cylindricalVector.sphericalVector
        super.init()
    }
    
    /**
      Initialize `Vector3D` object with a unit value.
     
      - Parameter value: Double value represent the vector x y z value.
     */
    public init(value: Double) {
        self.cartesianVector = CartesianVector(x: value, y: value, z: value)
        self.sphericalVector = self.cartesianVector.sphericalVector
        self.cylindricalVector = self.cartesianVector.cylindricalVector
        super.init()
    }
    
    /**
     Initialize `Vectro3D` object with `CLHeading` in iOS Core Location.
     
     - Parameter heading: `CLHeading` object represent the location heading.
     */
    public convenience init(heading: CLHeading) {
        self.init(x: heading.x, y: heading.y, z: heading.z)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        let x = aDecoder.decodeDouble(forKey: "x")
        let y = aDecoder.decodeDouble(forKey: "y")
        let z = aDecoder.decodeDouble(forKey: "z")
        
        self.cartesianVector = CartesianVector(x: x, y: y, z: z)
        self.sphericalVector = cartesianVector.sphericalVector
        self.cylindricalVector = self.cartesianVector.cylindricalVector
        super.init(coder: aDecoder)
    }
    
    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(cartesianVector.x, forKey: "x")
        aCoder.encode(cartesianVector.y, forKey: "y")
        aCoder.encode(cartesianVector.z, forKey: "z")
    }
    
    open override var description: String {
        return "Vector3D\n[\n\t\(self.cartesianVector)\n\t\(self.sphericalVector)\n\t\(self.cylindricalVector)\n]"
    }
    
    // MARK: Vectors Operators

    /**
      A uniry operator calculate the length of a vector (Norm).
     
      - Parameter vector: Vector3D object.
     
      - Returns: length of the vector.
     */
    public static prefix func ~ (vector: Vector3D) -> Double {
        return sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
    }

    /**
      An operator that apply dot product for two vectors.
     
      - Parameter left: Vector3D object represent the left side.
      - Parameter right: Vector3D object represent the right side.
     
      - Returns: a Vector3D object represent the result.
     */
    public static func ~ (left: Vector3D, right: Vector3D) -> Double {
        let x = left.x - right.x
        let y = left.y - right.y
        let z = left.z - right.z
        return sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2))
    }

    /**
      An operator that apply cross product for two vectors.
     
      - Parameter left: Vector3D object represent the left side.
      - Parameter right: Rotation3D object represent the right side.
     
      - Returns: a Vector3D object represent the result.
     */
    public static func ^ (left: Vector3D, right: Rotation3D) -> Vector3D {
        return Vector3D(
            x: left.x * right.rotationMatrix.m11 + left.y * right.rotationMatrix.m12 + left.z * right.rotationMatrix.m13,
            y: left.x * right.rotationMatrix.m21 + left.y * right.rotationMatrix.m22 + left.z * right.rotationMatrix.m23,
            z: left.x * right.rotationMatrix.m31 + left.y * right.rotationMatrix.m32 + left.z * right.rotationMatrix.m33
        )
    }

    // MARK: Arithmetic operators
    
    prefix static func - (vector: Vector3D) -> Vector3D {
        return Vector3D(x: -vector.x, y: -vector.y, z: -vector.z)
    }

    public static func + (left: Vector3D, right: Vector3D) -> Vector3D {
        return Vector3D(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
    }

    public static func - (left: Vector3D, right: Vector3D) -> Vector3D {
        return left + -right
    }

    public static func += (left: inout Vector3D, right: Vector3D) {
        left = left + right
    }

    public static func -= (left: inout Vector3D, right: Vector3D) {
        left = left - right
    }

    public static func * (left: Vector3D, right: Vector3D) -> Vector3D {
        return Vector3D(x: left.x * right.x, y: left.y * right.y, z: left.z * right.z)
    }

    public static func / (left: Vector3D, right: Vector3D) -> Vector3D {
        return Vector3D(x: left.x / right.x, y: left.y / right.y, z: left.z / right.z)
    }

    // MARK: Logical operators
    
    public static func == (left: Vector3D, right: Vector3D) -> Bool {
        return (left.x == right.x) && (left.y == right.y) && (left.z == right.z)
    }

    public static func != (left: Vector3D, right: Vector3D) -> Bool {
        return !(left == right)
    }

    public static func <= (left: Vector3D, right: Vector3D) -> Bool {
        return (~left <= ~right)
    }

    public static func >= (left: Vector3D, right: Vector3D) -> Bool {
        return (~left >= ~right)
    }

    public static func < (left: Vector3D, right: Vector3D) -> Bool {
        return (~left < ~right)
    }

    public static func > (left: Vector3D, right: Vector3D) -> Bool {
        return (~left > ~right)
    }
}

#if os(iOS)
    import CoreMotion
    
    public extension Vector3D {
            
        /**
         Initialize `Acceleration` object with `CMAcceleration` in iOS Core Motion.
         
         - Parameter acceleration: `CMAcceleration` object represent the acceleration vector.
         - Warning: Please make note that this method is only available for iOS 8.1 or later.
         */
        @available(iOS 8.1, *)
        convenience init(acceleration: CMAcceleration) {
            
            let x = acceleration.x * Physics.EarthGravity
            let y = acceleration.y * Physics.EarthGravity
            let z = acceleration.z * Physics.EarthGravity
            
            self.init(x: x, y: y, z: z)
        }
        
        /**
         Initialize `Vectro3D` object with `CMRotationRate` in iOS Core Motion.
         
         - Parameter rotationRate: `CMRotationRate` object represent the rotation rate vector.
         */
        convenience init(rotationRate: CMRotationRate) {
            self.init(x: rotationRate.x, y: rotationRate.y, z: rotationRate.z)
        }
        
        /**
         Initialize `Vectro3D` object with `CMMagneticField` in iOS Core Motion.
         
         - Parameter field: `CMMagneticField` object represent the magnetic field.
         - Warning: Please make note that this method is only available for iOS 8.1 or later.
         */
        @available(iOS 8.1, *)
        convenience init(field: CMMagneticField) {
            self.init(x: field.x, y: field.y, z: field.z)
        }
        
        /**
         Initialize `Vectro3D` object with `CMCalibratedMagneticField` in iOS Core Motion.
         
         - Parameter magneticField: `CMCalibratedMagneticField` object represent the calibrated magnetic field.
         - Warning: Please make note that this method is only available for iOS 7.0 or later.
         */
        convenience init(magneticField: CMCalibratedMagneticField) {
            self.init(field: magneticField.field)
        }
    }
#endif
