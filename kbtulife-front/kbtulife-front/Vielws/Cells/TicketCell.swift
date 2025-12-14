//import UIKit
//
//class TicketCell: UITableViewCell {
//    private let eventNameLabel = UILabel()
//    private let statusLabel = UILabel()
//    private let qrImageView = UIImageView()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupUI() {
//        eventNameLabel.font = .boldSystemFont(ofSize: 20)
//        statusLabel.font = .systemFont(ofSize: 16)
//        
//        qrImageView.contentMode = .scaleAspectFit
//        qrImageView.backgroundColor = .white
//        qrImageView.layer.borderWidth = 1
//        qrImageView.layer.borderColor = UIColor.lightGray.cgColor
//        
//        [eventNameLabel, statusLabel, qrImageView].forEach {
//            contentView.addSubview($0)
//            $0.translatesAutoresizingMaskIntoConstraints = false
//        }
//        
//        NSLayoutConstraint.activate([
//            eventNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
//            eventNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            eventNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            
//            statusLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 8),
//            statusLabel.leadingAnchor.constraint(equalTo: eventNameLabel.leadingAnchor),
//            
//            qrImageView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 16),
//            qrImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            qrImageView.widthAnchor.constraint(equalToConstant: 200),
//            qrImageView.heightAnchor.constraint(equalToConstant: 200),
//            qrImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
//        ])
//    }
//    
//    func configure(with ticket: Ticket) {
//        eventNameLabel.text = ticket.event.name
//        
//        let statusText: String
//        switch ticket.paymentStatus {
//        case "paid": statusText = "✅ Оплачен"
//        case "pending": statusText = "⏳ Ожидает проверки"
//        case "unpaid": statusText = "🔴 Не оплачен"
//        default: statusText = ticket.paymentStatus
//        }
//        statusLabel.text = statusText
//        
//        qrImageView.image = ticket.qrCodeImage ?? UIImage(named: "placeholder") 
//    }
//}
