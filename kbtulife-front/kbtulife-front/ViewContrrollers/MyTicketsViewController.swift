import UIKit

class MyTicketsViewController: UIViewController {
    
    // MARK: - Properties
    private var tickets: [Ticket] = []
    private var selectedTicket: Ticket?
    
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private var overlayView: UIView?
    private var detailView: UIView?
    
    private weak var subtitleLabel: UILabel?
    private let headerView = UIView()
    
    private let dateFormatter = DateFormatter.inputFormatter
    
    private var today: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    private func isEventInFutureOrToday(_ dateString: String) -> Bool {
        guard let eventDate = dateFormatter.date(from: dateString) else { return false }
        let eventDay = Calendar.current.startOfDay(for: eventDate)
        return eventDay >= today
    }
    
    private func isEventPast(_ dateString: String) -> Bool {
        guard let eventDate = dateFormatter.date(from: dateString) else { return true }
        let eventDay = Calendar.current.startOfDay(for: eventDate)
        return eventDay < today
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1)
        
        setupHeader()
        setupTableView()
        setupActivityIndicator()
        
        fetchTickets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTickets()
    }
    
    @objc private func refreshTickets() {
        fetchTickets()
    }
    
    // MARK: - Setup UI
    
    private func setupHeader() {
        let header = headerView
        header.backgroundColor = .white
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        
        let titleLabel = UILabel()
        titleLabel.text = "My Tickets"
        titleLabel.font = .systemFont(ofSize: 30, weight: .black)
        titleLabel.textColor = UIColor(red: 0.05, green: 0.17, blue: 0.31, alpha: 1)
        
        let subLabel = UILabel()
        subLabel.font = .systemFont(ofSize: 15)
        subLabel.textColor = .gray
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, subLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(stack)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -16)
        ])
        
        self.subtitleLabel = subLabel
    }
    
    private func updateSubtitle(activeCount: Int) {
        let countString = activeCount == 0 ? "No active tickets" : "\(activeCount) active ticket\(activeCount != 1 ? "s" : "")"
        subtitleLabel?.text = countString
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TicketCardCell.self, forCellReuseIdentifier: "TicketCardCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        // Добавляем отступ сверху, чтобы первый заголовок секции не был слишком близко
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
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
        
        guard let detail = TicketDetailView(ticket: ticket) as? UIView else { return }
        
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
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .gray
        closeButton.addTarget(self, action: #selector(hideTicketDetail), for: .touchUpInside)
        detail.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: detail.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: detail.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24)
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

// MARK: - Ticket Management
extension MyTicketsViewController {
    private var activeTickets: [Ticket] {
        tickets.filter { ticket in
            let isPaidOrFree = ticket.paymentStatus == "paid" || ticket.event.isFree
            return !ticket.used && isEventInFutureOrToday(ticket.event.date) && isPaidOrFree
        }
    }
    
    private var pastTickets: [Ticket] {
        tickets.filter { ticket in
            let isUnpaidAndPaidEvent = !ticket.event.isFree && ticket.paymentStatus != "paid"
            return ticket.used || isEventPast(ticket.event.date) || isUnpaidAndPaidEvent
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
        
        if hasActiveTickets {
            if section == 0 { return activeTickets.count }
            if section == 1 { return pastTickets.count }
        }
        
        if hasPastTickets && section == 0 { return pastTickets.count }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tickets.isEmpty { return nil }
        
        if hasActiveTickets {
            if section == 0 { return "Active Tickets" }
            if section == 1 { return "Past Events" }
        } else if hasPastTickets && section == 0 {
            return "Past Events"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = self.tableView(tableView, titleForHeaderInSection: section) else { return nil }
        
        let container = UIView()
        container.backgroundColor = .clear
        
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        // Устанавливаем цвет в зависимости от секции
        label.textColor = (title == "Active Tickets") ? UIColor(red: 0.05, green: 0.17, blue: 0.31, alpha: 1) : .gray
        
        let backgroundView = UIView()
        // Устанавливаем белый фон для секции, чтобы он не был прозрачным при прокрутке
        backgroundView.backgroundColor = .white
        
        container.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: container.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        container.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])
        
        return container
    }
    
    // MARK: - Custom Header Height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tickets.isEmpty {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
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
                stack.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor, constant: -50),
                stack.leadingAnchor.constraint(greaterThanOrEqualTo: cell.contentView.leadingAnchor, constant: 20),
                stack.trailingAnchor.constraint(lessThanOrEqualTo: cell.contentView.trailingAnchor, constant: -20)
            ])
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCardCell", for: indexPath) as? TicketCardCell else {
            return UITableViewCell()
        }
        
        var ticket: Ticket
        var isPast = false
        
        if hasActiveTickets {
            if indexPath.section == 0 {
                ticket = activeTickets[indexPath.row]
            } else {
                ticket = pastTickets[indexPath.row]
                isPast = true
            }
        } else {
            ticket = pastTickets[indexPath.row]
            isPast = true
        }
        
        cell.configure(with: ticket) { [weak self] in
            self?.showTicketDetail(ticket)
        }
        
        cell.isUsed = isPast
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tickets.isEmpty ? tableView.frame.height - 100 : 180
    }
}

// MARK: - DateFormatters
extension DateFormatter {
    
    static let inputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    static let eventDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let eventWeekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let eventTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale.current
        return formatter
    }()
    
    static func fullEventDateTime(from dateString: String) -> String {
        guard let date = DateFormatter.inputFormatter.date(from: dateString) else {
            return "Unknown Date"
        }
        
        let weekday = DateFormatter.eventWeekdayFormatter.string(from: date)
        let day = DateFormatter.eventDayFormatter.string(from: date)
        let time = DateFormatter.eventTimeFormatter.string(from: date)
        
        let capitalizedWeekday = weekday.prefix(1).uppercased() + weekday.dropFirst()
        
        return "\(capitalizedWeekday), \(day), \(time)"
    }
}
