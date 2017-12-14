//
//  Constants.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/12/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation

//MARK: Structures
public struct DefaultValues {
    
    public static let DefaultSamplingFrequency: Double = 60.0 //Hz
    public static let DefaultCutoffFrequency: Double = 0.5
    public static let DefaultFloorHeight: Double = 4.0
    
    public static let DefaultAnimationDuration: Double = 150.0
    
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


public struct MultipeerManagerKeys {
    
    public static let PeerId: String = "PeerId"
    
    public static let Data: String = "SessionData"
    
    public static let State: String = "SessionState"
}
