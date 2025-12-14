import UIKit

class MyTicketsViewController: UIViewController {
    
    private var tickets: [Ticket] = []
    private var selectedTicket: Ticket?
    
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private var overlayView: UIView?
    private var detailView: UIView?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"  // ← новый: парсит полную дату с временем и Z
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)  // ← чтобы правильно обрабатывал UTC (Z)
        return formatter
    }()
    
    private var today: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    private func isEventInFutureOrToday(_ dateString: String) -> Bool {
        guard let eventDate = dateFormatter.date(from: dateString) else { return false }
        let eventDay = Calendar.current.startOfDay(for: eventDate)
        return eventDay >= today
    }
    
    private func isEventPast(_ dateString: String) -> Bool {
        guard let eventDate = dateFormatter.date(from: dateString) else { return true } // если не парсится — считаем прошлым
        let eventDay = Calendar.current.startOfDay(for: eventDate)
        return eventDay < today
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Tickets"
        view.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1) // #f8f9fa
        
        setupTableView()
        setupActivityIndicator()
        setupHeader()
        fetchTickets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTickets()
    }
    
    @objc private func refreshTickets() {
        fetchTickets() 
    }
    
    private func setupHeader() {
        let header = UIView()
        header.backgroundColor = .white
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        
        let titleLabel = UILabel()
        titleLabel.text = "My Tickets"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.05, green: 0.17, blue: 0.31, alpha: 1) // #0C2B4E
        
        let subtitleLabel = UILabel()
        subtitleLabel.font = .systemFont(ofSize: 15)
        subtitleLabel.textColor = .gray
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(stack)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            
            stack.topAnchor.constraint(equalTo: header.topAnchor, constant: 60),
            stack.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -16)
        ])
        
        self.subtitleLabel = subtitleLabel
    }
    
    private weak var subtitleLabel: UILabel?
    
    private func updateSubtitle(activeCount: Int) {
        subtitleLabel?.text = "\(activeCount) active ticket\(activeCount != 1 ? "s" : "")"
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TicketCardCell.self, forCellReuseIdentifier: "TicketCardCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func fetchTickets() {
        activityIndicator.startAnimating()
        
        NetworkManager.shared.get(url: "tickets/") { [weak self] (tickets: [Ticket]?, error: Error?) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                if let tickets = tickets {
                    self?.tickets = tickets
                    let activeCount = self?.activeTickets.count ?? 0
                    self?.updateSubtitle(activeCount: activeCount)
                    self?.tableView.reloadData()
                } else {
                    self?.showErrorAlert(message: error?.localizedDescription ?? "Failed to load tickets")
                }
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Show Ticket Detail Modal
    private func showTicketDetail(_ ticket: Ticket) {
        selectedTicket = ticket
        
        let overlay = UIView()
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.alpha = 0
        view.addSubview(overlay)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let detail = TicketDetailView(ticket: ticket)
        detail.layer.cornerRadius = 20
        detail.clipsToBounds = true
        detail.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        detail.alpha = 0
        
        overlay.addSubview(detail)
        detail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detail.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            detail.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),
            detail.widthAnchor.constraint(equalToConstant: 320),
            detail.heightAnchor.constraint(equalToConstant: 520)
        ])
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .gray
        closeButton.addTarget(self, action: #selector(hideTicketDetail), for: .touchUpInside)
        detail.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: detail.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: detail.trailingAnchor, constant: -16)
        ])
        
        self.overlayView = overlay
        self.detailView = detail
        
        UIView.animate(withDuration: 0.3) {
            overlay.alpha = 1
            detail.alpha = 1
            detail.transform = .identity
        }
    }
    
    @objc private func hideTicketDetail() {
        guard let overlay = overlayView, let detail = detailView else { return }
        
        UIView.animate(withDuration: 0.25, animations: {
            overlay.alpha = 0
            detail.alpha = 0
            detail.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            overlay.removeFromSuperview()
            detail.removeFromSuperview()
            self.overlayView = nil
            self.detailView = nil
            self.selectedTicket = nil
        }
    }
}

// MARK: - Active / Past Tickets by Date
extension MyTicketsViewController {
    private var activeTickets: [Ticket] {
        tickets.filter { ticket in
            ticket.paymentStatus == "paid" &&
            !ticket.used &&
            isEventInFutureOrToday(ticket.event.date)
        }
    }
    
    private var pastTickets: [Ticket] {
        tickets.filter { ticket in
            ticket.used ||
            ticket.paymentStatus != "paid" ||
            isEventPast(ticket.event.date)
        }
    }
}

// MARK: - UITableViewDataSource & Delegate
extension MyTicketsViewController: UITableViewDataSource, UITableViewDelegate {
    
    private var hasActiveTickets: Bool { !activeTickets.isEmpty }
    private var hasPastTickets: Bool { !pastTickets.isEmpty }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tickets.isEmpty { return 1 }
        var sections = 0
        if hasActiveTickets { sections += 1 }
        if hasPastTickets { sections += 1 }
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tickets.isEmpty { return 1 }
        if hasActiveTickets && section == 0 { return activeTickets.count }
        return pastTickets.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tickets.isEmpty { return nil }
        if hasActiveTickets && section == 0 { return "Active Tickets" }
        return "Past Events"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = self.tableView(tableView, titleForHeaderInSection: section) else { return nil }
        
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = (title == "Active Tickets") ? UIColor(red: 0.05, green: 0.17, blue: 0.31, alpha: 1) : .gray
        label.backgroundColor = .clear
        
        let container = UIView()
        container.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        return container
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tickets.isEmpty {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            
            let icon = UIImageView(image: UIImage(systemName: "ticket"))
            icon.tintColor = .lightGray
            icon.contentMode = .scaleAspectFit
            
            let title = UILabel()
            title.text = "No tickets yet"
            title.font = .systemFont(ofSize: 17)
            title.textAlignment = .center
            
            let subtitle = UILabel()
            subtitle.text = "Start exploring events to get your first ticket"
            subtitle.font = .systemFont(ofSize: 14)
            subtitle.textColor = .gray
            subtitle.textAlignment = .center
            
            let stack = UIStackView(arrangedSubviews: [icon, title, subtitle])
            stack.axis = .vertical
            stack.spacing = 12
            stack.alignment = .center
            
            cell.contentView.addSubview(stack)
            stack.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                icon.widthAnchor.constraint(equalToConstant: 80),
                icon.heightAnchor.constraint(equalToConstant: 80),
                stack.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                stack.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                stack.leadingAnchor.constraint(greaterThanOrEqualTo: cell.contentView.leadingAnchor, constant: 20),
                stack.trailingAnchor.constraint(lessThanOrEqualTo: cell.contentView.trailingAnchor, constant: -20)
            ])
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCardCell", for: indexPath) as! TicketCardCell
        
        let ticket: Ticket = (hasActiveTickets && indexPath.section == 0) ? activeTickets[indexPath.row] : pastTickets[indexPath.row]
        
        cell.configure(with: ticket) { [weak self] in
            self?.showTicketDetail(ticket)
        }
        
        cell.isUsed = pastTickets.contains(where: { $0.id == ticket.id })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tickets.isEmpty ? 300 : 180
    }
}
