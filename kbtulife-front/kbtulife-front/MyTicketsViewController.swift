import UIKit

class MyTicketsViewController: UIViewController {
    private let tableView = UITableView()
    private var tickets: [Ticket] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Tickets"
        view.backgroundColor = .systemBackground
        
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
        
        fetchTickets()
    }
    
    private func fetchTickets() {
        NetworkManager.shared.fetchMyTickets { [weak self] tickets, error in
            DispatchQueue.main.async {
                if let tickets = tickets {
                    self?.tickets = tickets
                    self?.tableView.reloadData()
                } else {
                    print("Error fetching tickets: \(error?.localizedDescription ?? "Unknown")")
                    // Можно добавить алерт
                }
            }
        }
    }
}

extension MyTicketsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as! TicketCell
        cell.configure(with: tickets[indexPath.row])
        return cell
    }
}
