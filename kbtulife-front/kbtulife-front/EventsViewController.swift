import UIKit

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Events"
        view.backgroundColor = .systemBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        fetchEvents()
    }
    
    private func fetchEvents() {
        NetworkManager.shared.fetchEvents { [weak self] events, error in
            if let events = events {
                self?.events = events
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } else {
                // Показать алерт об ошибке
                print("Error: \(error?.localizedDescription ?? "Unknown")")
            }
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        let event = events[indexPath.row]
        cell.configure(with: event)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = EventDetailViewController(event: events[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
