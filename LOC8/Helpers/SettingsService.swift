//
//  SettingsService.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/26/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation

public class SettingsService {
    
    //MARK: Properties
    
    //MARK:Shortcuts
    private var defaults: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    private var sensorsManager: SensorsManager {
        return SensorsManager.sharedInstance
    }
    
    private var motionDetector: MotinDetector {
        return MotinDetector.sharedInstance
    }
    
    //MARK:General Settings
    
    public var colorIndex: Int! {
        
        set {
            defaults.setObject(newValue, forKey: UserDefaultKeys.ColorIndexKey)
        }
        
        get {
            if let value = defaults.objectForKey(UserDefaultKeys.ColorIndexKey) as? Int {
                return value
            }
            else {
                defaults.setObject(0, forKey: UserDefaultKeys.ColorIndexKey)
                return 0
            }
        }
    }
    
    public var enableAnimation: Bool! {
        
        set {
            defaults.setBool(newValue, forKey: UserDefaultKeys.EnableAnimationKey)
        }
        
        get {
            return defaults.boolForKey(UserDefaultKeys.EnableAnimationKey)
        }
    }
    
    public var animationDuration : Double! {
        
        set {
            defaults.setObject(newValue, forKey: UserDefaultKeys.AnimationDurationKey)
        }
        
        get {
            if let value = defaults.objectForKey(UserDefaultKeys.AnimationDurationKey) as? Double {
                return value
            }
            else {
                defaults.setObject(DefaultValues.DefaultAnimationDuration, forKey: UserDefaultKeys.AnimationDurationKey)
                return DefaultValues.DefaultAnimationDuration
            }
        }
    }
    
    public var motionManagerSamplingFrequency : Double! {
        
        set {
            defaults.setObject(newValue, forKey: UserDefaultKeys.MotionManagerSamplingFrequencyKey)
            sensorsManager.motionManagerSamplingFrequency = newValue
        }
        
        get {
            if let value = defaults.objectForKey(UserDefaultKeys.MotionManagerSamplingFrequencyKey) as? Double {
                return value
            }
            else {
                defaults.setObject(DefaultValues.DefaultSamplingFrequency, forKey: UserDefaultKeys.MotionManagerSamplingFrequencyKey)
                return DefaultValues.DefaultSamplingFrequency
            }
        }
    }
    
    //MARK:Acceleration Settings
    public var accelerationFilterCutoffFrequency : Double! {
        
        set {
            defaults.setObject(newValue, forKey: UserDefaultKeys.AccelerationFilterCutoffFrequencyKey)
            motionDetector.cutoffFrequency = newValue
        }
        
        get {
            if let value = defaults.objectForKey(UserDefaultKeys.AccelerationFilterCutoffFrequencyKey) as? Double {
                return value
            }
            else {
                defaults.setObject(DefaultValues.DefaultCutoffFrequency, forKey: UserDefaultKeys.AccelerationFilterCutoffFrequencyKey)
                return DefaultValues.DefaultCutoffFrequency
            }
        }
    }
    
    public var accelerationFilterType: FilterType! {
        
        set {
            defaults.setObject(newValue.rawValue, forKey: UserDefaultKeys.AccelerationFilterTypeKey)
            motionDetector.filterType = newValue
        }
        
        get {
            if let value = defaults.objectForKey(UserDefaultKeys.AccelerationFilterTypeKey) as? String {
                return FilterType(rawValue: value)
            }
            else {
                defaults.setObject(FilterType.Non.rawValue, forKey: UserDefaultKeys.AccelerationFilterTypeKey)
                return FilterType.Non
            }
        }
    }
    
    public var accelerationAdaptiveFilter: Bool! {
        
        set {
            defaults.setBool(newValue, forKey: UserDefaultKeys.AccelerationAdaptiveFilterKey)
            motionDetector.adaptiveFilter = newValue
        }
        
        get {
            return defaults.boolForKey(UserDefaultKeys.AccelerationAdaptiveFilterKey)
        }
    }
    
    
    //MARK: Initialization
    
    /**
     * Get currently used SettingsService, singleton pattern
     *
     * - Returns: `SettingsService`
     */
    class var sharedInstance: SettingsService {
        struct Singleton {
            static let instance = SettingsService()
        }
        
        return Singleton.instance
    }
    
    public init() {
        if let _ = defaults.objectForKey(UserDefaultKeys.FirstLunchKey) {
            reset()
        }
        
    }
    
    //MARK: Controlles
    public func reset() {
        colorIndex = 0
        enableAnimation = false
        animationDuration = DefaultValues.DefaultAnimationDuration
        
        motionManagerSamplingFrequency = DefaultValues.DefaultSamplingFrequency
        
        accelerationFilterCutoffFrequency = DefaultValues.DefaultCutoffFrequency
        accelerationFilterType = .Non
        accelerationAdaptiveFilter = true
    }
    
    public func clear() {
        sensorsManager.clear()
    }
}
