import UIKit

class RegistrationViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registration"
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "Registration form (in development)"
        label.textAlignment = .center
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
