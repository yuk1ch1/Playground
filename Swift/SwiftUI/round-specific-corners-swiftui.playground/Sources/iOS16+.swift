import SwiftUI
import PlaygroundSupport


/*
 iOS 16+ has built-in modifier, which clips the view using the UnevenRoundedRectangle:
 Note: Although it  works from iOS16, .rect needes Xcode15 to be available.
 You can use the iOS13+ method just case using Xcode under15

 参照: https://stackoverflow.com/questions/56760335/round-specific-corners-swiftui
 */

public struct iOS16ContentView: View {
    @State private var topLeft: CGFloat = 0
    @State private var topRight: CGFloat = 0
    @State private var bottomLeft: CGFloat = 0
    @State private var bottomRight: CGFloat = 0

    public init() {

    }

    public var body: some View {
        VStack {
            HStack(spacing: 32) {
                Slider(value: $topLeft, in: 0...50)
                Slider(value: $topRight, in: 0...50)
            }

            Text("Round Me")
                .frame(width: 200, height: 100)
                .background(Color.red)
                .clipShape(
                    .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 20,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 20,
                        style: .continuous
                    )
                )

            HStack(spacing: 32) {
                Slider(value: $bottomLeft, in: 0...50)
                Slider(value: $bottomRight, in: 0...50)
            }
        }
        .padding()
    }
}


