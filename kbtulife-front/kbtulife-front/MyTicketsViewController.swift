import UIKit

class MyTicketsViewController: UIViewController {
    private let tableView = UITableView()
    private var tickets: [Ticket] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Мои билеты"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        fetchTickets()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TicketCell.self, forCellReuseIdentifier: "TicketCell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchTickets() {
        NetworkManager.shared.fetchMyTickets { [weak self] tickets, error in
            DispatchQueue.main.async {
                if let tickets = tickets {
                    self?.tickets = tickets
                    self?.tableView.reloadData()
                } else {
                    // Обработка ошибки (алерт или print)
                    print("Error fetching tickets: \(error?.localizedDescription ?? "Unknown")")
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension MyTicketsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as! TicketCell
        let ticket = tickets[indexPath.row]
        cell.configure(with: ticket)
        return cell
    }
}

// MARK: - UITableViewDelegate (опционально)
extension MyTicketsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300  // достаточно для QR + инфо
    }
}
