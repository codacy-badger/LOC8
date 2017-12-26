//
//  RotationMatrix.swift
//  LOC8
//
//  Created by Marwan Al Masri on 13/12/17.
//  Copyright © 2017 LOC8. All rights reserved.
//

import Foundation

/**
 Type represents a rotation matrix in three-dimensional space.
 
 ### Discussion:
 In linear algebra, a rotation matrix is a matrix that is used to perform a rotation in Euclidean space.
 */
public struct RotationMatrix: CustomStringConvertible {
    
    var m11: Double = 0.0
    var m12: Double = 0.0
    var m13: Double = 0.0
    
    var m21: Double = 0.0
    var m22: Double = 0.0
    var m23: Double = 0.0
    
    var m31: Double = 0.0
    var m32: Double = 0.0
    var m33: Double = 0.0
    
    /// EulerAngles object represent the rotation in euler angles form
    public var eulerAngles: EulerAngles {
        var yaw: Angle = 0
        var pitch: Angle = 0
        var roll: Angle = 0
        
        if (m21 > 0.998) { // singularity at north pole
            yaw = atan2(m13, m33)
            pitch = (Double.pi / 2) / 2
            roll = 0
        }
        
        if (m21 < -0.998) { // singularity at south pole
            yaw = atan2(m13, m33)
            pitch = -(Double.pi / 2) / 2
            roll = 0
        } else {
            yaw = atan2(-m31, m11)
            roll = atan2(-m23, m22)
            pitch = asin(m21)
        }
        
        return EulerAngles(roll: roll, pitch: pitch, yaw: yaw)
    }
    
    /// Quaternion object represent the rotation in quaternion form.
    public var quaternion: Quaternion {
        let w = sqrt(1 + m11 + m22 + m33) / 2
        let x = (m23 - m32) / (w * 4)
        let y = (m31 - m13) / (w * 4)
        let z = (m12 - m21) / (w * 4)
        return Quaternion(x: x, y: y, z: z, w: w)
    }
    
    // MARK: Initialaization
    
    /**
     `RotationMatrix` Default initializer.
     */
    public init() {
        // Nothing to do here.
    }
    
    public var description: String {
        return String(format: "RotationMatrix:\n|%.2f,\t%.2f,\t%.2f\t|\n|%.2f,\t%.2f,\t%.2f\t|\n|%.2f,\t%.2f,\t%.2f\t|", m11, m12, m13, m21, m22, m23, m31, m32, m33)
    }
}

#if os(iOS)
    import CoreMotion
    
    extension RotationMatrix {
        
        /**
         Initialize `RotationMatrix` object with `CMRotationMatrix` in iOS Core Motion.
         
         - Parameter matrix: `CMAttitude` object represent the rotation.
         - Warning: Please make note that this method is only available for iOS 8.1 or later.
         */
        @available(iOS 8.1, *)
        public init(matrix: CMRotationMatrix) {
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
