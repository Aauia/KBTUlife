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
        // Контейнер для ячейки
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 16
        container.layer.shadowOpacity = 0.1
        container.layer.shadowRadius = 8
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        contentView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        selectionStyle = .none
        
        eventNameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .gray
        locationLabel.font = .systemFont(ofSize: 14)
        locationLabel.textColor = .gray
        purchaseLabel.font = .systemFont(ofSize: 12)
        purchaseLabel.textColor = .systemGray
        
        qrButton.setTitle("View QR", for: .normal)
        qrButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        qrButton.setImage(UIImage(systemName: "qrcode"), for: .normal)
        qrButton.tintColor = UIColor(red: 0.05, green: 0.17, blue: 0.31, alpha: 1)
        
        let stack = UIStackView(arrangedSubviews: [eventNameLabel, dateLabel, locationLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        let bottomStack = UIStackView(arrangedSubviews: [purchaseLabel, UIView(), qrButton])
        bottomStack.axis = .horizontal
        bottomStack.distribution = .fill
        
        let mainStack = UIStackView(arrangedSubviews: [stack, UIView(), bottomStack])
        mainStack.axis = .vertical
        mainStack.spacing = 10
        mainStack.alignment = .leading
        
        container.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Констрейнты для контейнера (обеспечение отступов между ячейками)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Констрейнты для внутреннего стека
            mainStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
            
            // Выравнивание горизонтальных стеков по ширине
            bottomStack.widthAnchor.constraint(equalTo: mainStack.widthAnchor),
            stack.widthAnchor.constraint(equalTo: mainStack.widthAnchor)
        ])
    }
    
    func configure(with ticket: Ticket, onQR: @escaping () -> Void) {
        eventNameLabel.text = ticket.event.name
        locationLabel.text = "📍 \(ticket.event.location)"
        
        // Обновляем дату покупки (для чистоты кода используем DateFormatter.inputFormatter)
        if let purchasedDate = DateFormatter.inputFormatter.date(from: ticket.createdAt) {
            let simpleDayFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .none
                return formatter
            }()
             purchaseLabel.text = "Purchased \(simpleDayFormatter.string(from: purchasedDate))"
        } else {
             purchaseLabel.text = "Purchased (Unknown Date)"
        }
        
        // Используем форматирование для даты события
        if let eventDate = DateFormatter.inputFormatter.date(from: ticket.event.date) {
            let day = DateFormatter.eventDayFormatter.string(from: eventDate)
            let weekday = DateFormatter.eventWeekdayFormatter.string(from: eventDate)
            let time = DateFormatter.eventTimeFormatter.string(from: eventDate)
            
            // Вывод: "📅 Вторник, 16 декабря, 19:00"
            let capitalizedWeekday = weekday.prefix(1).uppercased() + weekday.dropFirst()
            dateLabel.text = "📅 \(capitalizedWeekday), \(day), \(time)"
        } else {
            dateLabel.text = "📅 Invalid date"
        }
        
        qrButton.removeTarget(nil, action: nil, for: .allEvents)
        qrButton.addTarget(self, action: #selector(qrTapped), for: .touchUpInside)
        self.qrAction = onQR
    }
    
    private var qrAction: (() -> Void)?
    
    @objc private func qrTapped() {
        qrAction?()
    }
}
