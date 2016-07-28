//
//  PlaneViewController.swift
//  LOC8
//
//  Created by MHD Adeeb MASOUD on 28/07/2016.
//  Copyright © 2016 LOC8. All rights reserved.
//

import UIKit
import CoreLocation

public class PlaneViewController : UIViewController {
    
    var headingAngle : CGFloat = 0
    
    @IBOutlet var planeView: UIPlaneView!
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlaneViewController.didUpdateDeviceMotion(_:)), name: NotificationKey.DeviceMotionUpdate, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlaneViewController.didUpdateHeading(_:)), name: NotificationKey.HeadingUpdate, object: nil)
        
    }
    override public func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationKey.DeviceMotionUpdate, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationKey.HeadingUpdate, object: nil)
    }
    
    
    //MARK: Receiving and handling motion values
    public func didUpdateDeviceMotion(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        let attitude = userInfo[DefaultKeys.AttitudeKey] as! Rotation3D
        
        planeView.rotateBy(CGFloat(attitude.pitch), yaw: CGFloat(attitude.yaw), roll: CGFloat(attitude.roll))
    }

    public func didUpdateHeading(notification: NSNotification) {
//        let heading = notification.userInfo![DefaultKeys.HeadingKey] as! CLHeading
//        dispatch_async(dispatch_get_main_queue()) {
//            self.planeView.north = CGFloat(degreesToRadians(-heading.magneticHeading))
//        }
    }
}