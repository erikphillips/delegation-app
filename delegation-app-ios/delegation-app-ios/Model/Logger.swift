//
//  Logger.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 1/25/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Foundation

enum LogEvent: String {
    case error = "[ERROR]"
    case info = "[INFO]"
    case debug = "[DEBUG]"
    case verbose = "[VERBOSE]"
    case warning = "[WARNING]"
    case severe = "[SEVERE]"
}

class Logger {
    static var dateFormat = "yyyy-MM-dd hh:mm:ss"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    class func log(_ message: String, event: LogEvent, fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        print("\(Date().toString()) \(event.rawValue)[\(sourceFileName(filePath: fileName)):\(line):\(column)] \(funcName) -> \(message)")
    }
}

extension Date {
    func toString() -> String {
        return Logger.dateFormatter.string(from: self as Date)
    }
}
