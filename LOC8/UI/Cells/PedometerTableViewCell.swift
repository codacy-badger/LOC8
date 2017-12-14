//
//  PedometerTableViewCell.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/26/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

open class PedometerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var numberOfStepsLabel: UILabel!
    
    @IBOutlet weak var floorsAscendedLabel: UILabel!
    
    @IBOutlet weak var floorsDescendedLabel: UILabel!
    
    @IBOutlet weak var activityLabel: UILabel!
    
    @IBOutlet weak var confidenceLabel: UILabel!
    
    @IBOutlet weak var confidenceProgress: UIDiscreteProgressView!
    
    open var distance: Double = 0.0 {
        didSet {
            distanceLabel.text =  String(format: "%.2f\tmeters", Float(distance))
        }
    }
    
    open var numberOfSteps: Int = 0 {
        didSet {
            numberOfStepsLabel.text = "\(numberOfSteps)"
        }
    }
    
    open var floorsAscended: Int = 0 {
        didSet {
            floorsAscendedLabel.text = "\(floorsAscended)"
        }
    }
    
    open var floorsDescended: Int = 0 {
        didSet {
            floorsDescendedLabel.text = "\(floorsDescended)"
        }
    }
    
    open var activity: MotionActivity = MotionActivity() {
        didSet {
            activityLabel.text = activity.status.description
            confidenceLabel.text = activity.confidence.description
            confidenceProgress.value = UInt(activity.confidence.rawValue + 1)
            
            switch activity.confidence {
            case .low:
                confidenceProgress.value = 1
            case .medium:
                confidenceProgress.value = 2
            case .high:
                confidenceProgress.value = 3
            default:
                confidenceProgress.value = 0
            }
        }
    }
    
}
