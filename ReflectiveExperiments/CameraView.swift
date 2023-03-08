import SwiftUI

struct CameraView: View {
    var image: CGImage?
    private let label = Text("frame")

    var body: some View {
        if let image {
            Image(image, scale: 1.0, orientation: .up, label: label)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Color.black
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(image: UIImage(named: "jimcarrey4ever")?.cgImage)
    }
}
