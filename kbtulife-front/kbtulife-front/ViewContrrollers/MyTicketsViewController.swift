import UIKit

class MyTicketsViewController: UIViewController {

    private var tickets: [Ticket] = []
    private var selectedTicket: Ticket?

    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let headerView = UIView()

    private var overlayView: UIView?
    private var detailView: UIView?

    private weak var subtitleLabel: UILabel?

    private let dateFormatter = DateFormatter.inputFormatter

    private var today: Date {
        Calendar.current.startOfDay(for: Date())
    }

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

    private func setupHeader() {
        headerView.backgroundColor = .white
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("tickets_title", comment: "")
        titleLabel.font = .systemFont(ofSize: 30, weight: .black)
        titleLabel.textColor = UIColor(red: 0.05, green: 0.17, blue: 0.31, alpha: 1)

        let subLabel = UILabel()
        subLabel.font = .systemFont(ofSize: 15)
        subLabel.textColor = .gray

        let stack = UIStackView(arrangedSubviews: [titleLabel, subLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(stack)

        subtitleLabel = subLabel

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16)
        ])
    }

    private func updateSubtitle(activeCount: Int) {
        let key: String
        switch activeCount {
        case 0: key = "active_tickets_subtitle_zero"
        case 1: key = "active_tickets_subtitle_one"
        default: key = "active_tickets_subtitle_many"
        }
        subtitleLabel?.text = String(format: NSLocalizedString(key, comment: ""), activeCount)
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
                    self?.showErrorAlert(message: error?.localizedDescription ?? "")
                }
            }
        }
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("error_title", comment: ""),
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

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

        overlayView = overlay
        detailView = detail

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

    private var activeTickets: [Ticket] {
        tickets.filter { !$0.used && isEventInFutureOrToday($0.event.date) }
    }

    private var pastTickets: [Ticket] {
        tickets.filter { $0.used || isEventPast($0.event.date) }
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
}

extension MyTicketsViewController: UITableViewDataSource, UITableViewDelegate {

    private var hasActiveTickets: Bool { !activeTickets.isEmpty }
    private var hasPastTickets: Bool { !pastTickets.isEmpty }

    func numberOfSections(in tableView: UITableView) -> Int {
        tickets.isEmpty ? 1 : (hasActiveTickets ? 1 : 0) + (hasPastTickets ? 1 : 0)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tickets.isEmpty { return 1 }

        if hasActiveTickets {
            return section == 0 ? activeTickets.count : pastTickets.count
        }
        return pastTickets.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !tickets.isEmpty else { return nil }

        if hasActiveTickets {
            return section == 0 ? NSLocalizedString("active_tickets_header", comment: "") : NSLocalizedString("past_tickets_header", comment: "")
        }
        return NSLocalizedString("past_tickets_header", comment: "")
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = self.tableView(tableView, titleForHeaderInSection: section) else { return nil }

        let container = UIView()
        container.backgroundColor = .clear

        let backgroundView = UIView()
        backgroundView.backgroundColor = .white

        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = title == NSLocalizedString("active_tickets_header", comment: "") ?
            UIColor(red: 0.05, green: 0.17, blue: 0.31, alpha: 1) : .gray

        container.addSubview(backgroundView)
        container.addSubview(label)

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: container.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])

        return container
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
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
            title.text = NSLocalizedString("no_tickets_title", comment: "")
            title.font = .systemFont(ofSize: 17)
            title.textAlignment = .center

            let subtitle = UILabel()
            subtitle.text = NSLocalizedString("no_tickets_subtitle", comment: "")
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

        let ticket: Ticket
        let isPast: Bool

        if hasActiveTickets && indexPath.section == 0 {
            ticket = activeTickets[indexPath.row]
            isPast = false
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
        tickets.isEmpty ? tableView.frame.height - 100 : 180
    }
}

extension DateFormatter {
    static let inputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    static func fullEventDateTime(from dateString: String) -> String {
        guard let date = inputFormatter.date(from: dateString) else { return "Unknown Date" }

        let day = date.formatted(.dateTime.day().month())
        let weekday = date.formatted(.dateTime.weekday(.wide)).capitalized
        let time = date.formatted(.dateTime.hour().minute())

        return "📅 \(weekday), \(day), \(time)"
    }

    static func formatPurchasedDate(from dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = formatter.date(from: dateString) else {
            return NSLocalizedString("unknown_date", comment: "")
        }

        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short
        displayFormatter.locale = Locale.current

        return displayFormatter.string(from: date)
    }
}
