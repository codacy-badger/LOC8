//
//  AngelTableViewCell.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/26/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

open class AngleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var angle_Rotation: UIRotationView!
    
    open var angle:  Double = 0 {
        didSet {
            DispatchQueue.main.async {
                self.angle_Rotation.angle = CGFloat(Angle(self.angle).degree)
            }
        }
    }
}
