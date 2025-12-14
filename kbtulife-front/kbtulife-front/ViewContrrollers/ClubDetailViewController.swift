// ClubDetailViewController.swift
import UIKit

class ClubDetailViewController: UIViewController {
    
    private let club: Club
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Header
    private let headerView = UIView()
    private let logoLabel = UILabel()
    private let gradientLayer = CAGradientLayer()
    
    // Card
    private let cardView = UIView()
    
    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let membersStatLabel = UILabel()
    private let eventsStatLabel = UILabel()
    
    private let instagramButton = UIButton(type: .system)
    private let telegramButton = UIButton(type: .system)
    
    private let membersPreviewStack = UIStackView()
    
    // Bottom bar
    private let bottomBar = UIView()
    private let applyButton = UIButton(type: .system)
    
    init(club: Club) {
        self.club = club
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGroupedBackground
        setupUI()
        configureContent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = headerView.bounds
        
        let bottomBarHeight: CGFloat = 96
        scrollView.contentInset.bottom = bottomBarHeight
        scrollView.verticalScrollIndicatorInsets.bottom = bottomBarHeight
    }
    
    private func setupUI() {
        // Scroll
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .automatic
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Header
        headerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerView)
        
        gradientLayer.colors = [
            UIColor(red: 12/255, green: 43/255, blue: 78/255, alpha: 1).cgColor,
            UIColor(red: 29/255, green: 84/255, blue: 108/255, alpha: 1).cgColor
        ]
        headerView.layer.addSublayer(gradientLayer)
        
        logoLabel.font = .systemFont(ofSize: 120)
        logoLabel.textAlignment = .center
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(logoLabel)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 260),
            
            logoLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            logoLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        // Card
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 32
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -32),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // Labels
        nameLabel.font = .systemFont(ofSize: 28, weight: .bold)
        nameLabel.numberOfLines = 0
        
        categoryLabel.font = .systemFont(ofSize: 13, weight: .medium)
        categoryLabel.textColor = UIColor(red: 12/255, green: 43/255, blue: 78/255, alpha: 1)
        categoryLabel.backgroundColor = UIColor(red: 12/255, green: 43/255, blue: 78/255, alpha: 0.1)
        categoryLabel.layer.cornerRadius = 12
        categoryLabel.clipsToBounds = true
        categoryLabel.textAlignment = .center
        
        descriptionLabel.font = .systemFont(ofSize: 17)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        
        membersStatLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        eventsStatLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        
        configureButton(instagramButton, title: "Instagram", image: "camera.fill", color: .systemPink)
        configureButton(telegramButton, title: "Telegram", image: "paperplane.fill", color: .systemBlue)
        
        membersPreviewStack.axis = .horizontal
        membersPreviewStack.spacing = -12
        
        let socialStack = UIStackView(arrangedSubviews: [instagramButton, telegramButton])
        socialStack.axis = .horizontal
        socialStack.spacing = 12
        socialStack.distribution = .fillEqually
        
        let mainStack = UIStackView(arrangedSubviews: [
            nameLabel,
            categoryLabel,
            descriptionLabel,
            membersStatLabel,
            eventsStatLabel,
            socialStack,
            membersPreviewStack
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            mainStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            mainStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            mainStack.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -24),
            instagramButton.heightAnchor.constraint(equalToConstant: 56),
            telegramButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        // Bottom bar
        bottomBar.backgroundColor = .white
        bottomBar.layer.borderWidth = 0.5
        bottomBar.layer.borderColor = UIColor.systemGray4.cgColor
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBar)
        
        applyButton.setTitle("Request Membership", for: .normal)
        applyButton.backgroundColor = UIColor(red: 12/255, green: 43/255, blue: 78/255, alpha: 1)
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.layer.cornerRadius = 16
        applyButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(applyButton)
        
        NSLayoutConstraint.activate([
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 96),
            
            applyButton.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 24),
            applyButton.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -24),
            applyButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            applyButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func configureButton(_ button: UIButton, title: String, image: String, color: UIColor) {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: image)
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseBackgroundColor = color
        config.cornerStyle = .large
        button.configuration = config
    }
    
    private func configureContent() {
        nameLabel.text = club.name
        descriptionLabel.text = club.description
        membersStatLabel.text = " \(club.members.count) Members"
        
        for _ in 0..<min(5, club.members.count) {
            let avatar = UIView()
            avatar.backgroundColor = UIColor(red: 12/255, green: 43/255, blue: 78/255, alpha: 1)
            avatar.layer.cornerRadius = 20
            avatar.layer.borderWidth = 2
            avatar.layer.borderColor = UIColor.white.cgColor
            avatar.translatesAutoresizingMaskIntoConstraints = false
            avatar.widthAnchor.constraint(equalToConstant: 40).isActive = true
            avatar.heightAnchor.constraint(equalToConstant: 40).isActive = true
            membersPreviewStack.addArrangedSubview(avatar)
        }
    }
}
