import UIKit
import SDWebImage

class EventDetailViewController: UIViewController {

    private let event: Event

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let headerImageView = UIImageView()
    private let categoryTag = UILabel()
    private let titleLabel = UILabel()
    private let organizerLabel = UILabel()

    private let dateStackView = UIStackView()
    private let locationStackView = UIStackView()

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

        setupViews()
        setupLayout()
        configure(with: event)

        if let clubId = event.club {
            loadClub(clubId: clubId)
        } else {
            organizerLabel.text = NSLocalizedString("by_kbtu", comment: "")
        }
    }

    private func setupViews() {
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true

        categoryTag.font = .systemFont(ofSize: 13, weight: .semibold)
        categoryTag.textColor = UIColor(hex: "#0C2B4E")
        categoryTag.backgroundColor = UIColor(hex: "#CBDCEB")
        categoryTag.layer.cornerRadius = 16
        categoryTag.clipsToBounds = true
        categoryTag.textAlignment = .center

        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.numberOfLines = 0

        organizerLabel.font = .systemFont(ofSize: 16)
        organizerLabel.textColor = .secondaryLabel

        let dateIcon = UIImageView(image: UIImage(systemName: "calendar"))
        dateIcon.tintColor = .secondaryLabel

        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 16, weight: .medium)
        dateLabel.textColor = .label

        dateStackView.axis = .horizontal
        dateStackView.spacing = 10
        dateStackView.alignment = .center
        dateStackView.addArrangedSubview(dateIcon)
        dateStackView.addArrangedSubview(dateLabel)

        let locationIcon = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        locationIcon.tintColor = .secondaryLabel

        let locationLabel = UILabel()
        locationLabel.font = .systemFont(ofSize: 16)
        locationLabel.textColor = .secondaryLabel
        locationLabel.numberOfLines = 0

        locationStackView.axis = .horizontal
        locationStackView.spacing = 10
        locationStackView.alignment = .top
        locationStackView.addArrangedSubview(locationIcon)
        locationStackView.addArrangedSubview(locationLabel)

        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .label

        priceButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        priceButton.backgroundColor = UIColor(hex: "#0C2B4E")
        priceButton.setTitleColor(.white, for: .normal)
        priceButton.layer.cornerRadius = 18
        priceButton.addTarget(self, action: #selector(buyTicketTapped), for: .touchUpInside)

        view.addSubview(scrollView)
        view.addSubview(priceButton)
        scrollView.addSubview(contentView)

        [headerImageView, categoryTag, titleLabel, organizerLabel,
         dateStackView, locationStackView, descriptionLabel].forEach {
            contentView.addSubview($0)
        }

        dateIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        dateIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        locationIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        locationIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    private func setupLayout() {
        [scrollView, contentView, headerImageView, categoryTag, titleLabel,
         organizerLabel, dateStackView, locationStackView, descriptionLabel, priceButton].forEach {
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
            headerImageView.heightAnchor.constraint(equalToConstant: 320),

            categoryTag.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: -16),
            categoryTag.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            categoryTag.heightAnchor.constraint(equalToConstant: 32),

            titleLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            organizerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            organizerLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            dateStackView.topAnchor.constraint(equalTo: organizerLabel.bottomAnchor, constant: 16),
            dateStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateStackView.trailingAnchor.constraint(lessThanOrEqualTo: titleLabel.trailingAnchor),

            locationStackView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 12),
            locationStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            locationStackView.trailingAnchor.constraint(lessThanOrEqualTo: titleLabel.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: locationStackView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),

            priceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            priceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            priceButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            priceButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    private func configure(with event: Event) {
        title = event.name
        titleLabel.text = event.name
        categoryTag.text = " \(event.category.capitalized) "
        descriptionLabel.text = event.description

        if let urlString = event.mediaUrls?.first, let url = URL(string: urlString) {
            headerImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        } else {
            headerImageView.image = UIImage(systemName: "photo")
        }

        let formattedDate = formatEventDate(event.date)
        (dateStackView.arrangedSubviews[1] as? UILabel)?.text = formattedDate

        let locationLabel = (locationStackView.arrangedSubviews[1] as? UILabel)
        if !event.location.isEmpty {
            locationLabel?.text = event.location
            locationStackView.isHidden = false
        } else {
            locationStackView.isHidden = true
        }

        let buttonTitle: String
        if event.ticketsAvailable <= 0 {
            buttonTitle = NSLocalizedString("sold_out", comment: "")
        } else if event.isFree {
            buttonTitle = NSLocalizedString("get_ticket_free", comment: "")
        } else {
            let price = event.price ?? "0"
            buttonTitle = String(format: NSLocalizedString("get_ticket_price", comment: ""), price)
        }

        priceButton.setTitle(buttonTitle, for: .normal)
        priceButton.isEnabled = event.ticketsAvailable > 0
    }

    private func formatEventDate(_ dateString: String) -> String {
        guard let date = DateFormatter.inputFormatter.date(from: dateString) else {
            return NSLocalizedString("unknown_date", comment: "")
        }
        
        let weekday = date.formatted(.dateTime.weekday(.wide)).capitalized
        let dayMonth = date.formatted(.dateTime.day().month())
        let time = date.formatted(.dateTime.hour().minute())
        
        return "\(weekday), \(dayMonth), \(time)"
    }

    private func loadClub(clubId: Int) {
        NetworkManager.shared.fetchClubDetail(clubId) { [weak self] club, _ in
            DispatchQueue.main.async {
                if let club = club {
                    self?.organizerLabel.text = NSLocalizedString("by", comment: "") + " \(club.name)"
                } else {
                    self?.organizerLabel.text = NSLocalizedString("by_kbtu", comment: "")
                }
            }
        }
    }

    @objc private func buyTicketTapped() {
        guard event.ticketsAvailable > 0 else { return }

        let isFreeEvent = event.isFree || (event.price ?? "").trimmingCharacters(in: .whitespaces).isEmpty

        NetworkManager.shared.buyTicket(eventId: event.id) { [weak self] ticket, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showErrorAlert(message: error.localizedDescription)
                    return
                }

                guard let ticket = ticket else {
                    self?.showErrorAlert(message: NSLocalizedString("ticket_error", comment: ""))
                    return
                }

                if isFreeEvent {
                    let message = String(format: NSLocalizedString("ticket_received_message", comment: ""), self?.event.name ?? "")
                    let alert = UIAlertController(
                        title: NSLocalizedString("ticket_received_title", comment: ""),
                        message: message,
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: NSLocalizedString("ticket_received_ok", comment: ""), style: .default) { _ in
                        NotificationCenter.default.post(name: NSNotification.Name("TicketsUpdated"), object: nil)
                    })
                    self?.present(alert, animated: true)
                } else {
                    let paymentVC = PaymentViewController(ticket: ticket)
                    self?.navigationController?.pushViewController(paymentVC, animated: true)
                }
            }
        }
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("error", comment: ""),
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
