//
// Created : Mike Johnson, 2021
//

import Foundation

public extension Date {
    enum Format: String, CustomStringConvertible {
        case isoDate = "yyyy-mm-dd"
        case isoDateTime = "yyyy-MM-dd'T'HH:mm:ss"
        case isoDateTimeZone = "yyyy-MM-dd'T'HH:mm:ss'Z'" // .iso8601
        
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
    func daysUntil( _ date: Date ) -> Int {
        let days = Calendar( identifier: .iso8601 ).dateComponents( [.day], from: self, to: date )
        return days.day ?? 0
    }
    var startOfDay: Date {
        let calendar = Calendar.current
        return calendar.startOfDay( for: self )
    }
    
    func isOutsideMonth( month: Int ) -> Bool {
        let calendar = Calendar.current
        return calendar.component( .month, from: self ) != month
    }
    
    var startOfWeek: Date {
        let calendar = Calendar.current
        var comp = calendar.dateComponents( [.yearForWeekOfYear, .weekOfYear], from: self )
        comp.weekday = 2 // start with monday
        return calendar.date( from: comp ) ?? Date()
    }
    
    var month: CalendarMonth {
        let calendar = Calendar.current
        let comp = calendar.dateComponents( [ .year, .month ], from: self )
        guard let year = comp.year, let month = comp.month else { fatalError( "Could not extract date information" ) }
        
        let monthInterval = calendar.dateInterval( of: .month, for: self )!
        let startOfWeek = self.startOfWeek
        let weeks = startOfWeek.weeksInMonth( monthEnd: monthInterval.end )
        
        return CalendarMonth( year: year, month: month, weeks: weeks )
    }
    
    var week: CalendarWeek {
        let calendar = Calendar.current
        let comp = calendar.dateComponents( [ .year, .month ], from: self )
        guard let year = comp.year, let month = comp.month else { fatalError( "Could not extract date information" ) }
        
        let weekInterval = calendar.dateInterval( of: .weekOfYear, for: self )!
        let weekOfYear = calendar.component( .weekOfYear, from: self )
        let days = weekInterval.start.daysInWeek
        
        return CalendarWeek( year: year, month: month, weekIndex: weekOfYear, days: days )
    }
    
    var day: CalendarDay {
        let calendar = Calendar.current
        let comp = calendar.dateComponents( [ .year, .month, .day ], from: self )
        return CalendarDay( date: self, year: comp.year!, month: comp.month!, day: comp.day! )
    }
    
    func weeksInMonth( monthEnd: Date ) -> [CalendarWeek] {
        let calendar = Calendar.current
        
        var weeks = [CalendarWeek]()
        var weekIndex = 0
        var currentWeekStart = self
        let comp = calendar.dateComponents( [.year, .month, .day], from: self )

        while currentWeekStart < monthEnd {
            let days = self.daysInWeek
            let week = CalendarWeek( year: comp.year!, month: comp.month!, weekIndex: weekIndex, days: days )
            weeks.append( week )
            
            guard let nextStart = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeekStart ) else { break }
            
            currentWeekStart = nextStart
            weekIndex += 1
            
            if nextStart.isOutsideMonth( month: comp.month! ) { break }
        }
        
        return weeks
    }
    
    var daysInWeek: [CalendarDay] {
        let calendar = Calendar.current
        var days = [CalendarDay]()
        
        for dayOffset in 0..<7 {
            let dayDate = calendar.date( byAdding: .day, value: dayOffset, to: self )!
            let comp = calendar.dateComponents( [.year, .month, .day], from: dayDate )
            let day = CalendarDay( date: dayDate, year: comp.year!, month: comp.month!, day: comp.day! )
            days.append( day )
        }
        
        return days
    }
}

public struct CalendarDay: Hashable, Identifiable {
    public var id: TimeInterval { date.timeIntervalSince1970 }
    
    public let date: Date
    public let year: Int
    public let month: Int
    public let day: Int
}

public struct CalendarWeek: Hashable, Identifiable {
    public var id: String { "\(year)-\(month)-\(weekIndex)"}
    
    public let year: Int
    public let month: Int
    public let weekIndex: Int
    public let days: [CalendarDay]
}

public struct CalendarMonth: Hashable, Identifiable {
    public var id: String { "\(year)-\(month)" }
    
    public let year: Int
    public let month: Int
    public let weeks: [CalendarWeek]
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
