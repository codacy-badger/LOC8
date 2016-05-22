//
//  Rotation3D.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/10/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation
#if os(iOS)
    import CoreMotion
#endif

//MARK: Rotations

/**
 # Rotation3D
 
  ### Discussion:
    A transformation in which a plane figure turns around a fixed center point.
 */
public class Rotation3D: Measurement {
    
    //MARK: Properties
    
    ///Radian value represent a rotation around x-axis.
    public var roll: Radian { return eulerAngles.roll }
    
    ///Radian value represent a rotation around y-axis.
    public var pitch: Radian { return eulerAngles.pitch }
    
    ///Radian value represent a rotation around z-axis.
    public var yaw: Radian { return eulerAngles.yaw }
    
    /// An EulerAngles object represent the rotaion.
    private(set) var eulerAngles: EulerAngles!
    
    /// An Quaternion object represent the rotaion.
    private(set) var quaternion: Quaternion!
    
    /// An RotationMatrix object represent the rotaion.
    private(set) var rotationMatrix: RotationMatrix!
    
    //MARK: Initialaization
    
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
     
      - Parameters:
      	- roll: Radian value represent a rotation around x-axis.
      	- pitch: Radian value represent a rotation around y-axis.
      	- yaw: Radian value represent a rotation around z-axis.
     */
    public init(roll: Radian, pitch: Radian, yaw: Radian){
        super.init()
        self.eulerAngles = EulerAngles(roll: roll, pitch: pitch, yaw: yaw)
        self.quaternion = eulerAngles.quaternion
        self.rotationMatrix = eulerAngles.rotationMatrix
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let roll = aDecoder.decodeDoubleForKey("roll")
        let pitch = aDecoder.decodeDoubleForKey("pitch")
        let yaw = aDecoder.decodeDoubleForKey("yaw")
        self.eulerAngles = EulerAngles(roll: roll, pitch: pitch, yaw: yaw)
        self.quaternion = eulerAngles.quaternion
        self.rotationMatrix = eulerAngles.rotationMatrix
    }
    
    public override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeDouble(yaw, forKey: "yaw")
        aCoder.encodeDouble(pitch, forKey: "pitch")
        aCoder.encodeDouble(roll, forKey: "roll")
    }
    
    #if os(iOS)
    
    
    /**
     Initialize `Rotation3D` object with `CMAttitude` in iOS Core Motion.
     
     - Parameter attitude: `CMAttitude` object represent the rotation.
     - Warning: Please make note that this method is only available for iOS 8.0 or later.
     */
    @available(iOS 8.0, *)
    public init(attitude: CMAttitude){
        super.init()
        self.eulerAngles = EulerAngles(attitude: attitude)
        self.rotationMatrix = RotationMatrix(matrix: attitude.rotationMatrix)
        self.quaternion = Quaternion(quaternion: attitude.quaternion)
    }
    #endif
    
    public override var description: String {
        return String(format: "Rotation3D[roll: %.2f, pitch: %.2f, yaw: %.2f]", Float(self.roll), Float(self.pitch), Float(self.yaw))
    }
}

//MARK: Rotation3D Operators

//MARK:Arithmetic operators
prefix func - (rotation: Rotation3D) -> Rotation3D {
    return Rotation3D(roll: -rotation.roll, pitch: -rotation.pitch, yaw: -rotation.yaw)
}

public func + (left: Rotation3D, right: Rotation3D) -> Rotation3D {
    return Rotation3D(roll: left.roll + right.roll, pitch: left.pitch + right.pitch, yaw: left.yaw + right.yaw)
}

public func - (left: Rotation3D, right: Rotation3D) -> Rotation3D {
    return left + -right
}

public func += (inout left: Rotation3D, right: Rotation3D) {
    left = left + right
}

public func -= (inout left: Rotation3D, right: Rotation3D) {
    left = left - right
}

public func * (left: Rotation3D, right: Rotation3D) -> Rotation3D {
    return Rotation3D(roll: left.roll * right.roll, pitch: left.pitch * right.pitch, yaw: left.yaw * right.yaw)
}

public func / (left: Rotation3D, right: Rotation3D) -> Rotation3D {
    return Rotation3D(roll: left.roll / right.roll, pitch: left.pitch / right.pitch, yaw: left.yaw / right.yaw)
}

//MARK:Logical operators
public func == (left: Rotation3D, right: Rotation3D) -> Bool {
    return (left.roll == right.roll) && (left.pitch == right.pitch) && (left.yaw == right.yaw)
}

public func != (left: Rotation3D, right: Rotation3D) -> Bool {
    return !(left == right)
}