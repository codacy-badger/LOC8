//
//  Accuracy.swift
//  LOC8
//
//  Created by Marwan Al Masri on 14/12/17.
//  Copyright © 2017 LOC8. All rights reserved.
//

import Foundation
#if os(iOS)
    import CoreMotion
#endif

/**
 # Accuracy
 
 ### Discussion:
 
 Enumerates the level of accuracy.
 - None
 - Low
 - Medium
 - High
 */
public enum Accuracy : Int, CustomStringConvertible {
    
    
    /// Accuracy is low.
    case none = 0
    
    /// Accuracy is low.
    case low = 1
    
    /// Accuracy is medium.
    case medium = 2
    
    /// Accuracy is high.
    case high = 3
    
    #if os(iOS)
    /**
     Initialize `Accuracy` object with `CMMotionActivityConfidence` in iOS Core Motion.
     
     - Parameter confidence: `CMAccuracy` object represent the motion activity confidence.
     - Warning: Please make note that this method is only available for iOS 7.0 or later.
     */
    public init(confidence: CMMotionActivityConfidence) {
        switch confidence {
        case .low:
            self = .low
        case .medium:
            self = .medium
        case .high:
            self = .high
        }
    }
    
    
    /**
     Initialize `Accuracy` object with `CMMotionActivity` in iOS Core Motion.
     
     - Parameter activity: `CMMotionActivity` object represent the motion activity.
     - Warning: Please make note that this method is only available for iOS 7.0 or later.
     */
    public init(activity: CMMotionActivity) {
        self.init(confidence: activity.confidence)
    }
    
    /**
     Initialize `Accuracy` object with `CMAccuracy` in iOS Core Motion.
     
     - Parameter accuracy: `CMAccuracy` object represent the motion activity confidence.
     - Warning: Please make note that this method is only available for iOS 7.0 or later.
     */
    public init(accuracy: CMMagneticFieldCalibrationAccuracy) {
        switch accuracy {
        case .uncalibrated:
            self = .none
        case .low:
            self = .low
        case .medium:
            self = .medium
        case .high:
            self = .high
        }
    }
    
    
    /**
     Initialize `Accuracy` object with `CMCalibratedMagneticField` in iOS Core Motion.
     
     - Parameter activity: `CMCalibratedMagneticField` object represent the motion activity.
     - Warning: Please make note that this method is only available for iOS 7.0 or later.
     */
    public init(magneticField: CMCalibratedMagneticField) {
        self.init(accuracy: magneticField.accuracy)
    }
    #endif
    
    public var description: String {
        switch self {
        case .none:
            return "Unknown"
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
}
