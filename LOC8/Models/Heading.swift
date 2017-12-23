//
//  Heading.swift
//  LOC8
//
//  Created by Marwan Al Masri on 05/12/2015.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation
import CoreLocation

/**
 An object the represent a magnetic headin information.
 
 ### Discussion:
 In a contemporary land navigation context, heading is measured with true north, magnetic north, or grid north being 0° in a 360-degree system.
 
 */
open class Heading: Measurement {
    
    //MARK: Properties
    
    // The heading (measured in radian) relative to magnetic north.
    private(set) var magnetic: Angle!
    
    // The heading (measured in radian) relative to true north.
    private(set) var `true`: Angle!
    
    // The maximum deviation (measured in radian) between the reported heading and the true geomagnetic heading.
    private(set) var accuracy: Angle!
    
    // The geomagnetic vector (measured in microteslas)
    private(set) var field: Vector3D!
    
    //MARK: Initialization
    
    /**
      Initialize Heading object with an angel
     
      - Parameter magnetic: The heading (measured in radian) relative to magnetic north..
      - Parameter true: The heading (measured in radian) relative to true north.
      - Parameter accuracy: The maximum deviation (measured in radian) between the reported heading and the true geomagnetic heading.
      - Parameter geomagneticField: The geomagnetic vector (measured in microteslas)
     */
    public init(magnetic: Angle, `true`: Angle, accuracy: Angle, field: Vector3D) {
        super.init()
        self.magnetic = magnetic
        self.true = `true`
        self.accuracy = accuracy
        self.field = field
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.magnetic = aDecoder.decodeDouble(forKey: "magnetic")
        self.true = aDecoder.decodeDouble(forKey: "true")
        self.accuracy = aDecoder.decodeDouble(forKey: "Accuracy")
        self.field = aDecoder.decodeObject(forKey: "field") as! Vector3D
    }
    
    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.magnetic, forKey: "magnetic")
        aCoder.encode(self.true, forKey: "true")
        aCoder.encode(self.accuracy, forKey: "accuracy")
        aCoder.encode(self.field, forKey: "field")
    }
    
    /**
     Initialize `Heading` object with `CLHeading` in iOS Core Location.
     
     - Parameter heading: `CLHeading` object represent the location heading.
     */
    public convenience init(heading: CLHeading) {
        self.init(magnetic: heading.magneticHeading, true: heading.trueHeading, accuracy: heading.headingAccuracy, field: Vector3D(heading: heading))
    }
    
    open override var description: String {
        return "Heading {\t\nMagnetic = \(self.magnetic)\n\tTrue = \(self.true)\n\tAccuracy = \(self.accuracy)\n\tGeomagnetic Field = \(self.field)\n}."
    }
}

