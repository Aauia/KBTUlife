import AVFoundation
import UIKit

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("qr_scanner_title", comment: "")
        view.backgroundColor = .black
        
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            validateQR(code: stringValue)
        }
    }
    
    private func validateQR(code: String) {
        NetworkManager.shared.validateQR(qrCode: code) { [weak self] ticket, error in
            DispatchQueue.main.async {
                if let ticket = ticket {
                    let email = ticket.userEmail ?? "—"
                    let message = String(format: NSLocalizedString("ticket_valid_message", comment: ""), ticket.event.name, email)
                    let alert = UIAlertController(title: NSLocalizedString("ticket_valid_title", comment: ""), message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("mark_used_button", comment: ""), style: .destructive) { _ in
       
                    })
                    alert.addAction(UIAlertAction(title: NSLocalizedString("cancel_button", comment: ""), style: .cancel) { _ in
                        self?.captureSession.startRunning()
                    })
                    self?.present(alert, animated: true)
                } else {
                    let errorMessage = error?.localizedDescription ?? NSLocalizedString("invalid_qr_message", comment: "")
                    let alert = UIAlertController(title: NSLocalizedString("error_title", comment: ""), message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        self?.captureSession.startRunning()
                    })
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}
