//
//  LogManager.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/6/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation

open class LogRecord : NSObject,  NSCoding {
    
    //MARK: Properties
    fileprivate(set) var sender: AnyObject!
    
    fileprivate(set) var message: String!
    
    fileprivate(set) var time: TimeInterval!
    
    
    //MARK:Initialization
    public init(sender: AnyObject, message: String , time: TimeInterval? = nil) {
        super.init()
        self.sender = sender
        self.message = message
        if let time = time {
            self.time = time
        } else {
            self.time = Date().timeIntervalSince1970
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.sender = aDecoder.decodeObject(forKey: "sender") as AnyObject
        self.message = aDecoder.decodeObject(forKey: "message") as! String
        self.time = aDecoder.decodeObject(forKey: "time") as! TimeInterval
    }
    
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(sender, forKey: "sender")
        aCoder.encode(message, forKey: "message")
        aCoder.encode(time, forKey: "time")
    }
    
    open override var description: String {
        let components = (Calendar.current as NSCalendar).components(NSCalendar.Unit.hour.union( NSCalendar.Unit.minute.union( NSCalendar.Unit.second)), from: Date(timeIntervalSince1970: time))
        return "\(type(of: sender!))~\(components.hour):\(components.minute):\(components.second)> \(self.message)"
    }
}

open class LogManager {
    
    //MARK:Shortcuts
    fileprivate var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    open static let LogKey: String = "system-log"
    open static let LogUpdateNotificationKey: String = "com.LOC8.LogUpdateNotificationKey"
    
    //MARK: Properties
    fileprivate(set) var logRecords: [LogRecord]! {
        didSet { self.saveLog() }
    }
    
    open var logText: String {
        var text = ""
        for record in logRecords { text += "\n\(record.description)" }
        return text
    }
    
    fileprivate let filename: String!
    
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
    
    init() {
        
        self.logRecords = []
        
        let components = (Calendar.current as NSCalendar).components(NSCalendar.Unit.year.union( NSCalendar.Unit.month).union( NSCalendar.Unit.day).union(NSCalendar.Unit.hour).union( NSCalendar.Unit.minute), from: Date())
        filename = "Log[\(components.year)-\(components.month)-\(components.day)-\(components.hour)-\(components.minute)].txt"
    }
    
    //MARK:Controlles
    open func print(_ sender: AnyObject, message: String , time: TimeInterval? = nil) {
        
        let record = LogRecord(sender: sender, message: message, time: time)
        self.logRecords.append(record)
        
        notifyObservers()
    }
    
    open func print(_ sender: AnyObject, message: CustomStringConvertible , time: TimeInterval? = nil) {
        
        let record = LogRecord(sender: sender, message: message.description, time: time)
        self.logRecords.append(record)
        
        notifyObservers()
    }
    
    open func clear() {
        
        self.logRecords = []
        
        notifyObservers()
    }
    
    //MARK: Methods
    fileprivate func saveLog() {
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first as! NSString {
            let path = dir.appendingPathComponent(filename)
            
            do { try logText.write(toFile: path, atomically: false, encoding: String.Encoding.utf8) }
            catch { debugPrint(error) }
        }
    }
    
    fileprivate func notifyObservers() {
        let userInfo: [AnyHashable: Any] = [LogManager.LogKey: logText]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: LogManager.LogUpdateNotificationKey), object: nil, userInfo: userInfo)
    }
}
