//
//  MotionActivityStatus.swift
//  LOC8
//
//  Created by Marwan Al Masri on 14/12/17.
//  Copyright © 2017 LOC8. All rights reserved.
//

import Foundation

/**
 An estimate of the user's activity based on the motion of the device.
 */
public enum MotionActivityStatus : Int, CustomStringConvertible {
    
    /// The state when the device is on a walking person.
    case walking = 0
    
    /// The state when the device is on a running person.
    case running = 1
    
    /// The state when the device is in a vehicle.
    case automotive = 2
    
    /// The state when the device is not moving.
    case stationary = 3
    
    /// The state when the device is on a bicycle.
    case cycling = 4
    
    /// The state when there is no estimate of the current state.
    /// This can happen if the device was turned off.
    case unknown = 5
    
    public var description: String {
        switch self {
        case .walking:
            return "Walking"
        case .running:
            return "Running"
        case .automotive:
            return "Automotive"
        case .stationary:
            return "Stationary"
        case .cycling:
            return "Cycling"
        case .unknown:
            return "Unknown"
        }
    }
}


#if os(iOS)
    import CoreMotion
    
    public extension MotionActivityStatus {
        
        /**
         Initialize `MotionActivityState` object with `CMMotionActivity` in iOS Core Motion.
         
         - Parameter activity: `CMMotionActivity` object represent the motion activity.
         - Warning: Please make note that this method is only available for iOS 7.0 or later.
         */
        @available(iOS 7.0, *)
        public init(activity: CMMotionActivity) {
            if activity.walking {
                self = .walking
            } else if activity.running {
                self = .running
            } else if activity.automotive {
                self = .automotive
            } else if activity.stationary {
                self = .stationary
            } else if activity.cycling {
                self = .cycling
            } else {
                self = .unknown
            }
        }
        
    }
#endif
