import UIKit

class AdminDashboardViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Admin"
        view.backgroundColor = .systemRed.withAlphaComponent(0.1)
        
        let label = UILabel()
        label.text = "Admin Dashboard (only for staff)"
        label.textAlignment = .center
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
