//
//  Constants.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/12/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation

//MARK:- Structures
public struct DefaultValues {
    
    public static let DefaultSamplingFrequency: Double = 60.0 //Hz
    public static let DefaultCutoffFrequency: Double = 0.5
    public static let DefaultFloorHeight: Double = 4.0
    
    public static let DefaultAnimationDuration: Double = 150.0
    
}

public struct NotificationKey{
    
    public static let  HeadingUpdate: String = "com.LOC8.HeadingUpdateNotificationKey"
    public static let  DistanceUpdate: String = "com.LOC8.DistanceUpdateNotificationKey"
    public static let  AltitudeUpdate: String = "com.LOC8.AltitudeUpdateNotificationKey"
    public static let  FloorUpdate: String = "com.LOC8.FloorUpdateNotificationKey"
    public static let  DeviceMotionUpdate: String = "com.LOC8.DeviceMotionUpdateNotificationKey"
    public static let  StepCountUpdate: String = "com.LOC8.StepCountUpdateNotificationKey"
    public static let  MotionActivityUpdate: String = "com.LOC8.MotionActivityUpdateNotificationKey"
}

public struct DefaultKeys {
    
    public static let HeadingKey = "heading"
    public static let DistanceKey = "distance"
    public static let AltitudeKey = "altitude"
    public static let FloorsAscendedKey = "floors-ascended"
    public static let FloorsDescendedKey = "floors-descended"
    public static let StepCountKey = "step-count"
    public static let MotionActivityKey = "motion-activity"
    public static let AttitudeKey = "attitude"
    public static let RotationRateKey = "rotation-rate"
    public static let GravityKey = "gravity"
    public static let AccelerationKey = "acceleration"
    public static let VelocityKey = "velocity"
}

public struct UserDefaultKeys {
    
    public static let FirstLunchKey = "first-lunch"
    public static let ColorIndexKey = "color-index"
    public static let EnableAnimationKey = "enable-animation"
    public static let AnimationDurationKey = "animation-duration"
    public static let MotionManagerSamplingFrequencyKey = "motion-manager-sampling-frequency"
    public static let AccelerationFilterCutoffFrequencyKey = "acceleration-filter-cutoff-frequency"
    public static let AccelerationFilterTypeKey = "acceleration-filter-type"
    public static let AccelerationAdaptiveFilterKey = "acceleration-adaptive-filter"
    public static let VelocityFilterCutoffFrequencyKey = "velocity-filter-cutoff-frequency"
    public static let VelocityFilterTypeKey = "velocity-filter-type"
    public static let VelocityAdaptiveFilterKey = "velocity-adaptive-filter"
}