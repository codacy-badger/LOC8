//
//  MotionActivity.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/27/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation
#if os(iOS)
    import CoreMotion
#endif

/**
 # Motion Activity Confidence
 
 ### Discussion:
 
    Enumerates the level of accuracy of the activity estimate.
 
  - Low
  - Medium
  - High
 */
public enum MotionActivityConfidence : Int {
    
    case Low = 0
    case Medium = 1
    case High = 2
    
    #if os(iOS)
    public init(confidence: CMMotionActivityConfidence){
        switch confidence {
        case .Low: self = .Low
        case .Medium: self = .Medium
        case .High: self = .High
        }
    }
    
    public init(activity: CMMotionActivity) {
        self.init(confidence: activity.confidence)
    }
    #endif
}

extension MotionActivityConfidence:  CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .Low: return "Low"
        case .Medium: return "Medium"
        case .High: return "High"
        }
    }
}

/**
 # Motion Activity Status
 
 ### Discussion:
 
 An estimate of the user's activity based on the motion of the device.
 
  - Walking
  - Running
  - Automotive
  - Stationary
  - Cycling
  - Unknown
 */
public enum MotionActivityStatus : Int {
    
    ///The state when the device is on a walking person.
    case walking = 0
    
    ///The state when the device is on a running person.
    case running = 1
    
    ///The state when the device is in a vehicle.
    case automotive = 2
    
    ///The state when the device is not moving.
    case stationary = 3
    
    ///The state when the device is on a bicycle.
    case cycling = 4
    
    ///The state when there is no estimate of the current state.  
    ///This can happen if the device was turned off.
    case unknown = 5
    
    #if os(iOS)
    
    /**
     Initialize `MotionActivityState` object with `CMMotionActivity` in iOS Core Motion.
     
     - Parameter activity: `CMMotionActivity` object represent the motion activity.
     - Warning: Please make note that this method is only available for iOS 7.0 or later.
     */
    @available(iOS 7.0, *)
    public init(activity: CMMotionActivity){
        if activity.walking { self = walking }
        else if activity.running { self = running }
        else if activity.automotive { self = automotive }
        else if activity.stationary { self = .stationary }
        else if activity.cycling { self = .cycling }
        else { self = .unknown }
    }
    #endif
    
}

extension MotionActivityStatus:  CustomStringConvertible {
    
    public var description: String {
        switch self {
        case walking: return "Walking"
        case running: return "Running"
        case automotive: return "Automotive"
        case stationary: return "Stationary"
        case cycling: return "Cycling"
        case unknown: return "Unknown"
        }
    }
}

/**
   # MotionActivity
 
   ### Discussion:
     An estimate of the user's activity based on the motion of the device.
     This object contains the motion activity of the user along with the confidence of this activity.
 
 */
public class MotionActivity: Measurement {
    
    //MARK:Properties
    
    ///`MotionActivityStatus` object represent the state of the activity.
    private(set) var status: MotionActivityStatus!
    
    ///`MotionActivityConfidence` object represent the confidance of the activity state.
    private(set) var confidence: MotionActivityConfidence!
    
    //MARK:Initialaization
    
    /**
     `MotionActivity` Default initializer.
     */
    public override init() {
        super.init()
        status = .unknown
        confidence = .Low
    }
    
    
    /**
      Initialize MotionActivity object
     
      - Parameters:
      	- status: A MotionActivityStatus value represent the activity.
      	- confidence: A MotionActivityConfidence value represent the confidence of the activity.
     */
    public init(status: MotionActivityStatus, confidence: MotionActivityConfidence) {
        super.init()
        self.status = status
        self.confidence = confidence
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        status = MotionActivityStatus(rawValue: aDecoder.decodeIntegerForKey("status"))!
        confidence = MotionActivityConfidence(rawValue: aDecoder.decodeIntegerForKey("confidence"))!
    }
    
    public override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeInteger(status.rawValue, forKey: "status")
        aCoder.encodeInteger(confidence.rawValue, forKey: "confidence")
    }
    
    #if os(iOS)
    
    /**
     Initialize `MotionActivity` object with `CMMotionActivity` in iOS Core Motion.
     
     - Parameter activity: `CMMotionActivity` object represent the motion activity.
     - Warning: Please make note that this method is only available for iOS 7.0 or later.
     */
    @available(iOS 7.0, *)
    public convenience init(activity: CMMotionActivity) {
        self.init(status: MotionActivityStatus(activity: activity), confidence: MotionActivityConfidence(activity: activity))
    }
    #endif
    
    public override var description: String {
        return "\(status) confidence \(confidence)"
    }
}