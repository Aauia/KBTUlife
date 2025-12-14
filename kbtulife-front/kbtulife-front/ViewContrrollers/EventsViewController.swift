import UIKit

class EventsViewController: UIViewController {
    private let tableView = UITableView()
    private var events: [Event] = []
    
    private let filterButton = UIBarButtonItem(title: "Фильтры", style: .plain, target: EventsViewController.self, action: #selector(showFilters))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Events"
        navigationItem.rightBarButtonItem = filterButton
        
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
    
    private func fetchEvents(filters: [String: String] = [:]) {
        NetworkManager.shared.fetchEvents(filters: filters) { [weak self] events, error in
            DispatchQueue.main.async {
                if let events = events {
                    self?.events = events
                    self?.tableView.reloadData()
                } else {
                    print("Error fetching events: \(error?.localizedDescription ?? "Unknown")")
                }
            }
        }
    }
    
    @objc private func showFilters() {
        let filterVC = FiltersViewController()
        filterVC.onApply = { [weak self] filters in
            self?.fetchEvents(filters: filters)
        }
        let nav = UINavigationController(rootViewController: filterVC)
        present(nav, animated: true)
    }
}

// MARK: UITableViewDataSource & Delegate
extension EventsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        cell.configure(with: events[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = EventDetailViewController(event: events[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
