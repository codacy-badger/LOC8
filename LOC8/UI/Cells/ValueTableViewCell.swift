//
//  ValueTableViewCell.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/25/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

public class ValueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var value_Progress: UIDifferentialLinearProgressView!
    
    public var value: Double = 0 {
        didSet {
            
            dispatch_async(dispatch_get_main_queue()) {
                self.value_Progress.value = Float(self.value)
            }
        }
    }
    
}
