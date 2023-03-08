import Foundation
import AVFoundation
import CoreImage

class FrameHandler: NSObject, ObservableObject {
    @Published var frameImage: CGImage?
    private let captureSession = AVCaptureSession()
    private let context = CIContext()

    override init() {
        super.init()
        setUpCaptureSession()
    }

    var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)

            // Determine if the user previously authorized camera access.
            var isAuthorized = status == .authorized

            // If the system hasn't determined the user's authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }

            return isAuthorized
        }
    }

    func setUpCaptureSession() {
        Task {
            guard await isAuthorized else { return }

            captureSession.startRunning()

            let videoOutput = AVCaptureVideoDataOutput()

            guard let videoDevice = AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .front),
                  let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
                  captureSession.canAddInput(videoDeviceInput)
            else { return }

            captureSession.addInput(videoDeviceInput)

            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
            captureSession.addOutput(videoOutput)
            videoOutput.connection(with: .video)?.videoOrientation = .portrait
            videoOutput.connection(with: .video)?.isVideoMirrored = true
        }
    }
}

extension FrameHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }

        DispatchQueue.main.async { [unowned self] in
            self.frameImage = cgImage
        }
    }

    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return cgImage
    }
}
