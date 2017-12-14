//
//  Vector3D.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/10/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation

/**
 # Vector3D

  ### Discussion:
    A vector is an object that has both a magnitude and a direction. Geometrically.
 */
open class Vector3D: Measurement {
    
    //MARK: Cartesian Properties
    
    /// A CartesianVector object represent the vector in cartesian coordinate.
    private(set) var cartesianVector: CartesianVector!
    
    ///Double value represent the projection on x-axis.
    open var x: Double {
        return cartesianVector.x
        
    }
    
    ///Double value represent the projection on y-axis.
    open var y: Double {
        return cartesianVector.y
        
    }
    
    ///Double value represent the projection on z-axis.
    open var z: Double {
        return cartesianVector.z
        
    }
    
    //MARK: Polar Properties
    
    /// A PolerVector object represent the vector in polar coordinate.
    private(set) var polarVector: PolarVector!
    
    ///Angle value represent the angle between the projection on z-axis and xy-plan.
    open var theta: Angle {
        return polarVector.theta
        
    }
    
    ///Angle value represent the angle between the projection on xy-plan and x-axis.
    open var lambda: Angle {
        return polarVector.lambda
        
    }
    
    ///Double value represent the distance of the vector.
    open var magnitude: Double {
        return polarVector.magnitude
        
    }
    
    //MARK: Vector Properties
    
    ///Return Direction that represent the vector heading.
    open var headingDirection: Direction {
        let maxAngle = 30.0
        
        if lambda > maxAngle {
            return .up
        }
        
        if lambda < -maxAngle {
            return .down
        }
        
        return Direction(angle: theta)
    }
    
    //MARK: Initialaization
    
    /**
     `Vector3D` Default initializer.
     */
    public override init() {
        super.init()
        self.cartesianVector = CartesianVector()
        self.polarVector = self.cartesianVector.polarVector
    }
    
    /**
      Initialize Vector3D object in cartesian form.
     
      - Parameter x: Double value represent the projection on x-axis.
      - Parameter y: Double value represent the projection on y-axis.
      - Parameter z: Double value represent the projection on z-axis.
     */
    public init(x: Double, y: Double, z: Double) {
        super.init()
        cartesianVector = CartesianVector(x: x, y: y, z: z)
        self.polarVector = self.cartesianVector.polarVector
    }
    
    /**
      Initialize Vector3D object in polar form.
     
      - Parameter magnitude: Double value represent the vector magnitude.
      - Parameter theta: Angle value represent the vector theta.
      - Parameter lambda: Angle value represent the vector lambda.
     */
    public init(magnitude: Double, theta: Angle, lambda: Angle) {
        super.init()
        polarVector = PolarVector(magnitude: magnitude, theta: theta, lambda: lambda)
        self.cartesianVector = self.polarVector.cartesianVector
    }
    
    /**
      Initialize Vector3D object with a unit value.
     
      - Parameter value: Double value represent the vector x y z value.
     */
    public init(value: Double) {
        super.init()
        cartesianVector = CartesianVector(x: value, y: value, z: value)
        self.polarVector = self.cartesianVector.polarVector
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let x = aDecoder.decodeDouble(forKey: "x")
        let y = aDecoder.decodeDouble(forKey: "y")
        let z = aDecoder.decodeDouble(forKey: "z")
        
        self.cartesianVector = CartesianVector(x: x, y: y, z: z)
        self.polarVector = cartesianVector.polarVector
    }
    
    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(cartesianVector.x, forKey: "x")
        aCoder.encode(cartesianVector.y, forKey: "y")
        aCoder.encode(cartesianVector.z, forKey: "z")
    }
    
    open override var description: String {
        return "Vector3D[\n\t\(self.cartesianVector.description)\n\t\(self.polarVector.description)\n]"
    }
}
#if os(iOS)
    import CoreMotion
    
    public extension Vector3D {
        
        /**
         Initialize `Vectro3D` object with `CMRotationRate` in iOS Core Motion.
         
         - Parameter rotationRate: `CMRotationRate` object represent the rotation rate vector.
         - Warning: Please make note that this method is only available for iOS 8.1 or later.
         */
        @available(iOS 8.1, *)
        public convenience init(rotationRate: CMRotationRate) {
            self.init(x: rotationRate.x, y: rotationRate.y, z: rotationRate.z)
        }
        
        /**
         Initialize `Vectro3D` object with `CMMagneticField` in iOS Core Motion.
         
         - Parameter field: `CMMagneticField` object represent the magnetic field.
         - Warning: Please make note that this method is only available for iOS 8.1 or later.
         */
        @available(iOS 8.1, *)
        public convenience init(field: CMMagneticField) {
            self.init(x: field.x, y: field.y, z: field.z)
        }
        
        /**
         Initialize `Vectro3D` object with `CMCalibratedMagneticField` in iOS Core Motion.
         
         - Parameter magneticField: `CMCalibratedMagneticField` object represent the calibrated magnetic field.
         - Warning: Please make note that this method is only available for iOS 7.0 or later.
         */
        public convenience init(magneticField: CMCalibratedMagneticField) {
            self.init(field: magneticField.field)
        }
    }
#endif


//MARK: Vector3D Operators

//MARK:Vectors Operators

prefix operator ~
/**
  A uniry operator calculate the length of a vector (Norm).
 
  - Parameter vector: Vector3D object.
 
  - Returns: length of the vector.
 */
prefix func ~ (vector: Vector3D) -> Double {
    return sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
}

infix operator ~
/**
  An operator that apply dot product for two vectors.
 
  - Parameter left: Vector3D object represent the left side.
  - Parameter right: Vector3D object represent the right side.
 
  - Returns: a Vector3D object represent the result.
 */
public func ~ (left: Vector3D, right: Vector3D) -> Double {
    let x = left.x - right.x
    let y = left.y - right.y
    let z = left.z - right.z
    return sqrt(x * x + y * y + z * z)
}

infix operator ^
/**
  An operator that apply cross product for two vectors.
 
  - Parameter left: Vector3D object represent the left side.
  - Parameter right: Rotation3D object represent the right side.
 
  - Returns: a Vector3D object represent the result.
 */
public func ^ (left: Vector3D, right: Rotation3D) -> Vector3D {
    return Vector3D(
        x: left.x * right.rotationMatrix.m11 + left.y * right.rotationMatrix.m12 + left.z * right.rotationMatrix.m13,
        y: left.x * right.rotationMatrix.m21 + left.y * right.rotationMatrix.m22 + left.z * right.rotationMatrix.m23,
        z: left.x * right.rotationMatrix.m31 + left.y * right.rotationMatrix.m32 + left.z * right.rotationMatrix.m33
    )
}

//MARK:Arithmetic operators
prefix func - (vector: Vector3D) -> Vector3D {
    return Vector3D(x: -vector.x, y: -vector.y, z: -vector.z)
}

public func + (left: Vector3D, right: Vector3D) -> Vector3D {
    return Vector3D(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}

public func - (left: Vector3D, right: Vector3D) -> Vector3D {
    return left + -right
}

public func += (left: inout Vector3D, right: Vector3D) {
    left = left + right
}

public func -= (left: inout Vector3D, right: Vector3D) {
    left = left - right
}

public func * (left: Vector3D, right: Vector3D) -> Vector3D {
    return Vector3D(x: left.x * right.x, y: left.y * right.y, z: left.z * right.z)
}

public func / (left: Vector3D, right: Vector3D) -> Vector3D {
    return Vector3D(x: left.x / right.x, y: left.y / right.y, z: left.z / right.z)
}

//MARK:Logical operators
public func == (left: Vector3D, right: Vector3D) -> Bool {
    return (left.x == right.x) && (left.y == right.y) && (left.z == right.z)
}

public func != (left: Vector3D, right: Vector3D) -> Bool {
    return !(left == right)
}

public func <= (left: Vector3D, right: Vector3D) -> Bool {
    return (~left <= ~right)
}

public func >= (left: Vector3D, right: Vector3D) -> Bool {
    return (~left >= ~right)
}

public func < (left: Vector3D, right: Vector3D) -> Bool {
    return (~left < ~right)
}

public func > (left: Vector3D, right: Vector3D) -> Bool {
    return (~left > ~right)
}
