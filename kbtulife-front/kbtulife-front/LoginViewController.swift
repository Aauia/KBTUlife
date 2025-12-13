import UIKit

class LoginViewController: UIViewController {
    private let outlookTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Вход"
        view.backgroundColor = .systemBackground
        
        outlookTextField.placeholder = "Outlook email (@kbtu.kz)"
        outlookTextField.keyboardType = .emailAddress
        outlookTextField.borderStyle = .roundedRect
        
        passwordTextField.placeholder = "Пароль"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        
        loginButton.setTitle("Войти", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 12
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [outlookTextField, passwordTextField, loginButton])
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
        guard let outlook = outlookTextField.text, !outlook.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Ошибка", message: "Заполните все поля")
            return
        }
        
        loginButton.isEnabled = false
        loginButton.setTitle("Вход...", for: .normal)
        
        NetworkManager.shared.login(outlook: outlook, password: password) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.loginButton.isEnabled = true
                self?.loginButton.setTitle("Войти", for: .normal)
                
                if success {
                    let mainTab = MainTabBarController()
                    UIApplication.shared.windows.first?.rootViewController = mainTab
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                } else {
                    let message = error?.localizedDescription ?? "Неверный email или пароль"
                    self?.showAlert(title: "Ошибка входа", message: message)
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
