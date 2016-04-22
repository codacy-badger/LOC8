//
//  Vector3DTableViewCell.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/25/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

public class Vector3DTableViewCell: UITableViewCell {
    
    @IBOutlet weak var x_Progress: UIDifferentialLinearProgressView!
    @IBOutlet weak var y_Progress: UIDifferentialLinearProgressView!
    @IBOutlet weak var z_Progress: UIDifferentialLinearProgressView!
    @IBOutlet weak var r_Progress: UILinearProgressView!
    @IBOutlet weak var t_Heading: UIRotationView!
    @IBOutlet weak var l_Heading: UIRotationView!
    
    public var vector: Vector3D = Vector3D() {
        didSet {
            
            dispatch_async(dispatch_get_main_queue()) {
                self.x_Progress.value = Float(self.vector.x)
                self.y_Progress.value = Float(self.vector.y)
                self.z_Progress.value = Float(self.vector.z)
                self.r_Progress.value = Float(self.vector.magnitude)
                self.t_Heading.angle = CGFloat(radiansToDegrees(self.vector.theta))
                self.l_Heading.angle = CGFloat(radiansToDegrees(self.vector.lambda))
            }
        }
    }
    
}
