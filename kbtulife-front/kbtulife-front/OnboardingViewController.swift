import UIKit

class OnboardingViewController: UIViewController {
    private let welcomeLabel = UILabel()
    private let registerButton = UIButton(type: .system)
    private let loginButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        welcomeLabel.text = "Добро пожаловать в KBTU Life!"
        welcomeLabel.font = .boldSystemFont(ofSize: 28)
        welcomeLabel.textAlignment = .center
        
        registerButton.setTitle("Регистрация", for: .normal)
        registerButton.backgroundColor = .systemBlue
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 10
        registerButton.addTarget(self, action: #selector(goToRegistration), for: .touchUpInside)
        
        loginButton.setTitle("Войти", for: .normal)
        loginButton.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [welcomeLabel, registerButton, loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc private func goToRegistration() {
        navigationController?.pushViewController(RegistrationViewController(), animated: true)
    }
    
    @objc private func goToLogin() {
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
}
