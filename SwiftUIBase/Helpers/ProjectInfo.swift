//
//  ProjectInfo.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/8/25.
//

import UIKit
import CryptoKit

extension String {
    func hash256() -> String {
        let inputData = Data(utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}

// MARK: - Public

public class ProjectInfo {
    public class var currentVersion : String {
        let version = Bundle.main.object( forInfoDictionaryKey: "CFBundleShortVersionString" ) as! String
        let build = Bundle.main.object( forInfoDictionaryKey: "CFBundleVersion" ) as! String
        return "\(version).\(build)"
    }
    
    public class var currentDevice : String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        var systemName = identifier
        if systemName == "i386" { systemName = "32-bit Simulator" }
        if systemName == "x86_64" { systemName = "64-bit Simulator" }
        if systemName == "iPhone7,1" { systemName = "iPhone 6 Plus" }
        if systemName == "iPhone7,2" { systemName = "iPhone 6" }
        
        return systemName
    }
    
    public class var currentEnvironment : String {
        return ProjectInfo.bundleValue( "BUILD_ENV" )
    }
    
    public class var currentRegion: String {
        return Locale.current.region?.identifier ?? "us"
    }

    public class var currentIPAddress : String {
        guard let address = ProjectInfo.getWiFiAddress( for: .wifi ) else {
            guard let first = ProjectInfo.getIFAddresses().first else { return "127.0.0.1" }
            return first
        }
        return address
    }
    
    public class var currentIPv6Address : String {
        guard let address = ProjectInfo.getWiFiAddress( for: .ipv6 ) else { return "" }
        return address
    }
    
    public class func logInfo() {
        let url = "none set"
        
        log( "BUILD \(ProjectInfo.currentEnvironment), VERSION \(ProjectInfo.currentVersion)", type: .application )
        log( "DEVICE: \(ProjectInfo.currentDevice)", type: .application )
        log( "IP ADDRESS: \(ProjectInfo.currentIPAddress)", type: .application )
        log( "IPV6 ADDRESS: \(ProjectInfo.currentIPv6Address)", type: .application )
        log( "BASE URL: \(url)", type: .application )
        log( "DEVICE NAME: \(UIDevice.current.name)", type: .application )
        log( "DEVICE MODEL: \(UIDevice.current.model)", type: .application )
        log( "SYSTEM VERSION: \(UIDevice.current.systemVersion)", type: .application )
        log( "LOCALE: \(ProjectInfo.currentRegion)", type: .application )
    }
}

// MARK: - Private

private extension ProjectInfo {
    enum NetworkType: String {
        case wifi = "en0"
        case cellular = "pdp_ip0"
        case ipv4 = "ipv4"
        case ipv6 = "ipv6"
    }
    
    class func bundleValue( _ key: String ) -> String {
        if let path = Bundle.main.path( forResource: "Info", ofType: "plist" ) {
            if let dict = NSDictionary( contentsOfFile: path ) {
                return dict[ key ] as? String ?? ""
            }
        }
        return ""
    }

    // Return IP address of WiFi interface (en0) as a String, or `nil`
    // http://stackoverflow.com/questions/30748480/swift-get-devices-ip-address
    // NOTE: SEEMS TO BE FOR iOS DEVICES ONLY
    class func getWiFiAddress( for network: NetworkType = .wifi ) -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == network.rawValue {
                    // Convert interface address to a human readable string:
                    var addr = interface.ifa_addr.pointee
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
    // http://stackoverflow.com/questions/25626117/how-to-get-ip-address-in-swift/25627545#25627545
    // WORKS FOR SIMULATOR
    class func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }
        
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            var addr = ptr.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                //if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return addresses
    }

}
