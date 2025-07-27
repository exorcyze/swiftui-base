//
// Created by Mike Johnson, 2025
//
// Used by shadowed `print` function for output of a
// demangled call-stack

import Foundation
import Darwin

// https://gist.github.com/kibotu/bbbd761b5f4990a671964e7f8e639a58

public extension Thread {
    /// Used to remove some generally extraneous verbosity from the demangled stack
    private static let removables: [String] = [
        "resume partial function ",
        "partial apply forwarder for ",
        "dispatch thunk of ",
    ]
    
    /// Returns a demangled version of methods from the callstack with some
    /// chaff removed.
    static var callStack : [String] {
        Thread
            .callStackSymbols
            .dropFirst()
            .map { line in
                let parts = line.split(separator:" ")
                let index = parts[0]
                let module = parts[1]
                var method = demangle("\(parts[3])")
                removables.forEach { method = method.replacingOccurrences( of: $0, with: "" ) }
                return "\(index)\t[\(module)]\t\(method)"
            }
    }
}

public typealias SwiftDemangle = @convention(c) (_ mangledName: UnsafePointer<CChar>?, _ mangledNameLength: Int, _ outputBuffer: UnsafeMutablePointer<CChar>?, _ outputBufferSize: UnsafeMutablePointer<Int>?, _ flags: UInt32) -> UnsafeMutablePointer<CChar>?

public let RTLD_DEFAULT = dlopen(nil, RTLD_NOW)
public let demangleSymbol = dlsym(RTLD_DEFAULT, "swift_demangle")!
public let cDemangle = unsafeBitCast(demangleSymbol, to: SwiftDemangle.self)

public func demangle(_ mangled: String) -> String {
    return mangled.withCString { cString in
        // Prepare output buffer size
        var size: Int = 0
        let ptr = cDemangle(cString, strlen(cString), nil, &size, 0)
        
        // Check if demangling was successful
        guard let result = ptr else { return mangled }
        
        // Convert demangled name to string
        let demangledName = String(cString: result)
        
        // Free memory allocated by swift_demangle (if necessary)
        free(result)
        
        return demangledName
    }
}

