//
//  Measurement.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/10/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation

/**
 An object represent the size or amount of something with the relation to a time.
 */
open class Measurement: CustomStringConvertible, NSCoding {
    
    /// A `TimeInterval` value represent the time when the measurment was taken.
    private(set) var timestamp: TimeInterval!
    
    //MARK: Initialaization
    
    public init() {
        timestamp = Date().timeIntervalSince1970
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.timestamp = aDecoder.decodeDouble(forKey: "timestamp")
    }
    
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(timestamp, forKey: "timestamp")
    }
    
    public var description: String {
        return "time of masurment \(self.timestamp) "
    }
}
