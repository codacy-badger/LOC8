//
//  UIPlaneView.swift
//  LOC8
//
//  Created by MHD Adeeb MASOUD on 28/07/2016.
//  Copyright © 2016 LOC8. All rights reserved.
//

import UIKit

public class UIPlaneView : UIView {
    
    var north : CGFloat = 0 {
        didSet { self.setNeedsDisplay() }
    }
    
    public override func drawRect(rect: CGRect) {
        let path = UIBezierPath ()
        path.lineWidth=3.0
        for index in 0...10
        {
            path.moveToPoint(CGPoint(x: CGFloat(index)*bounds.width/10.0, y:0))
            path.addLineToPoint(CGPoint(x: CGFloat(index)*bounds.width/10.0, y:bounds.height))
        }
        for index in 0...10
        {
            path.moveToPoint(CGPoint(x:0, y:CGFloat(index)*bounds.height/10.0))
            path.addLineToPoint(CGPoint(x:bounds.width, y:CGFloat(index)*bounds.height/10.0))
        }
        
        UIColor.blackColor().setStroke()
        path.stroke()
        
//        let northPath = UIBezierPath ()
//        northPath.lineWidth = 5.0
//        northPath.moveToPoint(CGPoint(x: bounds.width/2,y: bounds.height/2))
//        northPath.addLineToPoint(CGPoint(x: cos(north), y: sin(north)))
//        UIColor.redColor().setStroke()
//        northPath.stroke()
    }
    public func rotateBy(pitch:CGFloat, yaw:CGFloat, roll:CGFloat)
    {
        let layer=self.layer;
        var transform = CATransform3DIdentity
        //transform.m34 = 1.0/2000
        transform = CATransform3DConcat(
            CATransform3DMakeRotation(pitch , 1, 0, 0)
            , CATransform3DMakeRotation(roll , 0, 1, 0)
        )
        transform = CATransform3DConcat(transform, CATransform3DMakeRotation(yaw , 0, 0, 1))
        
//        layer.transform = CATransform3DMakeRotation(pitch , 1, 0, 0)
//        layer.transform = CATransform3DMakeRotation(roll , 0, 1, 0)
//        layer.transform = CATransform3DMakeRotation(yaw , 0, 0, 1)
        layer.transform=transform
    }
    
}