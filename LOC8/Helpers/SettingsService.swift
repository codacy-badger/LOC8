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
    
    //MARK: Properties
    
    //MARK:Shortcuts
    fileprivate var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    fileprivate var sensorsManager: SensorsManager {
        return SensorsManager.shared
    }
    
    fileprivate var motionDetector: MotinDetector {
        return MotinDetector.shared
    }
    
    //MARK:General Settings
    
    open var colorIndex: Int! {
        
        set {
            defaults.set(newValue, forKey: "color-index")
        }
        
        get {
            if let value = defaults.object(forKey: "color-index") as? Int {
                return value
            } else {
                defaults.set(0, forKey: "color-index")
                return 0
            }
        }
    }
    
    open var enableAnimation: Bool! {
        
        set {
            defaults.set(newValue, forKey: "enable-animation")
        }
        
        get {
            return defaults.bool(forKey: "enable-animation")
        }
    }
    
    open var animationDuration : Double! {
        
        set {
            defaults.set(newValue, forKey: "animation-duration")
        }
        
        get {
            if let value = defaults.object(forKey: "animation-duration") as? Double {
                return value
            } else {
                defaults.set(DefaultValues.DefaultAnimationDuration, forKey: "animation-duration")
                return DefaultValues.DefaultAnimationDuration
            }
        }
    }
    
    open var motionManagerSamplingFrequency : Double! {
        
        set {
            defaults.set(newValue, forKey: "motion-manager-sampling-frequency")
            sensorsManager.motionManagerSamplingFrequency = newValue
        }
        
        get {
            if let value = defaults.object(forKey: "motion-manager-sampling-frequency") as? Double {
                return value
            } else {
                defaults.set(DefaultValues.DefaultSamplingFrequency, forKey: "motion-manager-sampling-frequency")
                return DefaultValues.DefaultSamplingFrequency
            }
        }
    }
    
    //MARK:Acceleration Settings
    open var accelerationFilterCutoffFrequency : Double! {
        
        set {
            defaults.set(newValue, forKey: "acceleration-filter-cutoff-frequency")
            motionDetector.cutoffFrequency = newValue
        }
        
        get {
            if let value = defaults.object(forKey: "acceleration-filter-cutoff-frequency") as? Double {
                return value
            } else {
                defaults.set(DefaultValues.DefaultCutoffFrequency, forKey: "acceleration-filter-cutoff-frequency")
                return DefaultValues.DefaultCutoffFrequency
            }
        }
    }
    
    open var accelerationFilterType: FilterType! {
        
        set {
            defaults.set(newValue.rawValue, forKey: "acceleration-filter-type")
            motionDetector.filterType = newValue
        }
        
        get {
            if let value = defaults.object(forKey: "acceleration-filter-type") as? String {
                return FilterType(rawValue: value)
            } else {
                defaults.set(FilterType.Non.rawValue, forKey: "acceleration-filter-type")
                return FilterType.Non
            }
        }
    }
    
    open var accelerationAdaptiveFilter: Bool! {
        
        set {
            defaults.set(newValue, forKey: "acceleration-adaptive-filter")
            motionDetector.adaptiveFilter = newValue
        }
        
        get {
            return defaults.bool(forKey: "acceleration-adaptive-filter")
        }
    }
    
    
    //MARK: Initialization
    
    public init() {
        if let _ = defaults.object(forKey: "first-lunch") {
            reset()
        }
        
    }
    
    //MARK: Controlles
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
        sensorsManager.clear()
    }
}
