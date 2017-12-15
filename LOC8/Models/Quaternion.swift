//
//  Quaternion.swift
//  LOC8
//
//  Created by Marwan Al Masri on 13/12/17.
//  Copyright © 2017 LOC8. All rights reserved.
//

import Foundation

/**
 # Quaternion
 
 ### Discussion:
 Type represents a quaternion (one way of parameterizing rotation).
 If quaternion is an instance of `Quaternion`, mathematically it represents the
 following quaternion:
 
 __p = xi + yj + zk + w__
 
 Where: __i² = j² = k² = ijk = −1__
 */
public struct Quaternion: CustomStringConvertible {
    
    /// `Double` value represent a quaternion unity vector projection on x-axis.
    var x: Double = 0.0
    
    /// `Double` value represent a quaternion unity vector projection on y-axis.
    var y: Double = 0.0
    
    /// `Double` value represent a quaternion unity vector projection on z-axis.
    var z: Double = 0.0
    
    /// `Double` value represent a deference angel in rotation.
    var w: Double = 0.0
    
    /// `EulerAngles` object represent the rotation in euler angles form.
    public var eulerAngles: EulerAngles {
        
        let roll  = atan2(2 * y * w - 2 * z * x , 1 - 2 * pow(y, 2) - 2 * pow(x, 2))
        let pitch =  asin(2 * y * z + 2 * x * w)
        let yaw   = atan2(2 * z * w - 2 * y * x , 1 - 2 * pow(z, 2) - 2 * pow(x, 2))
        
        return EulerAngles(roll: roll, pitch: pitch, yaw: yaw)
    }
    
    /// `RotationMatrix` object represent the rotation in matrix form.
    public var rotationMatrix: RotationMatrix {
        
        var matrix = RotationMatrix()
        
        matrix.m11 =  1 - 2 * (pow(y, 2) + pow(z, 2))
        matrix.m12 =  2 * (x * y + w * z)
        matrix.m13 =  2 * (x * z - w * y)
        matrix.m21 =  2 * (x * y - w * z)
        matrix.m22 =  1 - 2 * (pow(x, 2) + pow(z, 2))
        matrix.m23 =  2 * (y * z + w * x)
        matrix.m31 =  2 * (x * z + w * y)
        matrix.m32 =  2 * (y * z - w * x)
        matrix.m33 =  1 - 2 * (pow(x, 2) + pow(y, 2))
        
        return matrix
    }
    
    //MARK: Initialaization
    
    /**
     `Quaternion` Default initializer.
     */
    public init() {
        // Nothing to do here.
    }
    
    /**
     Initialize `Quaternion` object
     
     - Parameter x: Double value represent the unity vector projection on x-axis.
     - Parameter y: Double value represent the unity vector projection on y-axis.
     - Parameter z: Double value represent the unity vector projection on z-axis.
     - Parameter w: Double value represent the deference angel in rotation.
     */
    public init(x: Double, y: Double, z: Double, w: Double) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    
    public var description: String {
        return String(format: "Quaternion(%.2f, %.2f, %.2f, %.2f)", Float(x), Float(y), Float(z), Float(w))
    }
}

#if os(iOS)
    import CoreMotion
    
    extension Quaternion {
        
        /**
         Initialize `Quaternion` object with `CMQuaternion` in iOS Core Motion.
         
         - Parameter quaternion: `CMQuaternion` object represent the rotation.
         - Warning: Please make note that this method is only available for iOS 8.1 or later.
         */
        @available(iOS 8.1, *)
        public init(quaternion: CMQuaternion) {
            self.x = quaternion.x
            self.y = quaternion.y
            self.z = quaternion.z
            self.w = quaternion.w
        }
        
    }
#endif
