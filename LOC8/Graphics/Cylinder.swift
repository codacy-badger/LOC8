//
//  Cylinder.swift
//  LOC8Display
//
//  Created by Marwan Al Masri on 12/5/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation
import SceneKit
import Darwin
import SpriteKit

class LineNode: SCNNode
{
    init( parent: SCNNode,     // because this node has not yet been assigned to a parent.
        v1: SCNVector3,  // where line starts
        v2: SCNVector3,  // where line ends
        radius: CGFloat,     // line thicknes
        radSegmentCount: Int)    // number of sides of the line
    {
        super.init()
        let height = CGFloat(GLKVector3Distance(SCNVector3ToGLKVector3(v1), SCNVector3ToGLKVector3(v2))) * 20
//        let  height = v1.distance(v2)
        
        position = v1
        
        let ndV2 = SCNNode()
        
        ndV2.position = v2
        parent.addChildNode(ndV2)
        
        let ndZAlign = SCNNode()
        ndZAlign.eulerAngles.x = Float((Double.pi / 2))
        
        let cylgeo = SCNCylinder(radius: radius, height: CGFloat(height))
        cylgeo.radialSegmentCount = radSegmentCount
        let mat = SCNMaterial()
        mat.diffuse.contents  = UIColor.white
        mat.specular.contents = UIColor.white
        cylgeo.materials = [mat]
        
        let ndCylinder = SCNNode(geometry: cylgeo )
        ndCylinder.position.y = -Float(height)/2
        ndZAlign.addChildNode(ndCylinder)
        
        addChildNode(ndZAlign)
        
        constraints = [SCNLookAtConstraint(target: ndV2)]
    }
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class Cylinder: SCNNode {
    
    var direction: Direction!
    var lastPosition: SCNVector3!
    var textNode: SCNNode!
    
    required convenience init(direction: Direction, height: Float) {
        self.init()
        let cylinder = SCNCylinder(radius: 0.01, height: CGFloat(height))
        self.geometry = cylinder
        self.direction = direction

    }
    
    class func MakeCylinder(withDirection direction: Direction, previousPipeDirection lastDirection: Direction, height: Float, fromPoint point: SCNVector3) -> Cylinder {
        // the cylinder is drawn with the middle at 0,0,0. so we want it's bottom at 0,0,0. so we move it up by half it's height
        
        let node = Cylinder(direction: direction, height: height)

        let cylinder = node.geometry as! SCNCylinder
        
        node.lastPosition = point
        // because scene kit centers shit, so you need to start from the head, that's why you pivot
        node.pivot = SCNMatrix4MakeTranslation(0, -height/2, 0)
        node.position = node.lastPosition
        

        
        
        switch node.direction! {
            
        case .east:
            node.lastPosition = SCNVector3Make(node.lastPosition.x + height, node.lastPosition.y, node.lastPosition.z)
            cylinder.firstMaterial?.diffuse.contents = UIColor.red
            node.rotation = SCNVector4Make(0, 0, 1, Float(90.0.radian))
            
        case .west:
            node.lastPosition = SCNVector3Make(node.lastPosition.x - height, node.lastPosition.y, node.lastPosition.z)
            cylinder.firstMaterial?.diffuse.contents = UIColor.green
            node.rotation = SCNVector4Make(0, 0, 1, Float(-90.0.radian))
            
        case .north:
            node.lastPosition = SCNVector3Make(node.lastPosition.x, node.lastPosition.y, node.lastPosition.z - height)
            cylinder.firstMaterial?.diffuse.contents = UIColor.white
            node.rotation = SCNVector4Make(1, 0, 0, Float(-90.0.radian))
            
        case .south:
            node.lastPosition = SCNVector3Make(node.lastPosition.x, node.lastPosition.y, node.lastPosition.z + height)
            cylinder.firstMaterial?.diffuse.contents = UIColor.blue
            node.rotation = SCNVector4Make(1, 0, 0, Float(90.0.radian))
            
        case .up:
            node.lastPosition = SCNVector3Make(node.lastPosition.x, node.lastPosition.y + height, node.lastPosition.z)
            cylinder.firstMaterial?.diffuse.contents = UIColor.yellow
            
        case .down:
            node.lastPosition = SCNVector3Make(node.lastPosition.x, node.lastPosition.y - height, node.lastPosition.z)
            cylinder.firstMaterial?.diffuse.contents = UIColor.orange
            node.rotation = SCNVector4Make(1, 0, 0, Float(180.0.radian))
            
        default: break
            
        }
        
        
        debugPrint("cylinder values: direction \(String(describing: node.direction)), distance: \(cylinder.height)")
        
        return node
    }
    
    func createTextNode(_ text: String) {
        
    }
    
}
