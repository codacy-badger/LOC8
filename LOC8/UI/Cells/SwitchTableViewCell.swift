//
//  SwitchTableViewCell.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/30/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

public typealias SwitchHandler = (Bool) -> Void

open class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var valueSwitch: UISwitch!
    
    open var value: Bool{
        set {
            valueSwitch.isOn = newValue
            handler?(newValue)
        }
        
        get{
            return valueSwitch.isOn
        }
    }
    
    fileprivate var handler: SwitchHandler?
    
    @IBAction func valueSwitchChangedValue(_ sender: UISwitch) {
        self.value = sender.isOn
    }
    
    open func initialize(_ value: Bool, handler: @escaping SwitchHandler) {
        self.value = value
        self.handler = handler
    }
    
}
