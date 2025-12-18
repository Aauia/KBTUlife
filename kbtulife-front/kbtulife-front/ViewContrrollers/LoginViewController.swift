// LoginViewController.swift
import UIKit

class LoginViewController: UIViewController {
    private let outlookTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let registerButton = UIButton(type: .system)  // ✅ Added
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Вход"
        view.backgroundColor = .systemBackground
        
        setupUI()
    }
    
    private func setupUI() {
        // Outlook TextField
        outlookTextField.placeholder = "Outlook email (@kbtu.kz)"
        outlookTextField.keyboardType = .emailAddress
        outlookTextField.autocapitalizationType = .none
        outlookTextField.borderStyle = .roundedRect
        
        // Password TextField
        passwordTextField.placeholder = "Пароль"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        
        // Login Button
        loginButton.setTitle("Войти", for: .normal)
        loginButton.backgroundColor = UIColor(red: 25/255, green: 45/255, blue: 85/255, alpha: 1.0)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 12
        loginButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        // Activity Indicator
        activityIndicator.hidesWhenStopped = true
        
        // Register Button ✅
        registerButton.setTitle("Нет аккаунта? Зарегистрироваться", for: .normal)
        registerButton.titleLabel?.font = .systemFont(ofSize: 15)
        registerButton.setTitleColor(.systemBlue, for: .normal)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        
        // Stack View - Added registerButton ✅
        let stack = UIStackView(arrangedSubviews: [
            outlookTextField,
            passwordTextField,
            loginButton,
            activityIndicator,
            registerButton  // ✅ Added to stack
        ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        outlookTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc private func loginTapped() {
        guard let outlook = outlookTextField.text?.trimmingCharacters(in: .whitespaces), !outlook.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Ошибка", message: "Заполните все поля")
            return
        }
        
        loginButton.isEnabled = false
        loginButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
        
        NetworkManager.shared.login(outlook: outlook, password: password) { [weak self] user, error in
            DispatchQueue.main.async {
                self?.loginButton.isEnabled = true
                self?.loginButton.setTitle("Войти", for: .normal)
                self?.activityIndicator.stopAnimating()
                
                if let user = user {
                    print("✅ Logged in: \(user.firstName) \(user.lastName)")
                    
                    // Navigate to main app
                    let mainTab = MainTabBarController()
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = mainTab
                        window.makeKeyAndVisible()
                    }
                } else {
                    let message = error?.localizedDescription ?? "Неверный email или пароль"
                    self?.showAlert(title: "Ошибка входа", message: message)
                }
            }
        }
    }
    
    // ✅ New method for registration
    @objc private func registerTapped() {
        let registerVC = RegistrationViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

