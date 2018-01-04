//
//  AdjustmentTableViewCell.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/26/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

    
public typealias AdjustmentHandler = (Double) -> Void

open class AdjustmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var valueSlider: UISlider!
    
    open var value: Double {
        set {
            valueSlider.value = Float(newValue)
            valueLabel.text = String(format: "%.2f", Float(newValue))
            handler?(newValue)
        }

        get{
            return Double(valueSlider.value)
        }
    }
    
    fileprivate var handler: AdjustmentHandler?
    
    @IBAction func valueSliderChangedValue(_ sender: UISlider) {
        self.value = Double(sender.value)
    }
    
    open func initialize(_ value: Double, handler: @escaping AdjustmentHandler) {
        self.value = value
        self.handler = handler
    }
}
