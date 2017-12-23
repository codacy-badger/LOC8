//
//  LogRecord.swift
//  LOC8
//
//  Created by Marwan Al Masri on 14/12/17.
//  Copyright © 2017 LOC8. All rights reserved.
//

import Foundation

/**
 A class represent a log record.
 */
public class LogRecord : NSObject,  NSCoding {
    
    ///the sender object.
    private(set) var sender: AnyObject!
    
    ///the logging content message that will be dispalyed
    private(set) var message: String!
    
    ///the time of logging, if it's nil it will record the current time (now).
    private(set) var time: TimeInterval!
    
    ///the logging level Eg. (error, info, warning.. etc.)
    private(set) var level: LogLevel!
    
    
    /**
     # Initializer
     Initialize new log record object.
     
     - Parameter sender: the sender object.
     - Parameter message: the logging content message that will be dispalyed
     - Parameter time: the time of logging, if it's nil it will record the current time (now).
     - Parameter level: the logging level Eg. (error, info, warning.. etc.)
     */
    public init(sender: AnyObject, message: String , time: TimeInterval? = nil, level: LogLevel) {
        super.init()
        self.sender = sender
        self.message = message
        self.level = level
        if let time = time {
            self.time = time
        }
        else {
            self.time = NSDate().timeIntervalSince1970
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.sender = aDecoder.decodeObject(forKey: "sender") as AnyObject!
        self.message = aDecoder.decodeObject(forKey: "message") as! String
        self.time = aDecoder.decodeObject(forKey: "time") as! TimeInterval
        self.level = LogLevel(rawValue: aDecoder.decodeObject(forKey: "level") as! Int)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(sender, forKey: "sender")
        aCoder.encode(message, forKey: "message")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(level.rawValue, forKey: "level")
    }
    
    public override var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        let stringValue = dateFormatter.string(from: Date(timeIntervalSinceReferenceDate: self.time))
        return "\(self.level.description):\t\(type(of: self.sender!))\t~\(stringValue)> \(self.message!)"
    }
    
    /**
     # print
     Logs the record message to the Apple System Log facility.
     */
    public func print() {
        // Check restrect object
        if let restrictObject = Log.restrictObject, let sender = self.sender {
            if !restrictObject.isEqual(sender) {
                return
            }
        }
        
        // Check restrect level
        if let restrictLevel = Log.restrictLevel, let level = self.level {
            if restrictLevel != level {
                return
            }
        }
        
        //Print record to console
        switch self.level {
        case .debug:
            Swift.debugPrint(self.description)
        default:
            Swift.print(self.description)
        }
    }
}
