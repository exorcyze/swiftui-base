//
//  Created by Mike Johnson 2025.
//

import Foundation

public enum AppEnvironment: String {
    case production, development
    
    /// Returns the envinroment we are running in
    public static var current: AppEnvironment {
        #if DEBUG
        return .development
        #elseif targetEnvironment(simulator)
        return .development
        #else
        guard let path = Bundle.main.appStoreReceiptURL?.path else { return .production }
        return path.contains( "sandboxReceipt" ) ? .development : .production
        #endif
    }
    
    public static var isProduction: Bool { return current == .production }
    public static var isDebug: Bool { return current == .development }
    
    /// Used to determine if we are previewing in Xcode
    public static var isRunningForPreviews: Bool { ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" }
}
