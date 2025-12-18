import UIKit

final class MembershipCell: UITableViewCell {

    static let reuseID = "MembershipCell"

    private let nameLabel = UILabel()
    private let outlookLabel = UILabel()
    private let acceptButton = UIButton(type: .system)
    private let rejectButton = UIButton(type: .system)

    var onAccept: (() -> Void)?
    var onReject: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        acceptButton.setTitle("Accept", for: .normal)
        rejectButton.setTitle("Reject", for: .normal)

        acceptButton.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)
        rejectButton.addTarget(self, action: #selector(rejectTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            nameLabel, outlookLabel, acceptButton, rejectButton
        ])
        stack.axis = .vertical
        stack.spacing = 8

        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    func configure(with membership: Membership) {
        nameLabel.text = "\(membership.userName) \(membership.userSurname)"
        outlookLabel.text = membership.userOutlook
    }

    @objc private func acceptTapped() {
        onAccept?()
    }

    @objc private func rejectTapped() {
        onReject?()
    }
}
