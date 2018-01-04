//
//  Rotation3D.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/10/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation

/**
 An object the hold a geometrical rotation in three dimensions, in deferant forms.
 
 ### Discussion:
 A transformation in which a plane figure turns around a fixed center point.
 */
open class Rotation3D: Measurement {
    
    // MARK: Properties
    
    /// `Angle` value represent a rotation around x-axis.
    open var roll: Angle {
        return eulerAngles.roll
    }
    
    /// `Angle` value represent a rotation around y-axis.
    open var pitch: Angle {
        return eulerAngles.pitch
    }
    
    /// `Angle` value represent a rotation around z-axis.
    open var yaw: Angle {
        return eulerAngles.yaw
    }
    
    /// An `EulerAngles` object represent the rotaion.
    private(set) var eulerAngles: EulerAngles!
    
    /// An `Quaternion` object represent the rotaion.
    private(set) var quaternion: Quaternion!
    
    /// An `RotationMatrix` object represent the rotaion.
    private(set) var rotationMatrix: RotationMatrix!
    
    // MARK: Initialaization
    
    /**
     `Rotation3D` Default initializer.
     */
    public override init() {
        super.init()
        self.eulerAngles = EulerAngles()
        self.quaternion = eulerAngles.quaternion
        self.rotationMatrix = eulerAngles.rotationMatrix
    }
    
    /**
      Initialize Rotation3D object
     
      - Parameter roll: Angle value represent a rotation around x-axis.
      - Parameter pitch: Angle value represent a rotation around y-axis.
      - Parameter yaw: Angle value represent a rotation around z-axis.
     */
    public init(roll: Angle, pitch: Angle, yaw: Angle) {
        super.init()
        self.eulerAngles = EulerAngles(roll: roll, pitch: pitch, yaw: yaw)
        self.quaternion = eulerAngles.quaternion
        self.rotationMatrix = eulerAngles.rotationMatrix
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let roll = aDecoder.decodeDouble(forKey: "roll")
        let pitch = aDecoder.decodeDouble(forKey: "pitch")
        let yaw = aDecoder.decodeDouble(forKey: "yaw")
        self.eulerAngles = EulerAngles(roll: roll, pitch: pitch, yaw: yaw)
        self.quaternion = eulerAngles.quaternion
        self.rotationMatrix = eulerAngles.rotationMatrix
    }
    
    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(yaw, forKey: "yaw")
        aCoder.encode(pitch, forKey: "pitch")
        aCoder.encode(roll, forKey: "roll")
    }
    
    open override var description: String {
        return String(format: "Rotation3D[roll: %.2f, pitch: %.2f, yaw: %.2f]", Float(self.roll), Float(self.pitch), Float(self.yaw))
    }
    
    // MARK: Arithmetic operators
    
    public static prefix func - (rotation: Rotation3D) -> Rotation3D {
        return Rotation3D(roll: -rotation.roll, pitch: -rotation.pitch, yaw: -rotation.yaw)
    }

    public static func + (left: Rotation3D, right: Rotation3D) -> Rotation3D {
        return Rotation3D(roll: left.roll + right.roll, pitch: left.pitch + right.pitch, yaw: left.yaw + right.yaw)
    }

    public static func - (left: Rotation3D, right: Rotation3D) -> Rotation3D {
        return left + -right
    }

    public static func += (left: inout Rotation3D, right: Rotation3D) {
        left = left + right
    }

    public static func -= (left: inout Rotation3D, right: Rotation3D) {
        left = left - right
    }

    public static func * (left: Rotation3D, right: Rotation3D) -> Rotation3D {
        return Rotation3D(roll: left.roll * right.roll, pitch: left.pitch * right.pitch, yaw: left.yaw * right.yaw)
    }

    public static func / (left: Rotation3D, right: Rotation3D) -> Rotation3D {
        return Rotation3D(roll: left.roll / right.roll, pitch: left.pitch / right.pitch, yaw: left.yaw / right.yaw)
    }

    // MARK: Logical operators
    
    public static func == (left: Rotation3D, right: Rotation3D) -> Bool {
        return (left.roll == right.roll) && (left.pitch == right.pitch) && (left.yaw == right.yaw)
    }

    public static func != (left: Rotation3D, right: Rotation3D) -> Bool {
        return !(left == right)
    }
}

#if os(iOS)
    import CoreMotion
    
    public extension Rotation3D {
        /**
         Initialize `Rotation3D` object with `CMAttitude` in iOS Core Motion.
         
         - Parameter attitude: `CMAttitude` object represent the rotation.
         - Warning: Please make note that this method is only available for iOS 8.0 or later.
         */
        @available(iOS 8.0, *)
        convenience init(attitude: CMAttitude) {
            self.init()
            self.eulerAngles = EulerAngles(attitude: attitude)
            self.rotationMatrix = RotationMatrix(matrix: attitude.rotationMatrix)
            self.quaternion = Quaternion(quaternion: attitude.quaternion)
        }
    }
#endif
