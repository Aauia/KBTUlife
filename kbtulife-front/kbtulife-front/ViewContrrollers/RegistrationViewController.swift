// RegistrationViewController.swift
import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let outlookTextField = UITextField()
    private let firstNameTextField = UITextField()
    private let lastNameTextField = UITextField()
    private let phoneTextField = UITextField()
    private let passwordTextField = UITextField()
    private let confirmPasswordTextField = UITextField()
    
    private let registerButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let loginButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Регистрация"
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupKeyboardHandling()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Scroll View
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
        
        // Configure TextFields
        configureTextField(outlookTextField, placeholder: "Email (@kbtu.kz)", keyboardType: .emailAddress)
        configureTextField(firstNameTextField, placeholder: "Имя")
        configureTextField(lastNameTextField, placeholder: "Фамилия")
        configureTextField(phoneTextField, placeholder: "Телефон (необязательно)", keyboardType: .phonePad)
        configureTextField(passwordTextField, placeholder: "Пароль", isSecure: true)
        configureTextField(confirmPasswordTextField, placeholder: "Подтвердите пароль", isSecure: true)
        
        // Register Button
        registerButton.setTitle("Зарегистрироваться", for: .normal)
        registerButton.backgroundColor = UIColor(red: 25/255, green: 45/255, blue: 85/255, alpha: 1.0)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 12
        registerButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        
        // Activity Indicator
        activityIndicator.hidesWhenStopped = true
        
        // Login Button
        loginButton.setTitle("Уже есть аккаунт? Войти", for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 15)
        loginButton.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
        
        // Stack View
        let stack = UIStackView(arrangedSubviews: [
            outlookTextField,
            firstNameTextField,
            lastNameTextField,
            phoneTextField,
            passwordTextField,
            confirmPasswordTextField,
            registerButton,
            activityIndicator,
            loginButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        // Heights
        [outlookTextField, firstNameTextField, lastNameTextField,
         phoneTextField, passwordTextField, confirmPasswordTextField, registerButton].forEach {
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
    
    private func configureTextField(_ textField: UITextField, placeholder: String, keyboardType: UIKeyboardType = .default, isSecure: Bool = false) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = keyboardType
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = isSecure
        textField.font = .systemFont(ofSize: 16)
        
        // Add padding
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
    }
    
    // MARK: - Actions
    @objc private func registerTapped() {
        // Validate inputs
        guard let outlook = outlookTextField.text?.trimmingCharacters(in: .whitespaces), !outlook.isEmpty else {
            showAlert(title: "Ошибка", message: "Введите email")
            return
        }
        
        guard outlook.contains("@kbtu.kz") else {
            showAlert(title: "Ошибка", message: "Email должен быть в формате @kbtu.kz")
            return
        }
        
        guard let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespaces), !firstName.isEmpty else {
            showAlert(title: "Ошибка", message: "Введите имя")
            return
        }
        
        guard let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespaces), !lastName.isEmpty else {
            showAlert(title: "Ошибка", message: "Введите фамилию")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Ошибка", message: "Введите пароль")
            return
        }
        
        guard password.count >= 6 else {
            showAlert(title: "Ошибка", message: "Пароль должен быть минимум 6 символов")
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text, password == confirmPassword else {
            showAlert(title: "Ошибка", message: "Пароли не совпадают")
            return
        }
        
        let phone = phoneTextField.text?.trimmingCharacters(in: .whitespaces)
        
        // Start registration
        registerButton.isEnabled = false
        registerButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
        view.endEditing(true)
        
        NetworkManager.shared.register(
            outlook: outlook,
            firstName: firstName,
            lastName: lastName,
            phone: phone,
            password: password
        ) { [weak self] user, error in
            DispatchQueue.main.async {
                self?.registerButton.isEnabled = true
                self?.registerButton.setTitle("Зарегистрироваться", for: .normal)
                self?.activityIndicator.stopAnimating()
                
                if let user = user {
                    print("✅ Registration successful: \(user.firstName) \(user.lastName)")
                    
                    // Show success and navigate
                    self?.showSuccessAndNavigate()
                } else {
                    let message = self?.parseError(error) ?? "Произошла ошибка. Попробуйте снова."
                    self?.showAlert(title: "Ошибка регистрации", message: message)
                }
            }
        }
    }
    
    @objc private func goToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper Methods
    private func showSuccessAndNavigate() {
        let alert = UIAlertController(
            title: "Успех! 🎉",
            message: "Регистрация прошла успешно",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Продолжить", style: .default) { [weak self] _ in
            // Navigate to main app
            let mainTab = MainTabBarController()
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = mainTab
                window.makeKeyAndVisible()
            }
        })
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func parseError(_ error: Error?) -> String {
        guard let error = error else { return "Неизвестная ошибка" }
        
        let errorMessage = error.localizedDescription
        
        // Parse common Django errors
        if errorMessage.contains("outlook") || errorMessage.contains("already exists") {
            return "Этот email уже зарегистрирован"
        } else if errorMessage.contains("password") {
            return "Пароль слишком простой"
        } else if errorMessage.contains("required") {
            return "Заполните все обязательные поля"
        }
        
        return "Ошибка сервера. Попробуйте позже."
    }
    
    // MARK: - Keyboard Handling
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        // Tap to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
