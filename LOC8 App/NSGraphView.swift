//
//  NSGraphView.swift
//  LOC8
//
//  Created by Marwan Al Masri on 3/27/16.
//  Copyright © 2016 LOC8. All rights reserved.
//

import AppKit
import QuartzCore

public class NSGraphViewSegment: NSObject{
    
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
    
    public var graphXColor: NSColor = NSColor.redColor() {
        didSet {
            layer.setNeedsDisplay()
        }
    }
    
    public var graphYColor: NSColor = NSColor.greenColor() {
        didSet {
            layer.setNeedsDisplay()
        }
    }
    
    public var graphZColor: NSColor = NSColor.blueColor() {
        didSet {
            layer.setNeedsDisplay()
        }
    }
    
    
    public override init() {
        super.init()
        layer = CALayer()
        layer.bounds = CGRectMake(0.0, -56.0, 32.0, 112.0)
        layer.delegate = self
        layer.opaque = true
        
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
        return CGRectIntersectsRect(r, layer.frame)
    }
    
    public func addX(vector: Vector3D) -> Bool {
        
        if index > 0 {
            index -= 1
            vectors[index] = vector
            
            layer.setNeedsDisplay()
        }
        
        return index == 0
    }
    
    public override func drawLayer(l: CALayer, inContext context: CGContextRef) {
        
        CGContextSetFillColorWithColor(context, graphBackgroundColor.CGColor)
        CGContextFillRect(context, layer.bounds)
        drawGridlines(context, x: 0.0, width: 32.0)
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
        CGContextSetStrokeColorWithColor(context, graphXColor.CGColor)
        CGContextStrokeLineSegments(context, lines, 64)
        
        // Y
        for i in 0..<32 {
            lines[i * 2].y = CGFloat(-vectors[i].y) * 16.0
            lines[i * 2 + 1].y = CGFloat(-vectors[i + 1].y) * 16.0
        }
        CGContextSetStrokeColorWithColor(context, graphYColor.CGColor)
        CGContextStrokeLineSegments(context, lines, 64)
        
        // Z
        for i in 0..<32 {
            lines[i * 2].y = CGFloat(-vectors[i].z) * 16.0
            lines[i * 2 + 1].y = CGFloat(-vectors[i + 1].z) * 16.0
        }
        CGContextSetStrokeColorWithColor(context, graphZColor.CGColor)
        CGContextStrokeLineSegments(context, lines, 64)
    }
    
    public override func actionForLayer( layer: CALayer, forKey event: String) -> CAAction? {
        return NSNull()
    }
    
    private func drawGridlines(context: CGContextRef, x: CGFloat, width: CGFloat) {
        
        var y: CGFloat = -48.5
        
        while y <= 48.5 {
            CGContextMoveToPoint(context, x, y);
            CGContextAddLineToPoint(context, x + width, y)
            y += 16.0
        }
        
        CGContextSetStrokeColorWithColor(context, graphLineColor.CGColor);
        CGContextStrokePath(context);
    }
}

public class NSGraphTextView: NSView {
    
    
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
    
    public var textColor: NSColor = NSColor.whiteColor() {
        didSet {
            needsDisplay = true
        }
    }
    
    public override func drawRect(rect: NSRect) {
        let context = NSGraphicsContext.currentContext()!.CGContext
        
        CGContextSetFillColorWithColor(context, graphBackgroundColor.CGColor)
        CGContextFillRect(context, self.bounds)
        CGContextTranslateCTM(context, 0.0, 56.0)
        
        drawGridlines(context, x: 26.0, width: 6.0)
        
        NSColor.whiteColor().set()
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .Right
        
        let attribute = [
            NSForegroundColorAttributeName: textColor,
            NSParagraphStyleAttributeName: paraStyle,
            NSFontAttributeName: NSFont.systemFontOfSize(10)
        ]
        
        "+3.0".drawInRect(CGRectMake(2.0, -56.0, 24.0, 16.0), withAttributes: attribute)
        "+2.0".drawInRect(CGRectMake(2.0, -40.0, 24.0, 16.0), withAttributes: attribute)
        "+1.0".drawInRect(CGRectMake(2.0, -24.0, 24.0, 16.0), withAttributes: attribute)
        " 0.0".drawInRect(CGRectMake(2.0, -8.0, 24.0, 16.0), withAttributes: attribute)
        "-1.0".drawInRect(CGRectMake(2.0, 8.0, 24.0, 16.0), withAttributes: attribute)
        "-2.0".drawInRect(CGRectMake(2.0, 24.0, 24.0, 16.0), withAttributes: attribute)
        "-3.0".drawInRect(CGRectMake(2.0, 40.0, 24.0, 16.0), withAttributes: attribute)
    }
    
    private func drawGridlines(context: CGContextRef, x: CGFloat, width: CGFloat) {
        
        var y: CGFloat = -48.5
        
        while y <= 48.5 {
            CGContextMoveToPoint(context, x, y);
            CGContextAddLineToPoint(context, x + width, y)
            y += 16.0
        }
        
        CGContextSetStrokeColorWithColor(context, graphLineColor.CGColor);
        CGContextStrokePath(context);
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
    
    @IBInspectable public var textColor: NSColor = NSColor.whiteColor() {
        didSet {
            text.textColor = textColor
        }
    }
    
    @IBInspectable public var graphXColor: NSColor = NSColor.redColor() {
        didSet {
            for segment in self.segments {
                segment.graphXColor = graphXColor
            }
        }
    }
    
    @IBInspectable public var graphYColor: NSColor = NSColor.greenColor() {
        didSet {
            for segment in self.segments {
                segment.graphYColor = graphYColor
            }
        }
    }
    
    @IBInspectable public var graphZColor: NSColor = NSColor.blueColor() {
        didSet {
            for segment in self.segments {
                segment.graphZColor = graphZColor
            }
        }
    }
    
    private let kSegmentInitialPosition = CGPointMake(14.0, 56.0)
    
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
    
    public override func drawRect(rect: NSRect) {
        let context = NSGraphicsContext.currentContext()!.CGContext
        
        CGContextSetFillColorWithColor(context, graphBackgroundColor.CGColor)
        CGContextFillRect(context, self.bounds)
        let width: CGFloat = self.bounds.size.width
        CGContextTranslateCTM(context, 0.0, 56.0)
        
        drawGridlines(context, x: 0.0, width: width)
    }
    
    private func drawGridlines(context: CGContextRef, x: CGFloat, width: CGFloat) {
        
        var y: CGFloat = -48.5
        
        while y <= 48.5 {
            CGContextMoveToPoint(context, x, y);
            CGContextAddLineToPoint(context, x + width, y)
            y += 16.0
        }
        
        CGContextSetStrokeColorWithColor(context, graphLineColor.CGColor);
        CGContextStrokePath(context);
    }
    
    private func commonInit() {
        
        self.text = NSGraphTextView(frame: CGRectMake(0.0, 0.0, 32.0, 112.0))
        self.addSubview(self.text)
        
        self.segments = [NSGraphViewSegment]()
        
        self.current = self.addSegment()
    }
    
    public func addX(vector: Vector3D) {
        
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
    
    private func addSegment() -> NSGraphViewSegment {
        
        let segment: NSGraphViewSegment = NSGraphViewSegment()
        segment.graphBackgroundColor = graphBackgroundColor
        segment.graphLineColor = graphLineColor
        segment.graphXColor = graphXColor
        segment.graphYColor = graphYColor
        segment.graphZColor = graphZColor
        self.segments.insert(segment, atIndex: 0)
        self.layer!.insertSublayer(segment.layer, below: self.text.layer)
        segment.layer.position = kSegmentInitialPosition
        return segment
    }
    
    private func recycleSegment() {
        
        let last = self.segments.last!
        if last.isVisibleInRect(self.layer!.bounds) {
            
            self.current = self.addSegment()
        } else {
            last.reset()
            last.layer.position = kSegmentInitialPosition
            self.segments.insert(last, atIndex: 0)
            self.segments.removeLast()
            self.current = last
        }
    }
}
