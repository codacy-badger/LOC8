//
//  UIDifferentialLinearProgressView.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/23/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

//MARK:- UILinearProgressView
@IBDesignable
public class UILinearProgressView: UIView {
    
    //MARK:UI Elements
    @IBInspectable public var titel: String = "" {
        didSet { titelLabel.text = titel }
    }
    
    @IBInspectable public var textColor : UIColor = UIColor.blackColor() {
        didSet {
            titelLabel.textColor = textColor
            valueLabel.textColor = textColor
        }
    }
    
    @IBInspectable public var progressTintColor : UIColor = UIColor.lightGrayColor() {
        didSet { progress.progressTintColor = progressTintColor }
    }
    
    @IBInspectable public var trackTintColor: UIColor = UIColor.clearColor() {
        didSet { progress.trackTintColor = trackTintColor }
    }
    
    @IBInspectable public var maxValue: Float = 100
    
    @IBInspectable public var value: Float = 0 {
        didSet {
            
            if abs(value) > 100 {valueLabel.text = String(format: "%.0f", value)}
            else if abs(value) > 10 {valueLabel.text = String(format: "%.1f", value)}
            else {valueLabel.text = String(format: "%.2f", value)}
            
            progress.progress = abs(value / maxValue)
        }
    }
    
    public var font: UIFont = UIFont.systemFontOfSize(14) {
        didSet {
            titelLabel.font = font
            valueLabel.font = font
        }
    }
    
    //MARK:UI Objects
    private(set) var titelLabel: UILabel!
    
    private(set) var progress: UIProgressView!
    
    private(set) var valueLabel: UILabel!
    
    //MARK:Initialization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        
        titelLabel = UILabel()
        titelLabel.text = titel
        titelLabel.textColor = textColor
        titelLabel.font = font
        titelLabel.textAlignment = NSTextAlignment.Left
        titelLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titelLabel)
        
        valueLabel = UILabel()
        valueLabel.textColor = textColor
        valueLabel.font = font
        valueLabel.textAlignment = NSTextAlignment.Right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(valueLabel)
        
        progress = UIProgressView()
        progress.tintColor = progressTintColor
        progress.trackTintColor = trackTintColor
        progress.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(progress)
        
        progress.addConstraint(NSLayoutConstraint(item: progress, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 4))
        
        self.addConstraints([
            NSLayoutConstraint(item: titelLabel, attribute: .Leading,  relatedBy: .Equal, toItem: self,         attribute: .Leading,  multiplier: 1, constant:  0),
            NSLayoutConstraint(item: titelLabel, attribute: .Top,      relatedBy: .Equal, toItem: self,         attribute: .Top,      multiplier: 1, constant:  0),
            NSLayoutConstraint(item: titelLabel, attribute: .Bottom,   relatedBy: .Equal, toItem: self,         attribute: .Bottom,   multiplier: 1, constant:  0),
            
            NSLayoutConstraint(item: valueLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self,         attribute: .Trailing, multiplier: 1, constant:  0),
            NSLayoutConstraint(item: valueLabel, attribute: .Top,      relatedBy: .Equal, toItem: self,         attribute: .Top,      multiplier: 1, constant:  0),
            NSLayoutConstraint(item: valueLabel, attribute: .Bottom,   relatedBy: .Equal, toItem: self,         attribute: .Bottom,   multiplier: 1, constant:  0),
            
            NSLayoutConstraint(item: progress,   attribute: .Leading,  relatedBy: .Equal, toItem: self,         attribute: .Leading,  multiplier: 1, constant: 45),
            NSLayoutConstraint(item: progress,   attribute: .Trailing, relatedBy: .Equal, toItem: self,         attribute: .Trailing, multiplier: 1, constant:-45),
            NSLayoutConstraint(item: progress,   attribute: .CenterY,  relatedBy: .Equal, toItem: self,         attribute: .CenterY,  multiplier: 1, constant:  2),
            ])
        
        self.updateConstraints()
    }
}

//MARK:- UIDifferentialLinearProgressView
@IBDesignable
public class UIDifferentialLinearProgressView: UIView {
    
    //MARK:UI Elements
    @IBInspectable public var titel: String = "" {
        didSet { titelLabel.text = titel }
    }
    
    @IBInspectable public var textColor : UIColor = UIColor.blackColor() {
        didSet {
            titelLabel.textColor = textColor
            valueLabel.textColor = textColor
        }
    }
    
    @IBInspectable public var progressTintColor : UIColor = UIColor.lightGrayColor() {
        didSet {
            leftProgress.trackTintColor = progressTintColor
            rightProgress.progressTintColor = progressTintColor
        }
    }
    
    @IBInspectable public var trackTintColor: UIColor = UIColor.clearColor() {
        didSet {
            leftProgress.progressTintColor = trackTintColor
            rightProgress.trackTintColor = trackTintColor
        }
    }
    
    @IBInspectable public var maxValue: Float = 100
    
    @IBInspectable public var value: Float = 0 {
        didSet {
            
            if abs(value) > 100 {valueLabel.text = String(format: "%.0f", value)}
            else if abs(value) > 10 {valueLabel.text = String(format: "%.1f", value)}
            else {valueLabel.text = String(format: "%.2f", value)}
            
            
            if value > 0 {
                leftProgress.progress = 1
                rightProgress.progress = value / maxValue
            }
            else if value < 0 {
                rightProgress.progress = 0
                leftProgress.progress = 1 - abs(value / maxValue)
            }
            else {
                rightProgress.progress = 0
                leftProgress.progress = 1
            }
        }
    }
    
    public var font: UIFont = UIFont.systemFontOfSize(14) {
        didSet {
            titelLabel.font = font
            valueLabel.font = font
        }
    }
    
    //MARK:UI Objects
    private(set) var titelLabel: UILabel!
    
    private(set) var leftProgress: UIProgressView!
    
    private(set) var rightProgress: UIProgressView!
    
    private(set) var valueLabel: UILabel!
    
    //MARK:Initialization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        
        titelLabel = UILabel()
        titelLabel.text = titel
        titelLabel.textColor = textColor
        titelLabel.font = font
        titelLabel.textAlignment = NSTextAlignment.Left
        titelLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titelLabel)
        
        valueLabel = UILabel()
        valueLabel.textColor = textColor
        valueLabel.font = font
        valueLabel.textAlignment = NSTextAlignment.Right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(valueLabel)
        
        leftProgress = UIProgressView()
        leftProgress.tintColor = progressTintColor
        leftProgress.trackTintColor = trackTintColor
        leftProgress.progress = 1.0
        leftProgress.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(leftProgress)
        
        rightProgress = UIProgressView()
        rightProgress.tintColor = progressTintColor
        rightProgress.trackTintColor = trackTintColor
        rightProgress.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rightProgress)
        
        leftProgress.addConstraint(NSLayoutConstraint(item: leftProgress, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 4))
        rightProgress.addConstraint(NSLayoutConstraint(item: rightProgress, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 4))
        
        self.addConstraints([
            NSLayoutConstraint(item: titelLabel,    attribute: .Leading,  relatedBy: .Equal, toItem: self,         attribute: .Leading,  multiplier: 1, constant:  0),
            NSLayoutConstraint(item: titelLabel,    attribute: .Top,      relatedBy: .Equal, toItem: self,         attribute: .Top,      multiplier: 1, constant:  0),
            NSLayoutConstraint(item: titelLabel,    attribute: .Bottom,   relatedBy: .Equal, toItem: self,         attribute: .Bottom,   multiplier: 1, constant:  0),
            
            NSLayoutConstraint(item: valueLabel,    attribute: .Trailing, relatedBy: .Equal, toItem: self,         attribute: .Trailing, multiplier: 1, constant:  0),
            NSLayoutConstraint(item: valueLabel,    attribute: .Top,      relatedBy: .Equal, toItem: self,         attribute: .Top,      multiplier: 1, constant:  0),
            NSLayoutConstraint(item: valueLabel,    attribute: .Bottom,   relatedBy: .Equal, toItem: self,         attribute: .Bottom,   multiplier: 1, constant:  0),
            
            NSLayoutConstraint(item: leftProgress,  attribute: .Leading,  relatedBy: .Equal, toItem: self,         attribute: .Leading,  multiplier: 1, constant: 45),
            NSLayoutConstraint(item: leftProgress,  attribute: .Trailing, relatedBy: .Equal, toItem: self,         attribute: .CenterX,  multiplier: 1, constant: -2),
            NSLayoutConstraint(item: leftProgress,  attribute: .CenterY,  relatedBy: .Equal, toItem: self,         attribute: .CenterY,  multiplier: 1, constant:  2),
            
            NSLayoutConstraint(item: rightProgress, attribute: .Leading,  relatedBy: .Equal, toItem: self,         attribute: .CenterX,  multiplier: 1, constant:  2),
            NSLayoutConstraint(item: rightProgress, attribute: .CenterY,  relatedBy: .Equal, toItem: self,         attribute: .CenterY,  multiplier: 1, constant:  2),
            NSLayoutConstraint(item: rightProgress, attribute: .Width,    relatedBy: .Equal, toItem: leftProgress, attribute: .Width,    multiplier: 1, constant:  0)
            ])
        
        self.updateConstraints()
    }
}

//MARK:- UIDiscreteProgressView
@IBDesignable
public class UIDiscreteProgressView: UIView {
    
    //MARK:UI Elements
    @IBInspectable public var numberOfValues: UInt = 0 {
        didSet { self.setNeedsDisplay() }
    }
    
    @IBInspectable public var fillColor: UIColor = UIColor.lightGrayColor() {
        didSet { self.setNeedsDisplay() }
    }
    
    @IBInspectable public var value: UInt = 0 {
        didSet { self.setNeedsDisplay() }
    }
    
    @IBInspectable public var gapWidth: CGFloat = 0 {
        didSet { self.setNeedsDisplay() }
    }
    
    //MARK:UI Objects
    private var mainLayer: CAShapeLayer!
    private var barsLayars: [CAShapeLayer] = []
    
    //MARK:Initialization
//    override public init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//    
//    func setup(){
//        
//        #if TARGET_INTERFACE_BUILDER
//        #else
//            
//        #endif
//    }
    
    //MARK:UI Drawings
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if self.mainLayer != nil {
            self.mainLayer.removeFromSuperlayer()
            self.mainLayer = nil
        }
        
        self.mainLayer = CAShapeLayer()
        self.mainLayer.bounds = rect
        self.mainLayer.frame = rect
        self.mainLayer.fillColor = fillColor.CGColor
        self.layer.addSublayer(self.mainLayer)
        
        let dH = rect.height / CGFloat(numberOfValues)
        let dW = rect.width / CGFloat(numberOfValues) - gapWidth / CGFloat(numberOfValues - 1)
        let h: CGFloat = rect.height
        var x: CGFloat = 0.0
        
//        #if TARGET_INTERFACE_BUILDER
//            
            let path = UIBezierPath()
            
            path.moveToPoint(CGPoint(x: x, y: h))
            
            for index in 0..<numberOfValues {
                
                if index + 1 > value { break }
                
                let y = h - (dH * CGFloat(index + 1))
                
                path.addLineToPoint(CGPoint(x: x, y: y))
                x += dW
                path.addLineToPoint(CGPoint(x: x, y: y))
                path.addLineToPoint(CGPoint(x: x, y: h))
                x += gapWidth
                path.addLineToPoint(CGPoint(x: x, y: h))
            }
            
            path.closePath()
            
            self.mainLayer.path = path.CGPath
//        #else
//        
//            if barsLayars.count != Int(numberOfValues) {
//            
//                let layer = CAShapeLayer()
//                layer.bounds = rect
//                layer.frame = rect
//                layer.fillColor = fillColor.CGColor
//                
//                for index in 0..<numberOfValues {
//                    
//                    let y = h - (dH * CGFloat(index + 1))
//                    
//                    let path = UIBezierPath()
//                    path.moveToPoint(CGPoint(x: x, y: h))
//                    path.addLineToPoint(CGPoint(x: x, y: y))
//                    x += dW
//                    path.addLineToPoint(CGPoint(x: x, y: y))
//                    path.addLineToPoint(CGPoint(x: x, y: h))
//                    path.closePath()
//                    x += gapWidth
//                    layer.path = path.CGPath
//                    
//                    mainLayer.addSublayer(layer)
//                    
//                    barsLayars.append(layer)
//                }
//            }
//            for index in 0..<numberOfValues {
//                
//                let layer = barsLayars[Int(index)]
//                
//                layer.removeFromSuperlayer()
//                
//                if index <= value {
//                    
//                    mainLayer.addSublayer(layer)
//                    
//                }
//                
//            }
//        #endif
        
    }
}



