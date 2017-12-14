//
//  MagneticField.swift
//  LOC8
//
//  Created by Marwan Al Masri on 14/12/17.
//  Copyright © 2017 LOC8. All rights reserved.
//

import Foundation

/**
 # MagneticField
 
 ### Discussion:
 A magnetic field is a force field that is created by moving electric charges and magnetic dipoles, and exerts a force on other nearby moving charges and magnetic dipoles. [Wikipedia](https://en.wikipedia.org/wiki/Magnetic_field)
 */
public class MagneticField: Measurement {
    
    /// A `Vector3D` containing 3-axis magnetometer data
    private(set) var field: Vector3D!
    
    /// An enum `Accuracy` value that indicates the accuracy of the magnetic field estimate.
    private(set) var accuracy: Accuracy = .none
    
    /**
     Initializes the magnetic field to the specified set of values.

     - Parameter field: A `Vector3D` containing 3-axis magnetometer data
     - Parameter accuracy: An `Accuracy` value that indicates the accuracy of the magnetic field estimate.
     */
    public init(field: Vector3D, accuracy: Accuracy) {
        super.init()
        self.field = field
        self.accuracy = accuracy
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        accuracy = Accuracy(rawValue: aDecoder.decodeInteger(forKey: "accuracy"))!
        field = aDecoder.decodeObject(forKey: "field") as! Vector3D
    }
    
    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(accuracy.rawValue, forKey: "accuracy")
        aCoder.encode(field, forKey: "field")
    }
    
    open override var description: String {
        return "Magnetic field with accuracy \(self.accuracy){\n\(self.field)\n"
    }
    
}



#if os(iOS)
    import CoreMotion
    
    public extension MagneticField {
        
        /**
         Initialize `MagneticField` object with `CMCalibratedMagneticField` in iOS Core Motion.
         
         - Parameter magneticField: `CMCalibratedMagneticField` object represent the calibrated magnetic field.
         - Warning: Please make note that this method is only available for iOS 7.0 or later.
         */
        public convenience init(magneticField: CMCalibratedMagneticField) {
            let accuracy = Accuracy(magneticField: magneticField)
            let field = Vector3D(magneticField: magneticField)
            self.init(field: field, accuracy: accuracy)
        }
    }
#endif
