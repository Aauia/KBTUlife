import UIKit

class TicketDetailView: UIView {

    private let ticket: Ticket

    init(ticket: Ticket) {
        self.ticket = ticket
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let qrImageView = UIImageView(image: ticket.qrCodeImage)
        qrImageView.contentMode = .scaleAspectFit

        let qrContainer = UIView()
        qrContainer.backgroundColor = .white
        qrContainer.layer.cornerRadius = 20
        qrContainer.layer.shadowColor = UIColor.black.cgColor
        qrContainer.layer.shadowOpacity = 0.15
        qrContainer.layer.shadowOffset = CGSize(width: 0, height: 6)
        qrContainer.layer.shadowRadius = 12
        qrContainer.clipsToBounds = false
        qrContainer.addSubview(qrImageView)

        let eventLabel = UILabel()
        eventLabel.text = ticket.event.name
        eventLabel.font = .systemFont(ofSize: 26, weight: .bold)
        eventLabel.textAlignment = .center
        eventLabel.numberOfLines = 0
        eventLabel.textColor = .label

        let dateStack = createInfoRow(
            iconName: "calendar",
            text: DateFormatter.fullEventDateTime(from: ticket.event.date)
        )

        let locationStack = createInfoRow(
            iconName: "mappin.and.ellipse",
            text: ticket.event.location
        )

        let mainStack = UIStackView(arrangedSubviews: [
            eventLabel,
            qrContainer,
            dateStack,
            locationStack
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 28
        mainStack.alignment = .center

        addSubview(mainStack)

        qrImageView.translatesAutoresizingMaskIntoConstraints = false
        qrContainer.translatesAutoresizingMaskIntoConstraints = false
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            qrContainer.widthAnchor.constraint(equalToConstant: 280),
            qrContainer.heightAnchor.constraint(equalToConstant: 280),

            qrImageView.centerXAnchor.constraint(equalTo: qrContainer.centerXAnchor),
            qrImageView.centerYAnchor.constraint(equalTo: qrContainer.centerYAnchor),
            qrImageView.widthAnchor.constraint(equalToConstant: 240),
            qrImageView.heightAnchor.constraint(equalToConstant: 240),

            mainStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            mainStack.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }

    private func createInfoRow(iconName: String, text: String) -> UIStackView {
        let icon = UIImageView(image: UIImage(systemName: iconName))
        icon.tintColor = iconName == "calendar" ? .systemBlue : .systemOrange
        icon.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        icon.contentMode = .scaleAspectFit

        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 17)
        label.textColor = .secondaryLabel
        label.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [icon, label])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center

        icon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 24).isActive = true

        return stack
    }
}
