//
//  PedometerTableViewCell.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/26/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

public class PedometerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var numberOfStepsLabel: UILabel!
    
    @IBOutlet weak var floorsAscendedLabel: UILabel!
    
    @IBOutlet weak var floorsDescendedLabel: UILabel!
    
    @IBOutlet weak var activityLabel: UILabel!
    
    @IBOutlet weak var confidenceLabel: UILabel!
    
    @IBOutlet weak var confidenceProgress: UIDiscreteProgressView!
    
    public var distance: Double = 0.0 {
        didSet {
            distanceLabel.text =  String(format: "%.2f\tmeters", Float(distance))
        }
    }
    
    public var numberOfSteps: Int = 0 {
        didSet {
            numberOfStepsLabel.text = "\(numberOfSteps)"
        }
    }
    
    public var floorsAscended: Int = 0 {
        didSet {
            floorsAscendedLabel.text = "\(floorsAscended)"
        }
    }
    
    public var floorsDescended: Int = 0 {
        didSet {
            floorsDescendedLabel.text = "\(floorsDescended)"
        }
    }
    
    public var activity: MotionActivity = MotionActivity() {
        didSet {
            activityLabel.text = activity.status.description
            confidenceLabel.text = activity.confidence.description
            confidenceProgress.value = UInt(activity.confidence.rawValue + 1)
            
            switch activity.confidence.description {
            case MotionActivityConfidence.Low.description: confidenceProgress.value = 1
            case MotionActivityConfidence.Medium.description: confidenceProgress.value = 2
            case MotionActivityConfidence.High.description: confidenceProgress.value = 3
            default: confidenceProgress.value = 0
            }
        }
    }
    
}
