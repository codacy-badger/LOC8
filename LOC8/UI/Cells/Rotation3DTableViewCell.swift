//
//  Rotation3DTableViewCell.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/25/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

open class Rotation3DTableViewCell: UITableViewCell {
    
    @IBOutlet weak var y_Heading: UIRotationView!
    @IBOutlet weak var p_Heading: UIRotationView!
    @IBOutlet weak var r_Heading: UIRotationView!
    
    open var rotation: Rotation3D = Rotation3D() {
        didSet {
            DispatchQueue.main.async {
                self.y_Heading.angle = CGFloat(self.rotation.yaw.degree)
                self.p_Heading.angle = CGFloat(self.rotation.pitch.degree)
                self.r_Heading.angle = CGFloat(self.rotation.roll.degree)
            }
        }
    }
    
    
}
