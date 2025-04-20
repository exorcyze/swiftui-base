//
//  TextInputField.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/9/25.
//

import SwiftUI

// Original source : https://www.youtube.com/watch?v=PocljzAYFL4&ab_channel=SwiftHeroes
// https://github.com/peterfriese/FloatingLabelTextInputField

struct TextInputField: View {
    private var title : String
    @Binding private var text : String
    @Binding private var isValidBinding : Bool
    
    @Environment( \.clearButtonHidden ) var clearButtonHidden
    @Environment( \.isRequired ) var isRequired
    @Environment( \.validationHandler ) var validationHandler
    
    @State private var isValid : Bool = true { didSet { isValidBinding = isValid } }
    @State var validationMessage : String = ""
    
    private var clearButtonPadding : CGFloat { clearButtonHidden ? 0 : 25 }
    
    public init( _ title: String, text: Binding<String>, isValid isValidBinding: Binding<Bool>? = nil ) {
        self.title = title
        self._text = text
        self._isValidBinding = isValidBinding ?? .constant( true )
    }
    
    var body: some View {
        ZStack( alignment: .leading ) {
            if !isValid {
                Text( validationMessage )
                    .foregroundStyle( .red )
                    .offset( y: -25 )
                    .scaleEffect( 0.8, anchor: .leading )
            }
            
            if ( text.isEmpty || isValid ) {
                Text( title )
                    .foregroundStyle( text.isEmpty ? Color( .placeholderText ) : .accentColor )
                    .offset( y: text.isEmpty ? 0 : -25 )
                    .scaleEffect( text.isEmpty ? 1 : 0.8, anchor: .leading )
            }
            TextField( "", text: $text )
                .onAppear { validate( text ) }
                .onChange( of: text ) { value in validate( value ) }
                .padding( .trailing, clearButtonPadding )
                .overlay( clearButton )
        }
        .padding( .top, 15 )
        .animation( .default, value: text )
    }
    
}

// MARK: - Subviews

extension TextInputField {
    var clearButton : some View {
        HStack {
            if !clearButtonHidden {
                Spacer()
                Button( action: { text = "" } ) {
                    Image( systemName: "multiply.circle.fill" )
                        .foregroundStyle( Color( .systemGray ) )
                }
            }
            else {
                EmptyView()
            }
        }
    }
}

// MARK: - Private Methods

private extension TextInputField {
    func validate( _ value: String ) {
        if isRequired {
            isValid = value.isNotEmpty
            validationMessage = isValid ? "" : "This field is required"
        }
        
        if isValid {
            guard let validationHandler = self.validationHandler else { return }
            let validationResult = validationHandler( value )
            if case .failure(let error) = validationResult {
                isValid = false
                self.validationMessage = "\(error.localizedDescription)"
            }
            else if case .success(let isValid) = validationResult {
                self.isValid = isValid
                self.validationMessage = ""
            }
        }
        
    }
}

// MARK: - Environment + View extensiosn
public struct ValidationError : Error {
    let message: String
    public init( message: String ) { self.message = message }
}
extension ValidationError {
    public var errorDescription: String? { return NSLocalizedString( "\(message)", comment: "Message for generic validation errors." ) }
}

private struct TextInputFieldClearButtonHidden : EnvironmentKey {
    static var defaultValue : Bool = false
}
private struct TextInputFieldRequired : EnvironmentKey {
    static var defaultValue : Bool = false
}
private struct TextInputFieldValidationHandler : EnvironmentKey {
    static var defaultValue: ( (String ) -> Result<Bool, ValidationError> )?
}

public extension EnvironmentValues {
    /*
    var clearButtonHidden : Bool {
        get { self[ TextInputFieldClearButtonHidden.self ] }
        set { self[ TextInputFieldClearButtonHidden.self ] = newValue }
    }
    var isRequired : Bool {
        get { self[ TextInputFieldRequired.self ] }
        set { self[ TextInputFieldRequired.self ] = newValue }
    }
    var validationHandler : ( (String) -> Result<Bool, ValidationError> )? {
        get { self[ TextInputFieldValidationHandler.self ] }
        set { self[ TextInputFieldValidationHandler.self ] = newValue }
    }
     */
    
    // with @Entry macro in XCode 16 all of the above is no longer needed to define keys
    @Entry var clearButtonHidden: Bool = false
    @Entry var isRequired: Bool = false
    @Entry var validationHandler: ( (String) -> Result<Bool, ValidationError> )?
}

extension View {
    func clearButtonHidden( _ hidesClearButton: Bool = true ) -> some View {
        environment( \.clearButtonHidden, hidesClearButton )
    }
    func isRequired( _ value : Bool = true ) -> some View {
        environment( \.isRequired, value )
    }
    func onValidate( validationHandler : @escaping (String) -> Result<Bool, ValidationError> ) -> some View {
        environment( \.validationHandler, validationHandler )
    }
}
// MARK: - Preview

#Preview {
    Group {
        TextInputField( "First Name", text: .constant( "Bilbo Baggins" ) )
            .clearButtonHidden()
            .isRequired( false )
            .padding( 16 )
        TextInputField( "Last Name", text: .constant( "" ) )
            .isRequired()
            .padding( 16 )
    }
}
