import UIKit

class MyTicketsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var tickets: [Ticket] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchTickets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTickets() // обновляем при каждом появлении
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TicketCell.self, forCellReuseIdentifier: "TicketCell")
        // или UINib если из xib/storyboard
    }
    
    private func fetchTickets() {
        NetworkManager.shared.get(url: "tickets/") { [weak self] (tickets: [Ticket]?, error: Error?) in
            DispatchQueue.main.async {
                if let tickets = tickets {
                    self?.tickets = tickets
                    self?.tableView.reloadData()
                    print("Загружено билетов: \(tickets.count)")
                } else {
                    print("Ошибка загрузки билетов: \(error?.localizedDescription ?? "Unknown error")")
                    self?.showErrorAlert(message: error?.localizedDescription ?? "Не удалось загрузить билеты")
                }
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MyTicketsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as! TicketCell
        cell.configure(with: tickets[indexPath.row])
        return cell
    }
}

extension MyTicketsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // можно открыть деталку билета или QR-код
    }
}
