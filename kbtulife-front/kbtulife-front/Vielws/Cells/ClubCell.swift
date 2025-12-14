// Views/Cells/ClubCell.swift
import UIKit

class ClubCell: UITableViewCell {
    
    private let cardView = UIView()
        private let logoContainer = UIView()
        private let logoLabel = UILabel()
        private let nameLabel = UILabel()
        private let descriptionLabel = UILabel()
        private let membersIcon = UIImageView()
        private let membersLabel = UILabel()
        private let eventsIcon = UIImageView()
        private let eventsLabel = UILabel()
        private let instagramButton = UIButton(type: .system)
        private let applyButton = UIButton(type: .system)
        
        private var club: Club?
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupUI() {
            backgroundColor = .clear
            selectionStyle = .none
            
            // Card View
            cardView.backgroundColor = .white
            cardView.layer.cornerRadius = 16
            cardView.layer.shadowColor = UIColor.black.cgColor
            cardView.layer.shadowOpacity = 0.05
            cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cardView.layer.shadowRadius = 8
            
            contentView.addSubview(cardView)
            cardView.translatesAutoresizingMaskIntoConstraints = false
            
            // Logo Container (Gradient)
            logoContainer.layer.cornerRadius = 16
            logoContainer.layer.masksToBounds = true
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                UIColor(red: 0.05, green: 0.17, blue: 0.31, alpha: 1.0).cgColor, // #0C2B4E
                UIColor(red: 0.38, green: 0.55, blue: 0.76, alpha: 1.0).cgColor  // #608BC1
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
            logoContainer.layer.insertSublayer(gradientLayer, at: 0)
            
            // Logo Label (Emoji)
            logoLabel.font = .systemFont(ofSize: 32)
            logoLabel.textAlignment = .center
            logoContainer.addSubview(logoLabel)
            logoLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // Name Label
            nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
            nameLabel.textColor = .label
            nameLabel.numberOfLines = 1
            
            // Description Label
            descriptionLabel.font = .systemFont(ofSize: 14)
            descriptionLabel.textColor = .systemGray
            descriptionLabel.numberOfLines = 2
            
            // Stats Icons
            membersIcon.image = UIImage(systemName: "person.2.fill")
            membersIcon.tintColor = .systemGray2
            membersIcon.contentMode = .scaleAspectFit
            
            eventsIcon.image = UIImage(systemName: "calendar")
            eventsIcon.tintColor = .systemGray2
            eventsIcon.contentMode = .scaleAspectFit
            
            // Stats Labels
            membersLabel.font = .systemFont(ofSize: 12)
            membersLabel.textColor = .systemGray
            
            eventsLabel.font = .systemFont(ofSize: 12)
            eventsLabel.textColor = .systemGray
            
            // Stats Stack
            let membersStack = createStatStack(icon: membersIcon, label: membersLabel)
            let eventsStack = createStatStack(icon: eventsIcon, label: eventsLabel)
            
            let statsStack = UIStackView(arrangedSubviews: [membersStack, eventsStack])
            statsStack.axis = .horizontal
            statsStack.spacing = 12
            
            // Text Stack
            let textStack = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel, statsStack])
            textStack.axis = .vertical
            textStack.spacing = 4
            textStack.setCustomSpacing(8, after: descriptionLabel)
            
            // Header Stack
            let headerStack = UIStackView(arrangedSubviews: [logoContainer, textStack])
            headerStack.axis = .horizontal
            headerStack.spacing = 16
            headerStack.alignment = .top
            
            // Buttons
            configureInstagramButton()
            configureApplyButton()
            
            let buttonStack = UIStackView(arrangedSubviews: [instagramButton, applyButton])
            buttonStack.axis = .horizontal
            buttonStack.spacing = 8
            buttonStack.distribution = .fillEqually
            
            // Main Stack
            let mainStack = UIStackView(arrangedSubviews: [headerStack, buttonStack])
            mainStack.axis = .vertical
            mainStack.spacing = 16
            
            cardView.addSubview(mainStack)
            mainStack.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                // Card View
                cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
                cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
                cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
                cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
                
                // Main Stack
                mainStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
                mainStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
                mainStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
                mainStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
                
                // Logo
                logoContainer.widthAnchor.constraint(equalToConstant: 64),
                logoContainer.heightAnchor.constraint(equalToConstant: 64),
                
                logoLabel.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor),
                logoLabel.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor),
                
                // Buttons
                instagramButton.heightAnchor.constraint(equalToConstant: 48),
                applyButton.heightAnchor.constraint(equalToConstant: 48),
                
                // Icons
                membersIcon.widthAnchor.constraint(equalToConstant: 12),
                membersIcon.heightAnchor.constraint(equalToConstant: 12),
                eventsIcon.widthAnchor.constraint(equalToConstant: 12),
                eventsIcon.heightAnchor.constraint(equalToConstant: 12)
            ])
        }
        
        private func createStatStack(icon: UIImageView, label: UILabel) -> UIStackView {
            let stack = UIStackView(arrangedSubviews: [icon, label])
            stack.axis = .horizontal
            stack.spacing = 4
            stack.alignment = .center
            return stack
        }
        
        private func configureInstagramButton() {
            var config = UIButton.Configuration.filled()
            config.image = UIImage(systemName: "camera.fill")
            config.title = "Instagram"
            config.imagePlacement = .leading
            config.imagePadding = 8
            config.baseBackgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.98, alpha: 1.0)
            config.baseForegroundColor = UIColor(red: 0.05, green: 0.17, blue: 0.31, alpha: 1.0)
            config.cornerStyle = .medium
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = .systemFont(ofSize: 14, weight: .medium)
                return outgoing
            }
            
            instagramButton.configuration = config
            instagramButton.addTarget(self, action: #selector(instagramTapped), for: .touchUpInside)
        }
        
        private func configureApplyButton() {
            var config = UIButton.Configuration.filled()
            config.image = UIImage(systemName: "paperplane.fill")
            config.title = "Apply"
            config.imagePlacement = .leading
            config.imagePadding = 8
            config.baseBackgroundColor = UIColor(red: 0.05, green: 0.17, blue: 0.31, alpha: 1.0)
            config.baseForegroundColor = .white
            config.cornerStyle = .medium
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = .systemFont(ofSize: 14, weight: .medium)
                return outgoing
            }
            
            applyButton.configuration = config
            applyButton.addTarget(self, action: #selector(applyTapped), for: .touchUpInside)
        }
        
        func configure(with club: Club) {
            self.club = club
            
            // Set logo emoji (first letter of club name as fallback)
            logoLabel.text = String(club.name.prefix(1))
            
            nameLabel.text = club.name
            descriptionLabel.text = club.description
            membersLabel.text = "\(club.members.count) members"
            
            // You might want to add events count to your Club model
            eventsLabel.text = "0 events"
            
            // Hide Instagram button if no link
            instagramButton.isHidden = club.instagramLink == nil || club.instagramLink?.isEmpty == true
        }
        
        @objc private func instagramTapped() {
            guard let urlString = club?.instagramLink, let url = URL(string: urlString) else { return }
            UIApplication.shared.open(url)
        }
        
        @objc private func applyTapped() {
            guard let club = club else { return }
            
            applyButton.isEnabled = false
            applyButton.configuration?.showsActivityIndicator = true
            
            NetworkManager.shared.applyToClub(clubId: club.id) { [weak self] membership, error in
                DispatchQueue.main.async {
                    self?.applyButton.isEnabled = true
                    self?.applyButton.configuration?.showsActivityIndicator = false
                    
                    if let _ = membership {
                        self?.showSuccessAlert()
                    } else if let error = error {
                        self?.showErrorAlert(message: error.localizedDescription)
                    }
                }
            }
        }
        
        private func showSuccessAlert() {
            guard let viewController = self.findViewController() else { return }
            let alert = UIAlertController(title: "Success!", message: "Your application has been sent", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            viewController.present(alert, animated: true)
        }
        
        private func showErrorAlert(message: String) {
            guard let viewController = self.findViewController() else { return }
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            viewController.present(alert, animated: true)
        }
    }

    // Helper extension to find the view controller
    extension UIView {
        func findViewController() -> UIViewController? {
            if let nextResponder = self.next as? UIViewController {
                return nextResponder
            } else if let nextResponder = self.next as? UIView {
                return nextResponder.findViewController()
            } else {
                return nil
            }
        }
    }
