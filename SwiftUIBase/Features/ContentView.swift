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
            try await Task.sleep( for: .seconds( 2.0 ) )
            do {
                user = try await SampleDataStore().getGithubUser()
                print( "user loaded: \(user.login)" )
            }
            catch { print( "ERROR: " + error.localizedDescription ) }
            
            isLoading = false
        }
    }
}

struct CustomProgressBar: View {
    let amount: Double
    let width: Double
    let height: Double = 10
    let emptyColor: Color = .black.opacity( 0.3 )
    let fillColor: Color = .yellow

    var body: some View {
        HStack( alignment: .bottom, spacing: 0 ) {
            fillColor
                .frame(width: width * amount, height: height)
            emptyColor
                .frame( width: width - ( width * amount ), height: height )
        }
        .cornerRadius( .infinity )
    }
}

struct CustomBar: View {
    let amount: Double
    let height: Double = 10
    let emptyColor: Color = .black.opacity( 0.3 )
    let fillColor: Color = .orange
    
    var body: some View {
        RoundedRectangle( cornerRadius: .infinity )
            .fill( .blue.opacity( 0.3 ) )
            .overlay {
                Rectangle()
                    .fill( .orange )
                    .relativeProposed( width: 0.4 )
                    .frame( maxWidth: .infinity, alignment: .leading )
                    .padding( 0 )
            }
            .clipShape( RoundedRectangle( cornerRadius: .infinity) )
            .padding( .horizontal, 10 )
            .frame( height: height )
            .padding( .bottom, 8 )
    }
}
struct ContentView: View {
    var viewModel = SampleUserModel()
    
    @State private var textWidth: CGFloat = 80 // default placeholder
    @State private var stackWidth: CGFloat = 80 // default placeholder
    
    @State private var toggleState = false
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text( "Loading:")
                    Text( "0:05 sec")
                }
                ProgressView( value: 0.25 )
            }
            .padding( 16 )
            .background(
                RoundedRectangle( cornerRadius: 8 )
                    .foregroundStyle( .black.opacity( 0.2 ) )
            )
            .fixedSize()
            
            Text( "Progress + Custom View:" )
            alignmentGuide
            
            //Text( "Custom Bar:" )
            //zstackLayout

            //Text( "Progress View:" )
            //layoutProgress
            
            iActivityIndicator(style: .arcs())
                .frame( width: 80, height: 80 )
                .foregroundStyle( .blue )
            
            Image( systemName: "aqi.medium" )
                .symbolEffect( .variableColor.iterative, options: .repeat( .continuous ), value: !viewModel.isLoading )
                .scaleEffect( 3 )
                .foregroundStyle( .blue )
                .frame( width: 80, height: 80 )
            
            Text("Hello \(viewModel.user.login)!")
            Text( "Visit our [website](https://example.com)." ).tint( .cyan )
                
            Toggle( "Toggle", isOn: $toggleState.animation() )
            Button( "Toggle" ) { withAnimation { toggleState.toggle() } }
        }
        .loadingIndicator( viewModel.isLoading )
        .task { await viewModel.getData() }
        .padding()
    }

    // Loading with size
    // https://www.swiftbysundell.com/articles/swiftui-layout-system-guide-part-3/
    // https://stackoverflow.com/questions/59445483/making-a-shape-the-size-of-the-parent-view-in-swiftui

    /// Sample using .alignmentGuide to read computed width of HStack
    /// and pass that fixed width to a progress view without Geometry Reader
    var alignmentGuide: some View {
        VStack {
            HStack {
                Text( ".alignment")
                Text( "Guide")
            }
            .readSize { size in stackWidth = size.width }
            .alignmentGuide( HorizontalAlignment.center ) { dimensions in
                DispatchQueue.main.async { self.textWidth = dimensions.width }
                return dimensions[ HorizontalAlignment.center ]
            }
            
            LinearProgressView( value: 0.6 )
                .tint( Gradient( colors: [ .orange, .red ] ) )
                .frame( width: textWidth, height: 10 )
            
            /*
            CustomProgressBar( amount: 0.35, width: stackWidth )
            ProgressView( value: 0.25 )
                .scaleEffect( x: progressHeight / 4, y: progressHeight / 4 )
                .frame( width: textWidth / ( progressHeight / 4 ) )
             */
        }
        .padding( 16 )
        .background(
            RoundedRectangle( cornerRadius: 8 )
                .foregroundStyle( .black.opacity( 0.2 ) )
        )
    }
    
    var progressHeight: CGFloat = 10

    /// Sample using rounded rects for progress view in zstack
    /// and custom layout for progress fill width by percentage
    var zstackLayout: some View {
        ZStack( alignment: .bottom ) {
            HStack {
                HStack {
                    Text( "Layout:")
                    Text( "OS 16+")
                }
            }
            .padding( 12 )
            .padding( .bottom, 12 )
            
            LinearProgressView( value: 0.2 )
                .padding( .horizontal, 6 )
                .padding( .bottom, 4 )
                .frame( height: 10 )
                .layoutPriority( -1 )

            CustomBar( amount: 0.6 ).layoutPriority( -1 )
        }
        .background(
            RoundedRectangle( cornerRadius: 8 )
                .foregroundStyle( .black.opacity( 0.2 ) )
        )
    }
    
    /// Sample using ZStack and proposed relative width Layout without
    /// geometry reader or .alignmentGuides for fixed size
    var layoutProgress: some View {
        ZStack( alignment: .bottom ) {
            HStack {
                Text( "Layout:")
                Text( "Progress")
            }
            .padding( .bottom, 16 )

            ProgressView( value: 0.25 )
                .padding( .horizontal, 6 )
                .scaleEffect( x: progressHeight / 4, y: progressHeight / 4 )
                .relativeProposed( width: 0.5 )
        }
        .padding( 16 )
        .background(
            RoundedRectangle( cornerRadius: 8 )
                .foregroundStyle( .black.opacity( 0.2 ) )
        )

    }
    
    /// Example comparison of sizing progress view using scale to achieve a given
    /// point height and also maintain the appropriate capsule appearances
    var progressScaling: some View {
        HStack {
            ProgressView( value: 0.25 )
                .scaleEffect( x: progressHeight / 4, y: progressHeight / 4 )
                .frame( width: textWidth / ( progressHeight / 4 ) )
            RoundedRectangle( cornerRadius: .infinity )
                .foregroundStyle( .green )
                .frame( width: textWidth / 2, height: progressHeight )
        }
    }
}

// https://www.fivestars.blog/articles/swiftui-share-layout-information/
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

// https://oleb.net/2023/swiftui-relative-size/
/// A custom layout that proposes a percentage of its
/// received proposed size to its subview.
///
/// - Precondition: must contain exactly one subview.
public struct RelativeSizeLayout: Layout {
    public enum RelativeSizeLayoutStyle { case horizontal, center }
    
    var relativeWidth: Double
    var relativeHeight: Double
    var layoutStyle: RelativeSizeLayoutStyle = .center
    
    public func sizeThatFits( proposal: ProposedViewSize, subviews: Subviews, cache: inout () ) -> CGSize {
        assert(subviews.count == 1, "expects a single subview")
        let resizedProposal = ProposedViewSize(
            width: proposal.width.map { $0 * relativeWidth },
            height: proposal.height.map { $0 * relativeHeight }
        )
        return subviews[0].sizeThatFits(resizedProposal)
    }

    public func placeSubviews( in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout () ) {
        assert(subviews.count == 1, "expects a single subview")
        let resizedProposal = ProposedViewSize(
            width: proposal.width.map { $0 * relativeWidth },
            height: proposal.height.map { $0 * relativeHeight }
        )
        if layoutStyle == .center {
            subviews[0].place( at: CGPoint(x: bounds.midX, y: bounds.midY), anchor: .center, proposal: resizedProposal )
        }
        else {
            subviews[0].place( at: CGPoint(x: bounds.minX, y: bounds.midY), anchor: .leading, proposal: resizedProposal )
        }
    }
}
extension View {
    /// Proposes a percentage of its received proposed size to `self`.
    public func relativeProposed(width: Double = 1, height: Double = 1) -> some View {
        RelativeSizeLayout(relativeWidth: width, relativeHeight: height) {
            // Wrap content view in a container to make sure the layout only
            // receives a single subview. Because views are lists!
            VStack { // alternatively: `_UnaryViewAdaptor(self)`
                self
            }
        }
    }
}


#Preview {
    ContentView()
}

