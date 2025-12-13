import UIKit

class PaymentViewController: UIViewController {
    private let ticket: Ticket
    private let kaspiNumberLabel = UILabel()
    private let instructionLabel = UILabel()
    private let paidButton = UIButton(type: .system)
    
    init(ticket: Ticket) {
        self.ticket = ticket
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Payment"
        view.backgroundColor = .systemBackground
        
        kaspiNumberLabel.text = "Kaspi: +7 777 123 45 67\nAmount: \(ticket.event.price) KZT"
        kaspiNumberLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        
        instructionLabel.text = "В комментарии укажите вашу почту: \(ticket.userEmail ?? "")\nПосле перевода нажмите 'Я оплатил'"
        instructionLabel.numberOfLines = 0
        instructionLabel.textColor = .systemGray
        
        paidButton.setTitle("Я оплатил", for: .normal)
        paidButton.backgroundColor = .systemOrange
        paidButton.layer.cornerRadius = 10
        paidButton.addTarget(self, action: #selector(markPaid), for: .touchUpInside)
        
        // надо subviews и constraints..
    }
    
    @objc private func markPaid() {
        NetworkManager.shared.markAsPending(ticketId: ticket.id) { [weak self] message, error in
            if message != nil {
                let alert = UIAlertController(title: "Готово!", message: "Ожидаем проверки админом", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
                // Вернись к My Tickets
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
