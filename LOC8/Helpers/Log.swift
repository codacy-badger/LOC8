//
//  LogManager.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/6/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation

/**
 # LogLevel
 An enumenator that descrip log levels.
 
 - FATAL
 - ERROR
 - WARN
 - INFO
 - DEBUG
 - TRACE
 */
public enum LogLevel: Int, CustomStringConvertible{
    case fatal = 0
    case error = 1
    case warning = 2
    case info = 3
    case debug = 4
    case trace = 5
    
    public var description: String {
        switch self {
        case .fatal:
            return "FATAL"
        case .error:
            return "ERROR"
        case .warning:
            return "WARN"
        case .info:
            return "INFO"
        case .debug:
            return "DEBUG"
        case .trace:
            return "TRACE"
        }
    }
}


/**
 # LogRecord
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


/**
 # Log
 Log Manager is a static class that represent the system logging manager.
 
 ## Logging
 - fatal
 - error
 - warning
 - info
 - debug
 - trace
 
 ## General
 - clear
 - save
 
 */
public class Log {
    
    ///Get currently used Log, singleton pattern
    public static let shared = Log()
    
    ///Returns the log update notification. Which is use to register with notification center.
    public static let LogUpdateNotification = Notification.Name(rawValue: "com.LOC8.LogUpdateNotificationKey")
    
    ///An `AnyObject` object witch the log print will be restrected to.
    ///Spacify nil for all objects.
    public static var restrictObject: AnyObject? = nil
    
    ///An `LogLevel` object witch the log print will be restrected to.
    ///Spacify nil for all levels.
    public static var restrictLevel: LogLevel? = nil
    
    ///An array of `LogRecord` that represent the logs containaer.
    private(set) var logRecords: [LogRecord]! = [] {
        didSet {
            NotificationCenter.default.post(name: Log.LogUpdateNotification, object: nil)
        }
    }
    
    ///Returns the full log report with the header info.
    public static var fullLog: String {
        if Log.shared.logRecords.count < 1 {
            return "No Record Has Been Loged."
        }
        var text = ""
        for record in Log.shared.logRecords {
            text += "\n\(record.description)"
        }
        return text
    }
    
    //MARK: Controlles
    
    /**
     # fatal
     Any error that is forcing a shutdown of the service or application to prevent data loss (or further data loss). I reserve these only for the most heinous errors and situations where there is guaranteed to have been data corruption or loss.
     
     - Parameter sender: the sender object.
     - Parameter message: the logging content message that will be dispalyed
     - Parameter time: the time of logging, if it's nil it will record the current time (now).
     */
    public static func fatal(sender: AnyObject, message: String , time: TimeInterval? = nil){
        let record = LogRecord(sender: sender, message: message, time: time, level: .fatal)
        Log.shared.logRecords.append(record)
        record.print()
    }
    
    /**
     # fatal
     Any error that is forcing a shutdown of the service or application to prevent data loss (or further data loss). I reserve these only for the most heinous errors and situations where there is guaranteed to have been data corruption or loss.
     
     - Parameter sender: the sender object.
     - Parameter error: the logging error that will be dispalyed
     - Parameter time: the time of logging, if it's nil it will record the current time (now).
     */
    public static func fatal(sender: AnyObject, error: NSError , time: TimeInterval? = nil){
        let record = LogRecord(sender: sender, message: error.debugDescription, time: time, level: .fatal)
        Log.shared.logRecords.append(record)
        record.print()
    }
    
    /**
     # info
     Generally useful information to log (service start/stop, configuration assumptions, etc). Info I want to always have available but usually don't care about under normal circumstances. This is my out-of-the-box config level.
     
     - Parameter sender: the sender object.
     - Parameter message: the logging content message that will be dispalyed
     - Parameter time: the time of logging, if it's nil it will record the current time (now).
     */
    public static func info(sender: AnyObject, message: String , time: TimeInterval? = nil){
        let record = LogRecord(sender: sender, message: message, time: time, level: .info)
        Log.shared.logRecords.append(record)
        record.print()
    }
    
    /**
     # info
     Generally useful information to log (service start/stop, configuration assumptions, etc). Info I want to always have available but usually don't care about under normal circumstances. This is my out-of-the-box config level.
     
     - Parameter sender: the sender object.
     - Parameter object: the logging content object that will be dispalyed
     - Parameter time: the time of logging, if it's nil it will record the current time (now).
     */
    public static func info(sender: AnyObject, object: CustomStringConvertible , time: TimeInterval? = nil){
        let record = LogRecord(sender: sender, message: object.description, time: time, level: .info)
        Log.shared.logRecords.append(record)
        record.print()
    }
    
    /**
     # error
     Any error which is fatal to the operation, but not the service or application (can't open a required file, missing data, etc.). These errors will force user (administrator, or direct user) intervention. These are usually reserved (in my apps) for incorrect connection strings, missing services, etc.
     
     - Parameter sender: the sender object.
     - Parameter message: the logging content message that will be dispalyed
     - Parameter time: the time of logging, if it's nil it will record the current time (now).
     */
    public static func error(sender: AnyObject, message: String , time: TimeInterval? = nil){
        let record = LogRecord(sender: sender, message: message, time: time, level: .error)
        Log.shared.logRecords.append(record)
        record.print()
    }
    
    /**
     # error
     Any error which is fatal to the operation, but not the service or application (can't open a required file, missing data, etc.). These errors will force user (administrator, or direct user) intervention. These are usually reserved (in my apps) for incorrect connection strings, missing services, etc.
     
     - Parameter sender: the sender object.
     - Parameter error: the logging error that will be dispalyed
     - Parameter time: the time of logging, if it's nil it will record the current time (now).
     */
    public static func error(sender: AnyObject, error: NSError , time: TimeInterval? = nil){
        let record = LogRecord(sender: sender, message: error.localizedDescription, time: time, level: .error)
        Log.shared.logRecords.append(record)
        record.print()
    }
    
    /**
     # warning
     Anything that can potentially cause application oddities, but for which I am automatically recovering. (Such as switching from a primary to backup server, retrying an operation, missing secondary data, etc.).
     
     - Parameter sender: the sender object.
     - Parameter message: the logging content message that will be dispalyed
     - Parameter time: the time of logging, if it's nil it will record the current time (now).
     */
    public static func warning(sender: AnyObject, message: String , time: TimeInterval? = nil){
        let record = LogRecord(sender: sender, message: message, time: time, level: .warning)
        Log.shared.logRecords.append(record)
        record.print()
    }
    
    /**
     # debug
     Information that is diagnostically helpful to people more than just developers (IT, sysadmins, etc.).
     
     - Parameter sender: the sender object.
     - Parameter message: the logging content message that will be dispalyed
     - Parameter time: the time of logging, if it's nil it will record the current time (now).
     */
    public static func debug(sender: AnyObject, message: String , time: TimeInterval? = nil){
        let record = LogRecord(sender: sender, message: message, time: time, level: .debug)
        Log.shared.logRecords.append(record)
        record.print()
    }
    
    /**
     # trace
     Only when I would be "tracing" the code and trying to find one part of a function specifically.
     
     - Parameter sender: the sender object.
     - Parameter message: the logging content message that will be dispalyed
     - Parameter time: the time of logging, if it's nil it will record the current time (now).
     */
    public static func trace(sender: AnyObject, message: String , time: TimeInterval? = nil){
        let record = LogRecord(sender: sender, message: message, time: time, level: .trace)
        Log.shared.logRecords.append(record)
        record.print()
    }
    
    /**
     # clear
     delete all records in log.
     */
    public static func clear() {
        Log.shared.logRecords = []
    }
    
    /**
     # save
     this method will save the full log to a file .
     */
    private static func save() {
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first as NSString? {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm"
            let stringValue = dateFormatter.string(from: Date())
            let filename = "Log[\(stringValue)].txt"
            let path = dir.appendingPathComponent(filename)
            
            do {
                try fullLog.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {
                debugPrint(error)
            }
        }
    }
}
