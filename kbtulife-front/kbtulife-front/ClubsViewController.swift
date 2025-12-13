import UIKit

class ClubsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Clubs"
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "Clubs page (coming soon)"
        label.textAlignment = .center
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
