//
//  ContentView.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/8/25.
//

import SwiftUI
import Observation

@MainActor @Observable
final class SampleUserModel {
    public var isLoading = false
    public var user = GithubUser.empty
    
    func getData() async {
        isLoading = true
        Task {
            try await Task.sleep( nanoseconds: 2_000_000_000 )
            do {
                user = try await SampleDataStore().getGithubUser()
                print( "user loaded: \(user.login)" )
            }
            catch { print( "ERROR: " + error.localizedDescription ) }
            
            isLoading = false
        }
    }
}

struct ContentView: View {
    var viewModel = SampleUserModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello \(viewModel.user.login)!")
        }
        .loadingIndicator( viewModel.isLoading )
        .task { await viewModel.getData() }
        .padding()
    }
}

#Preview {
    ContentView()
}

