//
//  LogLevel.swift
//  LOC8
//
//  Created by Marwan Al Masri on 14/12/17.
//  Copyright © 2017 LOC8. All rights reserved.
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
