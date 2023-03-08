import SwiftUI

struct ContentView: View {
    @StateObject private var motion = MotionManager()

    let previewImage: CGImage?

    @StateObject private var model = FrameHandler()
    @State private var isOpened = false

    init(previewImage: CGImage? = nil) {
        self.previewImage = previewImage
    }

    var body: some View {
        CameraView(image: previewImage ?? model.frameImage)
            .mask(CDShape())
            .overlay { texture }
            .overlay { box }
            .overlay { frontBox }
            .padding(70)
            .onTapGesture {
                isOpened.toggle()
            }
    }

    private var texture: some View {
        Image("cd-texture2")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .opacity(0.6)
            .rotationEffect(.degrees(motion.x * 80))
    }

    private var box: some View {
        Image("cd-box")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(1.2)
            .offset(x: -12, y: 5)
    }

    private var frontBox: some View {
        Image("front-box")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .rotation3DEffect(
                .degrees(isOpened ? -180 : 0),
                axis: (x: 0, y: 1, z: 0),
                anchor: .leading
            )
            .scaleEffect(x: 1.2, y: 1.3)
            .offset(x: -8, y: 2)
            .animation(.easeInOut(duration: 0.6), value: isOpened)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(previewImage: UIImage(named: "jimcarrey4ever")?.cgImage)
    }
}
