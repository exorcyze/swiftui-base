//
//  NetworkMonitor.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/24/25.
//

import SwiftUI
import Network

extension EnvironmentValues {
    @Entry var isNetworkConnected: Bool?
    @Entry var connectionType: NWInterface.InterfaceType?
}

class NetworkMonitor: ObservableObject {
    @Published var isConnected: Bool?
    @Published var connectionType: NWInterface.InterfaceType?
    
    private var queue = DispatchQueue( label: "Monitor" )
    private var monitor = NWPathMonitor()
    
    init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            Task { @MainActor in
                self.isConnected = path.status == .satisfied
                
                let types: [NWInterface.InterfaceType] = [ .wifi, .cellular, .wiredEthernet, .loopback ]
                if let type = types.first( where: { path.usesInterfaceType( $0 ) } ) {
                    self.connectionType = type
                }
                else {
                    self.connectionType = nil
                }
            }
        }
        
        monitor.start( queue: queue )
    }
    
    func stopMonitoring() {
        
    }
}

//@main
struct MySampleApp: App {
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            TestNetworkView()
                .environment( \.isNetworkConnected, networkMonitor.isConnected )
                .environment( \.connectionType, networkMonitor.connectionType )
        }
    }
}

struct TestNetworkView: View {
    @Environment( \.isNetworkConnected ) private var isConnected
    @Environment( \.connectionType ) private var connectionType
    
    var body: some View {
        VStack {
            HStack {
                Text( "Status:")
                Text( isConnected == true ? "Connected" : "No Connection" )
            }
            if let connectionType {
                HStack {
                    Text( "Type:")
                    Text( String( describing: connectionType ).capitalized )
                }
            }
        }
        .sheet( isPresented: .constant( !( isConnected ?? true ) ) ) {
            NoInternetView()
                .presentationDetents( [ .height( 310 ) ] )
                .presentationCornerRadius( 0 )
                .presentationBackgroundInteraction( .disabled )
                .presentationBackground( .clear )
                .interactiveDismissDisabled()
        }
    }
}

struct NoInternetView: View {
    @Environment( \.isNetworkConnected ) private var isConnected
    @Environment( \.connectionType ) private var connectionType

    var body: some View {
        VStack( spacing: 20 ) {
            Image( systemName: "wifi.exclamationmark" )
                .font( .system( size: 80, weight: .semibold ) )
                .frame( height: 100 )
            
            Text( "No Internet Connectivity" )
                .font( .title3 )
                .fontWeight( .semibold )
            
            Text( "Please check your internet connection\nto continue using the app." )
                .multilineTextAlignment( .center )
                .foregroundStyle( .secondary )
                .lineLimit( 2 )
            
            Text( "Waiting for internet connection..." )
                .font( .caption )
                .foregroundStyle( .background )
                .padding( .vertical, 12 )
                .frame( maxWidth: .infinity )
                .background( .primary )
                .padding( .top, 10 )
                .padding( .horizontal, -20 )
        }
        .fontDesign( .rounded )
        .padding( [ .horizontal, .top ], 20 )
        .background( .background )
        .clipShape( .rect( cornerRadius: 20 ) )
        .padding( .horizontal, 20 )
        .padding( .bottom, 10 )
        .frame( height: 310 )
    }
}

#Preview {
    TestNetworkView()
}
