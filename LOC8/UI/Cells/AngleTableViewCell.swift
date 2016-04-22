//
//  AngelTableViewCell.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/26/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

public class AngleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var angle_Rotation: UIRotationView!
    
    public var angle:  Double = 0 {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.angle_Rotation.angle = CGFloat(radiansToDegrees(self.angle))
            }
        }
    }
}
