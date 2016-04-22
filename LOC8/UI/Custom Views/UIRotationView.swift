//
//  UIDirectionView.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/25/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

//MARK:- UIRotationView
@IBDesignable
public class UIRotationView: UIView {
    
    //MARK:UI Elements
    @IBInspectable public var angle: CGFloat = 0 {
        didSet {
            
            #if TARGET_INTERFACE_BUILDER
                self.setNeedsDisplay()
            #else
                if rotationLayer != nil {
                    rotationLayer.transform = CATransform3DMakeRotation(degreesToRadians(startAngle + angle), 0, 0, 1)
                }
            #endif
        }
    }
    
    @IBInspectable public var startAngle: CGFloat = 0 {
        didSet { self.setNeedsDisplay() }
    }
    
    @IBInspectable public var pointerColor: UIColor = UIColor.blackColor() {
        didSet { self.setNeedsDisplay() }
    }
    
    @IBInspectable public var textColor: UIColor = UIColor.lightGrayColor() {
        didSet { self.setNeedsDisplay() }
    }
    
    @IBInspectable public var enabelSymbols: Bool = true {
        didSet { self.setNeedsDisplay() }
    }
    
    @IBInspectable public var enabelMarks: Bool = true {
        didSet { self.setNeedsDisplay() }
    }
    
    @IBInspectable public var upText: String = ""{
        didSet { self.setNeedsDisplay() }
    }
    
    @IBInspectable public var rightText: String = ""{
        didSet { self.setNeedsDisplay() }
    }
    
    @IBInspectable public var downText: String = ""{
        didSet { self.setNeedsDisplay() }
    }
    
    @IBInspectable public var leftText: String = ""{
        didSet { self.setNeedsDisplay() }
    }
    
    public var textFont: UIFont = UIFont.systemFontOfSize(10)
    
    //MARK:UI Objects
    private var rotationLayer: CAShapeLayer!
    private var marksLayer: CAShapeLayer!
    
    //MARK:UI Drawings
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        drawView(rect)
        
        if enabelSymbols {
            
            let center = CGPoint(x: rect.midX, y: rect.midY)
            
            func getAttributesFor(alignment: NSTextAlignment) -> [String: AnyObject] {
                let paraStyle = NSMutableParagraphStyle()
                paraStyle.alignment = alignment
                
                return [
                    NSForegroundColorAttributeName: textColor,
                    NSParagraphStyleAttributeName: paraStyle,
                    NSFontAttributeName: textFont
                ]
            }
            
            let h = CGFloat(textFont.pointSize)
            
            upText.drawInRect(CGRectMake(0, 0, rect.width, h), withAttributes: getAttributesFor(NSTextAlignment.Center))
            rightText.drawInRect(CGRectMake(center.x, center.y - h/2, rect.width/2, h), withAttributes: getAttributesFor(NSTextAlignment.Right))
            downText.drawInRect(CGRectMake(0, rect.height - h, rect.width, h), withAttributes: getAttributesFor(NSTextAlignment.Center))
            leftText.drawInRect(CGRectMake(0, center.y - h/2, 30, h), withAttributes: getAttributesFor(NSTextAlignment.Left))
        }
        
        if enabelMarks {
            
            func drawMark(a:CGFloat) {
                
                let c = CGPoint(x: rect.midX, y: rect.midY)
                let r:CGFloat = rect.height / 2 - 5
                let rd:CGFloat = r - 5

                self.marksLayer = CAShapeLayer()
                self.marksLayer.bounds = rect
                self.marksLayer.frame = rect
                self.marksLayer.strokeColor = textColor.CGColor
                self.marksLayer.lineWidth = 1
                self.marksLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                self.layer.addSublayer(self.marksLayer)
                
                let path = UIBezierPath()
                path.moveToPoint(   CGPoint(x: c.x + r  * cos(a), y: c.y + r  * sin(a)))
                path.addLineToPoint(CGPoint(x: c.x + rd * cos(a), y: c.y + rd * sin(a)))
                path.closePath()
                
                marksLayer.path = path.CGPath
            }
            
            drawMark(CGFloat(M_PI * 0.25))
            drawMark(CGFloat(M_PI * 0.75))
            drawMark(CGFloat(M_PI * 1.25))
            drawMark(CGFloat(M_PI * 1.75))
            
        }
    }
    
    public func drawView(rect: CGRect) {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        if self.rotationLayer != nil {
            self.rotationLayer.removeFromSuperlayer()
            self.rotationLayer = nil
        }
        
        self.rotationLayer = CAShapeLayer()
        self.rotationLayer.bounds = rect
        self.rotationLayer.frame = rect
        self.rotationLayer.fillColor = pointerColor.CGColor
        self.rotationLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.layer.addSublayer(self.rotationLayer)
        
        let d: CGFloat = min(rect.height, rect.width)/8
        
        let path = UIBezierPath()
        path.moveToPoint(   CGPoint(x: center.x - d/2, y: center.y))
        path.addLineToPoint(CGPoint(x: center.x      , y: d       ))
        path.addLineToPoint(CGPoint(x: center.x + d/2, y: center.y))
        path.addArcWithCenter(center, radius: d/2, startAngle: -CGFloat(M_PI/2), endAngle: CGFloat(M_PI * 1.5), clockwise: true)
        path.closePath()
        
        #if TARGET_INTERFACE_BUILDER
            rotatPath(path, rect: rect)
        #endif
        
        rotationLayer.path = path.CGPath
    }
    
    func rotatPath(path: UIBezierPath, rect: CGRect) {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        var transform = CGAffineTransformIdentity
        transform = CGAffineTransformTranslate(transform, center.x, center.y)
        transform = CGAffineTransformRotate(transform, degreesToRadians(startAngle + angle))
        transform = CGAffineTransformTranslate(transform, -center.x, -center.y)
        
        path.applyTransform(transform)
    }
}

//MARK:- UIDirectionView
@IBDesignable
public class UIDirectionView: UIRotationView {
    
    //MARK:Override Methods
    public override func drawView(rect: CGRect) {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        if self.rotationLayer != nil {
            self.rotationLayer.removeFromSuperlayer()
            self.rotationLayer = nil
        }
        
        self.rotationLayer = CAShapeLayer()
        self.rotationLayer.bounds = rect
        self.rotationLayer.frame = rect
        self.rotationLayer.fillColor = pointerColor.CGColor
        self.rotationLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.layer.addSublayer(self.rotationLayer)
        
        let d: CGFloat = min(rect.height, rect.width) / 12
        let x0: CGFloat = center.x - d
        let x1: CGFloat = center.x - d / 2
        let x2: CGFloat = center.x
        let x3: CGFloat = center.x + d / 2
        let x4: CGFloat = center.x + d
        let y0: CGFloat = rect.height * 0.2
        let y1: CGFloat = rect.height * 0.2 + d
        let y2: CGFloat = rect.height * 0.8
        
        let path = UIBezierPath()
        path.moveToPoint(   CGPoint(x: x0, y: y1))
        path.addLineToPoint(CGPoint(x: x2, y: y0))
        path.addLineToPoint(CGPoint(x: x4, y: y1))
        path.addLineToPoint(CGPoint(x: x3, y: y1))
        path.addLineToPoint(CGPoint(x: x3, y: y2))
        path.addLineToPoint(CGPoint(x: x1, y: y2))
        path.addLineToPoint(CGPoint(x: x1, y: y1))
        path.closePath()
        
        #if TARGET_INTERFACE_BUILDER
            rotatPath(path, rect: rect)
        #endif
        
        self.rotationLayer.path = path.CGPath
        self.rotationLayer.addSublayer(layer)
    }
}

//MARK:- UIHeadingView
@IBDesignable
public class UIHeadingView: UIRotationView {
    
    //MARK:Override Methods
    public override func drawView(rect: CGRect) {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        if self.rotationLayer != nil {
            self.rotationLayer.removeFromSuperlayer()
            rotationLayer = nil
        }
        
        self.rotationLayer = CAShapeLayer()
        self.rotationLayer.bounds = rect
        self.rotationLayer.frame = rect
        self.rotationLayer.fillColor = pointerColor.CGColor
        self.rotationLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.layer.addSublayer(self.rotationLayer)
        
        let d: CGFloat = min(rect.height, rect.width)
        
        let path = UIBezierPath()
        path.moveToPoint(center)
        path.addLineToPoint(CGPoint(x: d * 2/3,  y: d * 3/4))
        path.addLineToPoint(CGPoint(x: center.x, y: d/4))
        path.addLineToPoint(CGPoint(x: d/3,      y: d * 3/4))
        path.closePath()
        
        #if TARGET_INTERFACE_BUILDER
            rotatPath(path, rect: rect)
        #endif
        
        self.rotationLayer.path = path.CGPath
    }
}

//MARK:- UICompassView
@IBDesignable
public class UICompassView: UIRotationView {
    
    //MARK:Override Methods
    public override func drawView(rect: CGRect) {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        if self.rotationLayer != nil {
            self.rotationLayer.removeFromSuperlayer()
            rotationLayer = nil
        }
        
        self.rotationLayer = CAShapeLayer()
        self.rotationLayer.bounds = rect
        self.rotationLayer.frame = rect
        self.rotationLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.layer.addSublayer(self.rotationLayer)
        
        let d: CGFloat = min(rect.height, rect.width) / 10
        let xl: CGFloat = center.x - (d)
        let xr: CGFloat = center.x + (d)
        let yu: CGFloat = center.y - (4*d)
        let yd: CGFloat = center.y + (4*d)
        
        
        func shapeLayer(color:UIColor, points:CGPoint...) -> CAShapeLayer {
            
            let layer = CAShapeLayer()
            layer.bounds = rect
            layer.frame = rect
            layer.fillColor = color.CGColor
            
            if points.count == 0 { return layer }
            
            let path = UIBezierPath()
            
            path.moveToPoint(center)
            for point in points { path.addLineToPoint(point) }
            path.closePath()
            
            #if TARGET_INTERFACE_BUILDER
                rotatPath(path, rect: rect)
            #endif
            
            layer.path = path.CGPath
            
            return layer
        }
        
        
        self.rotationLayer.addSublayer(shapeLayer(UIColor(red:0.79, green:0.79, blue:0.79, alpha:1), points: CGPoint(x: xl, y: center.y), CGPoint(x: center.x, y: yu)))
        self.rotationLayer.addSublayer(shapeLayer(UIColor(red:0.02, green:0.48, blue:1   , alpha:1), points: CGPoint(x: xr, y: center.y), CGPoint(x: center.x, y: yu)))
        self.rotationLayer.addSublayer(shapeLayer(UIColor(red:0.79, green:0.79, blue:0.79, alpha:1), points: CGPoint(x: xr, y: center.y), CGPoint(x: center.x, y: yd)))
        self.rotationLayer.addSublayer(shapeLayer(UIColor(red:0.9 , green:0.18, blue:0.14, alpha:1), points: CGPoint(x: xl, y: center.y), CGPoint(x: center.x, y: yd)))
        self.rotationLayer.addSublayer(shapeLayer(UIColor(red:0.79, green:0.79, blue:0.79, alpha:1), points: CGPoint(x: xl, y: center.y), CGPoint(x: center.x, y: yu)))
        
        
        let path = UIBezierPath()
        path.addArcWithCenter(center, radius: d/4, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        path.closePath()
        let layer = shapeLayer(UIColor.grayColor())
        layer.path = path.CGPath
        self.rotationLayer.addSublayer(layer)
    }
}