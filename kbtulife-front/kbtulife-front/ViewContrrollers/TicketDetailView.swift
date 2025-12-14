import UIKit

class TicketDetailView: UIView {
    
    init(ticket: Ticket) {
        super.init(frame: .zero)
        backgroundColor = .white
        setupUI(with: ticket)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI(with ticket: Ticket) {
        let qrView = UIImageView(image: ticket.qrCodeImage)
        qrView.contentMode = .scaleAspectFit
        qrView.backgroundColor = .white
        qrView.layer.cornerRadius = 12
        qrView.clipsToBounds = true
        qrView.layer.borderWidth = 1
        qrView.layer.borderColor = UIColor.lightGray.cgColor
        
        let qrContainer = UIView()
        qrContainer.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.88, alpha: 1) // #F3F3E0
        qrContainer.layer.cornerRadius = 16
        qrContainer.addSubview(qrView)
        
        let titleLabel = UILabel()
        titleLabel.text = "Ticket Details"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.05, green: 0.17, blue: 0.31, alpha: 1)
        
        let eventLabel = UILabel()
        eventLabel.text = ticket.event.name
        eventLabel.font = .systemFont(ofSize: 17)
        eventLabel.textAlignment = .center
        
        let dateLabel = UILabel()
        dateLabel.text = "Date: \(ticket.event.date)"
        dateLabel.font = .systemFont(ofSize: 15)
        
        let locationLabel = UILabel()
        locationLabel.text = "Location: \(ticket.event.location)"
        locationLabel.font = .systemFont(ofSize: 15)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, qrContainer, eventLabel, dateLabel, locationLabel])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        qrView.translatesAutoresizingMaskIntoConstraints = false
        qrContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            qrView.widthAnchor.constraint(equalToConstant: 220),
            qrView.heightAnchor.constraint(equalToConstant: 220),
            qrView.centerXAnchor.constraint(equalTo: qrContainer.centerXAnchor),
            qrView.centerYAnchor.constraint(equalTo: qrContainer.centerYAnchor),
            qrContainer.heightAnchor.constraint(equalToConstant: 280),
            qrContainer.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.9),
            
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20)
        ])
    }
}
