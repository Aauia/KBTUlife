import SwiftQRCode  // Импорт библиотеки (после добавления через SPM)

private func generateQRCode(from string: String) -> Data? {
    // Базовая генерация (только QR с текстом)
    guard let qrImage = QRCode.generateImage(string, avatarImage: nil, avatarScale: 0.0) else {
        return nil
    }
    
    // Или с параметрами размера (библиотека сама масштабирует, но можно контролировать через UIGraphics)
    // Если хочешь точный размер:
    let size = CGSize(width: 300, height: 300)  // Желаемый размер QR
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    qrImage.draw(in: CGRect(origin: .zero, size: size))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return resizedImage?.jpegData(compressionQuality: 1.0)
}
//