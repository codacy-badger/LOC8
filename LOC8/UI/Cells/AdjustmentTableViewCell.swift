//
//  AdjustmentTableViewCell.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/26/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

    
public typealias AdjustmentHandler = (Double) -> Void

public class AdjustmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var valueSlider: UISlider!
    
    public var value: Double{
        set {
            valueSlider.value = Float(newValue)
            valueLabel.text = String(format: "%.2f", Float(newValue))
            handler?(newValue)
        }

        get{
            return Double(valueSlider.value)
        }
    }
    
    private var handler: AdjustmentHandler?
    
    @IBAction func valueSliderChangedValue(sender: UISlider) {
        self.value = Double(sender.value)
    }
    
    public func initialize(value: Double, handler: AdjustmentHandler) {
        self.value = value
        self.handler = handler
    }
}
