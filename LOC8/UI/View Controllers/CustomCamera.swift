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
    
    var slideVelocity: CGPoint = CGPoint.zero
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
        case undefined
        case up
        case down
        case left
        case right
    }
    
    func pan(_ sender: UIPanGestureRecognizer) {
        struct Holder {
            static var direction: UIPanGestureRecognizerDirection = .undefined
        }
        self.slideVelocity = sender.velocity(in: sender.view)
        switch sender.state {
        case .began:
            if Holder.direction == .undefined {
                let velocity = sender.velocity(in: sender.view)
                let isVerticalGesture = fabs(velocity.y) > fabs(velocity.x)
                if isVerticalGesture {
                    if velocity.y > 0 {
                        Holder.direction = .down
                    } else {
                        Holder.direction = .up
                    }
                } else {
                    if velocity.x > 0 {
                        Holder.direction = .right
                    } else {
                        Holder.direction = .left
                    }
                }
            }
        case .changed:
            switch Holder.direction {
            case .up:
                self.handleUpGesture(sender)
            case .down:
                self.handleDownGesture(sender)
            case .left:
                self.handleLeftGesture(sender)
            case .right:
                self.handleRightGesture(sender)
            default:
                break
            }
        case .ended:
            Holder.direction = .undefined
        default: break
        }
    }

    // zoom in
    func handleDownGesture(_ sender: UIPanGestureRecognizer) {
        let oldPos = self.position
        guard oldPos.z < 3 else {
            return
        }
        
        // translate self.slideVelocity in the z only, and keep x and y the same values
        
        
    }
    
    func handleUpGesture(_ sender: UIPanGestureRecognizer) {
        
    }
    

    
    func handleRightGesture(_ sender: UIPanGestureRecognizer) {
        
    }
    
    func handleLeftGesture(_ sender: UIPanGestureRecognizer) {
        
    }
}
