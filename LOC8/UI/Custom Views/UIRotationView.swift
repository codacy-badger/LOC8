//
//  UIDirectionView.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/25/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

//MARK: UIRotationView
@IBDesignable
open class UIRotationView: UIView {
    
    //MARK:UI Elements
    @IBInspectable open var angle: CGFloat = 0 {
        didSet {
            
            #if TARGET_INTERFACE_BUILDER
                self.setNeedsDisplay()
            #else
                if rotationLayer != nil {
                    rotationLayer.transform = CATransform3DMakeRotation(CGFloat(Angle(startAngle + angle).radian), 0, 0, 1)
                }
            #endif
        }
    }
    
    @IBInspectable open var startAngle: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable open var pointerColor: UIColor = UIColor.black {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable open var textColor: UIColor = UIColor.lightGray {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable open var enabelSymbols: Bool = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable open var enabelMarks: Bool = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable open var upText: String = ""{
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable open var rightText: String = ""{
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable open var downText: String = ""{
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable open var leftText: String = ""{
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    open var textFont: UIFont = UIFont.systemFont(ofSize: 10)
    
    //MARK:UI Objects
    fileprivate var rotationLayer: CAShapeLayer!
    fileprivate var marksLayer: CAShapeLayer!
    
    //MARK:UI Drawings
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        drawView(rect)
        
        if enabelSymbols {
            
            let center = CGPoint(x: rect.midX, y: rect.midY)
            
            func getAttributesFor(_ alignment: NSTextAlignment) -> [NSAttributedStringKey: AnyObject] {
                let paraStyle = NSMutableParagraphStyle()
                paraStyle.alignment = alignment
                
                return [
                    NSAttributedStringKey.foregroundColor: textColor,
                    NSAttributedStringKey.paragraphStyle: paraStyle,
                    NSAttributedStringKey.font: textFont
                ]
            }
            
            let h = CGFloat(textFont.pointSize)
            
            upText.draw(in: CGRect(x: 0, y: 0, width: rect.width, height: h), withAttributes: getAttributesFor(NSTextAlignment.center))
            rightText.draw(in: CGRect(x: center.x, y: center.y - h/2, width: rect.width/2, height: h), withAttributes: getAttributesFor(NSTextAlignment.right))
            downText.draw(in: CGRect(x: 0, y: rect.height - h, width: rect.width, height: h), withAttributes: getAttributesFor(NSTextAlignment.center))
            leftText.draw(in: CGRect(x: 0, y: center.y - h/2, width: 30, height: h), withAttributes: getAttributesFor(NSTextAlignment.left))
        }
        
        if enabelMarks {
            
            func drawMark(_ a:CGFloat) {
                
                let c = CGPoint(x: rect.midX, y: rect.midY)
                let r:CGFloat = rect.height / 2 - 5
                let rd:CGFloat = r - 5

                self.marksLayer = CAShapeLayer()
                self.marksLayer.bounds = rect
                self.marksLayer.frame = rect
                self.marksLayer.strokeColor = textColor.cgColor
                self.marksLayer.lineWidth = 1
                self.marksLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                self.layer.addSublayer(self.marksLayer)
                
                let path = UIBezierPath()
                path.move(   to: CGPoint(x: c.x + r  * cos(a), y: c.y + r  * sin(a)))
                path.addLine(to: CGPoint(x: c.x + rd * cos(a), y: c.y + rd * sin(a)))
                path.close()
                
                marksLayer.path = path.cgPath
            }
            
            drawMark(CGFloat(Double.pi * 0.25))
            drawMark(CGFloat(Double.pi * 0.75))
            drawMark(CGFloat(Double.pi * 1.25))
            drawMark(CGFloat(Double.pi * 1.75))
            
        }
    }
    
    open func drawView(_ rect: CGRect) {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        if self.rotationLayer != nil {
            self.rotationLayer.removeFromSuperlayer()
            self.rotationLayer = nil
        }
        
        self.rotationLayer = CAShapeLayer()
        self.rotationLayer.bounds = rect
        self.rotationLayer.frame = rect
        self.rotationLayer.fillColor = pointerColor.cgColor
        self.rotationLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.layer.addSublayer(self.rotationLayer)
        
        let d: CGFloat = min(rect.height, rect.width)/8
        
        let path = UIBezierPath()
        path.move(   to: CGPoint(x: center.x - d/2, y: center.y))
        path.addLine(to: CGPoint(x: center.x      , y: d       ))
        path.addLine(to: CGPoint(x: center.x + d/2, y: center.y))
        path.addArc(withCenter: center, radius: d/2, startAngle: -CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi * 1.5), clockwise: true)
        path.close()
        
        #if TARGET_INTERFACE_BUILDER
            rotatPath(path, rect: rect)
        #endif
        
        rotationLayer.path = path.cgPath
    }
    
    func rotatPath(_ path: UIBezierPath, rect: CGRect) {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: center.x, y: center.y)
        transform = transform.rotated(by: CGFloat(Angle(startAngle + angle).radian))
        transform = transform.translatedBy(x: -center.x, y: -center.y)
        
        path.apply(transform)
    }
}

//MARK: UIDirectionView
@IBDesignable
open class UIDirectionView: UIRotationView {
    
    //MARK:Override Methods
    open override func drawView(_ rect: CGRect) {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        if self.rotationLayer != nil {
            self.rotationLayer.removeFromSuperlayer()
            self.rotationLayer = nil
        }
        
        self.rotationLayer = CAShapeLayer()
        self.rotationLayer.bounds = rect
        self.rotationLayer.frame = rect
        self.rotationLayer.fillColor = pointerColor.cgColor
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
        path.move(   to: CGPoint(x: x0, y: y1))
        path.addLine(to: CGPoint(x: x2, y: y0))
        path.addLine(to: CGPoint(x: x4, y: y1))
        path.addLine(to: CGPoint(x: x3, y: y1))
        path.addLine(to: CGPoint(x: x3, y: y2))
        path.addLine(to: CGPoint(x: x1, y: y2))
        path.addLine(to: CGPoint(x: x1, y: y1))
        path.close()
        
        #if TARGET_INTERFACE_BUILDER
            rotatPath(path, rect: rect)
        #endif
        
        self.rotationLayer.path = path.cgPath
        self.rotationLayer.addSublayer(layer)
    }
}

//MARK: UIHeadingView
@IBDesignable
open class UIHeadingView: UIRotationView {
    
    //MARK:Override Methods
    open override func drawView(_ rect: CGRect) {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        if self.rotationLayer != nil {
            self.rotationLayer.removeFromSuperlayer()
            rotationLayer = nil
        }
        
        self.rotationLayer = CAShapeLayer()
        self.rotationLayer.bounds = rect
        self.rotationLayer.frame = rect
        self.rotationLayer.fillColor = pointerColor.cgColor
        self.rotationLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.layer.addSublayer(self.rotationLayer)
        
        let d: CGFloat = min(rect.height, rect.width)
        
        let path = UIBezierPath()
        path.move(to: center)
        path.addLine(to: CGPoint(x: d * 2/3,  y: d * 3/4))
        path.addLine(to: CGPoint(x: center.x, y: d/4))
        path.addLine(to: CGPoint(x: d/3,      y: d * 3/4))
        path.close()
        
        #if TARGET_INTERFACE_BUILDER
            rotatPath(path, rect: rect)
        #endif
        
        self.rotationLayer.path = path.cgPath
    }
}

//MARK: UICompassView
@IBDesignable
open class UICompassView: UIRotationView {
    
    //MARK:Override Methods
    open override func drawView(_ rect: CGRect) {
        
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
        
        
        func shapeLayer(_ color:UIColor, points:CGPoint...) -> CAShapeLayer {
            
            let layer = CAShapeLayer()
            layer.bounds = rect
            layer.frame = rect
            layer.fillColor = color.cgColor
            
            if points.count == 0 {
                return layer
            }
            
            let path = UIBezierPath()
            
            path.move(to: center)
            for point in points {
                path.addLine(to: point)
            }
            path.close()
            
            #if TARGET_INTERFACE_BUILDER
                rotatPath(path, rect: rect)
            #endif
            
            layer.path = path.cgPath
            
            return layer
        }
        
        
        self.rotationLayer.addSublayer(shapeLayer(UIColor(red:0.79, green:0.79, blue:0.79, alpha:1), points: CGPoint(x: xl, y: center.y), CGPoint(x: center.x, y: yu)))
        self.rotationLayer.addSublayer(shapeLayer(UIColor(red:0.02, green:0.48, blue:1   , alpha:1), points: CGPoint(x: xr, y: center.y), CGPoint(x: center.x, y: yu)))
        self.rotationLayer.addSublayer(shapeLayer(UIColor(red:0.79, green:0.79, blue:0.79, alpha:1), points: CGPoint(x: xr, y: center.y), CGPoint(x: center.x, y: yd)))
        self.rotationLayer.addSublayer(shapeLayer(UIColor(red:0.9 , green:0.18, blue:0.14, alpha:1), points: CGPoint(x: xl, y: center.y), CGPoint(x: center.x, y: yd)))
        self.rotationLayer.addSublayer(shapeLayer(UIColor(red:0.79, green:0.79, blue:0.79, alpha:1), points: CGPoint(x: xl, y: center.y), CGPoint(x: center.x, y: yu)))
        
        
        let path = UIBezierPath()
        path.addArc(withCenter: center, radius: d/4, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        path.close()
        let layer = shapeLayer(UIColor.gray)
        layer.path = path.cgPath
        self.rotationLayer.addSublayer(layer)
    }
}
