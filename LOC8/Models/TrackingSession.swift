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

public class TrackingSession: Measurement {
    
    //MARK: Properties
    public var currentEstimation: Estimation? { return estimations.last }
    
    public var previousEstimation: Estimation? { return (estimations.count > 1) ? estimations[estimations.count - 2] : nil }
    
    public lazy var estimations: [Estimation] = []
    
    public var distance: Double = 0
    
    public var lastFloorAscendedValue = 0
    
    public var lastFloorDescendedValue = 0
    
    public var lastFloorValue = 0
    
    public var acceleration: Acceleration = Acceleration()
    
    public var estimationHandler: EstimationHandler?
    
    //MARK:Initialization
    public override init() {
        super.init()
        SensorsManager.sharedInstance
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:Controlles
    public func startTraking(estimationHandler: EstimationHandler? = nil) {
        
        self.estimationHandler = estimationHandler
        
        let newEstimation = Estimation()
        newEstimation.startEstimation(estimationHandler)
        self.estimations.append(newEstimation)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TrackingSession.didUpdateDistance(_:)), name: NotificationKey.DistanceUpdate, object: nil)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didUpdateFloor:", name: NotificationKey.FloorUpdate, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TrackingSession.didUpdateAltitude(_:)), name: NotificationKey.AltitudeUpdate, object: nil)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TrackingSession.didUpdateDeviceMotion(_:)), name: NotificationKey.DeviceMotionUpdate, object: nil)
    }
    
    public func stopTraking() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationKey.DistanceUpdate, object: nil)
        
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationKey.FloorUpdate, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationKey.AltitudeUpdate, object: nil)
        
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationKey.DeviceMotionUpdate, object: nil)
        
        self.estimations.removeLast()
    }
    
    public func trackingMap() -> [Heading] {
        
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
                if heading.direction == last?.direction { continue }
                temp.append(heading)
            }
            last = estimation.headings.last
            
        }
        
        return temp
    }
    
    //MARK: Motion Updates
    public func didUpdateDistance(notification: NSNotification) {
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
            LogManager.sharedInstance.print(self, message: oldEstimation.description)
            estimationHandler?(oldEstimation)
        }
        
        self.distance = distance.doubleValue
        let newEstimation = Estimation()
        newEstimation.startEstimation(estimationHandler)
        self.estimations.append(newEstimation)
    }
    
    public func didUpdateAltitude(notification: NSNotification) {
        
        let altitude = notification.userInfo![DefaultKeys.AltitudeKey] as! NSNumber
        
        let floor = altitude.integerValue % Int(DefaultValues.DefaultFloorHeight)
        
        if floor != lastFloorValue {
            let deltaFloor = floor - self.lastFloorValue
            
            if deltaFloor > 0 {
                self.currentEstimation?.newFloorUpdate(deltaFloor, direction: .Up)
            }
            else {
                self.currentEstimation?.newFloorUpdate(abs(deltaFloor), direction: .Down)
            }
        }
    }
    
    public func didUpdateDeviceMotion(notification: NSNotification) {
        
        let userInfo = notification.userInfo!

//        let attitude = userInfo[DefaultKeys.AttitudeKey] as! Rotation3D
//        let rotationRate = userInfo[DefaultKeys.RotationRateKey] as! Vector3D
//        let gravity = userInfo[DefaultKeys.GravityKey] as! Vector3D
        let acceleration = userInfo[DefaultKeys.AccelerationKey] as! Vector3D
        
        self.acceleration += acceleration
        
    }
    
    public func didUpdateFloor(notification: NSNotification) {
        let floorsAscended = notification.userInfo![DefaultKeys.FloorsAscendedKey] as! NSNumber
        let floorsDescended = notification.userInfo![DefaultKeys.FloorsDescendedKey] as! NSNumber
        
        if self.lastFloorAscendedValue != floorsAscended.integerValue {
            self.currentEstimation?.newFloorUpdate(abs(floorsAscended.integerValue - self.lastFloorAscendedValue), direction: .Down)
        }
        if self.lastFloorDescendedValue != floorsDescended.integerValue {
            self.currentEstimation?.newFloorUpdate(abs(floorsDescended.integerValue - self.lastFloorDescendedValue), direction: .Up)
        }
        
        self.lastFloorAscendedValue = floorsAscended.integerValue
        self.lastFloorDescendedValue = floorsDescended.integerValue
    }
}