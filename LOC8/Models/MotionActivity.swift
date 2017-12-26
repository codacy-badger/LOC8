//
//  MotionActivity.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/27/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation

/**
 An object the represent a human activity for motions.

 ### Discussion:
 An estimate of the user's activity based on the motion of the device.
 This object contains the motion activity of the user along with the confidence of this activity.
 
 */
open class MotionActivity: Measurement {
    
    // MARK: Properties
    
    ///`MotionActivityStatus` object represent the state of the activity.
    private(set) var status: MotionActivityStatus!
    
    ///`MotionActivityConfidence` object represent the confidance of the activity state.
    private(set) var confidence: Accuracy!
    
    // MARK: Initialaization
    
    /**
     `MotionActivity` Default initializer.
     */
    public override init() {
        super.init()
        status = .unknown
        confidence = .low
    }
    
    
    /**
      Initialize MotionActivity object
     
      - Parameter status: A MotionActivityStatus value represent the activity.
      - Parameter confidence: A MotionActivityConfidence value represent the confidence of the activity.
     */
    public init(status: MotionActivityStatus, confidence: Accuracy) {
        super.init()
        self.status = status
        self.confidence = confidence
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        status = MotionActivityStatus(rawValue: aDecoder.decodeInteger(forKey: "status"))!
        confidence = Accuracy(rawValue: aDecoder.decodeInteger(forKey: "confidence"))!
    }
    
    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(status.rawValue, forKey: "status")
        aCoder.encode(confidence.rawValue, forKey: "confidence")
    }
    
    open override var description: String {
        return "\(status) confidence \(confidence)"
    }
}

#if os(iOS)
    import CoreMotion
    
    public extension MotionActivity {
        
        /**
         Initialize `MotionActivity` object with `CMMotionActivity` in iOS Core Motion.
         
         - Parameter activity: `CMMotionActivity` object represent the motion activity.
         - Warning: Please make note that this method is only available for iOS 7.0 or later.
         */
        @available(iOS 7.0, *)
        public convenience init(activity: CMMotionActivity) {
            self.init(status: MotionActivityStatus(activity: activity), confidence: Accuracy(activity: activity))
        }
    }
#endif
