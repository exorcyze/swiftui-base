//
//  DebugLog.swift
//  Created / Copyright © : Mike Johnson, 2016
//

import Foundation
import os

// MARK: - Shadowed Print

/// Outputs a log message to the console with the file, function, and line number. Time is output with minute:second:millisecond.
/// This handles string types.
///
/// - Parameters:
///   - msg: String value to be output to the console
///   - type: Optional type for categorizing + filtering output
///   - file: Leave blank
///   - fnc: Leave blank
///   - line: Leave blank
///
/// - Returns: None
///
///     print( "\(method) : \(path)", type: .network )
///     [27:57:604] BaseService.request:65 > GET : /api/v5/MyRequest
public func print( _ items: String..., type: DebugFilterType = .none, level: DebugLogLevel = .debug, file: String = #file, fnc : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n" ) {
    #if DEBUG
    struct LogFormatter {
        static let logger = Logger( subsystem: "com.app", category: "" )
        static let formatter = DateFormatter()
    }

    let filename = (("\(file)" as NSString).lastPathComponent as NSString).deletingPathExtension

    let source = "\(filename).\(fnc)"
    let withoutParams = source.components( separatedBy: "(" )[ 0 ]
    LogFormatter.formatter.dateFormat = "mm:ss:SSS"
    let timestamp = LogFormatter.formatter.string( from: Date() )
    let fileOutput = DebugFeature.showFilePath ? file : withoutParams
    let msg = items.map { "\($0)" }.joined(separator: separator)

    let outString = "[\(timestamp)] \(fileOutput):\(line) > \(msg)"
    
    //let icons = "🟥🟦🟧🟨🟩🟪🟫🟰"
    //Swift.print( outString, terminator: terminator )
    switch level {
    case .debug: LogFormatter.logger.debug( "🟰 \(outString)" )
    case .info: LogFormatter.logger.info( "🟩 \(outString)" )
    case .warning: LogFormatter.logger.warning( "🟨 \(outString)" )
    case .error: LogFormatter.logger.critical( "🟥 \(outString)" )
    }

    #endif
}

/// Outputs a log message to the console with the file, function, and line number. Time is output with minute:second:millisecond.
/// Same as above but handles array and dictionary types.
public func print( _ items: Any..., type: DebugFilterType = .none, level: DebugLogLevel = .debug, file: String = #file, fnc : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n" ) {
    #if DEBUG
    let msg = items.map { "\($0)" }.joined(separator: separator)
    print( msg, type: type, level: level, file: file, fnc: fnc, line: line, separator: separator, terminator: terminator )
    #endif
}

// MARK: - Module Struct

/// Struct used by DebugFlag.items to track modules
public struct DebugModule {
    let name: String
    let icon: String
    let show: Bool
    let type: DebugFilterType
}

// MARK: - Debug feature flags

/// These flags are used to conifigure or
/// enable / disable certain features of logging.
public struct DebugFeature {
    /// Turn on to force all output to show ( not yet implemented )
    static let showAllOutput = false
    /// Turn on to use os_log instead of print. This forces extra information on
    /// the front of the output, so this is more useful if you're using Console.app
    /// instead of the Xcode console.
    static let useOSLog = false
    /// Turn on to show the passed log output before the file/line/time information
    static let outputFirst = false
    /// Turn on to show the filePath/fileName instead of just fileName
    static let showFilePath = false
}

// MARK: - Debug filter types

/// Specifies the filter type used by modules to determine
/// if it should currently be logged
public enum DebugFilterType {
    case none
    case application
    case error
    case network
    case networkHeaders
    case networkError
    case analytics
    // MARK: Features
    case home
}

public enum DebugLogLevel {
    case debug
    case info
    case warning
    case error
}

// MARK: - Debug modules

/// Specifies modules to be output for logging.
/// These should usually always default to false when checked
/// in to reduce noise for other developers.
public struct DebugFlag {
    public static let items: [DebugModule] = [
        /*
        DebugModule(name: "None", icon: "[NON]", show: true, type: .none),
        DebugModule(name: "Application", icon: "[APP]", show: true, type: .application),
        DebugModule(name: "Error", icon: "[ERR]", show: true, type: .error),
        DebugModule(name: "Network", icon: "[NET]", show: true, type: .network),
        DebugModule(name: "Network Headers", icon: "[NET]", show: false, type: .networkHeaders),
        DebugModule(name: "Network Errors", icon: "[ERR]", show: true, type: .networkError),
        DebugModule(name: "Analytics", icon: "[ANA]", show: true, type: .analytics),
        
        DebugModule(name: "Home", icon: "[MOD]", show: true, type: .home),
         */
    ]
}

// MARK: - Logging functions

/// Outputs a log message to the console with the file, function, and line number. Time is output with minute:second:millisecond.
///
/// - Parameters:
///   - msg: String value to be output to the console
///   - file: Leave blank
///   - fnc: Leave blank
///   - line: Leave blank
///
/// - Returns: None
///
///     log( "\(method) : \(path)", type: .network )
///     // [27:57:604] BaseService.request:65 > GET : /api/v5/MyRequest
public func log(_ msg: String, type: DebugFilterType = .none, file: String = #file, fnc: String = #function, line: Int = #line) {
    #if DEBUG
    struct LogFormatter { static let formatter = DateFormatter() }

    // grab our file name and figure out enabled modules this is included in
    let filename = (("\(file)" as NSString).lastPathComponent as NSString).deletingPathExtension
    let filtered = DebugFlag.items.filter{ $0.show && $0.type == type }

    // leave if this file isn't an enabled module
    guard filtered.count > 0 else { return }

    // deal with formatting all our information for output
    let icon = filtered.first?.icon ?? ""
    let source = "\(filename).\(fnc)"
    let withoutParams = source.components( separatedBy: "(" )[ 0 ]
    LogFormatter.formatter.dateFormat = "mm:ss:SSS"
    let timestamp = LogFormatter.formatter.string( from: Date() )
    let fileOutput = DebugFeature.showFilePath ? file : withoutParams
    
    // Take care of our output based on debug feature flags.
    // This could be modified to use other output targets.
    var outString = "[APP]\(icon)[\(timestamp)] \(fileOutput):\(line) > \(msg)"
    if DebugFeature.outputFirst {
        outString = "\(icon)\(msg) > \(fileOutput):\(line) [\(timestamp)]"
    }
    if DebugFeature.useOSLog {
        outString = "\(fileOutput):\(line)"
        let osLogType = type == .error ? OSLogType.error : OSLogType.default
        let osLog = OSLog(subsystem: filename, category: String(describing: type))
        // Not using public for msg here since not currently planning on this being
        // used for production logs, so output will show <redacted>. But it is
        // being used so File.Method:line is public
        //os_log(osLogType, log: osLog, "%{public}@ > %@", outString, msg)
    } else {
        print(outString)
    }
    #endif
}

/// Used to log a stack trace to the console
///
///     printStack()
public func printStack( level: DebugLogLevel = .error, file: String = #file, fnc: String = #function, line: Int = #line ) {
    print( "STACK DUMP:\n\t" + Thread.callStackSymbols.joined(separator: "\n\t"), type: .error, level: level, file: file, fnc: fnc, line: line )
}
