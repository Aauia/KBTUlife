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
        
        
        buyButton.setTitle("Купить билет", for: .normal)
        buyButton.backgroundColor = .systemBlue
        buyButton.setTitleColor(.white, for: .normal)
        buyButton.layer.cornerRadius = 12
        buyButton.addTarget(self, action: #selector(buyTicketTapped), for: .touchUpInside)
        
    }
    
    private func configureBuyButton() {
        if event.ticketsAvailable <= 0 {
            buyButton.setTitle("Билеты закончились", for: .normal)
            buyButton.isEnabled = false
            buyButton.backgroundColor = .systemGray
        } else {
            buyButton.setTitle("Купить билет (\(event.ticketsAvailable) осталось)", for: .normal)
            buyButton.isEnabled = true
        }
    }
    
    @objc private func buyTicketTapped() {
        guard event.ticketsAvailable > 0 else {
            showAlert(title: "Ошибка", message: "Билеты закончились")
            return
        }
        
        NetworkManager.shared.buyTicket(eventId: event.id) { [weak self] ticket, error in
            DispatchQueue.main.async {
                if let ticket = ticket {
                    // Успешно куплен — переходим на экран оплаты Kaspi
                    let paymentVC = PaymentViewController(ticket: ticket)
                    self?.navigationController?.pushViewController(paymentVC, animated: true)
                } else {
                    let errorMessage = error?.localizedDescription ?? "Неизвестная ошибка при покупке"
                    self?.showAlert(title: "Ошибка покупки", message: errorMessage)
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
