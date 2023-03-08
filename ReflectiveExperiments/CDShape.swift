import SwiftUI

struct CDShape: View {
    private let ratio = 0.33

    var body: some View {
        GeometryReader { proxy in
            Circle()
                .stroke(style: StrokeStyle(lineWidth: proxy.size.width * ratio))
                .padding(proxy.size.width * ratio / 2)
        }
        .aspectRatio(contentMode: .fit)
    }
}

struct CDShape_Previews: PreviewProvider {
    static var previews: some View {
        CDShape()
    }
}
