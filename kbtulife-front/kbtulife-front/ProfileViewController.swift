import UIKit

class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "Profile page"
        label.textAlignment = .center
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
