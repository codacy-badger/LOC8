//
//  LogLevel.swift
//  LOC8
//
//  Created by Marwan Al Masri on 14/12/17.
//  Copyright © 2017 LOC8. All rights reserved.
//

import Foundation

/**
 An enumenator that descrip log levels.
 */
public enum LogLevel: Int, CustomStringConvertible {
    
    /// Any error that is forcing a shutdown of the service or application to prevent data loss (or further data loss).
    case fatal = 0
    
    /// Any error which is fatal to the operation, but not the service or application (can't open a required file, missing data, etc.).
    case error = 1
    
    /// Anything that can potentially cause application oddities, but for which I am automatically recovering.
    case warning = 2
    
    /// Generally useful information to log (service start/stop, configuration assumptions, etc).
    case info = 3
    
    /// Information that is diagnostically helpful to people more than just developers (IT, sysadmins, etc.).
    case debug = 4
    
    /// Only when I would be "tracing" the code and trying to find one part of a function specifically.
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
