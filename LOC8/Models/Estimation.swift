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
public typealias EstimationHandler = ((Estimation) -> Void)

public class Estimation: Measurement {
    
    //MARK: Properties
    public var estimationHandler: EstimationHandler?
    
    public lazy var headings: [Heading] = []
    
    public var acceleration: Acceleration = Acceleration()
    
    public var distance: Double = 0
    
    var currentFloor: Int!
    
    var currentFloorValue: Int!
    
    public var currentHeading: Heading? { return headings.last }
    
    public var wight: UInt {
        var totalWight: UInt = 0
        for heading in headings { totalWight += heading.wight }
        return totalWight
    }
    
    public var mean: Double {
        if headings.count == 0 { return 0 }
        return Double(self.wight) / Double(headings.count)
    }
    
    public var variance: Double {
        if headings.count <= 1 { return 0 }
        var variance: Double = 0
        for heading in headings { variance += pow((Double(heading.wight) - mean), 2) }
        variance = variance / Double(headings.count - 1)
        return sqrt(variance)
    }
    
    
    //MARK:Initialization
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
    }
    
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
        
    }
    
    public func newFloorUpdate(numberOfFloors: Int, direction: Direction) {
        let heading = Heading(direction: direction)
        heading.distance = Double(numberOfFloors) * DefaultValues.DefaultFloorHeight
        heading.wight = 1
        self.headings.append(heading)

    }
    
    //MARK:Controlle
    public func startEstimation( estimationHandler: EstimationHandler? = nil) {
        
        self.estimationHandler =  estimationHandler
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Estimation.didUpdateHeading(_:)), name: NotificationKey.HeadingUpdate, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didUpdateDeviceMotion:", name: NotificationKey.DeviceMotionUpdate, object: nil)
    }
    
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
