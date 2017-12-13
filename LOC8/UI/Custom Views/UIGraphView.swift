//
//  UIGraphView.swift
//  LOC8
//
//  Created by Marwan Al Masri on 1/2/16.
//  Copyright © 2016 LOC8. All rights reserved.
//

import UIKit
import QuartzCore

open class UIGraphViewSegment: NSObject, CALayerDelegate {
    
    var layer: CALayer!
    
    var vectors: [Vector3D] = []
    
    var index: Int = 0
    
    var count: Int = 33
    
    var isFull: Bool {  return index == 0 }
    
    open var graphBackgroundColor: UIColor = UIColor(white: 0.6, alpha: 1.0) {
        didSet { layer.setNeedsDisplay() }
    }
    
    open var graphLineColor: UIColor = UIColor(white: 0.5, alpha: 1.0) {
        didSet { layer.setNeedsDisplay() }
    }
    
    open var graphXColor: UIColor = UIColor.red {
        didSet { layer.setNeedsDisplay() }
    }
    
    open var graphYColor: UIColor = UIColor.green {
        didSet { layer.setNeedsDisplay() }
    }
    
    open var graphZColor: UIColor = UIColor.blue {
        didSet { layer.setNeedsDisplay() }
    }

    
    public override init() {
        super.init()
        layer = CALayer()
        layer.bounds = CGRect(x: 0.0, y: -56.0, width: 32.0, height: 112.0)
        layer.delegate = self
        layer.isOpaque = true
        
        index = count - 1
        
        for _ in 0..<count { vectors.append(Vector3D()) }
    }
    
    open func reset() {
        
        index = count - 1
        
        for _ in 0..<count { vectors.append(Vector3D()) }
        
        layer.setNeedsDisplay()
    }
    
    func isVisibleInRect(_ r: CGRect) -> Bool {
        return r.intersects(layer.frame)
    }
    
    open func addX(_ vector: Vector3D) -> Bool {
        
        if index > 0 {
            index -= 1
            vectors[index] = vector
            
            layer.setNeedsDisplay()
        }
        
        return index == 0
    }
    
    
    
    open func draw(_ layer: CALayer, in ctx: CGContext) {
        
        ctx.setFillColor(graphBackgroundColor.cgColor)
        ctx.fill(layer.bounds)
        drawGridlines(ctx, x: 0.0, width: 32.0)
        var lines: [CGPoint] = []
        for _ in 0..<64 { lines.append(CGPoint.zero) }
        
        // X
        for i in 0..<32 {
            lines[i * 2].x = CGFloat(i)
            lines[i * 2].y = CGFloat(-vectors[i].x) * 16.0
            lines[i * 2 + 1].x = CGFloat(i) + 1
            lines[i * 2 + 1].y = CGFloat(-vectors[i + 1].x) * 16.0
        }
        ctx.setStrokeColor(graphXColor.cgColor)
        ctx.strokeLineSegments(between: lines)
        
        // Y
        for i in 0..<32 {
            lines[i * 2].y = CGFloat(-vectors[i].y) * 16.0
            lines[i * 2 + 1].y = CGFloat(-vectors[i + 1].y) * 16.0
        }
        ctx.setStrokeColor(graphYColor.cgColor)
        ctx.strokeLineSegments(between: lines)
        
        // Z
        for i in 0..<32 {
            lines[i * 2].y = CGFloat(-vectors[i].z) * 16.0
            lines[i * 2 + 1].y = CGFloat(-vectors[i + 1].z) * 16.0
        }
        ctx.setStrokeColor(graphZColor.cgColor)
        ctx.strokeLineSegments(between: lines)
    }
    
    open func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return NSNull()
    }
    
    fileprivate func drawGridlines(_ context: CGContext, x: CGFloat, width: CGFloat) {
        
        var y: CGFloat = -48.5
        
        while y <= 48.5 {
            context.move(to: CGPoint(x: x, y: y));
            context.addLine(to: CGPoint(x: x + width, y: y))
            y += 16.0
        }
        
        context.setStrokeColor(graphLineColor.cgColor);
        context.strokePath();
    }
}

open class UIGraphTextView: UIView {
    
    
    open var graphBackgroundColor: UIColor = UIColor(white: 0.6, alpha: 1.0) {
        didSet { self.setNeedsDisplay() }
    }
    
    open var graphLineColor: UIColor = UIColor(white: 0.5, alpha: 1.0) {
        didSet { self.setNeedsDisplay() }
    }
    
    open var textColor: UIColor = UIColor.white {
        didSet { self.setNeedsDisplay() }
    }
    
    open override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(graphBackgroundColor.cgColor)
        context.fill(self.bounds)
        context.translateBy(x: 0.0, y: 56.0)
        
        drawGridlines(context, x: 26.0, width: 6.0)
        
        UIColor.white.set()
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .right
        
        let attribute = [
            NSAttributedStringKey.foregroundColor: textColor,
            NSAttributedStringKey.paragraphStyle: paraStyle,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10)
        ]
        
        "+3.0".draw(in: CGRect(x: 2.0, y: -56.0, width: 24.0, height: 16.0), withAttributes: attribute)
        "+2.0".draw(in: CGRect(x: 2.0, y: -40.0, width: 24.0, height: 16.0), withAttributes: attribute)
        "+1.0".draw(in: CGRect(x: 2.0, y: -24.0, width: 24.0, height: 16.0), withAttributes: attribute)
        " 0.0".draw(in: CGRect(x: 2.0, y: -8.0, width: 24.0, height: 16.0), withAttributes: attribute)
        "-1.0".draw(in: CGRect(x: 2.0, y: 8.0, width: 24.0, height: 16.0), withAttributes: attribute)
        "-2.0".draw(in: CGRect(x: 2.0, y: 24.0, width: 24.0, height: 16.0), withAttributes: attribute)
        "-3.0".draw(in: CGRect(x: 2.0, y: 40.0, width: 24.0, height: 16.0), withAttributes: attribute)
    }
    
    fileprivate func drawGridlines(_ context: CGContext, x: CGFloat, width: CGFloat) {
        
        var y: CGFloat = -48.5
        
        while y <= 48.5 {
            context.move(to: CGPoint(x: x, y: y));
            context.addLine(to: CGPoint(x: x + width, y: y))
            y += 16.0
        }
        
        context.setStrokeColor(graphLineColor.cgColor);
        context.strokePath();
    }
}

@IBDesignable
open class UIGraphView: UIView {
    
    @IBInspectable open var graphBackgroundColor: UIColor = UIColor(white: 0.6, alpha: 1.0) {
        didSet {
            text.graphBackgroundColor = graphBackgroundColor
            for segment in self.segments {segment.graphBackgroundColor = graphBackgroundColor}
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable open var graphLineColor: UIColor = UIColor(white: 0.5, alpha: 1.0) {
        didSet {
            text.graphLineColor = graphLineColor
            for segment in self.segments {segment.graphLineColor = graphLineColor}
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable open var textColor: UIColor = UIColor.white {
        didSet { text.textColor = textColor }
    }
    
    @IBInspectable open var graphXColor: UIColor = UIColor.red {
        didSet { for segment in self.segments {segment.graphXColor = graphXColor} }
    }
    
    @IBInspectable open var graphYColor: UIColor = UIColor.green {
        didSet { for segment in self.segments {segment.graphYColor = graphYColor} }
    }
    
    @IBInspectable open var graphZColor: UIColor = UIColor.blue {
        didSet { for segment in self.segments {segment.graphZColor = graphZColor} }
    }
    
    fileprivate let kSegmentInitialPosition = CGPoint(x: 14.0, y: 56.0)
    
    fileprivate var segments: [UIGraphViewSegment]!
    
    fileprivate var current: UIGraphViewSegment!
    
    fileprivate var text: UIGraphTextView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    public required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
        self.commonInit()
    }
    
    open override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(graphBackgroundColor.cgColor)
        context.fill(self.bounds)
        let width: CGFloat = self.bounds.size.width
        context.translateBy(x: 0.0, y: 56.0)
        
        drawGridlines(context, x: 0.0, width: width)
    }
    
    fileprivate func drawGridlines(_ context: CGContext, x: CGFloat, width: CGFloat) {
        
        var y: CGFloat = -48.5
        
        while y <= 48.5 {
            context.move(to: CGPoint(x: x, y: y));
            context.addLine(to: CGPoint(x: x + width, y: y))
            y += 16.0
        }
        
        context.setStrokeColor(graphLineColor.cgColor);
        context.strokePath();
    }
    
    fileprivate func commonInit() {
        
        self.text = UIGraphTextView(frame: CGRect(x: 0.0, y: 0.0, width: 32.0, height: 112.0))
        self.addSubview(self.text)
        
        self.segments = [UIGraphViewSegment]()
        
        self.current = self.addSegment()
    }
    
    open func addX(_ vector: Vector3D) {
        
        if self.current.addX(vector) {
            self.recycleSegment()
            self.current.addX(vector)
        }
        
        for segment in self.segments {
            segment.graphXColor = graphXColor
            segment.graphYColor = graphYColor
            segment.graphZColor = graphZColor
            
            var position: CGPoint = segment.layer.position
            position.x += 1.0
            segment.layer.position = position
        }
    }
    
    fileprivate func addSegment() -> UIGraphViewSegment {
        
        let segment: UIGraphViewSegment = UIGraphViewSegment()
        segment.graphBackgroundColor = graphBackgroundColor
        segment.graphLineColor = graphLineColor
        segment.graphXColor = graphXColor
        segment.graphYColor = graphYColor
        segment.graphZColor = graphZColor
        self.segments.insert(segment, at: 0)
        self.layer.insertSublayer(segment.layer, below: self.text.layer)
        segment.layer.position = kSegmentInitialPosition
        return segment
    }
    
    fileprivate func recycleSegment() {
        
        let last = self.segments.last!
        if last.isVisibleInRect(self.layer.bounds) {
            
            self.current = self.addSegment()
        }
        else {
            last.reset()
            last.layer.position = kSegmentInitialPosition
            self.segments.insert(last, at: 0)
            self.segments.removeLast()
            self.current = last
        }
    }
}
