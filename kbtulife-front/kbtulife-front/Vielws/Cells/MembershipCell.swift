import UIKit

final class MembershipCell: UITableViewCell {
    static let reuseID = "MembershipCell"

    private let nameLabel = UILabel()
    private let outlookLabel = UILabel()
    private let acceptButton = UIButton(type: .system)
    private let rejectButton = UIButton(type: .system)
    private let containerStack = UIStackView()

    var onAccept: ((Int) -> Void)?
    var onReject: ((Int) -> Void)?
    
    private var membershipId: Int?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onAccept = nil
        onReject = nil
        membershipId = nil
    }

    private func setupUI() {
        // ✅ Настраиваем labels
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.numberOfLines = 0
        
        outlookLabel.font = .systemFont(ofSize: 14)
        outlookLabel.textColor = .gray
        outlookLabel.numberOfLines = 0
        
        // ✅ Настраиваем кнопки с фиксированной высотой
        configureButton(acceptButton, title: "Accept", backgroundColor: .systemGreen)
        configureButton(rejectButton, title: "Reject", backgroundColor: .systemRed)
        
        acceptButton.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)
        rejectButton.addTarget(self, action: #selector(rejectTapped), for: .touchUpInside)
        
        // ✅ Создаём stack для кнопок
        let buttonStack = UIStackView(arrangedSubviews: [acceptButton, rejectButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually
        
        // ✅ Главный vertical stack
        containerStack.axis = .vertical
        containerStack.spacing = 8
        containerStack.addArrangedSubview(nameLabel)
        containerStack.addArrangedSubview(outlookLabel)
        containerStack.addArrangedSubview(buttonStack)
        
        contentView.addSubview(containerStack)
        containerStack.translatesAutoresizingMaskIntoConstraints = false

        // ✅ КРИТИЧНО: используем lessThanOrEqualTo вместо equalTo
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            // ✅ Фиксированная высота для кнопок
            acceptButton.heightAnchor.constraint(equalToConstant: 44),
            rejectButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        contentView.isUserInteractionEnabled = true
    }
    
    private func configureButton(_ button: UIButton, title: String, backgroundColor: UIColor) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 8
        button.isUserInteractionEnabled = true
    }

    func configure(with membership: Membership) {
        self.membershipId = membership.id
        nameLabel.text = "\(membership.userName) \(membership.userSurname)"
        outlookLabel.text = membership.userOutlook
        
        print("📝 Cell configured with ID: \(membership.id), name: \(membership.userName)")
    }

    @objc private func acceptTapped() {
        print("🟢 ACCEPT BUTTON TAPPED!")
        guard let id = membershipId else {
            print("⚠️ No membership ID!")
            return
        }
        print("🟢 Calling onAccept closure for ID: \(id)")
        onAccept?(id)
    }

    @objc private func rejectTapped() {
        print("🔴 REJECT BUTTON TAPPED!")
        guard let id = membershipId else {
            print("⚠️ No membership ID!")
            return
        }
        print("🔴 Calling onReject closure for ID: \(id)")
        onReject?(id)
    }
}
