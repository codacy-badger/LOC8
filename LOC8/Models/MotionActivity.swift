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

//MARK:- MotionActivityConfidence

/**
 *  MotionActivityConfidence
 *
 * - Low
 * - Medium
 * - High
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

//MARK:- MotionActivityStatus

/**
 * Heading MotionActivityConfidence
 *
 * - walking
 * - running
 * - automotive
 * - stationary
 * - cycling
 * - unknown
 */
public enum MotionActivityStatus : Int {
    
    case walking = 0
    case running = 1
    case automotive = 2
    case stationary = 3
    case cycling = 4
    case unknown = 5
    
    #if os(iOS)
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

//MARK:- Motion Activity

/**
 *  MotionActivity
 *
 *  Discussion:
 *    An estimate of the user's activity based on the motion of the device.
 *    This object contains the motion activity of the user with the confidence of this activity.
 *
 */
public class MotionActivity: Measurement {
    
    //MARK:Properties
    private(set) var status: MotionActivityStatus!
    
    private(set) var confidence: MotionActivityConfidence!
    
    //MARK:Initialaization
    public override init() {
        super.init()
        status = .unknown
        confidence = .Low
    }
    
    
    /**
     * Initialize MotionActivity object
     *
     * - Parameters:
     * 	- status: A MotionActivityStatus value represent the activity.
     * 	- confidence: A MotionActivityConfidence value represent the confidence of the activity.
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
    public convenience init(activity: CMMotionActivity) {
        self.init(status: MotionActivityStatus(activity: activity), confidence: MotionActivityConfidence(activity: activity))
    }
    #endif
    
    public override var description: String {
        return "\(status) confidence \(confidence)"
    }
}