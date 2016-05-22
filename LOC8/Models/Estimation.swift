//
//  Estimation.swift
//  LOC8
//
//  Created by Marwan Al Masri on 10/17/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion

//MARK:- Estimation

/**
 # Estimation Handler
 
 ### Discussion:
 A closer type that take an `Estimation` object and retun nothing
 */
public typealias EstimationHandler = ((Estimation) -> Void)

/**
  # Estimation

  ### Discussion:
    Estimation is a model that is responseple to collect headings until distance value come up.
 */
public class Estimation: Measurement {
    
    //MARK: Properties
    
    /// `EstimationHandler` object act as a deleget.
    public var estimationHandler: EstimationHandler?
    
    /// A list of `Heading` objects represent all the collected headings for the estimation.
    public lazy var headings: [Heading] = []
    
    /// A `Double` value represent the total distance for the estimation
    public var distance: Double = 0
    
    /// A computed property return the last heading recieved.
    public var currentHeading: Heading? { return headings.last }
    
    /// A computed property return the total wight for all the collected headings.
    public var wight: UInt {
        var totalWight: UInt = 0
        for heading in headings { totalWight += heading.wight }
        return totalWight
    }
    
    /// A computed property return the sample mean for all the collected headings wight.
    public var mean: Double {
        if headings.count == 0 { return 0 }
        return Double(self.wight) / Double(headings.count)
    }
    
    /// A computed property return the sample variance for all the collected headings wight
    public var variance: Double {
        if headings.count <= 1 { return 0 }
        var variance: Double = 0
        for heading in headings { variance += pow((Double(heading.wight) - mean), 2) }
        variance = variance / Double(headings.count - 1)
        return sqrt(variance)
    }
    
    
    //MARK:Initialization
    
    /**
     `Estimation` Default initializer.
     */
    public override init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var description: String {
        var result: String = "{\n\tNumber of headings: \(headings.count)\n\tTotal Distance:\(distance)\n\tTotal Wight:\(wight)\n\tMean:\(mean)\n\tVariance:\(variance)\n\tHeadings:[\n"
        
        for heading in headings { result += "\t\t\(heading.description)\n"}
        
        result += "\t]\n}"
        return result
    }
    
    //MARK: Motion Updates
    
    ///An action tregered whene the `SensorsManager` recieve a heading update.
    public func didUpdateHeading (notification: NSNotification) {
        
        let heading = notification.userInfo![DefaultKeys.HeadingKey] as! CLHeading
        
        let newHeading = Heading(angle: heading.magneticHeading)
        
        if headings.count == 0 {
            headings.append(newHeading)
        }
        else {
            
            if let oldHeading = headings.last {
                
                if oldHeading == newHeading{
                    oldHeading.wight += 1
                }
                else {
                    headings.append(newHeading)
                    LogManager.sharedInstance.print(self, message: oldHeading.description)
                }
            }
        }
        self.estimationHandler?(self)
    }
    
    ///An action tregered whene the `SensorsManager` recieve a device motion update.
    public func didUpdateDeviceMotion(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        
//        let attitude = userInfo[DefaultKeys.AttitudeKey] as! Rotation3D
//        let rotationRate = userInfo[DefaultKeys.RotationRateKey] as! Vector3D
//        let gravity = userInfo[DefaultKeys.GravityKey] as! Vector3D
        let acceleration = userInfo[DefaultKeys.AccelerationKey] as! Vector3D
        
        let newHeading = Heading(angle: acceleration.theta)
        
        if headings.count == 0 {
            headings.append(newHeading)
        }
        else {
            
            if let oldHeading = headings.last {
                
                if oldHeading == newHeading{
                    oldHeading.wight += 1
                }
                else {
                    headings.append(newHeading)
                    LogManager.sharedInstance.print(self, message: oldHeading.description)
                }
            }
        }
        self.estimationHandler?(self)
    }
    
    //MARK:Controlle
    
    /**
     Starts a series of continuous heading updates to the estimation.
     
     - Parameter estimationHandler: `EstimationHandler` closer that will be called each time new heading is recived.
     */
    public func startEstimation( estimationHandler: EstimationHandler? = nil) {
        
        self.estimationHandler =  estimationHandler
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Estimation.didUpdateHeading(_:)), name: NotificationKey.HeadingUpdate, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didUpdateDeviceMotion:", name: NotificationKey.DeviceMotionUpdate, object: nil)
    }
    
    /**
     Stop heading updates.
     
     - Parameter distance: `Double` value that represent the total distance update.
     */
    public func stopEstimation(distance: Double){
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationKey.HeadingUpdate, object: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationKey.DeviceMotionUpdate, object: nil)
        
        self.distance = distance
        
        let delta = distance / Double(self.wight)
        
        for heading in headings {
            if heading.direction == .Up || heading.direction == .Down { continue }
            heading.distance = Double(heading.wight) * delta
        }
        
    }
}
