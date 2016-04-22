//
//  Measurement.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/10/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation

//MARK:- Measurement

/**
 *
 * Measurement
 *
 *  Discussion:
 *   An objsect represent the size or amount of something related to a time.
 *
 */
public class Measurement: NSObject, NSCoding {
    
    private(set) var timestamp: NSTimeInterval!
    
    //MARK: Initialaization
    
    public override init(){
        super.init()
        timestamp = NSDate().timeIntervalSince1970
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.timestamp = aDecoder.decodeDoubleForKey("timestamp")
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(timestamp, forKey: "timestamp")
    }
}
