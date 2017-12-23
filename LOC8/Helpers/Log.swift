//
//  LogManager.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/6/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation

/**
 # Log
 Log Manager is a static class that represent the system logging manager.
 */
public class Log {
    
    ///Get currently used Log, singleton pattern
    public static let shared = Log()
    
    ///Returns the log update notification. Which is use to register with notification center.
    public static let LogUpdateNotification = Notification.Name(rawValue: "com.LOC8.LogUpdateSensorsManager")
    
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
     Any error that is forcing a shutdown of the service or application to prevent data loss (or further data loss).
     I reserve these only for the most heinous errors and situations where there is guaranteed to have been data corruption or loss.
     
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
     Any error that is forcing a shutdown of the service or application to prevent data loss (or further data loss).
     I reserve these only for the most heinous errors and situations where there is guaranteed to have been data corruption or loss.
     
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
     Generally useful information to log (service start/stop, configuration assumptions, etc).
     Info I want to always have available but usually don't care about under normal circumstances. This is my out-of-the-box config level.
     
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
     Generally useful information to log (service start/stop, configuration assumptions, etc).
     Info I want to always have available but usually don't care about under normal circumstances. This is my out-of-the-box config level.
     
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
     Any error which is fatal to the operation, but not the service or application (can't open a required file, missing data, etc.).
     These errors will force user (administrator, or direct user) intervention. These are usually reserved (in my apps) for incorrect connection strings, missing services, etc.
     
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
     Any error which is fatal to the operation, but not the service or application (can't open a required file, missing data, etc.).
     These errors will force user (administrator, or direct user) intervention. These are usually reserved (in my apps) for incorrect connection strings, missing services, etc.
     
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
     Anything that can potentially cause application oddities, but for which I am automatically recovering.
     (Such as switching from a primary to backup server, retrying an operation, missing secondary data, etc.).
     
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
     delete all records in log.
     */
    public static func clear() {
        Log.shared.logRecords = []
    }
    
    /**
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
