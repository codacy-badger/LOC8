//
//  SettingsService.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/26/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation

open class SettingsService {
    
    /// Get currently used SettingsService, singleton pattern
    public static let shared = SettingsService()
    
    // MARK: General Settings
    
    open var colorIndex: Int! {
        set {
            UserDefaults.standard.set(newValue, forKey: "color-index")
        }
        get {
            return UserDefaults.standard.integer(forKey: "color-index")
        }
    }
    
    open var enableAnimation: Bool! {
        set {
            UserDefaults.standard.set(newValue, forKey: "enable-animation")
        }
        get {
            return UserDefaults.standard.bool(forKey: "enable-animation")
        }
    }
    
    open var animationDuration : Double! {
        set {
            UserDefaults.standard.set(newValue, forKey: "animation-duration")
        }
        get {
            if let value = UserDefaults.standard.object(forKey: "animation-duration") as? Double {
                return value
            } else {
                UserDefaults.standard.set(DefaultValues.DefaultAnimationDuration, forKey: "animation-duration")
                return DefaultValues.DefaultAnimationDuration
            }
        }
    }
    
    open var motionManagerSamplingFrequency : Double! {
        set {
            UserDefaults.standard.set(newValue, forKey: "motion-manager-sampling-frequency")
            SensorsManager.shared.motionManagerSamplingFrequency = newValue
        }
        get {
            if let value = UserDefaults.standard.object(forKey: "motion-manager-sampling-frequency") as? Double {
                return value
            } else {
                UserDefaults.standard.set(DefaultValues.DefaultSamplingFrequency, forKey: "motion-manager-sampling-frequency")
                return DefaultValues.DefaultSamplingFrequency
            }
        }
    }
    
    // MARK: Acceleration Settings
    open var accelerationFilterCutoffFrequency : Double! {
        set {
            UserDefaults.standard.set(newValue, forKey: "acceleration-filter-cutoff-frequency")
            MotinDetector.shared.cutoffFrequency = newValue
        }
        get {
            if let value = UserDefaults.standard.object(forKey: "acceleration-filter-cutoff-frequency") as? Double {
                return value
            } else {
                UserDefaults.standard.set(DefaultValues.DefaultCutoffFrequency, forKey: "acceleration-filter-cutoff-frequency")
                return DefaultValues.DefaultCutoffFrequency
            }
        }
    }
    
    open var accelerationFilterType: FilterType! {
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "acceleration-filter-type")
            MotinDetector.shared.filterType = newValue
        }
        get {
            if let value = UserDefaults.standard.object(forKey: "acceleration-filter-type") as? String {
                return FilterType(rawValue: value)
            } else {
                UserDefaults.standard.set(FilterType.Non.rawValue, forKey: "acceleration-filter-type")
                return FilterType.Non
            }
        }
    }
    
    open var accelerationAdaptiveFilter: Bool! {
        set {
            UserDefaults.standard.set(newValue, forKey: "acceleration-adaptive-filter")
            MotinDetector.shared.adaptiveFilter = newValue
        }
        get {
            return UserDefaults.standard.bool(forKey: "acceleration-adaptive-filter")
        }
    }
    
    
    // MARK: Initialization
    
    public init() {
        if !UserDefaults.standard.bool(forKey: "first-lunch") {
            UserDefaults.standard.set(true, forKey: "first-lunch")
            reset()
        }
    }
    
    // MARK: Controlles
    open func reset() {
        colorIndex = 0
        enableAnimation = false
        animationDuration = DefaultValues.DefaultAnimationDuration
        
        motionManagerSamplingFrequency = DefaultValues.DefaultSamplingFrequency
        
        accelerationFilterCutoffFrequency = DefaultValues.DefaultCutoffFrequency
        accelerationFilterType = .Non
        accelerationAdaptiveFilter = true
    }
    
    open func clear() {
        SensorsManager.shared.clear()
    }
}
