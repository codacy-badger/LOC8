//
//  MotionDetector.swift
//  LOC8
//
//  Created by Marwan Al Masri on 4/2/16.
//  Copyright © 2016 LOC8. All rights reserved.
//

import Foundation

open class MotinDetector: NSObject {
    
    /// Get currently used MotinDetector, singleton pattern
    public static let shared = MotinDetector()
    
    //MARK:Filters
    
    //Acceleration
    fileprivate var filter: AccelerationFilter!
    
    open var cutoffFrequency: Double = SettingsService.shared.accelerationFilterCutoffFrequency {
        didSet {
            setupFilter()
        }
    }
    
    open var filterType: FilterType = SettingsService.shared.accelerationFilterType {
        didSet {
            setupFilter()
        }
    }
    
    open var adaptiveFilter: Bool = SettingsService.shared.accelerationAdaptiveFilter  {
        didSet {
            filter.adaptive = adaptiveFilter
        }
    }
    
    
    open var acceleration: Acceleration {
        set {
            filter.addValue(newValue)
        }
        get {
            return filter.value
        }
    }
    
    
    fileprivate(set) var velocity: Velocity = Velocity() {
        didSet {
            finalVelocity += velocity
        }
    }
    fileprivate(set) var finalVelocity: Velocity = Velocity()
    
    
    fileprivate(set) var distance: Distance = Distance() {
        didSet {
            traveledDistance += distance
        }
    }
    fileprivate(set) var traveledDistance: Distance = Distance()
    
    
    
    override init() {
        super.init()
        setupFilter()
        NotificationCenter.default.addObserver(self, selector: #selector(MotinDetector.didUpdateDeviceMotion(_:)), name: SensorsManager.DeviceMotionUpdateNotification, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: SensorsManager.DeviceMotionUpdateNotification, object: nil)
    }
    
    fileprivate func setupFilter() {
        let rat = SensorsManager.shared.motionManagerSamplingFrequency
        self.filter = AccelerationFilter(type: self.filterType, rate: rat, cutoffFrequency: self.cutoffFrequency)
        self.filter.adaptive = self.adaptiveFilter
        self.velocity = Velocity()
        self.distance = Distance()
    }
    
    @objc open func didUpdateDeviceMotion(_ notification: Notification) {
        
        let userInfo = notification.userInfo!
        
//        let attitude = userInfo[DefaultKeys.AttitudeKey] as! Rotation3D
        let acceleration = userInfo[DefaultKeys.AccelerationKey] as! Acceleration
        
        let dt = Vector3D(value: abs(self.acceleration.timestamp - acceleration.timestamp))
        let _2 = Vector3D(value: 2)
        let dA = (self.acceleration - acceleration)
        
        self.acceleration = acceleration
        
        self.velocity =  (dA / _2) * dt
        
        self.distance = self.velocity * dt + (dA / _2) * dt * dt
        
    }
}
