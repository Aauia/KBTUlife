import Foundation
import UIKit

struct Ticket: Codable {
    let id: Int
    let userEmail: String?
    let event: Event
    let qrcode: String
    let paymentStatus: String
    let used: Bool
    let createdAt: String
    let qrCodeImageBase64: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userEmail = "user_email"
        case event
        case qrcode
        case paymentStatus = "payment_status"
        case used
        case createdAt = "created_at"
        case qrCodeImageBase64 = "qr_code_image"
    }
    var qrCodeImage: UIImage? {
        if let image = generateQRCode(from: qrcode) {
            return image
        }
        if let base64 = qrCodeImageBase64,
           let data = Data(base64Encoded: base64.replacingOccurrences(of: "data:image/png;base64,", with: "")),
           let image = UIImage(data: data) {
            return image
        }
        return nil
    }

    private func generateQRCode(from string: String) -> UIImage? {
        guard let data = string.data(using: .utf8) else { return nil }
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }

        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")

        guard let ciImage = filter.outputImage else { return nil }

        let scale = CGFloat(10)
        let transformed = ciImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))

        let context = CIContext()
        guard let cgImage = context.createCGImage(transformed, from: transformed.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
