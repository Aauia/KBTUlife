class EventCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let priceLabel = UILabel()
    private let buyButton = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.font = .boldSystemFont(ofSize: 18)
        dateLabel.font = .systemFont(ofSize: 14)
        priceLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        buyButton.setTitle("Buy Ticket", for: .normal)
        buyButton.backgroundColor = .systemBlue
        buyButton.layer.cornerRadius = 8
        buyButton.addTarget(self, action: #selector(buyTapped), for: .touchUpInside)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(buyButton)
        
        // Constraints (упрощённо, подгони под Figma)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        // ... аналогично для остальных
    }
    
    func configure(with event: Event) {
        titleLabel.text = event.name
        dateLabel.text = event.date
        priceLabel.text = event.isFree ? "Free" : "$\(event.price)"
    }
    
    @objc private func buyTapped() {
        // Вызов buyTicket из superview или delegate
    }
}
