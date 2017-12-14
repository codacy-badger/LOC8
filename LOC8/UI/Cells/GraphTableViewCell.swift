//
//  GraphTableViewCell.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/28/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit


open class GraphTableViewCell: UITableViewCell {
    @IBOutlet weak var graph: UIGraphView!
    
    open func addValue(_ vector: Vector3D) {
        self.graph.addX(vector)
    }
}
