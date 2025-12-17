// Updated ProfileViewController.swift
import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - UI
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let settingsButton = UIButton(type: .system)
    
    private let avatarView = UIView()
    private let avatarLabel = UILabel()
    
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let idLabel = UILabel()
    
    private let statsStack = UIStackView()
    
    private let achievementsTitle = UILabel()
    private let achievementsContainer = UIView()
    
    private let menuStack = UIStackView()
    
    private let adminButton = UIButton(type: .system)
    private let logoutButton = UIButton(type: .system)
    
    private let languageSegment = UISegmentedControl(items: ["Русский", "Қазақша", "English"])
    
    private var userTickets: [Ticket] = []
    private var userBadges: [Badge] = []
    private var attendedEventsCount = 0
    private var unlockedBadgesCount = 0
    private var joinedClubsCount = 0
    
    // MARK: - Properties
    private var currentUser: User?
    private var isManager = false
    private var managedClubs: [ManagedClub] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        fetchProfile()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        setupScroll()
        setupHeader()
        setupProfileInfo()
        setupStats()
        setupAchievements()
        setupMenu()
        setupLanguageSwitcher()
    }
    
    private func setupScroll() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
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
    }
    
    private func setupHeader() {
        headerView.backgroundColor = UIColor(red: 22/255, green: 42/255, blue: 92/255, alpha: 1)
        contentView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = NSLocalizedString("profile_title", comment: "")
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 28)
        
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.tintColor = .white
        
        avatarView.backgroundColor = .white
        avatarView.layer.cornerRadius = 40
        avatarView.layer.shadowOpacity = 0.2
        avatarView.layer.shadowRadius = 6
        
        avatarLabel.font = .boldSystemFont(ofSize: 32)
        avatarLabel.textAlignment = .center
        
        avatarView.addSubview(avatarLabel)
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = .boldSystemFont(ofSize: 22)
        nameLabel.textColor = .white
        
        emailLabel.textColor = UIColor(white: 1, alpha: 0.8)
        idLabel.textColor = UIColor(white: 1, alpha: 0.8)
        
        [titleLabel, settingsButton, avatarView, nameLabel, emailLabel, idLabel].forEach {
            headerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 220),
            
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            settingsButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            settingsButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            avatarView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            avatarView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            avatarView.widthAnchor.constraint(equalToConstant: 80),
            avatarView.heightAnchor.constraint(equalToConstant: 80),
            
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 12),
            nameLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            idLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4),
            idLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        ])
    }
    
    private func setupProfileInfo() {
        [avatarView, nameLabel, emailLabel, idLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            avatarView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -40),
            avatarView.widthAnchor.constraint(equalToConstant: 80),
            avatarView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 12),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            idLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4),
            idLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func setupStats() {
        statsStack.axis = .horizontal
        statsStack.distribution = .fillEqually
        statsStack.spacing = 12
        
        statsStack.addArrangedSubview(statCard(title: "Events", value: "0"))
        statsStack.addArrangedSubview(statCard(title: "Clubs", value: "0"))
        statsStack.addArrangedSubview(statCard(title: "Badges", value: "0"))
        
        contentView.addSubview(statsStack)
        statsStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            statsStack.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 24),
            statsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupAchievements() {
        achievementsTitle.text = NSLocalizedString("achievements_title", comment: "")
        achievementsTitle.font = .boldSystemFont(ofSize: 20)
        
        achievementsContainer.backgroundColor = UIColor.systemGray6
        achievementsContainer.layer.cornerRadius = 16
        
        contentView.addSubview(achievementsTitle)
        contentView.addSubview(achievementsContainer)
        
        [achievementsTitle, achievementsContainer].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            achievementsTitle.topAnchor.constraint(equalTo: statsStack.bottomAnchor, constant: 48),
            achievementsTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            achievementsContainer.topAnchor.constraint(equalTo: achievementsTitle.bottomAnchor, constant: 12),
            achievementsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            achievementsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            achievementsContainer.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupMenu() {
        menuStack.axis = .vertical
        menuStack.spacing = 12
        
        menuStack.addArrangedSubview(menuLabel(NSLocalizedString("my_clubs", comment: "")))
        menuStack.addArrangedSubview(menuLabel(NSLocalizedString("event_history", comment: "")))
        menuStack.addArrangedSubview(menuLabel(NSLocalizedString("my_reviews", comment: "")))
        
        // Admin Dashboard Button
        adminButton.setTitle(NSLocalizedString("admin_dashboard", comment: ""), for: .normal)
        adminButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.15)
        adminButton.setTitleColor(.systemBlue, for: .normal)
        adminButton.layer.cornerRadius = 14
        adminButton.addTarget(self, action: #selector(handleAdminDashboard), for: .touchUpInside)
        
        logoutButton.setTitle(NSLocalizedString("logout", comment: ""), for: .normal)
        logoutButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.layer.cornerRadius = 14
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        menuStack.addArrangedSubview(adminButton)
        menuStack.addArrangedSubview(logoutButton)
        
        contentView.addSubview(menuStack)
        menuStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            menuStack.topAnchor.constraint(equalTo: achievementsContainer.bottomAnchor, constant: 32),
            menuStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            menuStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            menuStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        [adminButton, logoutButton].forEach {
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
    
    private func setupLanguageSwitcher() {
        languageSegment.selectedSegmentIndex = currentLanguageIndex()
        languageSegment.addTarget(self, action: #selector(languageChanged), for: .valueChanged)
        
        let languageTitle = UILabel()
        languageTitle.text = NSLocalizedString("language_title", comment: "")
        languageTitle.font = .systemFont(ofSize: 17)
        
        let languageRow = UIStackView(arrangedSubviews: [languageTitle, languageSegment])
        languageRow.axis = .horizontal
        languageRow.spacing = 20
        languageRow.distribution = .fill
        
        menuStack.insertArrangedSubview(languageRow, at: 3)
        
        languageRow.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func currentLanguageIndex() -> Int {
        let current = Locale.current.language.languageCode?.identifier ?? "en"
        switch current {
        case "ru": return 0
        case "kk": return 1
        default: return 2
        }
    }
    
    @objc private func languageChanged() {
        let languages = ["ru", "kk", "en"]
        let selected = languages[languageSegment.selectedSegmentIndex]
        
        UserDefaults.standard.set([selected], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        let alert = UIAlertController(
            title: NSLocalizedString("language_changed_title", comment: ""),
            message: NSLocalizedString("language_changed_message", comment: ""),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            exit(0)
        })
        present(alert, animated: true)
    }
    
    // MARK: - Helpers
    
    private func statCard(title: String, value: String) -> UIView {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 16
        v.layer.shadowOpacity = 0.1
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .boldSystemFont(ofSize: 20)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .secondaryLabel
        
        let stack = UIStackView(arrangedSubviews: [valueLabel, titleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        
        v.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: v.centerYAnchor)
        ])
        return v
    }
    
    private func menuLabel(_ title: String) -> UIView {
        let container = UIView()
        
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 18)
        label.textColor = .label
        
        container.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
        
        let separator = UIView()
        separator.backgroundColor = UIColor.systemGray4
        container.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            separator.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    // MARK: - Data
    
    private func fetchProfile() {
        NetworkManager.shared.fetchCurrentUser { [weak self] user, _ in
            guard let user = user else { return }
            self?.currentUser = user
            
            DispatchQueue.main.async {
                self?.nameLabel.text = "\(user.firstName) \(user.lastName)"
                self?.emailLabel.text = user.outlook
                self?.avatarLabel.text = String(user.firstName.prefix(1))
                
                // Store user ID for later use
                UserDefaults.standard.set(user.id, forKey: "userId")
            }
            
            // Check if user is a manager
            self?.checkManagerStatus()
        }
    }
    
    private func checkManagerStatus() {
        NetworkManager.shared.checkManagerStatus { [weak self] response, error in
            guard let self, let response else { return }
            
            DispatchQueue.main.async {
                self.isManager = response.isManager
                self.managedClubs = response.managedClubs
                self.adminButton.isHidden = !response.isManager
            }
        }
    }
    
    
    // MARK: - Actions
    @objc private func handleAdminDashboard() {
        guard isManager else {
            showAlert(
                title: NSLocalizedString("access_denied", comment: ""),
                message: NSLocalizedString("not_club_manager_message", comment: "")
            )
            return
        }
        
        let dashboardVC = ClubManagerViewController()
        dashboardVC.managedClubs = managedClubs   // 🔑 inject data
        dashboardVC.modalPresentationStyle = .fullScreen
        present(dashboardVC, animated: true)
    }
    
    
    
    @objc private func handleLogout() {
        NetworkManager.shared.logout { [weak self] success, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if success {
                    self.showInfoAlert(
                        title: NSLocalizedString("logout_success_title", comment: ""),
                        message: NSLocalizedString("logout_success_message", comment: "")
                    ) {
                        // Navigate to onboarding after alert dismissed
                        self.navigateToOnboarding()
                    }
                } else {
                    self.showAlert(
                        title: NSLocalizedString("logout_failed_title", comment: ""),
                        message: error?.localizedDescription ?? NSLocalizedString("logout_failed_message", comment: "")
                    )
                }
            }
        }
    }
    
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    private func showInfoAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    // ✅ Add here
    private func navigateToOnboarding() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? UIWindowSceneDelegate,
              let window = sceneDelegate.window ?? nil else {
            return
        }

        let onboardingVC = OnboardingViewController()
        let navController = UINavigationController(rootViewController: onboardingVC) // Optional, if you want navigation

        // Smooth crossfade animation
        UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve) {
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }

}
