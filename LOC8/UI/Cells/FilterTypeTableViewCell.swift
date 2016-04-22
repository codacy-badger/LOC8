//
//  FilterTypeTableViewCell.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/26/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

public typealias FilterTypeHandler = (FilterType) -> Void

public class FilterTypeTableViewCell: UITableViewCell {
    
    @IBOutlet public weak var typeSegmentedControl: UISegmentedControl!
    
    public var type: FilterType{
        set {
            typeSegmentedControl.selectedSegmentIndex = indexFor(newValue)
            handler?(newValue)
        }
        
        get {
            return typeFor(typeSegmentedControl.selectedSegmentIndex)
        }
    }
    
    private var handler: FilterTypeHandler?
    
    @IBAction public func typeSegmentedControlChangeValue(sender: UISegmentedControl) {
        self.type = typeFor(sender.selectedSegmentIndex)
    }
    
    public func initialize(type: FilterType, handler: FilterTypeHandler) {
        self.type = type
        self.handler = handler
    }
    
    
    private func typeFor(index: Int) -> FilterType {
        switch index {
        case 1: return .Lowpass
        case 2: return .Highpass
        default: return .Non
        }
    }
    
    private func indexFor(type: FilterType) -> Int {
        switch type {
        case .Non: return 0
        case .Lowpass: return 1
        case .Highpass: return 2
        }
    }
    
}
