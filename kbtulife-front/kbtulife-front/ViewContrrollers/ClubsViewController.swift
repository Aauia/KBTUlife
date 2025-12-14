import UIKit

class ClubsViewController: UIViewController {
    
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var clubs: [Club] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Клубы"
        view.backgroundColor = .systemBackground
        
        setupUI()
        loadClubs()
    }
    
    private func setupUI() {
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ClubCell.self, forCellReuseIdentifier: "ClubCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Activity Indicator
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Add refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshClubs), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func loadClubs() {
        activityIndicator.startAnimating()
        
        NetworkManager.shared.fetchClubs { [weak self] clubs, error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.tableView.refreshControl?.endRefreshing()
                
                if let clubs = clubs {
                    self?.clubs = clubs
                    self?.tableView.reloadData()
                } else if let error = error {
                    self?.showError(message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func refreshClubs() {
        loadClubs()
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - TableView DataSource
extension ClubsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClubCell", for: indexPath) as? ClubCell else {
            return UITableViewCell()
        }
        
        let club = clubs[indexPath.row]
        cell.configure(with: club)
        return cell
    }
}

// MARK: - TableView Delegate
extension ClubsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let club = clubs[indexPath.row]
        let detailVC = ClubDetailViewController(club: club)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
