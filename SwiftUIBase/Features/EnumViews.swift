//
//  EnumViews.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 5/5/25.
//

import SwiftUI

fileprivate enum ResultView: View {
    case success
    case failure( Error )
    
    var body: some View {
        switch self {
        case .success: Text( "Success" )
        case .failure( let error ): Text( "Error: \(error.localizedDescription)" )
        }
    }
}

fileprivate struct EnumViews: View {
    @State private var isSuccessful = false
    
    var body: some View {
        VStack {
            Button( "Toggle Result" ) { isSuccessful.toggle() }
            
            if isSuccessful {
                ResultView.success
            }
            else {
                ResultView.failure( NSError( domain: "", code: 0, userInfo: nil ) )
            }
        }
        .padding()
    }
}

#Preview {
    EnumViews()
}
