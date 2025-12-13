import UIKit

class EventsViewController: UIViewController {
    private let tableView = UITableView()
    private var events: [Event] = []
    private let filterButton = UIBarButtonItem(title: "Filters", style: .plain, target: self, action: #selector(showFilters))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Events"
        navigationItem.rightBarButtonItem = filterButton
        
        // register EventCell
        fetchEvents()
    }
    
    private func fetchEvents(filters: [String: String] = [:]) {
        var url = "events/"
        if !filters.isEmpty {
            let query = filters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            url += "?\(query)"
        }
        NetworkManager.shared.get(url: url) { [weak self] (events: [Event]?, error) in
            if let events = events {
                self?.events = events
                DispatchQueue.main.async { self?.tableView.reloadData() }
            }
        }
    }
    
    @objc private func showFilters() {
        let filterVC = FiltersViewController()
        filterVC.onApply = { [weak self] filters in
            self?.fetchEvents(filters: filters)
        }
        present(UINavigationController(rootViewController: filterVC), animated: true)
    }
}

// FiltersViewController.swift (modal sheet)
class FiltersViewController: UIViewController {
    var onApply: (([String: String]) -> Void)?
    private let freeSwitch = UISwitch()
    private let categoryPicker = UIPickerView()  // categories: ярмарки, семинары, guest lectures, психолог, выездное, parties, games
    
}
