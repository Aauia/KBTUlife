import UIKit

class TicketDetailView: UIView {
    
    private let ticket: Ticket
    
    init(ticket: Ticket) {
        self.ticket = ticket
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        
        // MARK: QR Code setup
        let qrView = UIImageView(image: ticket.qrCodeImage)
        qrView.contentMode = .scaleAspectFit
        qrView.backgroundColor = .white
        qrView.layer.cornerRadius = 16
        qrView.clipsToBounds = true
        qrView.layer.borderWidth = 1.5
        qrView.layer.borderColor = UIColor.systemGray4.cgColor
        
        let qrContainer = UIView()
        qrContainer.backgroundColor = UIColor.systemGroupedBackground
        qrContainer.layer.cornerRadius = 20
        qrContainer.layer.shadowColor = UIColor.black.cgColor
        qrContainer.layer.shadowOpacity = 0.1
        qrContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        qrContainer.layer.shadowRadius = 8
        qrContainer.addSubview(qrView)
        
        // MARK: Title and Event Name
        let titleLabel = UILabel()
        titleLabel.text = "Ticket Details"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        
        let eventLabel = UILabel()
        eventLabel.text = ticket.event.name
        eventLabel.font = .systemFont(ofSize: 28, weight: .bold)
        eventLabel.textAlignment = .center
        eventLabel.numberOfLines = 0
        eventLabel.textColor = .label
        
        // MARK: Date Stack (Formatted Date)
        let dateStack = UIStackView()
        dateStack.axis = .horizontal
        dateStack.spacing = 10
        dateStack.alignment = .center
        
        let calendarIcon = UIImageView(image: UIImage(systemName: "calendar"))
        calendarIcon.tintColor = .systemBlue
        calendarIcon.preferredSymbolConfiguration = .init(pointSize: 20, weight: .medium)
        
        let dateString = DateFormatter.fullEventDateTime(from: ticket.event.date)
        
        let dateLabel = UILabel()
        dateLabel.text = dateString
        dateLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        dateLabel.textColor = .label
        
        dateStack.addArrangedSubview(calendarIcon)
        dateStack.addArrangedSubview(dateLabel)
        
        // MARK: Location Stack
        let locationStack = UIStackView()
        locationStack.axis = .horizontal
        locationStack.spacing = 10
        locationStack.alignment = .center
        
        let locationIcon = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        locationIcon.tintColor = .systemOrange
        locationIcon.preferredSymbolConfiguration = .init(pointSize: 20, weight: .medium)
        
        let locationLabel = UILabel()
        locationLabel.text = ticket.event.location
        locationLabel.font = .systemFont(ofSize: 17)
        locationLabel.textColor = .secondaryLabel
        
        locationStack.addArrangedSubview(locationIcon)
        locationStack.addArrangedSubview(locationLabel)
        
        // MARK: Button
        let viewQRButton = UIButton(type: .system)
        viewQRButton.setTitle("View QR", for: .normal)
        viewQRButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        viewQRButton.setTitleColor(.white, for: .normal)
        viewQRButton.backgroundColor = .systemBlue
        viewQRButton.layer.cornerRadius = 14
        viewQRButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        // MARK: Main Stack
        let spacer = UIView() // Заполнитель для выравнивания кнопки внизу
        
        let mainStack = UIStackView(arrangedSubviews: [
            // titleLabel, // Удалил, так как контроллер уже имеет заголовок
            eventLabel,
            qrContainer,
            dateStack,
            locationStack,
            spacer, // Растягивающийся элемент
            viewQRButton
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.alignment = .center
        
        addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        qrView.translatesAutoresizingMaskIntoConstraints = false
        qrContainer.translatesAutoresizingMaskIntoConstraints = false
        viewQRButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // QR View
            qrView.widthAnchor.constraint(equalToConstant: 240),
            qrView.heightAnchor.constraint(equalToConstant: 240),
            qrView.centerXAnchor.constraint(equalTo: qrContainer.centerXAnchor),
            qrView.centerYAnchor.constraint(equalTo: qrContainer.centerYAnchor),
            
            // QR Container
            qrContainer.heightAnchor.constraint(equalToConstant: 260),
            qrContainer.widthAnchor.constraint(equalTo: mainStack.widthAnchor, multiplier: 0.9),
            
            // Main Stack (для модального окна 320x520)
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 48), // Учитываем место для кнопки закрытия
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            
            // Button Width (чтобы кнопка была по ширине стека)
            viewQRButton.widthAnchor.constraint(equalTo: mainStack.widthAnchor)
        ])
        
        // Принудительное выравнивание центральных стеков
        dateStack.widthAnchor.constraint(equalTo: mainStack.widthAnchor).isActive = true
        locationStack.widthAnchor.constraint(equalTo: mainStack.widthAnchor).isActive = true
    }
}
