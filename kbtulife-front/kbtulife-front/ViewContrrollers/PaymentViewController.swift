import UIKit

class PaymentViewController: UIViewController {
    
    private let ticket: Ticket
    
    private let cardView = UIView()
    private let logoImageView = UIImageView()
    private let amountLabel = UILabel()
    private let phoneContainer = UIView()
    private let phoneNumberLabel = UILabel()
    private let copyButton = UIButton(type: .system)
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
        setupUI()
        setupConstraints()
        fillData()
    }
    
    private func setupUI() {
        title = NSLocalizedString("payment_title", comment: "")
        view.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1.0)
        
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 24
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.05
        cardView.layer.shadowOffset = CGSize(width: 0, height: 10)
        cardView.layer.shadowRadius = 20
        
        amountLabel.font = .systemFont(ofSize: 34, weight: .black)
        amountLabel.textColor = UIColor(hex: "#0C2B4E")
        amountLabel.textAlignment = .center
        
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        instructionLabel.font = .systemFont(ofSize: 15)
        instructionLabel.textColor = .secondaryLabel
        
        phoneContainer.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        phoneContainer.layer.cornerRadius = 16
        
        phoneNumberLabel.font = .systemFont(ofSize: 18, weight: .bold)
        phoneNumberLabel.textColor = .black
        
        copyButton.setTitle(NSLocalizedString("copy_button", comment: ""), for: .normal)
        copyButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        copyButton.addTarget(self, action: #selector(copyNumber), for: .touchUpInside)
        
        paidButton.backgroundColor = UIColor(hex: "#122E68")
        paidButton.setTitle(NSLocalizedString("paid_button", comment: ""), for: .normal)
        paidButton.setTitleColor(.white, for: .normal)
        paidButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        paidButton.layer.cornerRadius = 16
        paidButton.addTarget(self, action: #selector(markPaid), for: .touchUpInside)
        
        logoImageView.image = UIImage(systemName: "creditcard.fill")
        logoImageView.tintColor = UIColor(hex: "#FF6900")
        logoImageView.contentMode = .scaleAspectFit
    }
    
    private func setupConstraints() {
        [cardView, amountLabel, instructionLabel, phoneContainer, paidButton, logoImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        phoneContainer.addSubview(phoneNumberLabel)
        phoneContainer.addSubview(copyButton)
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardView.bottomAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 30),
            
            logoImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 30),
            logoImageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
            
            amountLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            amountLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            
            phoneContainer.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 24),
            phoneContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            phoneContainer.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            phoneContainer.heightAnchor.constraint(equalToConstant: 60),
            
            phoneNumberLabel.leadingAnchor.constraint(equalTo: phoneContainer.leadingAnchor, constant: 16),
            phoneNumberLabel.centerYAnchor.constraint(equalTo: phoneContainer.centerYAnchor),
            
            copyButton.trailingAnchor.constraint(equalTo: phoneContainer.trailingAnchor, constant: -16),
            copyButton.centerYAnchor.constraint(equalTo: phoneContainer.centerYAnchor),
            
            instructionLabel.topAnchor.constraint(equalTo: phoneContainer.bottomAnchor, constant: 24),
            instructionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            
            paidButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            paidButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            paidButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            paidButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func fillData() {
        let cleanPrice = ticket.event.price?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0"
        amountLabel.text = "\(cleanPrice.isEmpty ? "0" : cleanPrice) ₸"
        
        phoneNumberLabel.text = "+7 777 123 45 67"
        
        let email = ticket.userEmail ?? "ваш email"
        let instructionText = String(format: NSLocalizedString("payment_instruction", comment: ""), email)
        instructionLabel.text = instructionText
        
        let fullText = instructionLabel.text ?? ""
        let range = (fullText as NSString).range(of: email)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .bold), range: range)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: range)
        instructionLabel.attributedText = attributedString
    }
    
    @objc private func copyNumber() {
        UIPasteboard.general.string = "+77771234567"
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        copyButton.setTitle(NSLocalizedString("copied", comment: ""), for: .normal)
        copyButton.setTitleColor(.systemGreen, for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.copyButton.setTitle(NSLocalizedString("copy_button", comment: ""), for: .normal)
            self.copyButton.setTitleColor(self.view.tintColor, for: .normal)
        }
    }
    
    @objc private func markPaid() {
        paidButton.isEnabled = false
        paidButton.setTitle(NSLocalizedString("processing", comment: ""), for: .normal)
        
        NetworkManager.shared.markAsPending(ticketId: ticket.id) { [weak self] message, error in
            DispatchQueue.main.async {
                self?.paidButton.isEnabled = true
                self?.paidButton.setTitle(NSLocalizedString("paid_button", comment: ""), for: .normal)
                
                if message != nil {
                    let alert = UIAlertController(
                        title: NSLocalizedString("payment_success_title", comment: ""),
                        message: NSLocalizedString("payment_success_message", comment: ""),
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: NSLocalizedString("payment_success_ok", comment: ""), style: .default) { _ in
                        NotificationCenter.default.post(name: NSNotification.Name("TicketsUpdated"), object: nil)
                        self?.navigationController?.popToRootViewController(animated: true)
                    })
                    self?.present(alert, animated: true)
                } else {
                    let errorMessage = error?.localizedDescription ?? NSLocalizedString("payment_error_message", comment: "")
                    let alert = UIAlertController(
                        title: NSLocalizedString("payment_error_title", comment: ""),
                        message: errorMessage,
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}
