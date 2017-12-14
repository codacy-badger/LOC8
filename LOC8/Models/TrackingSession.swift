//
//  TrackingSession.swift
//  LOC8
//
//  Created by Marwan Al Masri on 05/12/2015.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation
import CoreMotion
import CoreLocation

/**
 # TrackingSession
 
 ### Discussion:
 TrackingSession is a model that is responseple to create a series of estimations. also responseble for recieve distance from `SensorsManager` and update the estimations.
 */
open class TrackingSession: Measurement {
    
    //MARK: Properties
    
    /// `EstimationHandler` object act as a deleget.
    open var estimationHandler: EstimationHandler?
    
    /// A computed property return the last estimation that has been created.
    open var currentEstimation: Estimation? {
        return estimations.last
    }
    
    /// A computed property return the previous estimation that has been created.
    open var previousEstimation: Estimation? {
        return (estimations.count > 1) ? estimations[estimations.count - 2] : nil
    }
    
    /// A list of `Heading` objects represent all the collected headings for the estimation.
    open lazy var estimations: [Estimation] = []
    
    /// A `Double` value represent the total distance for the session.
    open var distance: Double = 0
    
    //MARK:Initialization
    
    /**
     `TrackingSession` Default initializer.
     */
    public override init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Motion Updates
    
    ///An action tregered whene the `SensorsManager` recieve a distance update.
    @objc open func didUpdateDistance(_ notification: Notification) {
        let distance = notification.userInfo![DefaultKeys.DistanceKey] as! NSNumber
        
        if let oldEstimation = self.currentEstimation {
            
            if oldEstimation.headings.count == 0 {
                if let previousEstimation = previousEstimation {
                    previousEstimation.stopEstimation((distance.doubleValue - self.distance) + oldEstimation.distance)
                    self.distance = distance.doubleValue
                    estimationHandler?(previousEstimation)
                    return
                }
            }
            
            oldEstimation.stopEstimation(distance.doubleValue - self.distance )
            Log.info(sender: self, message: oldEstimation.description)
            estimationHandler?(oldEstimation)
        }
        
        self.distance = distance.doubleValue
        let newEstimation = Estimation()
        newEstimation.startEstimation(estimationHandler)
        self.estimations.append(newEstimation)
    }
    
    ///An action tregered whene the `SensorsManager` recieve a device motion update.
    open func didUpdateDeviceMotion(_ notification: Notification) {
        
//        let userInfo = notification.userInfo!
//
//        let attitude = userInfo[DefaultKeys.AttitudeKey] as! Rotation3D
//        let rotationRate = userInfo[DefaultKeys.RotationRateKey] as! Vector3D
//        let gravity = userInfo[DefaultKeys.GravityKey] as! Vector3D
//        let acceleration = userInfo[DefaultKeys.AccelerationKey] as! Vector3D
        
    }
    
    //MARK:Controlles
    
    /**
     Starts a series of continuous estimation updates to the session. 
     
     - Parameter estimationHandler: `EstimationHandler` closer that will be called each time the new heading is recived.
     */
    open func startTraking(_ estimationHandler: EstimationHandler? = nil) {
        
        self.estimationHandler = estimationHandler
        
        let newEstimation = Estimation()
        newEstimation.startEstimation(estimationHandler)
        self.estimations.append(newEstimation)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TrackingSession.didUpdateDistance(_:)), name: NSNotification.Name(rawValue: NotificationKey.DistanceUpdate), object: nil)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TrackingSession.didUpdateDeviceMotion(_:)), name: NotificationKey.DeviceMotionUpdate, object: nil)
    }
    
    /**
     Stop estimation updates.
     */
    open func stopTraking() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationKey.DistanceUpdate), object: nil)
        
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationKey.FloorUpdate, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationKey.AltitudeUpdate), object: nil)
        
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationKey.DeviceMotionUpdate, object: nil)
        
        self.estimations.removeLast()
    }
    
    /**
     Method that mearge all estimations headings.
     - Returns: A list of `Heading` objects represent the tracking map.
     */
    open func trackingMap() -> [Heading] {
        
        var temp: [Heading] = []
        
        var last: Heading?
        
        for estimation in estimations {
            
            if let last = last {
                if let first = estimation.headings.first {
                    if last.direction == first.direction {
                        last.distance += first.distance
                    }
                }
            }
            
            for heading in estimation.headings {
                if heading.direction == last?.direction {
                    continue
                }
                temp.append(heading)
            }
            last = estimation.headings.last
            
        }
        
        return temp
    }
}
