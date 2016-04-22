//
//  Vector3D.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/10/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation
#if os(iOS)
    import CoreMotion
#endif

//MARK:- Vector3D

/**
 * Vector3D
 *
 *  Discussion:
 *    A vector is an object that has both a magnitude and a direction. Geometrically.
 *
 */
public class Vector3D: Measurement {
    
    //MARK: Cartesian Properties
    
    /// A CartesianVector object represent the vector in cartesian coordinate.
    private(set) var cartesianVector: CartesianVector!
    
    ///Double value represent the projection on x-axis.
    public var x: Double { return cartesianVector.x }
    
    ///Double value represent the projection on y-axis.
    public var y: Double { return cartesianVector.y }
    
    ///Double value represent the projection on z-axis.
    public var z: Double { return cartesianVector.z }
    
    //MARK: Polar Properties
    
    /// A PolerVector object represent the vector in polar coordinate.
    private(set) var polarVector: PolarVector!
    
    ///Radian value represent the distance of the vector.
    public var theta: Radian { return polarVector.theta }
    
    ///Radian value represent the angle between the projection on xy-plan and x-axis.
    public var lambda: Radian { return polarVector.lambda }
    
    ///Double value represent the angle between the projection on z-axis and xy-plan.
    public var magnitude: Double { return polarVector.magnitude }
    
    //MARK: Vector Properties
    
    ///Return Direction that represent the vector heading.
    public var headingDirection: Direction {
        let maxAngle = 30.0
        
        if lambda > maxAngle { return .Up }
        
        if lambda < -maxAngle { return .Down }
        
        return Direction(angle: theta)
    }
    
    //MARK: Initialaization
    public override init(){
        super.init()
        self.cartesianVector = CartesianVector()
        self.polarVector = self.cartesianVector.polarVector
    }
    
    /**
     * Initialize Vector3D object in cartesian form.
     *
     * - Parameters:
     * 	- x: Double value represent the projection on x-axis.
     * 	- y: Double value represent the projection on y-axis.
     * 	- z: Double value represent the projection on z-axis.
     */
    public init(x: Double, y: Double, z: Double){
        super.init()
        cartesianVector = CartesianVector(x: x, y: y, z: z)
        self.polarVector = self.cartesianVector.polarVector
    }
    
    /**
     * Initialize Vector3D object in polar form.
     *
     * - Parameters:
     * 	- magnitude: Double value represent the vector magnitude.
     * 	- theta: Radian value represent the vector theta.
     * 	- lambda: Radian value represent the vector lambda.
     */
    public init(magnitude: Double, theta: Radian, lambda: Radian) {
        super.init()
        polarVector = PolarVector(magnitude: magnitude, theta: theta, lambda: lambda)
        self.cartesianVector = self.polarVector.cartesianVector
    }
    
    /**
     * Initialize Vector3D object with a unit value.
     *
     * - Parameters:
     * 	- value: Double value represent the vector x y z value.
     */
    public init(value: Double){
        super.init()
        cartesianVector = CartesianVector(x: value, y: value, z: value)
        self.polarVector = self.cartesianVector.polarVector
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let x = aDecoder.decodeDoubleForKey("x")
        let y = aDecoder.decodeDoubleForKey("y")
        let z = aDecoder.decodeDoubleForKey("z")
        
        self.cartesianVector = CartesianVector(x: x, y: y, z: z)
        self.polarVector = cartesianVector.polarVector
    }
    
    public override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeDouble(cartesianVector.x, forKey: "x")
        aCoder.encodeDouble(cartesianVector.y, forKey: "y")
        aCoder.encodeDouble(cartesianVector.z, forKey: "z")
    }
    
    #if os(iOS)
    public convenience init(rotationRate: CMRotationRate){
        self.init(x: rotationRate.x, y: rotationRate.y, z: rotationRate.z)
    }
    #endif
    
    public override var description: String {
        return "Vector3D[\n\t\(self.cartesianVector.description)\n\t\(self.polarVector.description)\n]"
    }
}

//MARK:- Vector3D Operators

//MARK:Vectors Operators

prefix operator ~ {}
/**
 * A uniry operator calculate the length of a vector (Norm).
 *
 * - Parameters:
 * 	- vector: Vector3D object.
 *
 * - Returns: length of the vector.
 */
prefix func ~ (vector: Vector3D) -> Double {
    return sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
}

infix operator ~ {}
/**
 * An operator that apply dot product for two vectors.
 *
 * - Parameters:
 * 	- left: Vector3D object represent the left side.
 * 	- right: Vector3D object represent the right side.
 *
 * - Returns: a Vector3D object represent the result.
 */
func ~ (left: Vector3D, right: Vector3D) -> Double{
    let x = left.x - right.x
    let y = left.y - right.y
    let z = left.z - right.z
    return sqrt(x * x + y * y + z * z)
}

infix operator ^ {}
/**
 * An operator that apply cross product for two vectors.
 *
 * - Parameters:
 * 	- left: Vector3D object represent the left side.
 * 	- right: Rotation3D object represent the right side.
 *
 * - Returns: a Vector3D object represent the result.
 */
func ^ (left: Vector3D, right: Rotation3D) -> Vector3D {
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

func + (left: Vector3D, right: Vector3D) -> Vector3D {
    return Vector3D(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}

func - (left: Vector3D, right: Vector3D) -> Vector3D {
    return left + -right
}

func += (inout left: Vector3D, right: Vector3D) {
    left = left + right
}

func -= (inout left: Vector3D, right: Vector3D) {
    left = left - right
}

func * (left: Vector3D, right: Vector3D) -> Vector3D {
    return Vector3D(x: left.x * right.x, y: left.y * right.y, z: left.z * right.z)
}

func / (left: Vector3D, right: Vector3D) -> Vector3D {
    return Vector3D(x: left.x / right.x, y: left.y / right.y, z: left.z / right.z)
}

//MARK:Logical operators
func == (left: Vector3D, right: Vector3D) -> Bool {
    return (left.x == right.x) && (left.y == right.y) && (left.z == right.z)
}

func != (left: Vector3D, right: Vector3D) -> Bool {
    return !(left == right)
}

func <= (left: Vector3D, right: Vector3D) -> Bool {
    return (~left <= ~right)
}

func >= (left: Vector3D, right: Vector3D) -> Bool {
    return (~left >= ~right)
}

func < (left: Vector3D, right: Vector3D) -> Bool {
    return (~left < ~right)
}

func > (left: Vector3D, right: Vector3D) -> Bool {
    return (~left > ~right)
}