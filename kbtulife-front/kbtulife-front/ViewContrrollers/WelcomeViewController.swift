import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - UI Elements
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "kbtu_logo_cool") // Замените на имя вашего лого
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome!"
        label.font = UIFont.systemFont(ofSize: 40, weight: .medium)
        label.textColor = UIColor(red: 25/255, green: 45/255, blue: 85/255, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose how to get started"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let iconContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 25/255, green: 45/255, blue: 85/255, alpha: 1.0)
        view.layer.cornerRadius = 28
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.fill")
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let registerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Register with Student Outlook account "
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let registerSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Use your KBTU student outlook account"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 25/255, green: 45/255, blue: 85/255, alpha: 1.0)
        button.setTitle("Already have an account? Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(red: 248/255, green: 249/255, blue: 251/255, alpha: 1.0)
        
        // Add subviews
        view.addSubview(logoImageView)
        view.addSubview(welcomeLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(registerButton)
        view.addSubview(loginButton)
        
        // Setup register button content
        registerButton.addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
        registerButton.addSubview(registerTitleLabel)
        registerButton.addSubview(registerSubtitleLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Logo
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 180),
            logoImageView.heightAnchor.constraint(equalToConstant: 180),
            
            // Welcome label
            welcomeLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Register button
            registerButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 60),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            registerButton.heightAnchor.constraint(equalToConstant: 110),
            
            // Icon container
            iconContainerView.leadingAnchor.constraint(equalTo: registerButton.leadingAnchor, constant: 24),
            iconContainerView.centerYAnchor.constraint(equalTo: registerButton.centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 56),
            iconContainerView.heightAnchor.constraint(equalToConstant: 56),
            
            // Icon
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28),
            
            // Register title
            registerTitleLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 16),
            registerTitleLabel.trailingAnchor.constraint(equalTo: registerButton.trailingAnchor, constant: -16),
            registerTitleLabel.topAnchor.constraint(equalTo: registerButton.topAnchor, constant: 26),
            
            // Register subtitle
            registerSubtitleLabel.leadingAnchor.constraint(equalTo: registerTitleLabel.leadingAnchor),
            registerSubtitleLabel.trailingAnchor.constraint(equalTo: registerTitleLabel.trailingAnchor),
            registerSubtitleLabel.topAnchor.constraint(equalTo: registerTitleLabel.bottomAnchor, constant: 4),
            
            // Login button
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            loginButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupActions() {
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func registerTapped() {
        // Навигация на экран регистрации
        print("Register tapped")
         let registerVC = RegistrationViewController()
         navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc private func loginTapped() {
        // Навигация на экран логина
        print("Login tapped")
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
}
