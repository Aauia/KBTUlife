import UIKit

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "Login form"
        label.textAlignment = .center
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
