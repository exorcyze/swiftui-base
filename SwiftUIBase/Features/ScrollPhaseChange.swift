import SwiftUI

// https://www.reddit.com/r/SwiftUI/comments/1m7638y/swiftui_onscrollphasechange/

struct ScrollPhaseChangeView: View {
    @State private var showTabBar = true
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView{
                DataView()
            }
            .safeAreaPadding(10)
            .overlay(alignment: .bottom, content: {
                if showTabBar{
                    fakeTabBar()
                        .transition(.offset(y: 200))
                }
            })
            .onScrollPhaseChange { _, newPhase in
                switch newPhase {
                case .decelerating:
                    withAnimation {
                        showTabBar = false
                    }
                case .idle:
                    withAnimation {
                        showTabBar = true
                    }
                case .interacting: break
                case .animating: break
                case .tracking: break
                default: break
                }
            }
        }
    }
}

#Preview {
    ScrollPhaseChangeView()
}

struct DataView: View {
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
            ForEach(0 ..< 51) { item in
                ZStack{
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundStyle(.gray.gradient ).frame(height: 200)
                    
                    VStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 10).frame(height: 70)
                        RoundedRectangle(cornerRadius: 5)
                        RoundedRectangle(cornerRadius: 5).frame(width: 100)
                        RoundedRectangle(cornerRadius: 5)
                            .frame(height: 20)
                    }
                    .foregroundStyle(.black.opacity(0.1)).padding()
                }
            }
        }
    }
}

struct fakeTabBar: View {
    var body: some View {
        HStack(spacing: 70){
            Image(systemName: "house")
                .foregroundStyle(.white)
            Image(systemName: "magnifyingglass")
            Image(systemName: "bell")
            Image(systemName: "rectangle.stack")
        }
        .foregroundStyle(.gray)
        .font(.title2)
        .frame(height: 80)
        .padding(.horizontal,20)
        .background(.secondary,in:.capsule)
    }
}

