import UIKit

final class ProfileViewController: UIViewController {
    

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
    
    private let myClubsSection = UIView()
    private let myClubsHeader = UIButton(type: .system)
    private let myClubsListStack = UIStackView()
    private var isMyClubsExpanded = false
    
    private let adminButton = UIButton(type: .system)
    private let logoutButton = UIButton(type: .system)
    
    private let languageSegment = UISegmentedControl(items: ["Русский", "Қазақша", "English"])
    

    private var userTickets: [Ticket] = []
    private var userBadges: [Badge] = []
    private var attendedEventsCount = 0
    private var unlockedBadgesCount = 0
    private var joinedClubsCount = 0
    
    private var currentUser: User?
    private var isManager = false
    private var managedClubs: [ManagedClub] = []
    private var clubs: [Club] = []
    private var currentUserId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        fetchAllData()
    }
    

    private func setupUI() {
        setupScroll()
        setupHeader()
        setupStats()
        setupAchievements()
        setupMenu()
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
        headerView.backgroundColor = UIColor(red: 25/255, green: 45/255, blue: 85/255, alpha: 1)
        contentView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = NSLocalizedString("profile_title", comment: "Profile")
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 28)
        
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.tintColor = .white
        
        avatarView.backgroundColor = .white
        avatarView.layer.cornerRadius = 40
        avatarView.layer.shadowOpacity = 0.2
        avatarView.layer.shadowRadius = 6
        avatarView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        avatarLabel.font = .boldSystemFont(ofSize: 32)
        avatarLabel.textAlignment = .center
        avatarLabel.textColor = UIColor(red: 25/255, green: 45/255, blue: 85/255, alpha: 1)
        
        avatarView.addSubview(avatarLabel)
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = .boldSystemFont(ofSize: 22)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        
        emailLabel.font = .systemFont(ofSize: 16)
        emailLabel.textColor = UIColor(white: 1, alpha: 0.9)
        emailLabel.textAlignment = .center
        
        idLabel.font = .systemFont(ofSize: 14)
        idLabel.textColor = UIColor(white: 1, alpha: 0.8)
        idLabel.textAlignment = .center
        
        [titleLabel, settingsButton, avatarView, nameLabel, emailLabel, idLabel].forEach {
            headerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 280),
            
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            settingsButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            settingsButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            avatarView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            avatarView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            avatarView.widthAnchor.constraint(equalToConstant: 80),
            avatarView.heightAnchor.constraint(equalToConstant: 80),
            
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            nameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: headerView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerView.trailingAnchor, constant: -20),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            emailLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            emailLabel.leadingAnchor.constraint(greaterThanOrEqualTo: headerView.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerView.trailingAnchor, constant: -20),
            
            idLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            idLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            idLabel.leadingAnchor.constraint(greaterThanOrEqualTo: headerView.leadingAnchor, constant: 20),
            idLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerView.trailingAnchor, constant: -20)
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
            statsStack.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 60),
            statsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statsStack.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupAchievements() {
        achievementsTitle.text = NSLocalizedString("achievements_title", comment: "Achievements")
        achievementsTitle.font = .boldSystemFont(ofSize: 20)
        achievementsTitle.textColor = .label
        
        achievementsContainer.backgroundColor = UIColor.systemGray6
        achievementsContainer.layer.cornerRadius = 16
        
        contentView.addSubview(achievementsTitle)
        contentView.addSubview(achievementsContainer)
        
        [achievementsTitle, achievementsContainer].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            achievementsTitle.topAnchor.constraint(equalTo: statsStack.bottomAnchor, constant: 40),
            achievementsTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            achievementsContainer.topAnchor.constraint(equalTo: achievementsTitle.bottomAnchor, constant: 16),
            achievementsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            achievementsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            achievementsContainer.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupMenu() {
        menuStack.axis = .vertical
        menuStack.spacing = 12
        
        setupMyClubsSection()
        
        let eventsButton = createMenuButton(
            title: NSLocalizedString("event_history", comment: "Event History"),
            icon: "calendar"
        )
        
        menuStack.addArrangedSubview(myClubsSection)
        menuStack.addArrangedSubview(eventsButton)
        
        setupLanguageSwitcher()
        
        adminButton.setTitle(NSLocalizedString("admin_dashboard", comment: "Admin Dashboard"), for: .normal)
        adminButton.backgroundColor = UIColor(red: 25/255, green: 45/255, blue: 85/255, alpha: 0.1)
        adminButton.setTitleColor(UIColor(red: 25/255, green: 45/255, blue: 85/255, alpha: 1), for: .normal)
        adminButton.layer.cornerRadius = 14
        adminButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        adminButton.contentHorizontalAlignment = .center
        adminButton.addTarget(self, action: #selector(handleAdminDashboard), for: .touchUpInside)
        
        logoutButton.setTitle(NSLocalizedString("logout", comment: "Logout"), for: .normal)
        logoutButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.layer.cornerRadius = 14
        logoutButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        logoutButton.contentHorizontalAlignment = .center
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        menuStack.addArrangedSubview(adminButton)
        menuStack.addArrangedSubview(logoutButton)
        
        contentView.addSubview(menuStack)
        menuStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            menuStack.topAnchor.constraint(equalTo: achievementsContainer.bottomAnchor, constant: 32),
            menuStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            menuStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            menuStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            eventsButton.heightAnchor.constraint(equalToConstant: 56),
            adminButton.heightAnchor.constraint(equalToConstant: 56),
            logoutButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

      
    private func setupMyClubsSection() {
        myClubsSection.backgroundColor = .systemGray6
        myClubsSection.layer.cornerRadius = 14
        myClubsSection.translatesAutoresizingMaskIntoConstraints = false
        
        myClubsHeader.setTitle("My Clubs", for: .normal)
                myClubsHeader.setTitleColor(.label, for: .normal)
                myClubsHeader.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
                myClubsHeader.contentHorizontalAlignment = .left
                myClubsHeader.addTarget(self, action: #selector(toggleMyClubs), for: .touchUpInside)
                
                let clubIcon = UIImageView(image: UIImage(systemName: "person.3.fill"))
                clubIcon.tintColor = UIColor(red: 25/255, green: 45/255, blue: 85/255, alpha: 1)
                clubIcon.contentMode = .scaleAspectFit
                
                let chevronIcon = UIImageView(image: UIImage(systemName: "chevron.down"))
                chevronIcon.tintColor = .systemGray3
                chevronIcon.contentMode = .scaleAspectFit
                chevronIcon.tag = 999
                
                myClubsSection.addSubview(myClubsHeader)
                myClubsSection.addSubview(clubIcon)
                myClubsSection.addSubview(chevronIcon)
                
                myClubsHeader.translatesAutoresizingMaskIntoConstraints = false
                clubIcon.translatesAutoresizingMaskIntoConstraints = false
                chevronIcon.translatesAutoresizingMaskIntoConstraints = false
                
         
                myClubsListStack.axis = .vertical
                myClubsListStack.spacing = 0
                myClubsListStack.isHidden = true
                
                myClubsSection.addSubview(myClubsListStack)
                myClubsListStack.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    clubIcon.leadingAnchor.constraint(equalTo: myClubsSection.leadingAnchor, constant: 16),
                    clubIcon.centerYAnchor.constraint(equalTo: myClubsHeader.centerYAnchor),
                    clubIcon.widthAnchor.constraint(equalToConstant: 24),
                    clubIcon.heightAnchor.constraint(equalToConstant: 24),
                    
                    myClubsHeader.leadingAnchor.constraint(equalTo: clubIcon.trailingAnchor, constant: 12),
                    myClubsHeader.topAnchor.constraint(equalTo: myClubsSection.topAnchor, constant: 16),
                    myClubsHeader.trailingAnchor.constraint(equalTo: chevronIcon.leadingAnchor, constant: -8),
                    myClubsHeader.heightAnchor.constraint(equalToConstant: 24),
                    
                    chevronIcon.trailingAnchor.constraint(equalTo: myClubsSection.trailingAnchor, constant: -16),
                    chevronIcon.centerYAnchor.constraint(equalTo: myClubsHeader.centerYAnchor),
                    chevronIcon.widthAnchor.constraint(equalToConstant: 16),
                    chevronIcon.heightAnchor.constraint(equalToConstant: 16),
                    
                    myClubsListStack.topAnchor.constraint(equalTo: myClubsHeader.bottomAnchor, constant: 8),
                    myClubsListStack.leadingAnchor.constraint(equalTo: myClubsSection.leadingAnchor),
                    myClubsListStack.trailingAnchor.constraint(equalTo: myClubsSection.trailingAnchor),
                    myClubsListStack.bottomAnchor.constraint(equalTo: myClubsSection.bottomAnchor, constant: -8)

        ])
    }
    
    private func setupLanguageSwitcher() {
        languageSegment.selectedSegmentIndex = currentLanguageIndex()
        languageSegment.addTarget(self, action: #selector(languageChanged), for: .valueChanged)
        languageSegment.backgroundColor = .systemGray6
        languageSegment.selectedSegmentTintColor = UIColor(red: 25/255, green: 45/255, blue: 85/255, alpha: 1)
        
        let languageTitle = UILabel()
        languageTitle.text = NSLocalizedString("language_title", comment: "Language")
        languageTitle.font = .systemFont(ofSize: 17, weight: .medium)
        languageTitle.textColor = .label
        
        let languageContainer = UIView()
        languageContainer.backgroundColor = .systemGray6
        languageContainer.layer.cornerRadius = 14
        
        let contentStack = UIStackView(arrangedSubviews: [languageTitle, languageSegment])
        contentStack.axis = .horizontal
        contentStack.spacing = 16
        contentStack.alignment = .center
        contentStack.distribution = .fill
        
        languageContainer.addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: languageContainer.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: languageContainer.trailingAnchor, constant: -16),
            contentStack.topAnchor.constraint(equalTo: languageContainer.topAnchor, constant: 12),
            contentStack.bottomAnchor.constraint(equalTo: languageContainer.bottomAnchor, constant: -12)
        ])
        
        menuStack.addArrangedSubview(languageContainer)
        languageContainer.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    // MARK: - Helper Methods
    private func createMenuButton(title: String, icon: String) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 14
        
        let iconImage = UIImageView(image: UIImage(systemName: icon))
        iconImage.tintColor = UIColor(red: 25/255, green: 45/255, blue: 85/255, alpha: 1)
        iconImage.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = .systemGray3
        chevron.contentMode = .scaleAspectFit
        
        button.addSubview(iconImage)
        button.addSubview(label)
        button.addSubview(chevron)
        
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        chevron.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImage.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
            iconImage.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            iconImage.widthAnchor.constraint(equalToConstant: 24),
            iconImage.heightAnchor.constraint(equalToConstant: 24),
            
            label.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            
            chevron.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16),
            chevron.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            chevron.widthAnchor.constraint(equalToConstant: 16),
            chevron.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        return button
    }
    
    private func statCard(title: String, value: String) -> UIView {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 16
        v.layer.shadowOpacity = 0.08
        v.layer.shadowRadius = 8
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .boldSystemFont(ofSize: 24)
        valueLabel.textColor = .label
        valueLabel.textAlignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center
        
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
    
    private func createClubRow(for club: Club) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear
        
        let iconView = UIView()
        iconView.backgroundColor = UIColor(red: 25/255, green: 45/255, blue: 85/255, alpha: 0.1)
        iconView.layer.cornerRadius = 20
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconLabel = UILabel()
        iconLabel.text = String(club.name.prefix(1))
        iconLabel.font = .boldSystemFont(ofSize: 18)
        iconLabel.textColor = UIColor(red: 25/255, green: 45/255, blue: 85/255, alpha: 1)
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        iconView.addSubview(iconLabel)
        
        let nameLabel = UILabel()
        nameLabel.text = club.name
        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        nameLabel.textColor = .label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = .systemGray3
        chevron.contentMode = .scaleAspectFit
        chevron.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(iconView)
        container.addSubview(nameLabel)
        container.addSubview(chevron)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),
            
            iconLabel.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevron.leadingAnchor, constant: -8),
            
            chevron.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            chevron.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            chevron.widthAnchor.constraint(equalToConstant: 14),
            chevron.heightAnchor.constraint(equalToConstant: 14),
            
            container.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        return container
    }
    
    private func updateStatsCard(at index: Int, with value: String) {
        guard index < statsStack.arrangedSubviews.count else { return }
        if let cardView = statsStack.arrangedSubviews[index] as? UIView,
           let stack = cardView.subviews.first as? UIStackView,
           let valueLabel = stack.arrangedSubviews.first as? UILabel {
            valueLabel.text = value
        }
    }
    
    private func currentLanguageIndex() -> Int {
        let current = Locale.current.language.languageCode?.identifier ?? "en"
        switch current {
        case "ru": return 0
        case "kk": return 1
        default: return 2
        }
    }

    
    private func fetchAllData() {
        let group = DispatchGroup()
        var user: User?
        var tickets: [Ticket]?
        var managerStatus: ClubManagerStatusResponse?
        var userClubs: [Club]?
        
        group.enter()
        NetworkManager.shared.fetchCurrentUser { fetchedUser, error in
            if let fetchedUser = fetchedUser {
                user = fetchedUser
                group.enter()
                NetworkManager.shared.fetchUserClubs(userId: fetchedUser.id) { fetchedClubs, error in
                    userClubs = fetchedClubs
                    group.leave()
                }
            }
            group.leave()
        }
        
        group.enter()
        NetworkManager.shared.fetchMyTickets { fetchedTickets, error in
            tickets = fetchedTickets
            group.leave()
        }
        
        group.enter()
        NetworkManager.shared.checkManagerStatus { status, error in
            managerStatus = status
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            self.currentUser = user
            self.userTickets = tickets ?? []
            self.isManager = managerStatus?.isManager ?? false
            self.managedClubs = managerStatus?.managedClubs ?? []
            self.clubs = userClubs ?? []
            
            self.updateUI()
        }
    }
    
    private func updateUI() {
        if let user = currentUser {
            nameLabel.text = "\(user.firstName) \(user.lastName)"
            emailLabel.text = user.outlook
            avatarLabel.text = String(user.firstName.prefix(1))
            UserDefaults.standard.set(user.id, forKey: "userId")
            currentUserId = user.id
        }
        
        attendedEventsCount = userTickets.filter { $0.used }.count
        updateStatsCard(at: 0, with: "\(attendedEventsCount)")
        
        joinedClubsCount = clubs.count
        updateStatsCard(at: 1, with: "\(joinedClubsCount)")
        adminButton.isHidden = !isManager
        
        populateMyClubsStack()
    }
    
    private func populateMyClubsStack() {
        myClubsListStack.arrangedSubviews.forEach {
            self.myClubsListStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        guard !clubs.isEmpty else {
            let emptyLabel = UILabel()
            emptyLabel.text = NSLocalizedString("no_clubs", comment: "No clubs yet")
            emptyLabel.font = .systemFont(ofSize: 15)
            emptyLabel.textColor = .secondaryLabel
            emptyLabel.textAlignment = .center
            myClubsListStack.addArrangedSubview(emptyLabel)
            return
        }
        
        clubs.forEach { club in
            let clubRow = self.createClubRow(for: club)
            myClubsListStack.addArrangedSubview(clubRow)
        }
    }

    @objc private func toggleMyClubs() {
        isMyClubsExpanded.toggle()
        
        if let chevron = myClubsSection.viewWithTag(999) {
            UIView.animate(withDuration: 0.3) {
                chevron.transform = self.isMyClubsExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.myClubsListStack.isHidden = !self.isMyClubsExpanded
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func languageChanged() {
        let languages = ["ru", "kk", "en"]
        let selected = languages[languageSegment.selectedSegmentIndex]
        
        UserDefaults.standard.set([selected], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        let alert = UIAlertController(
            title: NSLocalizedString("language_changed_title", comment: "Language Changed"),
            message: NSLocalizedString("language_changed_message", comment: "Please restart the app"),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            exit(0)
        })
        present(alert, animated: true)
    }
    
    
    @objc private func handleAdminDashboard() {
        guard isManager else {
            showAlert(
                title: NSLocalizedString("access_denied", comment: ""),
                message: NSLocalizedString("not_club_manager_message", comment: "")
            )
            return
        }
        
        let dashboardVC = ClubManagerViewController()
        dashboardVC.managedClubs = managedClubs
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
    
    private func navigateToOnboarding() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? UIWindowSceneDelegate,
              let window = sceneDelegate.window ?? nil else {
            return
        }
        
        let onboardingVC = OnboardingViewController()
        let navController = UINavigationController(rootViewController: onboardingVC)
        
        UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve) {
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }
}

