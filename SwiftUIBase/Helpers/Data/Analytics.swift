//
// Created by Mike Johnson, 2020.
//
// Usage:
//
// Analytics.track( LaunchEvent() )
// Analytics.track( ButtonEvent( page: .home, buttonLabel: "", pageSection: "" ) )
//
// let event = ContentEvent( type: .play, mediaId: "", origin: .user )
// event.configure( with: player, model: dataModel.source, parentTitle: dataModel.parentTitle )
// Analytics.track( event )
//

import UIKit

// MARK: - Protocols

public protocol AnalyticsEvent {
    var name: String { get }
    var data: [String: Any] { get }
}

// MARK: - Core Definitions

public struct Analytics {
    public enum Page: String {
        case home = "Home"
        case details = "Details"
        case player = "Player"
    }
    
    static public var session: ProviderMediaSession?
    
    /// Deffault method for tracking all standard types of events
    static public func track( _ data: AnalyticsEvent ) {
        let event = ProviderEvent(name: data.name, type: .other )
        event.customAttributes = data.data
        SampleProvider.instance().logEvent( event )
    }
    
    /// Custom method specifically for tracking content-type ( IE player related ) events.
    /// Needed for any specialized tracking in an SDK, like anything session-based.
    static public func trackContent( _ data: ContentEvent ) {
        switch data.type {
        case .sessionStart:
            session = ProviderMediaSession( sessionId: UUID().uuidString )
            session?.logSessionStart()
        case .play:
            session?.logPlay()
        case .contentResume:
            Analytics.track( data )
        }
    }
}

// MARK: - Launch Event

/// Analytics.track( LaunchEvent() )
public struct LaunchEvent: AnalyticsEvent {
    public init() {}
    
    public let name = "Platform Launch"
    public var data: [String: Any] {
        return [
            "platform_client_os": UIDevice.isTv ? "tvOS" : "iOS",
            "platform_client_os_version": UIDevice.current.systemVersion,
        ]
    }
}

// MARK: - Button Event

/// Analytics.track( ButtonEvent( page: .home, buttonLabel: "", pageSection: "" ) )
public struct ButtonEvent: AnalyticsEvent {
    public var page: Analytics.Page
    public var buttonLabel = ""
    public var pageSection = ""
    
    public init(page: Analytics.Page, buttonLabel: String = "", pageSection: String = "") {
        self.page = page
        self.buttonLabel = buttonLabel
        self.pageSection = pageSection
    }
    
    public let name = "Button Click Event"
    public var data: [String: Any] {
        return [ "platform_page_name": page.rawValue,
                 "platform_button_label": buttonLabel,
                 "platform_page_section": pageSection,
        ]
    }
}

// MARK: - Player Event

/// let event = ContentEvent( type: .play, mediaId: "", origin: .user )
/// event.configure( with: player, model: dataModel.source )
/// Analytics.track( event )
public struct ContentEvent: AnalyticsEvent {
    public enum EventType: String {
        case play = "Play"
        case sessionStart
        case contentResume
    }
    public enum OriginType: String {
        case system
        case user
    }
    
    public var type: EventType = .play
    public var mediaId = ""
    public var origin: OriginType = .system // only for play / pause
    private var genre = ""
    public var position = 0
    public var duration = 0
    private var errorCode = "" // Only for error
    private var errorMessage = "" // Only for error

    public init( type: EventType, mediaId: String, origin: OriginType ) {
        self.type = type
        self.mediaId = mediaId
        self.origin = origin
    }

    public mutating func configure( errorCode: String, errorMessage: String ) {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }
    
    public var name: String { return type.rawValue }
    public var data: [String: Any] {
        return [ "player_media_id": mediaId,
                 "player_media_length": duration,
                 "player_playhead_position": position,
                 "player_event_originator": origin.rawValue,
                 "player_error_code": errorCode,
                 "player_error_message": errorMessage,
        ]
    }
}

// MARK: - Sample Extension for custom types

public struct Player {
    let position = 0
    let duration = 0
}
public struct ContentModel {
    let genre: String = ""
}
/// Sample of extending a configuration for a content event inside a context ( Eg: Player module )
/// where there would be awareness of the required type. Ideally, the core Analytics module should be
/// unaware of these types and not need external dependencies on them all.
public extension ContentEvent {
    /// Configures an content event with module-specific types
    ///
    ///     let event = ContentEvent( type: .play, mediaId: "", origin: .user )
    ///     event.configure( with: player, model: dataModel.source )
    ///     Analytics.track( event )
    mutating func configure( with player: Player?, model: ContentModel ) {
        // Player data items
        if let player = player {
            duration = Int( player.duration )
            position = Int( player.position )
        }
        
        // Model data items
        genre = model.genre
    }
}

// MARK: - Fake Stubs

/// These are stand-in examples for an actual provider SDK interface
public class ProviderEvent {
    enum EventType: String { case other }
    
    var name: String
    var type: EventType
    var customAttributes = [String: Any]()
    
    init(name: String, type: EventType) {
        self.name = name
        self.type = type
    }
}
public class SampleProvider {
    static func instance() -> SampleProvider { return SampleProvider() }
    func logEvent( _ event: ProviderEvent ) { }
}
public struct ProviderMediaSession {
    let sessionId: String
    func logSessionStart() {}
    func logPlay() {}
}
