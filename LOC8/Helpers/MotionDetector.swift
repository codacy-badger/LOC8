//
//  MotionDetector.swift
//  LOC8
//
//  Created by Marwan Al Masri on 4/2/16.
//  Copyright © 2016 LOC8. All rights reserved.
//

import Foundation

public class MotinDetector: NSObject {
    
    //MARK:Filters
    
    //Acceleration
    private var filter: AccelerationFilter!
    
    public var cutoffFrequency: Double = SettingsService.sharedInstance.accelerationFilterCutoffFrequency {
        didSet { setupFilter() }
    }
    
    public var filterType: FilterType = SettingsService.sharedInstance.accelerationFilterType {
        didSet { setupFilter() }
    }
    
    public var adaptiveFilter: Bool = SettingsService.sharedInstance.accelerationAdaptiveFilter  {
        didSet { filter.adaptive = adaptiveFilter }
    }
    
    
    public var acceleration: Acceleration {
        set {
            filter.addValue(newValue)
        }
        get {
            return filter.value
        }
    }
    
    
    private(set) var velocity: Velocity = Velocity() {
        didSet {
            finalVelocity += velocity
        }
    }
    private(set) var finalVelocity: Velocity = Velocity()
    
    
    private(set) var distance: Distance = Distance() {
        didSet {
            traveledDistance += distance
        }
    }
    private(set) var traveledDistance: Distance = Distance()
    
    
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MotinDetector.didUpdateDeviceMotion(_:)), name: NotificationKey.DeviceMotionUpdate, object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationKey.DeviceMotionUpdate, object: nil)
    }
    
    
    private func setupFilter() {
        let rat = SensorsManager.sharedInstance.motionManagerSamplingFrequency
        self.filter = AccelerationFilter(type: self.filterType, rate: rat, cutoffFrequency: self.cutoffFrequency)
        self.filter.adaptive = self.adaptiveFilter
        self.velocity = Velocity()
        self.distance = Distance()
    }
    
    public func didUpdateDeviceMotion(notification: NSNotification) {
        
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