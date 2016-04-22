//
//  Rotation3DTableViewCell.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/25/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

public class Rotation3DTableViewCell: UITableViewCell {
    
    @IBOutlet weak var y_Heading: UIRotationView!
    @IBOutlet weak var p_Heading: UIRotationView!
    @IBOutlet weak var r_Heading: UIRotationView!
    
    public var rotation: Rotation3D = Rotation3D() {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.y_Heading.angle = CGFloat(radiansToDegrees(self.rotation.yaw))
                self.p_Heading.angle = CGFloat(radiansToDegrees(self.rotation.pitch))
                self.r_Heading.angle = CGFloat(radiansToDegrees(self.rotation.roll))
            }
        }
    }
    
    
}
