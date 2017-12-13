//
//  ValueTableViewCell.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/25/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

open class ValueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var value_Progress: UIDifferentialLinearProgressView!
    
    open var value: Double = 0 {
        didSet {
            
            DispatchQueue.main.async {
                self.value_Progress.value = Float(self.value)
            }
        }
    }
    
}
