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
        title = "Оплата"
        view.backgroundColor = .systemBackground

        kaspiNumberLabel.textAlignment = .center
        kaspiNumberLabel.numberOfLines = 0
        kaspiNumberLabel.font = .systemFont(ofSize: 20, weight: .semibold)

        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        instructionLabel.font = .systemFont(ofSize: 16)
        instructionLabel.textColor = .secondaryLabel

        paidButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        paidButton.backgroundColor = UIColor(hex: "#FF6900")
        paidButton.setTitleColor(.white, for: .normal)
        paidButton.layer.cornerRadius = 12

        let stack = UIStackView(arrangedSubviews: [kaspiNumberLabel, instructionLabel, paidButton])
        stack.axis = .vertical
        stack.spacing = 30
        stack.alignment = .center

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            paidButton.heightAnchor.constraint(equalToConstant: 56)
        ])

        // Заполняем данные
        let price = ticket.event.price
        kaspiNumberLabel.text = "Kaspi Gold: +7 777 123 45 67\nСумма: \(price) ₸"
        instructionLabel.text = "В комментарии к переводу укажите:\n\(ticket.userEmail ?? "ваш email")"
    }
    
    @objc private func markPaid() {
        paidButton.isEnabled = false
        paidButton.setTitle("Обработка...", for: .normal)

        NetworkManager.shared.markAsPending(ticketId: ticket.id) { [weak self] message, error in
            DispatchQueue.main.async {
                self?.paidButton.isEnabled = true
                self?.paidButton.setTitle("Я оплатил", for: .normal)

                if message != nil {
                    // Успешно отметили оплату
                    let alert = UIAlertController(title: "Спасибо!", message: "Ваш платёж принят. Билет появится в разделе «Мои билеты» после подтверждения.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        // уведомляем приложение, что билеты изменились
                        NotificationCenter.default.post(name: NSNotification.Name("TicketsUpdated"), object: nil)
                        
                        // Возвращаемся на главный таб (или на события)
                        self?.navigationController?.popToRootViewController(animated: true)
                    })
                    self?.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "Ошибка", message: error?.localizedDescription ?? "Не удалось отметить оплату", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}
