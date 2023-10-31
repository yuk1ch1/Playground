import SwiftUI

/*
 cornerRadius modifier round all of the corners
 Here is the way to round only specific corners such as the top.
 */

/// iOS13+
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

public struct iOS13ContentView: View {
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
                .cornerRadius(topLeft, corners: [.topLeft])
                .cornerRadius(topRight, corners: [.topRight])
                .cornerRadius(bottomLeft, corners: [.bottomLeft])
                .cornerRadius(bottomRight, corners: [.bottomRight])

            HStack(spacing: 32) {
                Slider(value: $bottomLeft, in: 0...50)
                Slider(value: $bottomRight, in: 0...50)
            }
        }.padding()
    }
}



