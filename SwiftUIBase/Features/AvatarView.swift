//
//  AvatarView.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/2/25.
//

// https://www.youtube.com/watch?v=YjSxPxT5V40&ab_channel=SwiftConf

import SwiftUI

// Enum for our shape
enum AvatarImageShape {
    case round, rectangle
}
// Setup our environment key
struct AvatarImageShapeKey: EnvironmentKey {
    static var defaultValue: AvatarImageShape = .round
}
// Extend our environment values
extension EnvironmentValues {
    var avatarImageShape: AvatarImageShape {
        get { self[ AvatarImageShapeKey.self] }
        set { self[ AvatarImageShapeKey.self] = newValue }
    }
}
// Setup our view modifier
extension View {
    func avatarImageShape( _ imageShape: AvatarImageShape ) -> some View {
        environment( \.avatarImageShape, imageShape )
    }
}
/// Usage:
///
///     AvatarView( user: url )
///         .avatarImageShape( .rectangle )
///         .onEditProfile { /* stuff */ }
struct AvatarView: View {
    @Environment( \.avatarImageShape ) var imageShape
    @Environment( \.editProfileHandler ) var editProfileHandler
    @Environment( \.avatarStyle ) var style
    
    var title: String
    var subtitle: String
    var imageName: String
    
    init( _ title: String, subtitle: String, image name: String ) {
        self.title = title
        self.subtitle = subtitle
        self.imageName = name
    }
    
    var body: some View {
        let configuration = AvatarStyleConfiguration(
            title: .init( Text( title ) ),
            subTitle: .init( Text( subtitle ) ),
            image: .init( systemName: imageName ) )
        AnyView( style.makeBody( configuration: configuration ) )
    }
}

struct AvatarEditProfileHandler: EnvironmentKey {
    static var defaultValue: ( () -> Void )?
}
extension EnvironmentValues {
    var editProfileHandler: ( () -> Void )? {
        get { self[ AvatarEditProfileHandler.self] }
        set { self[ AvatarEditProfileHandler.self] = newValue }
    }
}
extension View {
    public func onEditProfile( editProfileHandler: @escaping () -> Void ) -> some View {
        environment( \.editProfileHandler, editProfileHandler )
    }
}


/// Custom style protocol
///
///     Toggle( isOn: $isOn ) { Text( "Custom Toggle Style" ) }
///         .toggleStyle( .reminder )
struct ReminderToggleStyle: ToggleStyle {
    func makeBody( configuration: Configuration ) -> some View {
        HStack {
            Image( systemName: configuration.isOn ? "largecircle.fill.circle" : "circle" )
                .resizable()
                .frame( width: 24, height: 24 )
                .foregroundStyle( configuration.isOn ? Color.accentColor : .gray )
                .onTapGesture { configuration.isOn.toggle() }
            configuration.label
        }
    }
}
extension ToggleStyle where Self == ReminderToggleStyle {
    static var reminder: ReminderToggleStyle { ReminderToggleStyle() }
}


// create our configuration
struct AvatarStyleConfiguration {
    let title: Title
    struct Title: View {
        let underlyingTitle: AnyView
        init( _ title: some View ) { self.underlyingTitle = AnyView( title ) }
        var body: some View { underlyingTitle }
    }
    
    let subtitle: SubTitle
    struct SubTitle: View {
        let underlyingSubTitle: AnyView
        init( _ subtitle: some View ) { self.underlyingSubTitle = AnyView( subtitle ) }
        var body: some View { underlyingSubTitle }
    }
    
    let image: Image
    
    init( title: Title, subTitle: SubTitle, image: Image ) {
        self.title = title
        self.subtitle = subTitle
        self.image = image
    }
}
// define our style protocol
protocol AvatarStyle {
    associatedtype Body: View
    
    @ViewBuilder
    func makeBody( configuration: Configuration ) -> Body
    
    typealias Configuration = AvatarStyleConfiguration
}
// Setup our environment key
struct AvatarStyleKey: EnvironmentKey {
    static var defaultValue: any AvatarStyle = DefaultAvatarStyle()
}
// Extend our environment values
extension EnvironmentValues {
    var avatarStyle: any AvatarStyle {
        get { self[ AvatarStyleKey.self] }
        set { self[ AvatarStyleKey.self] = newValue }
    }
}
// Setup our view modifier
extension View {
    func avatarStyle( _ style: some AvatarStyle ) -> some View {
        environment( \.avatarStyle, style )
    }
}
// implement style
struct DefaultAvatarStyle: AvatarStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack( alignment: .top ) {
            configuration.image
                .resizable()
                .aspectRatio( contentMode: .fit )
                .background( .gray.opacity( 0.3 ) )
                .frame( width: 50, height: 50, alignment: .center )
                .clipShape( Circle(), style: FillStyle() )
            VStack( alignment: .leading ) {
                configuration.title
                    .font( .headline )
                configuration.subtitle
                    .font( .subheadline )
            }
            Spacer()
        }
    }
}
struct ProfileAvatarStyle: AvatarStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack( alignment: .center ) {
            configuration.image
                .resizable()
                .aspectRatio( contentMode: .fill )
                .frame( width: 50, height: 50, alignment: .center )
                .clipShape( Circle(), style: FillStyle() )
            configuration.title
                .font( .headline )
            configuration.subtitle
                .font( .subheadline )
        }
    }
}
extension AvatarStyle where Self == ProfileAvatarStyle {
    static var profile: Self { .init() }
}

#Preview {
    VStack {
        AvatarView( "Lorem Ipsum", subtitle: "some subtitle", image: "person.circle.fill" )
        AvatarView( "Lorem Ipsum", subtitle: "some subtitle", image: "person.circle.fill" )
            .avatarStyle( .profile )
    }
}
