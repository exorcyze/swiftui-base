//
//  DebugLog.swift
//  Created / Copyright © : Mike Johnson, 2016
//

import Foundation
import os

// MARK: - Features

/// These flags are used to conifigure or
/// enable / disable certain features of logging.
public struct DebugFeature {
    /// Turn on to force all output to show ( not yet implemented )
    static let showAllOutput = false
    /// Turn on to show the filePath/fileName instead of just fileName
    static let showFilePath = false
    /// Turn on to output the DebugModule key in the console log
    static let showModuleCode = true
}

// MARK: - Modules

/// Specifies the filter type used by modules to determine
/// if it should currently be logged. The string key can be used for
/// outputting to the console if showModuleCode is on.
public enum DebugModule: String {
    case none = "NON"
    case application = "APP"
    case error = "ERR"
    case network = "NET"
    case networkHeaders = "HDR"
    case networkError = "NETERR"
    case analytics = "ANA"
    case routing = "RTE"
    // MARK: Features
    case home = "HOME"
    
    /// Used to override locally if you only want to show certain modules in the
    /// output logs.
    var showInOutput: Bool {
        switch self {
        case .none: true
        case .application: true
        case .error: true
        case .network: true
        case .networkHeaders: true
        case .networkError: true
        case .analytics: true
        case .routing: true
        case .home: true
        }
    }
}

// MARK: - Shadowed Print

/// Outputs a log message to the console with the file, function, and line number. Time is output with minute:second:millisecond.
/// This handles string types.
///
/// - Parameters:
///   - items: String value to be output to the console
///   - module: Optional type for categorizing + filtering output
///   - level: Logging level ( Eg: .warning, .info )
///   - file: Leave blank
///   - fnc: Leave blank
///   - line: Leave blank
///
/// - Returns: None
///
///     print( "\(method) : \(path)", module: .network )
///     [27:57:604] BaseService.request:65 > GET : /api/v5/MyRequest
public func print( _ items: String..., module: DebugModule = .none, level: DebugLogLevel = .debug, file: String = #file, fnc : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n" ) {
    #if DEBUG
    struct LogFormatter {
        static let logger = Logger( subsystem: "com.app", category: "" )
        static let formatter = DateFormatter()
    }

    // bail out if we don't want output from this module
    guard module.showInOutput else { return }
    
    let filename = (("\(file)" as NSString).lastPathComponent as NSString).deletingPathExtension

    let source = "\(filename).\(fnc)"
    let withoutParams = source.components( separatedBy: "(" )[ 0 ]
    LogFormatter.formatter.dateFormat = "mm:ss:SSS"
    let timestamp = LogFormatter.formatter.string( from: Date() )
    let fileOutput = DebugFeature.showFilePath ? file : withoutParams
    let msg = items.map { "\($0)" }.joined(separator: separator)

    let module = DebugFeature.showModuleCode ? "[\(module.rawValue)]" : ""
    let outString = module + "[\(timestamp)] \(fileOutput):\(line) > \(msg)"
    
    //Swift.print( outString, terminator: terminator )
    switch level {
    case .debug: LogFormatter.logger.debug( "\(level.prefixIcon)\(outString)" )
    case .info: LogFormatter.logger.info( "\(level.prefixIcon)\(outString)" )
    case .warning: LogFormatter.logger.warning( "\(level.prefixIcon)\(outString)" )
    case .error: LogFormatter.logger.critical( "\(level.prefixIcon)\(outString)" )
    }

    #endif
}

/// Outputs a log message to the console with the file, function, and line number. Time is output with minute:second:millisecond.
/// Same as above but handles array and dictionary types.
public func print( _ items: Any..., module: DebugModule = .none, level: DebugLogLevel = .debug, file: String = #file, fnc : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n" ) {
    #if DEBUG
    let msg = items.map { "\($0)" }.joined(separator: separator)
    print( msg, module: module, level: level, file: file, fnc: fnc, line: line, separator: separator, terminator: terminator )
    #endif
}

// MARK: - Logging functions

/// Used to log a stack trace to the console
///
///     printStack()
public func printStack( level: DebugLogLevel = .error, file: String = #file, fnc: String = #function, line: Int = #line ) {
    print( "STACK DUMP:\n\t" + Thread.callStackSymbols.joined(separator: "\n\t"), module: .error, level: level, file: file, fnc: fnc, line: line )
}

// MARK: - Levels

public enum DebugLogLevel {
    case debug
    case info
    case warning
    case error
    
    //let icons = "🟥🟦🟧🟨🟩🟪🟫🟰"
    var prefixIcon: String {
        switch self {
        case .debug: return "🟰 "
        case .info: return "🟩 "
        case .warning: return "🟨 "
        case .error: return "🟥 "
        }
    }
}
