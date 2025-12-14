// Views/Cells/MemberCell.swift
import UIKit

class MemberCell: UITableViewCell {
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let textStack = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(textStack)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            
            textStack.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with member: ClubMember) {
        nameLabel.text = "\(member.firstName) \(member.lastName)"
        emailLabel.text = member.outlook
        
        // Load avatar if URL is available
        if let avatarUrl = member.avatarUrl, let url = URL(string: avatarUrl) {
            loadImage(from: url)
        } else {
            // Set default initials avatar
            avatarImageView.image = nil
            avatarImageView.backgroundColor = .systemBlue
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.avatarImageView.image = image
            }
        }.resume()
    }
}
