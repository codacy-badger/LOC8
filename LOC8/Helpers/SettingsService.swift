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
            defaults.set(newValue, forKey: UserDefaultKeys.ColorIndexKey)
        }
        
        get {
            if let value = defaults.object(forKey: UserDefaultKeys.ColorIndexKey) as? Int {
                return value
            } else {
                defaults.set(0, forKey: UserDefaultKeys.ColorIndexKey)
                return 0
            }
        }
    }
    
    open var enableAnimation: Bool! {
        
        set {
            defaults.set(newValue, forKey: UserDefaultKeys.EnableAnimationKey)
        }
        
        get {
            return defaults.bool(forKey: UserDefaultKeys.EnableAnimationKey)
        }
    }
    
    open var animationDuration : Double! {
        
        set {
            defaults.set(newValue, forKey: UserDefaultKeys.AnimationDurationKey)
        }
        
        get {
            if let value = defaults.object(forKey: UserDefaultKeys.AnimationDurationKey) as? Double {
                return value
            } else {
                defaults.set(DefaultValues.DefaultAnimationDuration, forKey: UserDefaultKeys.AnimationDurationKey)
                return DefaultValues.DefaultAnimationDuration
            }
        }
    }
    
    open var motionManagerSamplingFrequency : Double! {
        
        set {
            defaults.set(newValue, forKey: UserDefaultKeys.MotionManagerSamplingFrequencyKey)
            sensorsManager.motionManagerSamplingFrequency = newValue
        }
        
        get {
            if let value = defaults.object(forKey: UserDefaultKeys.MotionManagerSamplingFrequencyKey) as? Double {
                return value
            } else {
                defaults.set(DefaultValues.DefaultSamplingFrequency, forKey: UserDefaultKeys.MotionManagerSamplingFrequencyKey)
                return DefaultValues.DefaultSamplingFrequency
            }
        }
    }
    
    //MARK:Acceleration Settings
    open var accelerationFilterCutoffFrequency : Double! {
        
        set {
            defaults.set(newValue, forKey: UserDefaultKeys.AccelerationFilterCutoffFrequencyKey)
            motionDetector.cutoffFrequency = newValue
        }
        
        get {
            if let value = defaults.object(forKey: UserDefaultKeys.AccelerationFilterCutoffFrequencyKey) as? Double {
                return value
            } else {
                defaults.set(DefaultValues.DefaultCutoffFrequency, forKey: UserDefaultKeys.AccelerationFilterCutoffFrequencyKey)
                return DefaultValues.DefaultCutoffFrequency
            }
        }
    }
    
    open var accelerationFilterType: FilterType! {
        
        set {
            defaults.set(newValue.rawValue, forKey: UserDefaultKeys.AccelerationFilterTypeKey)
            motionDetector.filterType = newValue
        }
        
        get {
            if let value = defaults.object(forKey: UserDefaultKeys.AccelerationFilterTypeKey) as? String {
                return FilterType(rawValue: value)
            } else {
                defaults.set(FilterType.Non.rawValue, forKey: UserDefaultKeys.AccelerationFilterTypeKey)
                return FilterType.Non
            }
        }
    }
    
    open var accelerationAdaptiveFilter: Bool! {
        
        set {
            defaults.set(newValue, forKey: UserDefaultKeys.AccelerationAdaptiveFilterKey)
            motionDetector.adaptiveFilter = newValue
        }
        
        get {
            return defaults.bool(forKey: UserDefaultKeys.AccelerationAdaptiveFilterKey)
        }
    }
    
    
    //MARK: Initialization
    
    public init() {
        if let _ = defaults.object(forKey: UserDefaultKeys.FirstLunchKey) {
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
