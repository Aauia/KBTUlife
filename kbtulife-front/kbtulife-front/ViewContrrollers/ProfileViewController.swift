// ProfileViewController.swift
// Fixed layout: achievements padding, admin dashboard button added, logout wired

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
    }

    private func setupScroll() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
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

        // Profile title
        titleLabel.text = "Profile"
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 28)

        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.tintColor = .white

        // User info labels
        nameLabel.font = .boldSystemFont(ofSize: 22)
        nameLabel.textColor = .white
        emailLabel.textColor = UIColor(white: 1, alpha: 0.8)
        idLabel.textColor = UIColor(white: 1, alpha: 0.8)

        // Avatar
        avatarView.backgroundColor = .white
        avatarView.layer.cornerRadius = 40
        avatarView.layer.shadowOpacity = 0.2
        avatarView.layer.shadowRadius = 6
        avatarLabel.font = .boldSystemFont(ofSize: 32)
        avatarLabel.textAlignment = .center
        avatarView.addSubview(avatarLabel)
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews to headerView
        headerView.addSubview(titleLabel)
        headerView.addSubview(settingsButton)
        headerView.addSubview(avatarView)
        headerView.addSubview(nameLabel)
        headerView.addSubview(emailLabel)
        headerView.addSubview(idLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 220), // can increase if needed

            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 40),

            settingsButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            settingsButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),

            avatarView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            avatarView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            avatarView.widthAnchor.constraint(equalToConstant: 80),
            avatarView.heightAnchor.constraint(equalToConstant: 80),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 8),
            nameLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),

            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            emailLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),

            idLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 2),
            idLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        ])
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
        
        // Add a bottom separator line
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


    private func setupProfileInfo() {
        avatarView.backgroundColor = .white
        avatarView.layer.cornerRadius = 40
        avatarView.layer.shadowOpacity = 0.2
        avatarView.layer.shadowRadius = 6

        avatarLabel.font = .boldSystemFont(ofSize: 32)
        avatarLabel.textAlignment = .center

        avatarView.addSubview(avatarLabel)
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = .boldSystemFont(ofSize: 22)
        emailLabel.textColor = .secondaryLabel
        idLabel.textColor = .secondaryLabel

        [avatarView, nameLabel, emailLabel, idLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            avatarView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -40),
            avatarView.widthAnchor.constraint(equalToConstant: 80),
            avatarView.heightAnchor.constraint(equalToConstant: 80),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

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
        achievementsTitle.text = "Achievements"
        achievementsTitle.font = .boldSystemFont(ofSize: 20)

        achievementsContainer.backgroundColor = UIColor.systemGray6
        achievementsContainer.layer.cornerRadius = 16

        contentView.addSubview(achievementsTitle)
        contentView.addSubview(achievementsContainer)
        achievementsTitle.translatesAutoresizingMaskIntoConstraints = false
        achievementsContainer.translatesAutoresizingMaskIntoConstraints = false

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

        menuStack.addArrangedSubview(menuLabel("My Clubs"))
        menuStack.addArrangedSubview(menuLabel("Event History"))
        menuStack.addArrangedSubview(menuLabel("My Reviews"))


        adminButton.setTitle("Admin Dashboard", for: .normal)
        adminButton.backgroundColor = UIColor.systemGray5
        adminButton.layer.cornerRadius = 14
        adminButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.layer.cornerRadius = 14
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
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

    private func menuButton(_ title: String) -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle(title, for: .normal)
        b.backgroundColor = UIColor.systemGray6
        b.layer.cornerRadius = 14
        b.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return b
    }

    // MARK: - Data

    private func fetchProfile() {
        NetworkManager.shared.fetchCurrentUser { [weak self] user, _ in
            guard let user = user else { return }
            DispatchQueue.main.async {
                self?.nameLabel.text = "\(user.firstName) \(user.lastName)"
                self?.emailLabel.text = user.outlook
                self?.avatarLabel.text = String(user.firstName.prefix(1))
            }
        }
    }

    // MARK: - Actions

    @objc private func handleLogout() {
        NetworkManager.shared.logout { [weak self] success, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if success {
                    // Logout succeeded — dismiss profile
                    self.dismiss(animated: true)
                } else {
                    // Logout failed — show alert
                    let alert = UIAlertController(
                        title: "Logout Failed",
                        message: error?.localizedDescription ?? "Please try again",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }

}
