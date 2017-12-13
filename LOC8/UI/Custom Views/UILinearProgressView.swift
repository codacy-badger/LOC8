//
//  UIDifferentialLinearProgressView.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/23/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

//MARK: UILinearProgressView
@IBDesignable
open class UILinearProgressView: UIView {
    
    //MARK:UI Elements
    @IBInspectable open var titel: String = "" {
        didSet { titelLabel.text = titel }
    }
    
    @IBInspectable open var textColor : UIColor = UIColor.black {
        didSet {
            titelLabel.textColor = textColor
            valueLabel.textColor = textColor
        }
    }
    
    @IBInspectable open var progressTintColor : UIColor = UIColor.lightGray {
        didSet { progress.progressTintColor = progressTintColor }
    }
    
    @IBInspectable open var trackTintColor: UIColor = UIColor.clear {
        didSet { progress.trackTintColor = trackTintColor }
    }
    
    @IBInspectable open var maxValue: Float = 100
    
    @IBInspectable open var value: Float = 0 {
        didSet {
            
            if abs(value) > 100 {valueLabel.text = String(format: "%.0f", value)}
            else if abs(value) > 10 {valueLabel.text = String(format: "%.1f", value)}
            else {valueLabel.text = String(format: "%.2f", value)}
            
            progress.progress = abs(value / maxValue)
        }
    }
    
    open var font: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            titelLabel.font = font
            valueLabel.font = font
        }
    }
    
    //MARK:UI Objects
    fileprivate(set) var titelLabel: UILabel!
    
    fileprivate(set) var progress: UIProgressView!
    
    fileprivate(set) var valueLabel: UILabel!
    
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
        titelLabel.textAlignment = NSTextAlignment.left
        titelLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titelLabel)
        
        valueLabel = UILabel()
        valueLabel.textColor = textColor
        valueLabel.font = font
        valueLabel.textAlignment = NSTextAlignment.right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(valueLabel)
        
        progress = UIProgressView()
        progress.tintColor = progressTintColor
        progress.trackTintColor = trackTintColor
        progress.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(progress)
        
        progress.addConstraint(NSLayoutConstraint(item: progress, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 4))
        
        self.addConstraints([
            NSLayoutConstraint(item: titelLabel, attribute: .leading,  relatedBy: .equal, toItem: self,         attribute: .leading,  multiplier: 1, constant:  0),
            NSLayoutConstraint(item: titelLabel, attribute: .top,      relatedBy: .equal, toItem: self,         attribute: .top,      multiplier: 1, constant:  0),
            NSLayoutConstraint(item: titelLabel, attribute: .bottom,   relatedBy: .equal, toItem: self,         attribute: .bottom,   multiplier: 1, constant:  0),
            
            NSLayoutConstraint(item: valueLabel, attribute: .trailing, relatedBy: .equal, toItem: self,         attribute: .trailing, multiplier: 1, constant:  0),
            NSLayoutConstraint(item: valueLabel, attribute: .top,      relatedBy: .equal, toItem: self,         attribute: .top,      multiplier: 1, constant:  0),
            NSLayoutConstraint(item: valueLabel, attribute: .bottom,   relatedBy: .equal, toItem: self,         attribute: .bottom,   multiplier: 1, constant:  0),
            
            NSLayoutConstraint(item: progress,   attribute: .leading,  relatedBy: .equal, toItem: self,         attribute: .leading,  multiplier: 1, constant: 45),
            NSLayoutConstraint(item: progress,   attribute: .trailing, relatedBy: .equal, toItem: self,         attribute: .trailing, multiplier: 1, constant:-45),
            NSLayoutConstraint(item: progress,   attribute: .centerY,  relatedBy: .equal, toItem: self,         attribute: .centerY,  multiplier: 1, constant:  2),
            ])
        
        self.updateConstraints()
    }
}

//MARK: UIDifferentialLinearProgressView
@IBDesignable
open class UIDifferentialLinearProgressView: UIView {
    
    //MARK:UI Elements
    @IBInspectable open var titel: String = "" {
        didSet { titelLabel.text = titel }
    }
    
    @IBInspectable open var textColor : UIColor = UIColor.black {
        didSet {
            titelLabel.textColor = textColor
            valueLabel.textColor = textColor
        }
    }
    
    @IBInspectable open var progressTintColor : UIColor = UIColor.lightGray {
        didSet {
            leftProgress.trackTintColor = progressTintColor
            rightProgress.progressTintColor = progressTintColor
        }
    }
    
    @IBInspectable open var trackTintColor: UIColor = UIColor.clear {
        didSet {
            leftProgress.progressTintColor = trackTintColor
            rightProgress.trackTintColor = trackTintColor
        }
    }
    
    @IBInspectable open var maxValue: Float = 100
    
    @IBInspectable open var value: Float = 0 {
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
    
    open var font: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            titelLabel.font = font
            valueLabel.font = font
        }
    }
    
    //MARK:UI Objects
    fileprivate(set) var titelLabel: UILabel!
    
    fileprivate(set) var leftProgress: UIProgressView!
    
    fileprivate(set) var rightProgress: UIProgressView!
    
    fileprivate(set) var valueLabel: UILabel!
    
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
        titelLabel.textAlignment = NSTextAlignment.left
        titelLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titelLabel)
        
        valueLabel = UILabel()
        valueLabel.textColor = textColor
        valueLabel.font = font
        valueLabel.textAlignment = NSTextAlignment.right
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
        
        leftProgress.addConstraint(NSLayoutConstraint(item: leftProgress, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 4))
        rightProgress.addConstraint(NSLayoutConstraint(item: rightProgress, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 4))
        
        self.addConstraints([
            NSLayoutConstraint(item: titelLabel,    attribute: .leading,  relatedBy: .equal, toItem: self,         attribute: .leading,  multiplier: 1, constant:  0),
            NSLayoutConstraint(item: titelLabel,    attribute: .top,      relatedBy: .equal, toItem: self,         attribute: .top,      multiplier: 1, constant:  0),
            NSLayoutConstraint(item: titelLabel,    attribute: .bottom,   relatedBy: .equal, toItem: self,         attribute: .bottom,   multiplier: 1, constant:  0),
            
            NSLayoutConstraint(item: valueLabel,    attribute: .trailing, relatedBy: .equal, toItem: self,         attribute: .trailing, multiplier: 1, constant:  0),
            NSLayoutConstraint(item: valueLabel,    attribute: .top,      relatedBy: .equal, toItem: self,         attribute: .top,      multiplier: 1, constant:  0),
            NSLayoutConstraint(item: valueLabel,    attribute: .bottom,   relatedBy: .equal, toItem: self,         attribute: .bottom,   multiplier: 1, constant:  0),
            
            NSLayoutConstraint(item: leftProgress,  attribute: .leading,  relatedBy: .equal, toItem: self,         attribute: .leading,  multiplier: 1, constant: 45),
            NSLayoutConstraint(item: leftProgress,  attribute: .trailing, relatedBy: .equal, toItem: self,         attribute: .centerX,  multiplier: 1, constant: -2),
            NSLayoutConstraint(item: leftProgress,  attribute: .centerY,  relatedBy: .equal, toItem: self,         attribute: .centerY,  multiplier: 1, constant:  2),
            
            NSLayoutConstraint(item: rightProgress, attribute: .leading,  relatedBy: .equal, toItem: self,         attribute: .centerX,  multiplier: 1, constant:  2),
            NSLayoutConstraint(item: rightProgress, attribute: .centerY,  relatedBy: .equal, toItem: self,         attribute: .centerY,  multiplier: 1, constant:  2),
            NSLayoutConstraint(item: rightProgress, attribute: .width,    relatedBy: .equal, toItem: leftProgress, attribute: .width,    multiplier: 1, constant:  0)
            ])
        
        self.updateConstraints()
    }
}

//MARK: UIDiscreteProgressView
@IBDesignable
open class UIDiscreteProgressView: UIView {
    
    //MARK:UI Elements
    @IBInspectable open var numberOfValues: UInt = 0 {
        didSet { self.setNeedsDisplay() }
    }
    
    @IBInspectable open var fillColor: UIColor = UIColor.lightGray {
        didSet { self.setNeedsDisplay() }
    }
    
    @IBInspectable open var value: UInt = 0 {
        didSet { self.setNeedsDisplay() }
    }
    
    @IBInspectable open var gapWidth: CGFloat = 0 {
        didSet { self.setNeedsDisplay() }
    }
    
    //MARK:UI Objects
    fileprivate var mainLayer: CAShapeLayer!
    fileprivate var barsLayars: [CAShapeLayer] = []
    
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
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if self.mainLayer != nil {
            self.mainLayer.removeFromSuperlayer()
            self.mainLayer = nil
        }
        
        self.mainLayer = CAShapeLayer()
        self.mainLayer.bounds = rect
        self.mainLayer.frame = rect
        self.mainLayer.fillColor = fillColor.cgColor
        self.layer.addSublayer(self.mainLayer)
        
        let dH = rect.height / CGFloat(numberOfValues)
        let dW = rect.width / CGFloat(numberOfValues) - gapWidth / CGFloat(numberOfValues - 1)
        let h: CGFloat = rect.height
        var x: CGFloat = 0.0
        
//        #if TARGET_INTERFACE_BUILDER
//            
            let path = UIBezierPath()
            
            path.move(to: CGPoint(x: x, y: h))
            
            for index in 0..<numberOfValues {
                
                if index + 1 > value { break }
                
                let y = h - (dH * CGFloat(index + 1))
                
                path.addLine(to: CGPoint(x: x, y: y))
                x += dW
                path.addLine(to: CGPoint(x: x, y: y))
                path.addLine(to: CGPoint(x: x, y: h))
                x += gapWidth
                path.addLine(to: CGPoint(x: x, y: h))
            }
            
            path.close()
            
            self.mainLayer.path = path.cgPath
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



