import UIKit

class EventCell: UITableViewCell {
    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    private let organizerLabel = UILabel()
    private let dateTimeLabel = UILabel()
    private let locationLabel = UILabel()
    private let priceTag = UILabel()
    private let ticketsLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
        clipsToBounds = false
        contentView.clipsToBounds = false
        
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 12
        thumbnailImageView.backgroundColor = .systemGray5
        
        titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        
        organizerLabel.font = .systemFont(ofSize: 13)
        organizerLabel.textColor = .secondaryLabel
        
        dateTimeLabel.font = .systemFont(ofSize: 12)
        dateTimeLabel.textColor = .secondaryLabel
        
        locationLabel.font = .systemFont(ofSize: 12)
        locationLabel.textColor = .secondaryLabel
        
        priceTag.font = .systemFont(ofSize: 12, weight: .semibold)
        priceTag.textColor = .white
        priceTag.textAlignment = .center
        priceTag.layer.cornerRadius = 12
        priceTag.clipsToBounds = true
        
        ticketsLabel.font = .systemFont(ofSize: 12)
        ticketsLabel.textColor = .secondaryLabel
        
        let infoStack = UIStackView(arrangedSubviews: [titleLabel, organizerLabel, dateTimeLabel, locationLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 6
        
        let bottomStack = UIStackView(arrangedSubviews: [priceTag, ticketsLabel])
        bottomStack.axis = .horizontal
        bottomStack.spacing = 8
        bottomStack.alignment = .center
        
        let mainStack = UIStackView(arrangedSubviews: [infoStack, bottomStack])
        mainStack.axis = .vertical
        mainStack.spacing = 16
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(mainStack)
        
        [thumbnailImageView, mainStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 96),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 96),
            
            mainStack.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 12),
            mainStack.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
        
        priceTag.heightAnchor.constraint(equalToConstant: 28).isActive = true
        priceTag.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        selectionStyle = .none
        accessoryType = .disclosureIndicator
    }
    
    private func loadClub(clubId: Int) {
        NetworkManager.shared.fetchClubDetail(clubId) { [weak self] club, error in
            DispatchQueue.main.async {
                if let club = club {
                    self?.organizerLabel.text = "by \(club.name)"
                } else {
                    self?.organizerLabel.text = "by KBTU"
                }
            }
        }
    }
    
    func configure(with event: Event) {
        titleLabel.text = event.name
        
        if let clubId = event.club {
            loadClub(clubId: clubId)
        } else {
            organizerLabel.text = "by KBTU"
        }
        
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: event.date) {
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.dateFormat = "d MMMM • HH:mm"
            dateTimeLabel.text = formatter.string(from: date)
        } else {
            dateTimeLabel.text = event.date
        }
        
        locationLabel.text = event.location
        
        if event.isFree {
            priceTag.text = NSLocalizedString("event_free_tag", comment: "")
            priceTag.backgroundColor = .systemGreen
        } else {
            priceTag.text = "\(event.price ?? "0") ₸"
            priceTag.backgroundColor = UIColor(hex: "#CBDCEB")
            priceTag.textColor = UIColor(hex: "#0C2B4E")
        }
        
        ticketsLabel.text = String(format: NSLocalizedString("event_tickets_label", comment: ""), event.ticketsAvailable)
        
        thumbnailImageView.image = nil
        if let urlString = event.mediaUrls?.first, let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.thumbnailImageView.image = image
                    }
                }
            }.resume()
        }
    }
}
