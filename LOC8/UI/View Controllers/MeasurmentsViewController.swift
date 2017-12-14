//
//  MeasurmentsViewController.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/24/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

open class MeasurmentsViewController: UITableViewController {
    
    //MARK:Properties
    
    @IBOutlet weak var headingCell: AngleTableViewCell!
    
    @IBOutlet weak var geomagnetismCell: Vector3DTableViewCell!
    
    
    @IBOutlet weak var altitudeCell: ValueTableViewCell!
    
    
    @IBOutlet weak var attitudeCell: Rotation3DTableViewCell!
    
    
    @IBOutlet weak var pedometerCell: PedometerTableViewCell!
    
    
    @IBOutlet weak var accelerationCell: Vector3DTableViewCell!
    
    @IBOutlet weak var accelerationGraphCell: GraphTableViewCell!
    
    
    @IBOutlet weak var velocityCell: Vector3DTableViewCell!
    
    @IBOutlet weak var velocityGraphCell: GraphTableViewCell!
    
    
    @IBOutlet weak var gravityCell: Vector3DTableViewCell!
    
    @IBOutlet weak var rotationRateCell: Vector3DTableViewCell!
    
    //MARK:Lifcycle
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(MeasurmentsViewController.didUpdateHeading(_:)), name: NSNotification.Name(rawValue: NotificationKey.HeadingUpdate), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MeasurmentsViewController.didUpdateAltitude(_:)), name: NSNotification.Name(rawValue: NotificationKey.AltitudeUpdate), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MeasurmentsViewController.didUpdateDeviceMotion(_:)), name: NSNotification.Name(rawValue: NotificationKey.DeviceMotionUpdate), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MeasurmentsViewController.didUpdateDistance(_:)), name: NSNotification.Name(rawValue: NotificationKey.DistanceUpdate), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MeasurmentsViewController.didUpdateStepCount(_:)), name: NSNotification.Name(rawValue: NotificationKey.StepCountUpdate), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MeasurmentsViewController.didUpdateFloor(_:)), name: NSNotification.Name(rawValue: NotificationKey.FloorUpdate), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MeasurmentsViewController.didUpdateMotionActivity(_:)), name: NSNotification.Name(rawValue: NotificationKey.MotionActivityUpdate), object: nil)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationKey.HeadingUpdate), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationKey.DeviceMotionUpdate), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationKey.AltitudeUpdate), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationKey.DistanceUpdate), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationKey.StepCountUpdate), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationKey.FloorUpdate), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationKey.MotionActivityUpdate), object: nil)
    }
}

//MARK: Motion values
extension MeasurmentsViewController {
    
    //MARK: Receiving and handling motion values
    @objc public func didUpdateHeading(_ notification: Notification) {
        
        let heading = notification.userInfo![DefaultKeys.HeadingKey] as! CLHeading
        self.headingCell.angle = -heading.magneticHeading.radian
        
        self.geomagnetismCell.vector = Vector3D(x: heading.x, y: heading.y, z: heading.z)
    }
    
    @objc public func didUpdateAltitude(_ notification: Notification) {
        
        let altitude = notification.userInfo![DefaultKeys.AltitudeKey] as! Double
        
        self.altitudeCell.value = altitude
    }
    
    @objc public func didUpdateDeviceMotion(_ notification: Notification) {
        
        let userInfo = notification.userInfo!
        
        let attitude = userInfo[DefaultKeys.AttitudeKey] as! Rotation3D
        let gravity = userInfo[DefaultKeys.GravityKey] as! Vector3D
        let rotationRate = userInfo[DefaultKeys.RotationRateKey] as! Vector3D
        
        
        let acceleration = MotinDetector.sharedInstance.acceleration
        let velocity = MotinDetector.sharedInstance.finalVelocity
        
        attitudeCell.rotation = attitude
        
        accelerationCell.vector = acceleration //acceleration ^ attitude
        accelerationGraphCell.addValue(acceleration)
        
        velocityCell.vector = velocity //velocity ^ attitude
        velocityGraphCell.addValue(velocity)
        
        gravityCell.vector = gravity
        rotationRateCell.vector = rotationRate
    }
    
    @objc public func didUpdateDistance(_ notification: Notification) {
        
        let distance = notification.userInfo![DefaultKeys.DistanceKey] as! NSNumber
        
        pedometerCell.distance = distance.doubleValue
    }
    
    @objc public func didUpdateStepCount(_ notification: Notification) {
        
        let numbersOfSteps = notification.userInfo![DefaultKeys.StepCountKey] as! NSNumber
        
        pedometerCell.numberOfSteps = numbersOfSteps.intValue
    }
    
    @objc public func didUpdateFloor(_ notification: Notification) {
        
        let floorsAscended = notification.userInfo![DefaultKeys.FloorsAscendedKey] as! NSNumber
        
        let floorsDescended = notification.userInfo![DefaultKeys.FloorsDescendedKey] as! NSNumber
        
        pedometerCell.floorsAscended = floorsAscended.intValue
        
        pedometerCell.floorsDescended = floorsDescended.intValue
        
    }
    
    @objc public func didUpdateMotionActivity(_ notification: Notification) {
        
        let activity = notification.userInfo![DefaultKeys.MotionActivityKey] as! MotionActivity
        
        pedometerCell.activity = activity
    }
    
}
