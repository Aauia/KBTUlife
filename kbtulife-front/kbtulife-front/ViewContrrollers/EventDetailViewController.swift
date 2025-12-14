import UIKit

class EventDetailViewController: UIViewController {
    private let event: Event
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerImageView = UIImageView()
    private let titleLabel = UILabel()
    private let organizerLabel = UILabel()
    private let categoryTag = UILabel()
    private let descriptionLabel = UILabel()
    private let priceButton = UIButton(type: .system)
    
    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        configure(with: event)
        
        if let clubId = event.club {
            loadClub(clubId: clubId)
        } else {
            organizerLabel.text = "by KBTU"
            
        }
        
    }
    
    private func setupUI() {
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.numberOfLines = 0
        
        organizerLabel.font = .systemFont(ofSize: 16)
        organizerLabel.textColor = .secondaryLabel
        
        categoryTag.font = .systemFont(ofSize: 13)
        categoryTag.textColor = UIColor(hex: "#0C2B4E")
        categoryTag.backgroundColor = UIColor(hex: "#CBDCEB")
        categoryTag.layer.cornerRadius = 12
        categoryTag.clipsToBounds = true
        categoryTag.textAlignment = .center
        
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .label
        
        priceButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        priceButton.backgroundColor = UIColor(hex: "#0C2B4E")
        priceButton.setTitleColor(.white, for: .normal)
        priceButton.layer.cornerRadius = 16
        priceButton.addTarget(self, action: #selector(buyTicketTapped), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(organizerLabel)
        contentView.addSubview(categoryTag)
        contentView.addSubview(descriptionLabel)
        
        view.addSubview(priceButton)
        
        [scrollView, contentView, headerImageView, titleLabel, organizerLabel, categoryTag, descriptionLabel, priceButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: priceButton.topAnchor, constant: -20),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: 300),
            
            categoryTag.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: -20),
            categoryTag.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            categoryTag.heightAnchor.constraint(equalToConstant: 32),
            categoryTag.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            organizerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            organizerLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: organizerLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20),
            
            priceButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            priceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            priceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            priceButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func configure(with event: Event) {
        title = event.name
        titleLabel.text = event.name
        categoryTag.text = " \(event.category) "
        descriptionLabel.text = event.description
        
        if let urlString = event.mediaUrls?.first, let url = URL(string: urlString) {
            headerImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        }
        
        let priceText = event.isFree ? "FREE" : "\(event.price ?? "0") ₸"
        priceButton.setTitle(event.ticketsAvailable > 0 ? "Get Ticket • \(priceText)" : "Sold Out", for: .normal)
        priceButton.isEnabled = event.ticketsAvailable > 0
    }
    
    private func loadClub(clubId: Int) {
        NetworkManager.shared.fetchClubDetail(clubId) { [weak self] club, error in
            DispatchQueue.main.async {
                if let club = club {
                    self?.organizerLabel.text = "by \(club.name)"
                    print("Club loaded: \(club.name)")
                } else {
                    self?.organizerLabel.text = "by KBTU Club"
                    if let error = error {
                        print("Failed to load club \(clubId): \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    @objc private func buyTicketTapped() {
        NetworkManager.shared.buyTicket(eventId: event.id) { [weak self] ticket, error in
            DispatchQueue.main.async {
                if let ticket = ticket {
                    let paymentVC = PaymentViewController(ticket: ticket)
                    self?.navigationController?.pushViewController(paymentVC, animated: true)
                } else {
                    // Alert
                }
            }
        }
    }
}
