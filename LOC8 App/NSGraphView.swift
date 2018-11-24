//
//  NSGraphView.swift
//  LOC8
//
//  Created by Marwan Al Masri on 3/27/16.
//  Copyright © 2016 LOC8. All rights reserved.
//

import AppKit
import QuartzCore

public class NSGraphViewSegment: NSObject, CALayerDelegate {
    
    var layer: CALayer!
    
    var vectors: [Vector3D] = []
    
    var index: Int = 0
    
    var count: Int = 33
    
    var isFull: Bool {
        return index == 0
    }
    
    public var graphBackgroundColor: NSColor = NSColor(white: 0.6, alpha: 1.0) {
        didSet {
            layer.setNeedsDisplay()
        }
    }
    
    public var graphLineColor: NSColor = NSColor(white: 0.5, alpha: 1.0) {
        didSet {
            layer.setNeedsDisplay()
        }
    }
    
    public var graphXColor: NSColor = NSColor.red {
        didSet {
            layer.setNeedsDisplay()
        }
    }
    
    public var graphYColor: NSColor = NSColor.green {
        didSet {
            layer.setNeedsDisplay()
        }
    }
    
    public var graphZColor: NSColor = NSColor.blue {
        didSet {
            layer.setNeedsDisplay()
        }
    }
    
    
    public override init() {
        super.init()
        layer = CALayer()
        layer.bounds = CGRect(x: 0.0, y: -56.0, width: 32.0, height: 112.0)
        layer.delegate = self
        layer.isOpaque = true
        
        index = count - 1
        
        for _ in 0..<count {
            vectors.append(Vector3D())
        }
    }
    
    public func reset() {
        
        index = count - 1
        
        for _ in 0..<count {
            vectors.append(Vector3D())
        }
        
        layer.setNeedsDisplay()
    }
    
    func isVisibleInRect(r: CGRect) -> Bool {
        return r.intersects(layer.frame)
    }
    
    public func addX(vector: Vector3D) -> Bool {
        
        if index > 0 {
            index -= 1
            vectors[index] = vector
            
            layer.setNeedsDisplay()
        }
        
        return index == 0
    }
    
    public func draw(_ layer: CALayer, in ctx: CGContext) {
        
        ctx.setStrokeColor(graphBackgroundColor.cgColor)
        ctx.fill(layer.bounds)
        drawGridlines(context: ctx, x: 0.0, width: 32.0)
        var lines: [CGPoint] = []
        for _ in 0..<64 {
            lines.append(CGPoint.zero)
        }
        
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
    
    public func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return NSNull()
    }
    
    private func drawGridlines(context: CGContext, x: CGFloat, width: CGFloat) {
        
        var y: CGFloat = -48.5
        
        while y <= 48.5 {
            context.move(to: CGPoint(x: x, y: y))
            context.addLine(to: CGPoint(x: x + width, y: y))
            y += 16.0
        }
        
        context.setStrokeColor(graphLineColor.cgColor)
        context.strokePath()
    }
}

public class NSGraphTextView: NSView, CALayerDelegate {
    
    
    public var graphBackgroundColor: NSColor = NSColor(white: 0.6, alpha: 1.0) {
        didSet {
            needsDisplay = true
        }
    }
    
    public var graphLineColor: NSColor = NSColor(white: 0.5, alpha: 1.0) {
        didSet {
            needsDisplay = true
        }
    }
    
    public var textColor: NSColor = NSColor.white {
        didSet {
            needsDisplay = true
        }
    }
    
    public override func draw(_ rect: NSRect) {
        let context = NSGraphicsContext.current!.cgContext
        
        context.setFillColor(graphBackgroundColor.cgColor)
        context.fill(self.bounds)
        context.translateBy(x: 0.0, y: 56.0)
        
        drawGridlines(context: context, x: 26.0, width: 6.0)
        
        NSColor.white.set()
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .right
        
        let attribute = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.paragraphStyle: paraStyle,
            NSAttributedString.Key.font: NSFont.systemFont(ofSize: 10)
        ]
        
        "+3.0".draw(in: CGRect(x: 2.0, y: -56.0, width: 24.0, height: 16.0), withAttributes: attribute)
        "+2.0".draw(in: CGRect(x: 2.0, y: -40.0, width: 24.0, height: 16.0), withAttributes: attribute)
        "+1.0".draw(in: CGRect(x: 2.0, y: -24.0, width: 24.0, height: 16.0), withAttributes: attribute)
        " 0.0".draw(in: CGRect(x: 2.0, y:  -8.0, width: 24.0, height: 16.0), withAttributes: attribute)
        "-1.0".draw(in: CGRect(x: 2.0, y:   8.0, width: 24.0, height: 16.0), withAttributes: attribute)
        "-2.0".draw(in: CGRect(x: 2.0, y:  24.0, width: 24.0, height: 16.0), withAttributes: attribute)
        "-3.0".draw(in: CGRect(x: 2.0, y:  40.0, width: 24.0, height: 16.0), withAttributes: attribute)
    }
    
    private func drawGridlines(context: CGContext, x: CGFloat, width: CGFloat) {
        
        var y: CGFloat = -48.5
        
        while y <= 48.5 {
            context.move(to: CGPoint(x: x, y: y))
            context.addLine(to: CGPoint(x: x + width, y: y))
            y += 16.0
        }
        
        context.setStrokeColor(graphLineColor.cgColor)
        context.strokePath()
    }
}

@IBDesignable
public class NSGraphView: NSView {
    
    @IBInspectable public var graphBackgroundColor: NSColor = NSColor(white: 0.6, alpha: 1.0) {
        didSet {
            text.graphBackgroundColor = graphBackgroundColor
            for segment in self.segments {segment.graphBackgroundColor = graphBackgroundColor}
            needsDisplay = true
        }
    }
    
    @IBInspectable public var graphLineColor: NSColor = NSColor(white: 0.5, alpha: 1.0) {
        didSet {
            text.graphLineColor = graphLineColor
            for segment in self.segments {segment.graphLineColor = graphLineColor}
            needsDisplay = true
        }
    }
    
    @IBInspectable public var textColor: NSColor = NSColor.white {
        didSet {
            text.textColor = textColor
        }
    }
    
    @IBInspectable public var graphXColor: NSColor = NSColor.red {
        didSet {
            for segment in self.segments {
                segment.graphXColor = graphXColor
            }
        }
    }
    
    @IBInspectable public var graphYColor: NSColor = NSColor.green {
        didSet {
            for segment in self.segments {
                segment.graphYColor = graphYColor
            }
        }
    }
    
    @IBInspectable public var graphZColor: NSColor = NSColor.blue {
        didSet {
            for segment in self.segments {
                segment.graphZColor = graphZColor
            }
        }
    }
    
    private let kSegmentInitialPosition = CGPoint(x: 14.0, y: 56.0)
    
    private var segments: [NSGraphViewSegment]!
    
    private var current: NSGraphViewSegment!
    
    private var text: NSGraphTextView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    public override func draw(_ rect: NSRect) {
        let context = NSGraphicsContext.current!.cgContext
        
        context.setFillColor(graphBackgroundColor.cgColor)
        context.fill(self.bounds)
        let width: CGFloat = self.bounds.size.width
        context.translateBy(x: 0.0, y: 56.0)
        
        drawGridlines(context: context, x: 0.0, width: width)
    }
    
    private func drawGridlines(context: CGContext, x: CGFloat, width: CGFloat) {
        
        var y: CGFloat = -48.5
        
        while y <= 48.5 {
            context.move(to: CGPoint(x: x, y: y))
            context.addLine(to: CGPoint(x: x + width, y: y))
            y += 16.0
        }
        
        context.setStrokeColor(graphLineColor.cgColor);
        context.strokePath();
    }
    
    private func commonInit() {
        
        self.text = NSGraphTextView(frame: CGRect(x: 0.0, y: 0.0, width: 32.0, height: 112.0))
        self.addSubview(self.text)
        
        self.segments = [NSGraphViewSegment]()
        
        self.current = self.addSegment()
    }
    
    public func addX(vector: Vector3D) {
        
        if self.current.addX(vector: vector) {
            self.recycleSegment()
            let _ = self.current.addX(vector: vector)
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
    
    private func addSegment() -> NSGraphViewSegment {
        
        let segment: NSGraphViewSegment = NSGraphViewSegment()
        segment.graphBackgroundColor = graphBackgroundColor
        segment.graphLineColor = graphLineColor
        segment.graphXColor = graphXColor
        segment.graphYColor = graphYColor
        segment.graphZColor = graphZColor
        self.segments.insert(segment, at: 0)
        self.layer!.insertSublayer(segment.layer, below: self.text.layer)
        segment.layer.position = kSegmentInitialPosition
        return segment
    }
    
    private func recycleSegment() {
        
        let last = self.segments.last!
        if last.isVisibleInRect(r: self.layer!.bounds) {
            
            self.current = self.addSegment()
        } else {
            last.reset()
            last.layer.position = kSegmentInitialPosition
            self.segments.insert(last, at: 0)
            self.segments.removeLast()
            self.current = last
        }
    }
}
