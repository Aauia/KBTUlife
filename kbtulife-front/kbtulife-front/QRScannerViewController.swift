import AVFoundation
import UIKit

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "QR Scanner"
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
                    // Валиден — покажи алерт
                    let alert = UIAlertController(title: "Билет валиден", message: "Event: \(ticket.event.name)\nEmail: \(ticket.userEmail ?? "—")", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Отметить использованным", style: .destructive) { _ in
                        // Вызов mark-as-used 
                    })
                    alert.addAction(UIAlertAction(title: "Отмена", style: .cancel) { _ in
                        self?.captureSession.startRunning()
                    })
                    self?.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "Ошибка", message: error?.localizedDescription ?? "Невалидный QR", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        self?.captureSession.startRunning()
                    })
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}
