//
//  Geometry.swift
//  LOC8
//
//  Created by Marwan Al Masri on 3/27/16.
//  Copyright © 2016 LOC8. All rights reserved.
//

import Foundation


//MARK: Generics


/**
  Clamping of a value to a range of [max - min].
 
 
 ### Discussion:
    Clamping is the process of limiting a position to an area.
 
 - Parameters:
 	- value: the current value.
 	- min: the minimum value.
 	- max: the maximum value.

 - Returns: A value between max and min.
 
 */
public func clamp<T: Comparable>(value: T, min: T, max: T) -> T {
    if value > max { return max }
    else if value < min { return min }
    else { return value }
}

/**
 Wrapping of a value to a range of [0 - 1].
 
 ### Discussion:
    Wrapping is the process of limiting a position to an area.
 
  - Parameters:
  	- value: a double represent the value  current value.
 
  - Returns: An integer value wrapped.
 */
public func wrap(value: Double) -> Int {
    let intValue = Int(value)
    let delta = value - Double(intValue)
    return delta >= 0.5 ? intValue + 1 : intValue
}

/**
 Convert an angle from degrees to radians.

 - Parameters:
 	- angel: the angle in degrees.

 - Returns: the angle in radians.
 */
public func degreesToRadians<T: NumericType>(angel: T) -> T {
    return angel * T(0.01745329251994329547)
}

/**
 Convert an angle from radians to degrees.

 - Parameters:
 	- angel: the angle in radians.

 - Returns: the angle in degrees.
 */
public func radiansToDegrees<T: NumericType>(angel: T) -> T {
    return angel *  T(57.29577951308232286465)
}

/**
  # Radian

  ### Discussion:
    The radian is the standard unit of angular measure.

    Radians is numerically equal to the length of a corresponding arc of a unit circle;
    one radian is just under 57.3 degrees (when the arc length is equal to the radius).
 */
public typealias Radian = Double

public extension Radian {
    ///Return the angle in degree.
    public var degree: Degree {
        return radiansToDegrees(self)
    }
}

/**
  # Degree

  ### Discussion:
    The degree is the standard unit of angular measure.

    Degree is a measurement of plane angle, representing 1⁄360 of a full rotation.
 */
public typealias Degree = Double

public extension Degree {
    
    ///Returns the angle in radian.
    public var radian: Radian {
        return degreesToRadians(self)
    }
}

//MARK: Vectors
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
public struct CartesianVector {
    
    ///Double value represent the projection on x-axis.
    private(set) var x: Double = 0.0
    
    ///Double value represent the projection on y-axis.
    private(set) var y: Double = 0.0
    
    ///Double value represent the projection on z-axis.
    private(set) var z: Double = 0.0
    /**
     PolarVector object represent the vector in poler form.
     
     ````
           _____________
      r = √ x² + y² + z²
     
      𝜃 = tan⁻¹(y / x)
                     ________
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
    public init(){ }
    
    /**
     Initialize CartesianVector object
    
     - Parameters:
     	- x: Double value represent the projection on x-axis.
     	- y: Double value represent the projection on y-axis.
     	- z: Double value represent the projection on z-axis.
     */
    public init(x: Double, y: Double, z: Double){
        self.x = x
        self.y = y
        self.z = z
    }
}


//CustomStringConvertible Protocall
extension CartesianVector:  CustomStringConvertible {
    public var description: String {
        return String(format: "Cartesian(%.2f, %.2f, %.2f)", Float(x), Float(y), Float(z))
    }
}

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
public struct PolarVector {
    
    ///Double value represent the distance of the vector.
    private(set) var magnitude: Double = 0.0
    
    ///Radian value represent the angle between the projection on xy-plan and x-axis.
    private(set) var theta: Radian = 0.0
    
    ///Radian value represent the angle between the projection on z-axis and xy-plan.
    private(set) var lambda: Radian = 0.0
    
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
    public init(){ }
    
    /**
     Initialize PolarVector object
    
     - Parameters:
     	- magnitude: Double value represent the vector magnitude.
     	- theta: Radian value represent the vector theta.
     	- lambda: Radian value represent the vector lambda.
     */
    public init(magnitude: Double, theta: Radian, lambda: Radian){
        self.theta = theta
        self.lambda = lambda
        self.magnitude = magnitude
    }
}

//CustomStringConvertible Protocall
extension PolarVector:  CustomStringConvertible {
    
    public var description: String {
        return String(format: "Polar(%.2f, %.2f, %.2f)", Float(magnitude), Float(radiansToDegrees(theta)), Float(radiansToDegrees(lambda)))
    }
}


//MARK: Rotations

/**
  # EulerAngles

  ### Discussion:
    Type represents a Euler angles (one way of parameterizing rotation).
    The Euler angles are three angles describe the orientation of a rigid body.
    To describe such an orientation in 3-dimensional Euclidean space three
    parameters are required:
 
    ````
      [roll, pich, yaw]
    ````
 */
public struct EulerAngles {
    
    ///Radian value represent a rotation around x-axis.
    private(set) var roll: Radian = 0
    
    ///Radian value represent a rotation around y-axis.
    private(set) var pitch: Radian = 0
    
    ///Radian value represent a rotation around z-axis.
    private(set) var yaw: Radian = 0
    
    ///RotationMatrix object represent the rotation in matrix form.
    public var rotationMatrix: RotationMatrix {
        
        var matrix = RotationMatrix()
        
        matrix.m11 =  cos(roll ) * cos(yaw )
        matrix.m12 =  cos(roll ) * sin(yaw )
        matrix.m13 = -sin(roll )
        matrix.m21 =  sin(pitch) * sin(roll )  * cos(yaw) - cos(pitch) * sin(yaw)
        matrix.m22 =  sin(pitch) * sin(roll )  * sin(yaw) + cos(pitch) * cos(yaw)
        matrix.m23 =  cos(roll ) * sin(pitch)
        matrix.m31 =  cos(pitch) * sin(roll )  * cos(yaw) + sin(pitch) * sin(yaw)
        matrix.m32 =  cos(pitch) * sin(roll )  * sin(yaw) - sin(pitch) * cos(yaw)
        matrix.m33 =  cos(roll ) * cos(pitch)
        
        return matrix
    }
    
    ///Quaternion object represent the rotation in quaternion form.
    public var quaternion: Quaternion {
        let c1 = cos(yaw / 2)
        let s1 = sin(yaw / 2)
        let c2 = cos(pitch / 2)
        let s2 = sin(pitch / 2)
        let c3 = cos(roll / 2)
        let s3 = sin(roll / 2)
        
        let x = c1 * s2 * c3 - s1 * c2 * s3
        let y = (c1 * c2 * s3) + (s1 * s2 * c3)
        let z = s1 * c2 * c3 + c1 * s2 * s3
        let w = (c1 * c2 * c3) - (s1 * s2 * s3)
        
        return Quaternion(x: x, y: y, z: z, w: w)
    }
    
    //MARK: Initialaization
    
    /**
     `EulerAngles` Default initializer.
     */
    public init(){ }
    
    /**
     Initialize EulerAngles object
    
     - Parameters:
     	- roll: Radian value represent a rotation around x-axis.
     	- pitch: Radian value represent a rotation around y-axis.
     	- yaw: Radian value represent a rotation around z-axis.
     */
    public init(roll: Radian, pitch: Radian, yaw: Radian){
        self.roll = roll
        self.pitch = pitch
        self.yaw = yaw
    }
}

extension EulerAngles:  CustomStringConvertible {
    public var description: String {
        return String(format: "EulerAngles[roll: %.2f, pitch: %.2f, yaw: %.2f]", Float(self.roll), Float(self.pitch), Float(self.yaw))
    }
}

/**
  # RotationMatrix

  ### Discussion:
    Type represents a rotation matrix in three-dimensional space.
 */
public struct RotationMatrix {
    
    var m11: Double = 0.0
    var m12: Double = 0.0
    var m13: Double = 0.0
    
    var m21: Double = 0.0
    var m22: Double = 0.0
    var m23: Double = 0.0
    
    var m31: Double = 0.0
    var m32: Double = 0.0
    var m33: Double = 0.0
    
    ///EulerAngles object represent the rotation in euler angles form
    public var eulerAngles: EulerAngles {
        var yaw: Radian = 0
        var pitch: Radian = 0
        var roll: Radian = 0
        
        if (m21 > 0.998) { // singularity at north pole
            yaw = atan2(m13, m33)
            pitch = M_PI_2 / 2
            roll = 0
        }
        if (m21 < -0.998) { // singularity at south pole
            yaw = atan2(m13, m33)
            pitch = -M_PI_2 / 2
            roll = 0
        }
        else {
            yaw = atan2(-m31, m11)
            roll = atan2(-m23, m22)
            pitch = asin(m21)
        }
        
        return EulerAngles(roll: roll, pitch: pitch, yaw: yaw)
    }
    
    ///Quaternion object represent the rotation in quaternion form.
    public var quaternion: Quaternion {
        let w = sqrt(1 + m11 + m22 + m33) / 2
        let x = (m23 - m32) / (w * 4)
        let y = (m31 - m13) / (w * 4)
        let z = (m12 - m21) / (w * 4)
        return Quaternion(x: x, y: y, z: z, w: w)
    }
    
    //MARK: Initialaization
    
    /**
     `RotationMatrix` Default initializer.
     */
    public init(){ }
}

extension RotationMatrix:  CustomStringConvertible {
    public var description: String {
        return String(format: "RotationMatrix:\n|%.2f,\t%.2f,\t%.2f\t|\n|%.2f,\t%.2f,\t%.2f\t|\n|%.2f,\t%.2f,\t%.2f\t|", m11, m12, m13, m21, m22, m23, m31, m32, m33)
    }
}


/**
  # Quaternion

  ### Discussion:
    Type represents a quaternion (one way of parameterizing rotation).
    If quaternion is an instance of `Quaternion`, mathematically it represents the
    following quaternion:
    ````
      p = xi + yj + zk + w
    ````
      
    __Where__: 
    ````
    i² = j² = k² = ijk = −1
    ````
 */
public struct Quaternion {
    
    ///Double value represent a quaternion unity vector projection on x-axis.
    var x: Double = 0.0
    
    ///Double value represent a quaternion unity vector projection on y-axis.
    var y: Double = 0.0
    
    ///Double value represent a quaternion unity vector projection on z-axis.
    var z: Double = 0.0
    
    ///Double value represent a deference angel in rotation.
    var w: Double = 0.0
    
    ///EulerAngles object represent the rotation in euler angles form.
    public var eulerAngles: EulerAngles {
        
        let roll  = atan2(2 * y * w - 2 * z * x , 1 - 2 * pow(y,2) - 2 * pow(x,2))
        let pitch =  asin(2 * y * z + 2 * x * w)
        let yaw   = atan2(2 * z * w - 2 * y * x , 1 - 2 * pow(z,2) - 2 * pow(x,2))
        
        return EulerAngles(roll: roll, pitch: pitch, yaw: yaw)
    }
    
    ///RotationMatrix object represent the rotation in matrix form.
    public var rotationMatrix: RotationMatrix {
        
        var matrix = RotationMatrix()
        
        matrix.m11 =  1 - 2 * (y * y + z * z)
        matrix.m12 =  2 * (x * y + w * z)
        matrix.m13 =  2 * (x * z - w * y)
        matrix.m21 =  2 * (x * y - w * z)
        matrix.m22 =  1 - 2 * (x * x + z * z)
        matrix.m23 =  2 * (y * z + w * x)
        matrix.m31 =  2 * (x * z + w * y)
        matrix.m32 =  2 * (y * z - w * x)
        matrix.m33 =  1 - 2 * (x * x + y * y)
        
        return matrix
    }
    
    //MARK: Initialaization
    
    /**
     `Quaternion` Default initializer.
     */
    public init(){ }
    
    /**
     Initialize PolarVector object
    
     - Parameters:
     	- x: Double value represent the unity vector projection on x-axis.
     	- y: Double value represent the unity vector projection on y-axis.
     	- z: Double value represent the unity vector projection on z-axis.
     	- w: Double value represent the deference angel in rotation.
     */
    public init(x: Double, y: Double, z: Double, w: Double){
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    
}

extension Quaternion:  CustomStringConvertible {
    public var description: String {
        return String(format: "Quaternion(%.2f, %.2f, %.2f, %.2f)", Float(x), Float(y), Float(z), Float(w))
    }
}

#if os(iOS)
    import CoreMotion
    
    extension EulerAngles {
        
        /**
         Initialize `EulerAngles` object with `CMAttitude` in iOS Core Motion.
         
         - Parameter attitude: `CMAttitude` object represent the rotation.
         - Warning: Please make note that this method is only available for iOS 8.1 or later.
         */
        @available(iOS 8.1, *)
        public init(attitude: CMAttitude){
            self.roll = attitude.roll
            self.pitch = attitude.pitch
            self.yaw = attitude.yaw
        }
        
    }
    
    extension Quaternion {
        
        /**
         Initialize `Quaternion` object with `CMQuaternion` in iOS Core Motion.
         
         - Parameter quaternion: `CMQuaternion` object represent the rotation.
         - Warning: Please make note that this method is only available for iOS 8.1 or later.
         */
        @available(iOS 8.1, *)
        public init(quaternion: CMQuaternion){
            self.x = quaternion.x
            self.y = quaternion.y
            self.z = quaternion.z
            self.w = quaternion.w
        }
        
    }
    
    extension RotationMatrix {
        
        /**
         Initialize `RotationMatrix` object with `CMRotationMatrix` in iOS Core Motion.
         
         - Parameter matrix: `CMAttitude` object represent the rotation.
         - Warning: Please make note that this method is only available for iOS 8.1 or later.
         */
        @available(iOS 8.1, *)
        public init(matrix: CMRotationMatrix){
            self.m11 = matrix.m11
            self.m12 = matrix.m12
            self.m13 = matrix.m13
            self.m21 = matrix.m21
            self.m22 = matrix.m22
            self.m23 = matrix.m23
            self.m31 = matrix.m31
            self.m32 = matrix.m32
            self.m33 = matrix.m33
        }
    }
#endif

