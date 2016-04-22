//
//  LogManager.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/6/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation

public class LogRecord : NSObject,  NSCoding {
    
    //MARK: Properties
    private(set) var sender: AnyObject!
    
    private(set) var message: String!
    
    private(set) var time: NSTimeInterval!
    
    
    //MARK:Initialization
    public init(sender: AnyObject, message: String , time: NSTimeInterval? = nil) {
        super.init()
        self.sender = sender
        self.message = message
        if let time = time {
            self.time = time
        }
        else {
            self.time = NSDate().timeIntervalSince1970
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.sender = aDecoder.decodeObjectForKey("sender")
        self.message = aDecoder.decodeObjectForKey("message") as! String
        self.time = aDecoder.decodeObjectForKey("time") as! NSTimeInterval
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(sender, forKey: "sender")
        aCoder.encodeObject(message, forKey: "message")
        aCoder.encodeObject(time, forKey: "time")
    }
    
    public override var description: String {
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Hour.union( NSCalendarUnit.Minute.union( NSCalendarUnit.Second)), fromDate: NSDate(timeIntervalSince1970: time))
        return "\(sender!.dynamicType)~\(components.hour):\(components.minute):\(components.second)> \(self.message)"
    }
}

public class LogManager {
    
    //MARK:Shortcuts
    private var defaults: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    public static let LogKey: String = "system-log"
    public static let LogUpdateNotificationKey: String = "com.LOC8.LogUpdateNotificationKey"
    
    //MARK: Properties
    private(set) var logRecords: [LogRecord]! {
        didSet { self.saveLog() }
    }
    
    public var logText: String {
        var text = ""
        for record in logRecords { text += "\n\(record.description)" }
        return text
    }
    
    private let filename: String!
    
    //MARK:Initialization
    
    /**
     * Get currently used LogManager, singleton pattern
     *
     * - Returns: `LogManager`
     */
    class var sharedInstance: LogManager {
        struct Singleton {
            static let instance = LogManager()
        }
        
        return Singleton.instance
    }
    
    init(){
        
        self.logRecords = []
        
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Year.union( NSCalendarUnit.Month).union( NSCalendarUnit.Day).union(NSCalendarUnit.Hour).union( NSCalendarUnit.Minute), fromDate: NSDate())
        filename = "Log[\(components.year)-\(components.month)-\(components.day)-\(components.hour)-\(components.minute)].txt"
    }
    
    //MARK:Controlles
    public func print(sender: AnyObject, message: String , time: NSTimeInterval? = nil){
        
        let record = LogRecord(sender: sender, message: message, time: time)
        self.logRecords.append(record)
        
        notifyObservers()
    }
    
    public func print(sender: AnyObject, message: CustomStringConvertible , time: NSTimeInterval? = nil){
        
        let record = LogRecord(sender: sender, message: message.description, time: time)
        self.logRecords.append(record)
        
        notifyObservers()
    }
    
    public func clear() {
        
        self.logRecords = []
        
        notifyObservers()
    }
    
    //MARK: Methods
    private func saveLog() {
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent(filename)
            
            do { try logText.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding) }
            catch { debugPrint(error) }
        }
    }
    
    private func notifyObservers() {
        let userInfo: [NSObject: AnyObject] = [LogManager.LogKey: logText]
        
        NSNotificationCenter.defaultCenter().postNotificationName(LogManager.LogUpdateNotificationKey, object: nil, userInfo: userInfo)
    }
}