//
//  ViewController.swift
//  LOC8
//
//  Created by Marwan Al Masri on 9/25/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import SceneKit

class ViewController: UIViewController {

    @IBOutlet weak var log: UITextView!
    @IBOutlet var sceneView: SCNView!
    @IBOutlet weak var compass: UICompassView!
    
    @IBOutlet weak var controllPanerTrailingConstrant: NSLayoutConstraint!
    @IBOutlet weak var logPanerTrailingConstrant: NSLayoutConstraint!
    @IBOutlet weak var controllButton: UIButton!
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var accLabel: UILabel!
    @IBOutlet weak var compLabel: UILabel!
    @IBOutlet weak var gyroLabel: UILabel!
    @IBOutlet weak var gravityLabel: UILabel!
    @IBOutlet weak var accCompass: UICompassView!
    
    
    var allowTouch: Bool = true
    var isControllPanerOpen: Bool = false
    var isLogPanerOpen: Bool = false
    var isStart: Bool = false
    var isPrinted: Bool = false
    
    var trackingSession: TrackingSession!
    
    var path: Path!
    var accHeadings: [Vector3D] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        LogManager.sharedInstance.printLog = { print in
//            dispatch_async(dispatch_get_main_queue()) {
//                self.log.text! += print
//                self.log.scrollToBotom()
//            }
//        }
        path = Path()
        path.movements = [
            Movement(distance: 10, direction: .North),
            Movement(distance: 10, direction: .East),
            Movement(distance: 2, direction: .East),
            Movement(distance: 3, direction: .Up),
            Movement(distance: 5, direction: .North),
            Movement(distance: 2, direction: .West),
            Movement(distance: 2, direction: .Down),
            Movement(distance: 4, direction: .South)
]
        self.setupScene()
        
        SensorsManager.sharedInstance.accelerationFilterType = .Lowpass
//        MotionManager.sharedInstance.gravityFilterType = .Lowpass
        
        let v = Vector3D(x: 10, y: 10, z: 30)
        SystemLogManager.sharedInstance.print(self, message: v.polarVector.description)
        SystemLogManager.sharedInstance.print(self, message: v.polarVector.cartesianVector.description)
        SystemLogManager.sharedInstance.print(self, message: v.polarVector.cartesianVector.polarVector.description)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.didUpdateHeading(_:)), name: NotificationKey.HeadingUpdate, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.didUpdateDeviceMotion(_:)), name: NotificationKey.DeviceMotionUpdate, object: nil)
        
        toggalControll()
        allowTouch = true
        toggalLog()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationKey.HeadingUpdate, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationKey.DeviceMotionUpdate, object: nil)
    }
    
    func didUpdateHeading(notification: NSNotification) {
        
        let heading = notification.userInfo![DefaultKeys.HeadingKey] as! CLHeading
        
        let angle = heading.magneticHeading
        
        dispatch_async(dispatch_get_main_queue()) {
            self.compLabel.text = String(format: "compass \t\t%.2f (%@)", Float(angle), HeadingDirection(angle: angle).description)
            self.compass.angle = CGFloat(angle)
        }
    }
    
    func didUpdateDeviceMotion(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        let attitude = userInfo[DefaultKeys.AttitudeKey] as! Rotation3D
//        let rotationRate = userInfo[DefaultKeys.RotationRateKey] as! Vector3D
        let gravity = userInfo[DefaultKeys.GravityKey] as! Vector3D
        let acceleration = userInfo[DefaultKeys.AccelerationKey] as! Vector3D
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let threshold = 0.1
            
            let accelerationRef = acceleration ^ attitude
            
            if ~accelerationRef > threshold || ~accelerationRef < -threshold {
                self.accHeadings.append(accelerationRef)
                self.drawData()
                //Bigining lastValue ending accelerationRef
                
                self.accCompass.angle = CGFloat(radiansToDegrees(accelerationRef.theta))
            }
//            self.accCompass.angle = CGFloat(gravity.theta.radiansToDegrees)
            
            self.accLabel.text = String(format: "Accelration \t%.2f,\t%.2f,\t%.2f", Float(radiansToDegrees(acceleration.theta)), Float(radiansToDegrees(acceleration.lambda)), Float(~acceleration * StandardDefault.StandardGravity))
            self.gyroLabel.text = String(format: "Gyro:\tyaw \t%.2f\n\t\tpitch \t%.2f\n\t\troll \t\t%.2f",
                Float(radiansToDegrees(attitude.yaw)),
                Float(radiansToDegrees(attitude.pitch)),
                Float(radiansToDegrees(attitude.roll)))
            self.gravityLabel.text = String(format: "Gravity \t\t\t%.2f,\t%.2f,\t%.2f", Float(radiansToDegrees(gravity.theta)), Float(radiansToDegrees(gravity.lambda)), Float(~gravity * StandardDefault.StandardGravity))
            if !self.isPrinted {
                self.isPrinted = true
            }
        }
    }
    
    func refreshSchene() {
        if self.trackingSession != nil {
            path = Path(data: self.trackingSession.trackingMap())
            self.drawData()
        }
    }
    
    func toggalControll() {
        if !allowTouch { return }
        allowTouch = false
        
        if isControllPanerOpen {
            controllButton.setTitle("➡︎", forState: .Normal)
            controllPanerTrailingConstrant.constant = 0
        }
        else {
            controllButton.setTitle("⬅︎", forState: .Normal)
            controllPanerTrailingConstrant.constant = UIScreen.width - controllButton.bounds.width
        }
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (finished) -> Void in
                self.allowTouch = true
        }
        
        isControllPanerOpen = !isControllPanerOpen
        
    }
    
    func toggalLog() {
        if !allowTouch { return }
        allowTouch = false
        
        if isLogPanerOpen {
            logButton.setTitle("➡︎", forState: .Normal)
            logPanerTrailingConstrant.constant = 0
        }
        else {
            logButton.setTitle("⬅︎", forState: .Normal)
            logPanerTrailingConstrant.constant = UIScreen.width - controllButton.bounds.width
        }
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (finished) -> Void in
                self.allowTouch = true
        }
        
        isLogPanerOpen = !isLogPanerOpen
        isPrinted = false
    }
    
    @IBAction func controllDidPressed(sender: UIButton) {
        
        isStart = !isStart
        
        if isStart {
            sender.backgroundColor = UIColor(red:0.83, green:0.17, blue:0.27, alpha:1)
            sender.setTitle("￭￭", forState: .Normal)
            
            log.text = ""
            
            self.trackingSession = TrackingSession()
            self.trackingSession.startTraking()
            self.trackingSession.estimationHandler = { estimation in
                self.refreshSchene()
            }
        }
        else {
            sender.backgroundColor = UIColor(red:0.48, green:0.8, blue:0.26, alpha:1)
            sender.setTitle("▶︎", forState: .Normal)
            self.trackingSession.stopTraking()
            self.refreshSchene()
        }
        
    }
    
    @IBAction func controllPanerButtonDidPressed(sender: UIButton) { toggalControll() }
    
    @IBAction func logPanerButtonDidPressed(sender: UIButton) { toggalLog() }
}

// MARK: Drawing
extension ViewController {
    
    var camera: SCNNode {
        return self.sceneView.scene!.rootNode.childNodes[0]
    }
    
    
    func setupScene() {
        // create a new scene
        let scene = SCNScene()
        
        // create and add a camera to the scene
        let cameraNode = Camera()
        scene.rootNode.addChildNode(cameraNode)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        // set the scene to the view
        self.sceneView.scene = scene
        
        // allows the user to manipulate the camera
        self.sceneView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        self.sceneView.showsStatistics = true
        
        // configure the view
        self.sceneView.backgroundColor = UIColor.lightGrayColor()
        
        
//        let panGesture = UIPanGestureRecognizer(target: self.camera, action: Selector("pan:"))
//        self.sceneView.addGestureRecognizer(panGesture)
        // add a tap gesture recognizer
        //        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        //        self.sceneView.addGestureRecognizer(tapGesture)
        
        self.drawData()

    }

    func drawData() {
        
        var lastPosition = SCNVector3Make(0, 0, 0)
        var index = 0
        var lastDirection: HeadingDirection = .East // whatever, it will be reset
        let scene = self.sceneView.scene!
        
        //Clear all the previous nodes
        for node in scene.rootNode.childNodes { node.removeFromParentNode() }
        
        //Draw the new nodes
        for movement in self.path.movements {

//            let ndLine = LineNode(parent: scene.rootNode, v1: previousHeading.scnVector3, v2: heading.scnVector3, radius: 0.01, radSegmentCount: 6)
//            scene.rootNode.addChildNode(ndLine)
//            let cylinder = SCNCylinder(radius: 0.001, height: <#T##CGFloat#>)
            if index == 0 {
                lastDirection = movement.direction
            }
//
//            debugPrint("before creating cylinder: \(lastPosition)")
            let sphere = SCNSphere(radius: 0.02)
            
            let sphereNode = SCNNode(geometry: sphere)
            if index == 0 {
                sphere.firstMaterial?.diffuse.contents = UIColor.magentaColor()
            }
            sphereNode.position = lastPosition
            scene.rootNode.addChildNode(sphereNode)
            
            
            
            let cylinderNode = Cylinder.MakeCylinder(withDirection: movement.direction, previousPipeDirection: lastDirection, height: movement.distance/2, fromPoint: lastPosition)
            lastPosition = cylinderNode.lastPosition
            debugPrint("after creating cylinder: \(lastPosition)")
            scene.rootNode.addChildNode(cylinderNode)
            if cylinderNode.textNode != nil {
                scene.rootNode.addChildNode(cylinderNode.textNode)
            }
            lastDirection = movement.direction

            
            index += 1
        }



    }
    
}

extension Vector3D {
    var scnVector3: SCNVector3 {
        return SCNVector3Make(Float(self.x), Float(self.y), Float(self.z))
    }
}