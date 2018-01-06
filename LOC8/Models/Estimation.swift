//
//  Estimation.swift
//  LOC8
//
//  Created by Marwan Al Masri on 10/17/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import CoreLocation
import Foundation

/**
 A closer type that take an `Estimation` object and retun nothing
 */
public typealias EstimationHandler = ((Estimation) -> Void)

/**
 An object the represent an estimation for motions repeted over a segment of time.

  ### Discussion:
    Estimation is a model that is responseple to collect headings until distance value come up.
 */
open class Estimation: Measurement {
    
    // MARK: Properties
    
    /// `EstimationHandler` object act as a deleget.
    open var estimationHandler: EstimationHandler?
    
    /// A list of `Heading` objects represent all the collected headings for the estimation.
    open lazy var headings: [Motion] = []
    
    /// A `Double` value represent the total distance for the estimation
    open var distance: Double = 0
    
    /// A computed property return the last heading recieved.
    open var currentHeading: Motion? {
        return headings.last
    }
    
    /// A computed property return the total wight for all the collected headings.
    open var wight: UInt {
        var totalWight: UInt = 0
        for heading in headings {
            totalWight += heading.wight
        }
        return totalWight
    }
    
    /// A computed property return the sample mean for all the collected headings wight.
    open var mean: Double {
        if headings.isEmpty {
            return 0
        }
        return Double(self.wight) / Double(headings.count)
    }
    
    /// A computed property return the sample variance for all the collected headings wight
    open var variance: Double {
        if headings.count <= 1 {
            return 0
        }
        var variance: Double = 0
        for heading in headings {
            variance += pow((Double(heading.wight) - mean), 2)
        }
        variance = variance / Double(headings.count - 1)
        return sqrt(variance)
    }
    
    // MARK: Initialization
    
    /**
     `Estimation` Default initializer.
     */
    public override init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override var description: String {
        var result: String = "{\n\tNumber of headings: \(headings.count)\n\tTotal Distance:\(distance)\n\tTotal Wight:\(wight)\n\tMean:\(mean)\n\tVariance:\(variance)\n\tHeadings:[\n"
        
        for heading in headings {
            result += "\t\t\(heading.description)\n"
        }
        
        result += "\t]\n}"
        return result
    }
    
    // MARK: Motion Updates
    
    /// An action tregered whene the `SensorsManager` recieve a heading update.
    @objc
    open func didUpdateHeading (_ notification: Notification) {
        
        let heading = notification.userInfo![DefaultKeys.HeadingKey] as? CLHeading ?? CLHeading()
        
        let newHeading = Motion(angle: heading.magneticHeading)
        
        if headings.isEmpty {
            headings.append(newHeading)
        } else {
            
            if let oldHeading = headings.last {
                
                if oldHeading == newHeading {
                    oldHeading.wight += 1
                } else {
                    headings.append(newHeading)
                    Log.info(sender: self, message: oldHeading.description)
                }
            }
        }
        self.estimationHandler?(self)
    }
    
    /// An action tregered whene the `SensorsManager` recieve a device motion update.
    open func didUpdateDeviceMotion(_ notification: Notification) {
        
        let userInfo = notification.userInfo!
        
        let attitude = userInfo[DefaultKeys.AttitudeKey] as? Rotation3D ?? Rotation3D()
//        let rotationRate = userInfo[DefaultKeys.RotationRateKey] as! Vector3D
//        let gravity = userInfo[DefaultKeys.GravityKey] as! Vector3D
//        let acceleration = userInfo[DefaultKeys.AccelerationKey] as! Vector3D
        
        let velocity = MotinDetector.shared.velocity ^ attitude
        
        let newHeading = Motion(direction: velocity.headingDirection)
        
        if headings.isEmpty {
            headings.append(newHeading)
        } else {
            
            if let oldHeading = headings.last {
                
                if oldHeading == newHeading {
                    oldHeading.wight += 1
                } else {
                    headings.append(newHeading)
                    Log.info(sender: self, message: oldHeading.description)
                }
            }
        }
        self.estimationHandler?(self)
    }
    
    // MARK: Controlle
    
    /**
     Starts a series of continuous heading updates to the estimation.
     
     - Parameter estimationHandler: `EstimationHandler` closer that will be called each time new heading is recived.
     */
    open func startEstimation( _ estimationHandler: EstimationHandler? = nil) {
        
        self.estimationHandler =  estimationHandler
        
        NotificationCenter.default.addObserver(self, selector: #selector(Estimation.didUpdateHeading(_:)), name: SensorsManager.HeadingUpdateNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didUpdateDeviceMotion:", name: SensorsManager.DeviceMotionUpdate, object: nil)
    }
    
    /**
     Stop heading updates.
     
     - Parameter distance: `Double` value that represent the total distance update.
     */
    open func stopEstimation(_ distance: Double) {
        
        NotificationCenter.default.removeObserver(self, name: SensorsManager.HeadingUpdateNotification, object: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: SensorsManager.DeviceMotionUpdate, object: nil)
        
        self.distance = distance
        
        let delta = distance / Double(self.wight)
        
        for heading in headings {
            if heading.direction == .up || heading.direction == .down {
                continue
            }
            heading.distance = Double(heading.wight) * delta
        }
        
    }
}
