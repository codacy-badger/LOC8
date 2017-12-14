//
//  DrawViewController.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/24/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit
import CoreLocation
import SceneKit

open class MapViewController: UIViewController {
    
    //MARK:Properties
    @IBOutlet weak var compass: UICompassView!
    
    @IBOutlet var sceneView: SCNView!
    
    open var isStart: Bool = false
    
    open var trackingSession: TrackingSession!
    
    open var path: Path!
    
    open var camera: SCNNode {
        return self.sceneView.scene!.rootNode.childNodes[0]
    }
    
    //MARK:Lifcycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        
//        path.movements = [Movement(distance: 10, direction: .Straight), Movement(distance: 10, direction: .Right), Movement(distance: 2, direction: .Right), Movement(distance: 3, direction: .Upwards), Movement(distance: 5, direction: .Straight), Movement(distance: 2, direction: .Left), Movement(distance: 2, direction: .Downwards), Movement(distance: 4, direction: .Backwards)]
        
        self.setupScene()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.didUpdateHeading(_:)), name: NSNotification.Name(rawValue: NotificationKey.HeadingUpdate), object: nil)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationKey.HeadingUpdate), object: nil)
    }
    
    open func setupScene() {
        // create a new scene
        let scene = SCNScene()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLight.LightType.omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // set the scene to the view
        self.sceneView.scene = scene
        
        // allows the user to manipulate the camera
        self.sceneView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        self.sceneView.showsStatistics = true
        
        // configure the view
        self.sceneView.backgroundColor = UIColor.black
        
        
//        let panGesture = UIPanGestureRecognizer(target: self.camera, action: Selector("pan:"))
//        self.sceneView.addGestureRecognizer(panGesture)
        // add a tap gesture recognizer
//        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
//        self.sceneView.addGestureRecognizer(tapGesture)

//        self.drawData()
        
    }
    
    // MARK:Drawing
    func drawData() {
        
        var lastPosition = SCNVector3Make(0, 0, 0)
        var index = 0
        var lastDirection: Direction = .north // whatever, it will be reset
        let scene = self.sceneView.scene!
        
        //Clear all the previous nodes
        for node in scene.rootNode.childNodes {
            node.removeFromParentNode()
        }
        
        //Draw the new nodes
        for movement in path.movements {
            if index == 0 {
                lastDirection = movement.direction
            }
            
            debugPrint("before creating cylinder: \(lastPosition)")
            let sphere = SCNSphere(radius: 0.02)
            
            let sphereNode = SCNNode(geometry: sphere)
            if index == 0 {
                sphere.firstMaterial?.diffuse.contents = UIColor.magenta
            }
            sphereNode.position = lastPosition
            scene.rootNode.addChildNode(sphereNode)
            
            
            
            let cylinderNode = Cylinder.MakeCylinder(withDirection: movement.direction, previousPipeDirection: lastDirection, height: movement.distance/10, fromPoint: lastPosition)
            lastPosition = cylinderNode.lastPosition
            debugPrint("after creating cylinder: \(lastPosition)")
            scene.rootNode.addChildNode(cylinderNode)
            lastDirection = movement.direction
            
//            let sceneText = SCNText(string: "\(cylinderNode.direction)", extrusionDepth: 0.01)
//            sceneText.firstMaterial!.diffuse.contents = UIColor.whiteColor()
//            sceneText.firstMaterial!.specular.contents = UIColor.whiteColor()
//            let textNode = SCNNode(geometry: sceneText)
//            textNode.position = SCNVector3Make(cylinderNode.lastPosition.x, cylinderNode.lastPosition.y, cylinderNode.lastPosition.z)
//            scene.rootNode.addChildNode(textNode)
            
            index += 1
        }
        
    }
    
    //MARK:Event contolles and IBActions
    open func refreshSchene() {
        if self.trackingSession != nil {
            path = Path(data: self.trackingSession.trackingMap())
            self.drawData()
        }
    }
    
    @IBAction func controllDidPressed(_ sender: UIBarButtonItem) {
        
        isStart = !isStart
        
        if isStart {
//            sender.backgroundColor = UIColor(red:0.83, green:0.17, blue:0.27, alpha:1)
            sender.title = "￭￭"
            self.trackingSession = TrackingSession()
            self.trackingSession.startTraking()
            self.trackingSession.estimationHandler = { estimation in
                self.refreshSchene()
                
            }
        } else {
//            sender.backgroundColor = UIColor(red:0.48, green:0.8, blue:0.26, alpha:1)
            sender.title = "▶︎"
            self.trackingSession.stopTraking()
            self.refreshSchene()
        }
        
    }
    
    //MARK:Receiving and handling motion values
    @objc open func didUpdateHeading(_ notification: Notification) {
        
        let heading = notification.userInfo![DefaultKeys.HeadingKey] as! CLHeading
        
        let angle = heading.magneticHeading
        
        DispatchQueue.main.async {
            self.compass.angle = CGFloat(-angle)
        }
    }
}
