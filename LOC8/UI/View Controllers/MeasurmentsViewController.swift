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

public class MeasurmentsViewController: UITableViewController {
    
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
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MeasurmentsViewController.didUpdateHeading(_:)), name: NotificationKey.HeadingUpdate, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MeasurmentsViewController.didUpdateAltitude(_:)), name: NotificationKey.AltitudeUpdate, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MeasurmentsViewController.didUpdateDeviceMotion(_:)), name: NotificationKey.DeviceMotionUpdate, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MeasurmentsViewController.didUpdateDistance(_:)), name: NotificationKey.DistanceUpdate, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MeasurmentsViewController.didUpdateStepCount(_:)), name: NotificationKey.StepCountUpdate, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MeasurmentsViewController.didUpdateFloor(_:)), name: NotificationKey.FloorUpdate, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MeasurmentsViewController.didUpdateMotionActivity(_:)), name: NotificationKey.MotionActivityUpdate, object: nil)
    }
    
    override public func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationKey.HeadingUpdate, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationKey.DeviceMotionUpdate, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationKey.AltitudeUpdate, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationKey.DistanceUpdate, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationKey.StepCountUpdate, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationKey.FloorUpdate, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationKey.MotionActivityUpdate, object: nil)
    }
}

//MARK: Motion values
extension MeasurmentsViewController {
    
    //MARK: Receiving and handling motion values
    public func didUpdateHeading(notification: NSNotification) {
        
        let heading = notification.userInfo![DefaultKeys.HeadingKey] as! CLHeading
        
        self.headingCell.angle = degreesToRadians(-heading.magneticHeading)
        
        self.geomagnetismCell.vector = Vector3D(x: heading.x, y: heading.y, z: heading.z)
    }
    
    public func didUpdateAltitude(notification: NSNotification) {
        
        let altitude = notification.userInfo![DefaultKeys.AltitudeKey] as! Double
        
        self.altitudeCell.value = altitude
    }
    
    public func didUpdateDeviceMotion(notification: NSNotification) {
        
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
    
    public func didUpdateDistance(notification: NSNotification) {
        
        let distance = notification.userInfo![DefaultKeys.DistanceKey] as! NSNumber
        
        pedometerCell.distance = distance.doubleValue
    }
    
    public func didUpdateStepCount(notification: NSNotification) {
        
        let numbersOfSteps = notification.userInfo![DefaultKeys.StepCountKey] as! NSNumber
        
        pedometerCell.numberOfSteps = numbersOfSteps.integerValue
    }
    
    public func didUpdateFloor(notification: NSNotification) {
        
        let floorsAscended = notification.userInfo![DefaultKeys.FloorsAscendedKey] as! NSNumber
        
        let floorsDescended = notification.userInfo![DefaultKeys.FloorsDescendedKey] as! NSNumber
        
        pedometerCell.floorsAscended = floorsAscended.integerValue
        
        pedometerCell.floorsDescended = floorsDescended.integerValue
        
    }
    
    public func didUpdateMotionActivity(notification: NSNotification) {
        
        let activity = notification.userInfo![DefaultKeys.MotionActivityKey] as! MotionActivity
        
        pedometerCell.activity = activity
    }
    
}