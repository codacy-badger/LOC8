//
//  CustomCamera.swift
//  LOC8
//
//  Created by Marwan Al Masri on 13/12/2015.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation
import SceneKit

class Camera: SCNNode {
    
    var slideVelocity: CGPoint = CGPointZero
    let viewSlideDivisor: Float = 100

    override init() {
        super.init()
        let camera = SCNCamera()

        let cameraNode = SCNNode()
        cameraNode.position = SCNVector3(x: 2, y: 0, z: 5)
        cameraNode.camera = camera
        
        self.addChildNode(cameraNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum UIPanGestureRecognizerDirection: Int {
        case Undefined
        case Up
        case Down
        case Left
        case Right
    }
    
    func pan(sender: UIPanGestureRecognizer) {
        struct Holder {
            static var direction: UIPanGestureRecognizerDirection = .Undefined
        }
        self.slideVelocity = sender.velocityInView(sender.view)
        switch sender.state {
        case .Began:
            if Holder.direction == .Undefined {
                let velocity = sender.velocityInView(sender.view)
                let isVerticalGesture = fabs(velocity.y) > fabs(velocity.x)
                if isVerticalGesture {
                    if velocity.y > 0 {
                        Holder.direction = .Down
                    }
                    else {
                        Holder.direction = .Up
                    }
                }
                else {
                    if velocity.x > 0 {
                        Holder.direction = .Right
                    }
                    else {
                        Holder.direction = .Left
                    }
                }
            }
        case .Changed:
            switch Holder.direction {
            case .Up:
                self.handleUpGesture(sender)
            case .Down:
                self.handleDownGesture(sender)
            case .Left:
                self.handleLeftGesture(sender)
            case .Right:
                self.handleRightGesture(sender)
            default:
                break
            }
        case .Ended:
            Holder.direction = .Undefined
        default: break
        }
    }

    // zoom in
    func handleDownGesture(sender: UIPanGestureRecognizer) {
        let oldPos = self.position
        guard oldPos.z < 3 else { return }
        
        // translate self.slideVelocity in the z only, and keep x and y the same values
        
        
    }
    
    func handleUpGesture(sender: UIPanGestureRecognizer) {
        
    }
    

    
    func handleRightGesture(sender: UIPanGestureRecognizer) {
        
    }
    
    func handleLeftGesture(sender: UIPanGestureRecognizer) {
        
    }
}