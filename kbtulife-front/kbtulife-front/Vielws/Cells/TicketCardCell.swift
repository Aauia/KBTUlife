import UIKit

class TicketCardCell: UITableViewCell {
    
    var isUsed = false {
        didSet {
            alpha = isUsed ? 0.6 : 1.0
        }
    }
    
    private let eventNameLabel = UILabel()
    private let dateLabel = UILabel()
    private let locationLabel = UILabel()
    private let purchaseLabel = UILabel()
    private let qrButton = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        selectionStyle = .none
        
        eventNameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .gray
        locationLabel.font = .systemFont(ofSize: 13)
        locationLabel.textColor = .gray
        purchaseLabel.font = .systemFont(ofSize: 12)
        purchaseLabel.textColor = .gray
        
        qrButton.setTitle("View QR", for: .normal)
        qrButton.setImage(UIImage(systemName: "qrcode"), for: .normal)
        qrButton.tintColor = UIColor(red: 0.05, green: 0.17, blue: 0.31, alpha: 1)
        
        let stack = UIStackView(arrangedSubviews: [eventNameLabel, dateLabel, locationLabel])
        stack.axis = .vertical
        stack.spacing = 8
        
        let bottomStack = UIStackView(arrangedSubviews: [purchaseLabel, qrButton])
        bottomStack.axis = .horizontal
        bottomStack.distribution = .fillProportionally
        
        let mainStack = UIStackView(arrangedSubviews: [stack, bottomStack])
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.alignment = .leading
        
        contentView.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with ticket: Ticket, onQR: @escaping () -> Void) {
        eventNameLabel.text = ticket.event.name
        dateLabel.text = "📅 \(ticket.event.date)"
        locationLabel.text = "📍 \(ticket.event.location)"
        purchaseLabel.text = "Purchased \(ticket.createdAt.prefix(10))"
        
        qrButton.removeTarget(nil, action: nil, for: .allEvents)
        qrButton.addTarget(self, action: #selector(qrTapped), for: .touchUpInside)
        self.qrAction = onQR
    }
    
    private var qrAction: (() -> Void)?
    
    @objc private func qrTapped() {
        qrAction?()
    }
}

