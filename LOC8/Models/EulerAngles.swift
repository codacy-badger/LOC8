//
//  EulerAngles.swift
//  LOC8
//
//  Created by Marwan Al Masri on 13/12/17.
//  Copyright © 2017 LOC8. All rights reserved.
//

import Foundation

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
public struct EulerAngles: CustomStringConvertible {
    
    ///Radian value represent a rotation around x-axis.
    fileprivate(set) var roll: Radian = 0
    
    ///Radian value represent a rotation around y-axis.
    fileprivate(set) var pitch: Radian = 0
    
    ///Radian value represent a rotation around z-axis.
    fileprivate(set) var yaw: Radian = 0
    
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
        
        let x = (c1 * s2 * c3) - (s1 * c2 * s3)
        let y = (c1 * c2 * s3) + (s1 * s2 * c3)
        let z = (s1 * c2 * c3) + (c1 * s2 * s3)
        let w = (c1 * c2 * c3) - (s1 * s2 * s3)
        
        return Quaternion(x: x, y: y, z: z, w: w)
    }
    
    //MARK: Initialaization
    
    /**
     `EulerAngles` Default initializer.
     */
    public init() {
        // Nothing to do here.
    }
    
    /**
     Initialize EulerAngles object
     
     - Parameter roll: Radian value represent a rotation around x-axis.
     - Parameter pitch: Radian value represent a rotation around y-axis.
     - Parameter yaw: Radian value represent a rotation around z-axis.
     */
    public init(roll: Radian, pitch: Radian, yaw: Radian) {
        self.roll = roll
        self.pitch = pitch
        self.yaw = yaw
    }
    
    public var description: String {
        return String(format: "EulerAngles[roll: %.2f, pitch: %.2f, yaw: %.2f]", Float(self.roll), Float(self.pitch), Float(self.yaw))
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
        public init(attitude: CMAttitude) {
            self.roll = attitude.roll
            self.pitch = attitude.pitch
            self.yaw = attitude.yaw
        }
        
    }
#endif
