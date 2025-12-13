import UIKit

class EventDetailViewController: UIViewController {
    private let event: Event
    private let buyButton = UIButton(type: .system)
    
    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = event.name
        view.backgroundColor = .systemBackground
        
        // Добавь UILabel для description, UIImageView для mediaUrls[0]
        let descLabel = UILabel()
        descLabel.text = event.description
        descLabel.numberOfLines = 0
        view.addSubview(descLabel)
        // Constraints...
        
        buyButton.setTitle("Buy Ticket (\(event.ticketsAvailable) left)", for: .normal)
        buyButton.backgroundColor = .systemGreen
        buyButton.layer.cornerRadius = 10
        buyButton.addTarget(self, action: #selector(buyTicket), for: .touchUpInside)
        view.addSubview(buyButton)
        // Constraints: buyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
    }
    
    @objc private func buyTicket() {
        NetworkManager.shared.buyTicket(eventId: event.id) { [weak self] ticket, error in
            if let ticket = ticket {
                let paymentVC = PaymentViewController(ticket: ticket)
                self?.navigationController?.pushViewController(paymentVC, animated: true)
            } else {
                // Alert error
            }
        }
    }
}
