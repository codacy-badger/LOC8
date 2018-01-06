//
//  FilterTypeTableViewCell.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/26/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

public typealias FilterTypeHandler = (FilterType) -> Void

open class FilterTypeTableViewCell: UITableViewCell {
    
    @IBOutlet open weak var typeSegmentedControl: UISegmentedControl!
    
    open var type: FilterType{
        set {
            typeSegmentedControl.selectedSegmentIndex = indexFor(newValue)
            handler?(newValue)
        }
        
        get {
            return typeFor(typeSegmentedControl.selectedSegmentIndex)
        }
    }
    
    fileprivate var handler: FilterTypeHandler?
    
    @IBAction open func typeSegmentedControlChangeValue(_ sender: UISegmentedControl) {
        self.type = typeFor(sender.selectedSegmentIndex)
    }
    
    open func initialize(_ type: FilterType, handler: @escaping FilterTypeHandler) {
        self.type = type
        self.handler = handler
    }
    
    
    fileprivate func typeFor(_ index: Int) -> FilterType {
        switch index {
        case 1: return .lowpass
        case 2: return .highpass
        default: return .non
        }
    }
    
    fileprivate func indexFor(_ type: FilterType) -> Int {
        switch type {
        case .non: return 0
        case .lowpass: return 1
        case .highpass: return 2
        }
    }
    
}
