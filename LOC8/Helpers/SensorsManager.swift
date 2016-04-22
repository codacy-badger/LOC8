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

public class SensorsManager: NSObject {
    
    //MARK:Filters
    
    //Motion Manager
    public var motionManagerSamplingFrequency: Double = SettingsService.sharedInstance.motionManagerSamplingFrequency {
        didSet { setupMotionManager() }
    }
    
    //MARK:Current Measurements
    
    private(set) var currentAcceleration: Acceleration!
    
    private(set) var currentGravity: Acceleration!
    
    private(set) var currentRotationRat: Vector3D!
    
    private(set) var currentHeading: CLHeading?
    
    private(set) var currentAltitude: Double!
    
    private(set) var totalDistance: Double!
    
    private(set) var currentFloorsDescended: Int!
    
    private(set) var currentFloorsAscended: Int!
    
    private(set) var currentNumberOfSteps: Int!
    
    private(set) var currentMotionActivity: MotionActivity = MotionActivity()
    
    //MARK:Properties
    
    private var pedometer: CMPedometer!
    
    private var altimeter: CMAltimeter!
    
    private var motionManager: CMMotionManager!
    
    private var locationManager: CLLocationManager!
    
    private var motionActivityManager: CMMotionActivityManager!
    
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
    
    private func setupAltimeter() {
        
        if CMAltimeter.isRelativeAltitudeAvailable() {
            
            if altimeter != nil {
                altimeter.stopRelativeAltitudeUpdates()
            }
            
            altimeter = CMAltimeter()
            
            let queue = NSOperationQueue.mainQueue()
            
            self.altimeter.startRelativeAltitudeUpdatesToQueue(queue, withHandler: { (data, error) -> Void in
                
                guard let data = data else{ return }
                
                if error != nil {
                    print(error?.localizedDescription)
                }
                
                let altitude = data.relativeAltitude
                
                self.currentAltitude = altitude.doubleValue
                
                let userInfo: [NSObject: AnyObject] = [DefaultKeys.AltitudeKey: altitude]
                
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.AltitudeUpdate, object: nil, userInfo: userInfo)
                
            })
                
        }
    }
    
    private func setupPedometer() {
        
        if pedometer != nil {
            pedometer.stopPedometerUpdates()
        }
        
        pedometer = CMPedometer()
        
        self.pedometer.startPedometerUpdatesFromDate(NSDate(timeIntervalSinceNow: 0.0), withHandler: { (data, error) -> Void in
            
            guard let data = data else { return }
            
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if CMPedometer.isDistanceAvailable() {
                
                let distance = data.distance!
                
                self.totalDistance = distance.doubleValue
                
                let userInfo: [NSObject: AnyObject] = [DefaultKeys.DistanceKey: distance]
                
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.DistanceUpdate, object: nil, userInfo: userInfo)
            }
            
            if CMPedometer.isFloorCountingAvailable() {
                
                let floorsDescended = data.floorsDescended!
                let floorsAscended = data.floorsAscended!
                
                self.currentFloorsDescended = floorsDescended.integerValue
                self.currentFloorsAscended = floorsAscended.integerValue
                
                let userInfo: [NSObject: AnyObject] = [DefaultKeys.FloorsAscendedKey: floorsAscended, DefaultKeys.FloorsDescendedKey:floorsDescended]
                
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.FloorUpdate, object: nil, userInfo: userInfo)
            }
            
            if CMPedometer.isStepCountingAvailable() {
                
                let numberOfSteps = data.numberOfSteps
                
                self.currentNumberOfSteps = numberOfSteps.integerValue
                
                let userInfo: [NSObject: AnyObject] = [DefaultKeys.StepCountKey: numberOfSteps]
                
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.StepCountUpdate, object: nil, userInfo: userInfo)
            }
            
            })
    }
    
    private func setupMotionManager() {
            
        if motionManager != nil {
            motionManager.stopDeviceMotionUpdates()
        }
        
        motionManager = CMMotionManager()
        
        if motionManager.deviceMotionAvailable {
            
            motionManager.deviceMotionUpdateInterval = 1 / motionManagerSamplingFrequency
            
            let queue = NSOperationQueue.mainQueue
            
            motionManager.startDeviceMotionUpdatesToQueue(queue(), withHandler: { (data, error) -> Void in
                
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
                
                let userInfo: [NSObject: AnyObject] = [
                    DefaultKeys.AttitudeKey: attitude,
                    DefaultKeys.RotationRateKey: self.currentRotationRat,
                    DefaultKeys.GravityKey: self.currentGravity,
                    DefaultKeys.AccelerationKey: self.currentAcceleration,
                ]
                
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.DeviceMotionUpdate, object: nil, userInfo: userInfo)
            })
        }
    }
    
    private func setupLocationManager() {
        
        if locationManager != nil {
            locationManager.stopUpdatingHeading()
        }
        
        locationManager = CLLocationManager()
        locationManager.headingFilter = 1
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }
    
    private func setupMotionActivityManager() {
        
        if motionActivityManager != nil {
            motionActivityManager.stopActivityUpdates()
        }
        
        motionActivityManager = CMMotionActivityManager()
        
        if (CMMotionActivityManager.isActivityAvailable()) {
            let queue = NSOperationQueue.mainQueue
            motionActivityManager.startActivityUpdatesToQueue(queue(), withHandler: { (data) -> Void in
                guard let data = data else{ return }
                
                let activity = MotionActivity(activity: data)
                
                self.currentMotionActivity = activity
                
                let userInfo: [NSObject: AnyObject] = [DefaultKeys.MotionActivityKey: activity]
                
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.MotionActivityUpdate, object: nil, userInfo: userInfo)
            })
        }
    }
    
    //MARK:Controlles
    
    public func reset() {
        motionManagerSamplingFrequency = DefaultValues.DefaultSamplingFrequency
    }
    
    public func clear() {
        
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
    
    private func printPedometerData(data: CMPedometerData) -> String {
        
        var log = "[Pedometer Data] = {\n"
        
        /* Can we ask for distance updates? */
        if CMPedometer.isDistanceAvailable(){
            log += "\t[Distance = \(data.distance!)], #meters\n"
        }
        else { log += "\t[Distance is not available],\n" }
        
        /* Can we ask for floor climb/descending updates? */
        if CMPedometer.isFloorCountingAvailable(){
            log += "\t[Floors ascended = \(data.floorsAscended!)],\n"
            log += "\t[Floors descended = \(data.floorsDescended!)],\n"
        }
        else { log += "\t[Floor counting is not available],\n" }
        
        /* Can we ask for step counting updates? */
        if CMPedometer.isStepCountingAvailable(){
            log += "\t[Number of steps = \(data.numberOfSteps)]\n"
        }
        else { log += "\t[Number of steps is not available]\n" }
        log += "\n}"
        
        return log
    }
    
    private func printDeviceMotionData(data: [NSObject: AnyObject]) -> String {
        
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

    public func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        currentHeading = newHeading
        
        let userInfo: [NSObject: AnyObject] = [DefaultKeys.HeadingKey: newHeading]
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.HeadingUpdate, object: nil, userInfo: userInfo)
    }
    
    public func locationManagerShouldDisplayHeadingCalibration(manager: CLLocationManager) -> Bool { return currentHeading == nil }
}