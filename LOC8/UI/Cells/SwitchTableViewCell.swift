//
//  SwitchTableViewCell.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/30/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

public typealias SwitchHandler = (Bool) -> Void

public class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var valueSwitch: UISwitch!
    
    public var value: Bool{
        set {
            valueSwitch.on = newValue
            handler?(newValue)
        }
        
        get{
            return valueSwitch.on
        }
    }
    
    private var handler: SwitchHandler?
    
    @IBAction func valueSwitchChangedValue(sender: UISwitch) {
        self.value = sender.on
    }
    
    public func initialize(value: Bool, handler: SwitchHandler) {
        self.value = value
        self.handler = handler
    }
    
}
