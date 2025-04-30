//
//  ViewExtensions.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/19/25.
//

import SwiftUI

extension View {
    /// Has the option to remove the view if hidden so it is not calculated for layout
    /// and sets an opacity transition on visibility
    @ViewBuilder
    func hidden( _ hide: Bool, remove: Bool = true ) -> some View {
        if hide {
            if !remove { self.hidden() }
        }
        else { self.transition( .opacity ) }
    }
    
    /// Type-erasure down to `AnyView` to address compiler warning
    /// for "Function declares an opaque type... " when trying to use views as properties etc.
    ///
    ///     SettingItemModel( ... type: .navigation( TestView().anyView ) )
    var anyView: AnyView { return AnyView( self ) }
    public func asAnyView() -> AnyView { return AnyView( self ) }
    
    /// Allows for easily setting a border on a rounded rect
    func roundedRectBorder( _ content: some ShapeStyle, cornerRadius: CGFloat, lineWidth: CGFloat = 1 ) -> some View {
        self.cornerRadius( cornerRadius )
            .overlay(
                RoundedRectangle( cornerRadius: cornerRadius )
                    .strokeBorder( content, lineWidth: lineWidth )
                    .padding( -lineWidth * 0.5 )
            )
    }
    
    /// Performs selector on view when app will resign active
    ///
    ///     .onAppWillResignActive { player.pause() }
    public func onAppWillResignActive(_ closure: @escaping () -> Void) -> some View {
        self.onReceive( NotificationCenter.default.publisher( for: UIApplication.willResignActiveNotification), perform: { _ in closure() } )
    }
    
    /// Performs selector on view when app becomes active
    ///
    ///     .onAppDidBecomeActive { Auth.refreshToken() }
    public func onAppDidBecomeActive(_ closure: @escaping () -> Void) -> some View {
        self.onReceive( NotificationCenter.default.publisher( for: UIApplication.didBecomeActiveNotification), perform: { _ in closure() } )
    }
    
    /// Apply modifiers based on a condition
    ///
    ///     .ifModifier( user.isActive ) { $0.tint( .green ) } else: { $0.tint( .black ) }
    @inlinable
    public func ifModifier<M1: View, M2: View>( _ condition: Bool, modifier: (Self) -> M1, else elseModifier: (Self) -> M2 ) -> some View {
        if condition { return modifier( self ).asAnyView() }
        else { return elseModifier( self ).asAnyView() }
    }
    
    /// Apply modifiers based on a condition
    ///
    ///     .ifModifier( user.isActive ) { $0.tint( .green ) }
    @inlinable
    public func ifModifier<M1: View>( _ condition: Bool, modifier: (Self) -> M1 ) -> some View {
        if condition { return modifier( self ).asAnyView() }
        else { return self.asAnyView() }
    }
    
    /// Apply modifiers based on a condition
    ///
    ///     .ifNotModifier( user.isActive ) { $0.tint( .black ) }
    @inlinable
    public func ifNotModifier<M1: View>( _ condition: Bool, modifier: (Self) -> M1 ) -> some View {
        if !condition { return modifier( self ).asAnyView() }
        else { return self.asAnyView() }
    }
    
    /// Apply modifiers if optional value is not `nil`
    ///
    ///     .ifLet( user ) { $0.tint( user.profileColor ) }
    @inlinable
    public func ifLet<T, M1: View>( _ value: T?, modifier: (Self, T) -> M1 ) -> some View {
        if let value { return modifier( self, value ).asAnyView() }
        else { return self.asAnyView() }
    }

}
