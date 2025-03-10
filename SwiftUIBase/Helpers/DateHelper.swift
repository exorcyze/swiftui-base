//
// DateHelper
// Created / Copyright © : Mike Johnson, 2021
//

import Foundation

public extension Date {
    enum Format: String, CustomStringConvertible {
        case isoDate = "yyyy-mm-dd"
        case isoDateTime = "yyyy-MM-dd'T'HH:mm:ss"
        case isoDateTimeZone = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        public var description: String { return self.rawValue }
    }
    
    static func parse( from: String, using format: String ) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date( from: from )
    }
    func string( using format: String ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string( from: self )
    }
    static func daysUntil( _ date: Date ) -> Int {
        let days = Calendar( identifier: .iso8601 ).dateComponents( [.day], from: Date(), to: date )
        return days.day ?? 0
    }
    static var startOfDay: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: Date() )
    }
    static var startOfWeek: Date {
        let calendar = Calendar.current
        var comp = calendar.dateComponents( [.yearForWeekOfYear, .weekOfYear], from: Date() )
        comp.weekday = 2 // start with monday
        return calendar.date( from: comp ) ?? Date()
    }
}

public extension Int {
    /// Converts a number of minutes to a display string ( 1hr 45min )
    var minutesAsDisplayString: String {
        return Float( self ).minutesToDisplayString
    }
}

public extension Float {
    /// Converts a number of seconds to a time display string ( hh:mm:ss )
    var asTimeDisplay: String {
        let hr = Int64( self / 3600 )
        let min = Int64( self / 60 ) - hr * 60
        let sec = Int64( self - Float( hr * 3600 + min * 60 ) )
        return String(format: "%02d:%02d:%02d", hr, min, sec)
    }
    
    /// Converts a number of minutes to a display string ( 1hr 45min )
    var minutesToDisplayString: String {
        let hr = Int64( self / 60 )
        let min = Int64( self ) - hr * 60
        if hr == 0 { return String( format: "%01dmin", min ) }
        if min == 0 { return String( format: "%01dhr", hr ) }
        return String( format: "%01dhr %02dmin", hr, min )
    }
}
public extension TimeInterval {
    /// Converts a number of seconds to a time display string ( hh:mm:ss )
    var asTimeDisplay: String {
        return Float( self ).asTimeDisplay
    }
    
    /// Converts a number of minutes to a display string ( 1hr 45min )
    var minutesAsDisplayString: String {
        return Float( self ).minutesToDisplayString
    }
}
