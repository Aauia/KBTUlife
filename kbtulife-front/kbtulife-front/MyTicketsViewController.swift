import UIKit

class MyTicketsViewController: UIViewController, UITableViewDataSource {
    // Аналогично EventsVC, но с Ticket, показываем QR в ячейке
    private func showQR(in cell: UITableViewCell, for ticket: Ticket) {
        if let imageData = ticket.qrCodeImageData, let image = UIImage(data: imageData) {
            // Добавить UIImageView в cell и set image
        }
        // Статус: label.text = "Status: \(ticket.paymentStatus.capitalized)"
    }
}
