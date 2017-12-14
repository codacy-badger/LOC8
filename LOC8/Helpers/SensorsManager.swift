//
//  SensorsManager.swift
//  LOC8
//
//  Created by Marwan Al Masri on 05/12/2015.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation
import CoreMotion
import CoreLocation

open class SensorsManager: NSObject {
    
    //MARK:Filters
    
    //Motion Manager
    open var motionManagerSamplingFrequency: Double = SettingsService.sharedInstance.motionManagerSamplingFrequency {
        didSet { setupMotionManager() }
    }
    
    //MARK:Current Measurements
    
    fileprivate(set) var currentAcceleration: Acceleration!
    
    fileprivate(set) var currentGravity: Acceleration!
    
    fileprivate(set) var currentRotationRat: Vector3D!
    
    fileprivate(set) var currentHeading: CLHeading?
    
    fileprivate(set) var currentAltitude: Double!
    
    fileprivate(set) var totalDistance: Double!
    
    fileprivate(set) var currentFloorsDescended: Int!
    
    fileprivate(set) var currentFloorsAscended: Int!
    
    fileprivate(set) var currentNumberOfSteps: Int!
    
    fileprivate(set) var currentMotionActivity: MotionActivity = MotionActivity()
    
    //MARK:Properties
    
    fileprivate var pedometer: CMPedometer!
    
    fileprivate var altimeter: CMAltimeter!
    
    fileprivate var motionManager: CMMotionManager!
    
    fileprivate var locationManager: CLLocationManager!
    
    fileprivate var motionActivityManager: CMMotionActivityManager!
    
    //MARK:Initialization
    
    /**
     * Get currently used SensorsManager, singleton pattern
     *
     * - Returns: `SensorsManager`
     */
    class var sharedInstance: SensorsManager {
        struct Singleton {
            static let instance = SensorsManager()
        }
        
        return Singleton.instance
    }
    
    public override init() {
        super.init()
        clear()
    }
    
    fileprivate func setupAltimeter() {
        
        if CMAltimeter.isRelativeAltitudeAvailable() {
            
            if altimeter != nil {
                altimeter.stopRelativeAltitudeUpdates()
            }
            
            altimeter = CMAltimeter()
            
            let queue = OperationQueue.main
            
            self.altimeter.startRelativeAltitudeUpdates(to: queue, withHandler: { (data, error) -> Void in
                
                guard let data = data else{ return }
                
                if error != nil {
                    print(error?.localizedDescription)
                }
                
                let altitude = data.relativeAltitude
                
                self.currentAltitude = altitude.doubleValue
                
                let userInfo: [AnyHashable: Any] = [DefaultKeys.AltitudeKey: altitude]
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationKey.AltitudeUpdate), object: nil, userInfo: userInfo)
                
            })
                
        }
    }
    
    fileprivate func setupPedometer() {
        
        if pedometer != nil {
            pedometer.stopUpdates()
        }
        
        pedometer = CMPedometer()
        
        self.pedometer.startUpdates(from: Date(timeIntervalSinceNow: 0.0), withHandler: { (data, error) -> Void in
            
            guard let data = data else { return }
            
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if CMPedometer.isDistanceAvailable() {
                
                let distance = data.distance!
                
                self.totalDistance = distance.doubleValue
                
                let userInfo: [AnyHashable: Any] = [DefaultKeys.DistanceKey: distance]
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationKey.DistanceUpdate), object: nil, userInfo: userInfo)
            }
            
            if CMPedometer.isFloorCountingAvailable() {
                
                let floorsDescended = data.floorsDescended!
                let floorsAscended = data.floorsAscended!
                
                self.currentFloorsDescended = floorsDescended.intValue
                self.currentFloorsAscended = floorsAscended.intValue
                
                let userInfo: [AnyHashable: Any] = [DefaultKeys.FloorsAscendedKey: floorsAscended, DefaultKeys.FloorsDescendedKey:floorsDescended]
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationKey.FloorUpdate), object: nil, userInfo: userInfo)
            }
            
            if CMPedometer.isStepCountingAvailable() {
                
                let numberOfSteps = data.numberOfSteps
                
                self.currentNumberOfSteps = numberOfSteps.intValue
                
                let userInfo: [AnyHashable: Any] = [DefaultKeys.StepCountKey: numberOfSteps]
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationKey.StepCountUpdate), object: nil, userInfo: userInfo)
            }
            
            })
    }
    
    fileprivate func setupMotionManager() {
            
        if motionManager != nil {
            motionManager.stopDeviceMotionUpdates()
        }
        
        motionManager = CMMotionManager()
        
        if motionManager.isDeviceMotionAvailable {
            
            motionManager.deviceMotionUpdateInterval = 1 / motionManagerSamplingFrequency
            
            let queue = OperationQueue.main
            
            motionManager.startDeviceMotionUpdates(to: queue, withHandler: { (data, error) -> Void in
                
                guard let data = data else{ return }
                
                if error != nil {
                    print(error?.localizedDescription)
                }
                
                let attitude = Rotation3D(attitude: data.attitude)
                let rotationRate = Vector3D(rotationRate: data.rotationRate)
                let gravity = Acceleration(acceleration: data.gravity)
                let acceleration = Acceleration(acceleration: data.userAcceleration)
                
                self.currentRotationRat = rotationRate
                self.currentGravity = gravity
                self.currentAcceleration = acceleration
                
                let userInfo: [AnyHashable: Any] = [
                    DefaultKeys.AttitudeKey: attitude,
                    DefaultKeys.RotationRateKey: self.currentRotationRat,
                    DefaultKeys.GravityKey: self.currentGravity,
                    DefaultKeys.AccelerationKey: self.currentAcceleration,
                ]
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationKey.DeviceMotionUpdate), object: nil, userInfo: userInfo)
            })
        }
    }
    
    fileprivate func setupLocationManager() {
        
        if locationManager != nil {
            locationManager.stopUpdatingHeading()
        }
        
        locationManager = CLLocationManager()
        locationManager.headingFilter = 1
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }
    
    fileprivate func setupMotionActivityManager() {
        
        if motionActivityManager != nil {
            motionActivityManager.stopActivityUpdates()
        }
        
        motionActivityManager = CMMotionActivityManager()
        
        if (CMMotionActivityManager.isActivityAvailable()) {
            let queue = OperationQueue.main
            motionActivityManager.startActivityUpdates(to: queue, withHandler: { (data) -> Void in
                guard let data = data else{ return }
                
                let activity = MotionActivity(activity: data)
                
                self.currentMotionActivity = activity
                
                let userInfo: [AnyHashable: Any] = [DefaultKeys.MotionActivityKey: activity]
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationKey.MotionActivityUpdate), object: nil, userInfo: userInfo)
            })
        }
    }
    
    //MARK:Controlles
    
    open func reset() {
        motionManagerSamplingFrequency = DefaultValues.DefaultSamplingFrequency
    }
    
    open func clear() {
        
        self.currentAltitude = 0
        self.totalDistance = 0
        self.currentFloorsAscended = 0
        self.currentFloorsDescended = 0
        self.currentNumberOfSteps = 0
        self.currentMotionActivity = MotionActivity()
        self.currentHeading = nil
        
        setupPedometer()
        
        setupAltimeter()
        
        setupMotionManager()
        
        setupLocationManager()
        
        setupMotionActivityManager()
    }
    
    //MARK:Data Display
    
    fileprivate func printPedometerData(_ data: CMPedometerData) -> String {
        
        var log = "[Pedometer Data] = {\n"
        
        /* Can we ask for distance updates? */
        if CMPedometer.isDistanceAvailable() {
            log += "\t[Distance = \(data.distance!)], #meters\n"
        }
        else { log += "\t[Distance is not available],\n" }
        
        /* Can we ask for floor climb/descending updates? */
        if CMPedometer.isFloorCountingAvailable() {
            log += "\t[Floors ascended = \(data.floorsAscended!)],\n"
            log += "\t[Floors descended = \(data.floorsDescended!)],\n"
        }
        else { log += "\t[Floor counting is not available],\n" }
        
        /* Can we ask for step counting updates? */
        if CMPedometer.isStepCountingAvailable() {
            log += "\t[Number of steps = \(data.numberOfSteps)]\n"
        }
        else { log += "\t[Number of steps is not available]\n" }
        log += "\n}"
        
        return log
    }
    
    fileprivate func printDeviceMotionData(_ data: [AnyHashable: Any]) -> String {
        
        var log = "[Device Motion Dat] = {\n"
        log += "\tAttitude: \(data[DefaultKeys.AttitudeKey]!),\n"
        log += "\tRotation Rate: \(data[DefaultKeys.RotationRateKey]!),\n"
        log += "\tGravity: \(data[DefaultKeys.GravityKey]!),\n"
        log += "\tAcceleration: \(data[DefaultKeys.AccelerationKey]!)\n"
        log += "\n}"
        
        return log
    }
    
}

//MARK:Location Manager Delegate
extension SensorsManager: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        currentHeading = newHeading
        
        let userInfo: [AnyHashable: Any] = [DefaultKeys.HeadingKey: newHeading]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationKey.HeadingUpdate), object: nil, userInfo: userInfo)
    }
    
    public func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool { return currentHeading == nil }
}
