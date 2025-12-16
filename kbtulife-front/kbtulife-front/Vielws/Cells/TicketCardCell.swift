import UIKit

class TicketCardCell: UITableViewCell {
    
    var isUsed = false {
        didSet {
            contentView.alpha = isUsed ? 0.5 : 1.0
            qrButton.isHidden = isUsed
            updateStatus()
        }
    }
    
    private let eventNameLabel = UILabel()
    private let dateLabel = UILabel()
    private let locationLabel = UILabel()
    private let statusLabel = UILabel() 
    private let purchaseLabel = UILabel()
    private let qrButton = UIButton(type: .system)
    private var qrAction: (() -> Void)?
    
    private var currentTicket: Ticket?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 20
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.06
        container.layer.shadowRadius = 10
        container.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        contentView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        eventNameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        eventNameLabel.textColor = UIColor(red: 0.05, green: 0.17, blue: 0.31, alpha: 1)
        
        [dateLabel, locationLabel, statusLabel].forEach {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .secondaryLabel
        }
        
        statusLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        
        purchaseLabel.font = .systemFont(ofSize: 11, weight: .medium)
        purchaseLabel.textColor = .tertiaryLabel
        
        qrButton.setTitle(NSLocalizedString("qr_button", comment: ""), for: .normal)
        qrButton.setImage(UIImage(systemName: "qrcode"), for: .normal)
        qrButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        qrButton.tintColor = UIColor(red: 0.05, green: 0.17, blue: 0.31, alpha: 1)
        qrButton.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1)
        qrButton.layer.cornerRadius = 10
        qrButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        qrButton.addTarget(self, action: #selector(qrTapped), for: .touchUpInside)
        
        let infoStack = UIStackView(arrangedSubviews: [eventNameLabel, dateLabel, locationLabel, statusLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 6
        
        let bottomStack = UIStackView(arrangedSubviews: [purchaseLabel, UIView(), qrButton])
        bottomStack.alignment = .center
        
        let mainStack = UIStackView(arrangedSubviews: [infoStack, bottomStack])
        mainStack.axis = .vertical
        mainStack.distribution = .equalSpacing
        
        container.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            mainStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with ticket: Ticket, onQR: @escaping () -> Void) {
        currentTicket = ticket
        
        eventNameLabel.text = ticket.event.name
        locationLabel.text = "📍 \(ticket.event.location)"
        
        // Дата события
        dateLabel.text = DateFormatter.fullEventDateTime(from: ticket.event.date)
        
        // Дата покупки
        let purchaseDate = DateFormatter.formatPurchasedDate(from: ticket.createdAt)
        purchaseLabel.text = String(format: NSLocalizedString("purchased_label", comment: ""), purchaseDate)
        
        // Статус оплаты
        updateStatus()
        
        self.qrAction = onQR
    }
    
    private func updateStatus() {
        guard let ticket = currentTicket else { return }
        
        let statusText: String
        let statusColor: UIColor
        
        if isUsed {
            statusText = NSLocalizedString("status_used", comment: "")
            statusColor = .secondaryLabel
        } else if ticket.event.isFree {
            statusText = NSLocalizedString("status_free", comment: "")
            statusColor = .systemGreen
        } else {
            switch ticket.paymentStatus {
            case "paid":
                statusText = NSLocalizedString("status_paid", comment: "")
                statusColor = .systemGreen
            case "pending":
                statusText = NSLocalizedString("status_pending", comment: "")
                statusColor = .systemOrange
            default:
                statusText = NSLocalizedString("status_unpaid", comment: "")
                statusColor = .systemRed
            }
        }
        
        statusLabel.text = statusText
        statusLabel.textColor = statusColor
    }
    
    @objc private func qrTapped() {
        qrAction?()
    }
}
