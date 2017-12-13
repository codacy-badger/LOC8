//
//  MotionDetector.swift
//  LOC8
//
//  Created by Marwan Al Masri on 4/2/16.
//  Copyright © 2016 LOC8. All rights reserved.
//

import Foundation

open class MotinDetector: NSObject {
    
    //MARK:Filters
    
    //Acceleration
    fileprivate var filter: AccelerationFilter!
    
    open var cutoffFrequency: Double = SettingsService.sharedInstance.accelerationFilterCutoffFrequency {
        didSet { setupFilter() }
    }
    
    open var filterType: FilterType = SettingsService.sharedInstance.accelerationFilterType {
        didSet { setupFilter() }
    }
    
    open var adaptiveFilter: Bool = SettingsService.sharedInstance.accelerationAdaptiveFilter  {
        didSet { filter.adaptive = adaptiveFilter }
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
    
    
    /**
     * Get currently used MotinDetector, singleton pattern
     *
     * - Returns: `MotinDetector`
     */
    class var sharedInstance: MotinDetector {
        struct Singleton {
            static let instance = MotinDetector()
        }
        
        return Singleton.instance
    }
    
    override init() {
        super.init()
        setupFilter()
        NotificationCenter.default.addObserver(self, selector: #selector(MotinDetector.didUpdateDeviceMotion(_:)), name: NSNotification.Name(rawValue: NotificationKey.DeviceMotionUpdate), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationKey.DeviceMotionUpdate), object: nil)
    }
    
    
    fileprivate func setupFilter() {
        let rat = SensorsManager.sharedInstance.motionManagerSamplingFrequency
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
