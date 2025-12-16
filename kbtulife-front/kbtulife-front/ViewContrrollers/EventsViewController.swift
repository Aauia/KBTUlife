import UIKit

class EventsViewController: UIViewController {

    private let headerContainer = UIView()
    private let tableView = UITableView()

    private var allEvents: [Event] = []
    private var filteredEvents: [Event] = []

    private var selectedPriceFilter: PriceFilter = .all
    private var selectedCategory: String = ""

    let searchButton = UIButton(type: .system)

    enum PriceFilter: String, CaseIterable {
        case all = "price_filter_all"
        case free = "price_filter_free"
        case paid = "price_filter_paid"
    }

    private let categories: [String] = [
        NSLocalizedString("category_all", comment: ""),
        NSLocalizedString("category_fairs", comment: ""),
        NSLocalizedString("category_seminars", comment: ""),
        NSLocalizedString("category_lectures", comment: ""),
        NSLocalizedString("category_psychologist", comment: ""),
        NSLocalizedString("category_offsite", comment: ""),
        NSLocalizedString("category_parties", comment: ""),
        NSLocalizedString("category_games", comment: ""),
        NSLocalizedString("category_hackathons", comment: ""),
        NSLocalizedString("category_workshops", comment: "")
    ]

    private let categoryBackendMap: [String: String?] = [
        NSLocalizedString("category_all", comment: ""): nil,
        NSLocalizedString("category_fairs", comment: ""): "fairs",
        NSLocalizedString("category_seminars", comment: ""): "seminars",
        NSLocalizedString("category_lectures", comment: ""): "lectures",
        NSLocalizedString("category_psychologist", comment: ""): "psychologist",
        NSLocalizedString("category_offsite", comment: ""): "offsite",
        NSLocalizedString("category_parties", comment: ""): "parties",
        NSLocalizedString("category_games", comment: ""): "games",
        NSLocalizedString("category_hackathons", comment: ""): "Hackathons",
        NSLocalizedString("category_workshops", comment: ""): "Workshops"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("events", comment: "")
        view.backgroundColor = UIColor(hex: "#F8F9FA")

        selectedCategory = categories[0]

        setupSearchButton()
        setupHeaderView()
        setupTableView()

        fetchEvents()
    }

    private func setupSearchButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        searchButton.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: config), for: .normal)
        searchButton.tintColor = UIColor(hex: "#0C2B4E")
        searchButton.layer.cornerRadius = 14
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
    }

    private func setupHeaderView() {
        headerContainer.backgroundColor = .white
        view.addSubview(headerContainer)
        headerContainer.translatesAutoresizingMaskIntoConstraints = false

        let priceStack = UIStackView()
        priceStack.spacing = 8
        priceStack.distribution = .fillProportionally
        priceStack.tag = 100

        for filter in PriceFilter.allCases {
            let button = UIButton(type: .system)
            button.setTitle(NSLocalizedString(filter.rawValue, comment: ""), for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14)
            button.layer.cornerRadius = 12
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            button.tag = PriceFilter.allCases.firstIndex(of: filter)! + 200
            button.addTarget(self, action: #selector(priceFilterTapped(_:)), for: .touchUpInside)
            button.heightAnchor.constraint(equalToConstant: 36).isActive = true
            priceStack.addArrangedSubview(button)
        }

        let categoryScroll = UIScrollView()
        categoryScroll.showsHorizontalScrollIndicator = false
        categoryScroll.tag = 300

        let categoryStack = UIStackView()
        categoryStack.spacing = 8
        categoryStack.tag = 301

        for (index, category) in categories.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14)
            button.layer.cornerRadius = 12
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            button.tag = index + 400
            button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
            button.heightAnchor.constraint(equalToConstant: 36).isActive = true
            categoryStack.addArrangedSubview(button)
        }

        categoryScroll.addSubview(categoryStack)
        categoryStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryStack.topAnchor.constraint(equalTo: categoryScroll.topAnchor),
            categoryStack.leadingAnchor.constraint(equalTo: categoryScroll.leadingAnchor),
            categoryStack.trailingAnchor.constraint(equalTo: categoryScroll.trailingAnchor),
            categoryStack.bottomAnchor.constraint(equalTo: categoryScroll.bottomAnchor),
            categoryStack.heightAnchor.constraint(equalTo: categoryScroll.heightAnchor)
        ])

        let headerStack = UIStackView(arrangedSubviews: [priceStack, categoryScroll])
        headerStack.axis = .vertical
        headerStack.spacing = 12

        headerContainer.addSubview(headerStack)
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: 110),

            headerStack.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 16),
            headerStack.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 24),
            headerStack.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -24),
            headerStack.bottomAnchor.constraint(lessThanOrEqualTo: headerContainer.bottomAnchor, constant: -16)
        ])

        headerContainer.layer.shadowColor = UIColor.black.cgColor
        headerContainer.layer.shadowOpacity = 0.08
        headerContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        headerContainer.layer.shadowRadius = 4

        updateFilterUI()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func updateFilterUI() {
        if let priceStack = headerContainer.viewWithTag(100) as? UIStackView {
            for case let button as UIButton in priceStack.arrangedSubviews {
                let index = button.tag - 200
                guard index >= 0 && index < PriceFilter.allCases.count else { continue }
                let filter = PriceFilter.allCases[index]
                let isSelected = selectedPriceFilter == filter
                button.backgroundColor = isSelected ? UIColor(hex: "#0C2B4E") : UIColor(hex: "#F8F9FA")
                button.setTitleColor(isSelected ? .white : .label, for: .normal)
            }
        }

        if let categoryScroll = headerContainer.viewWithTag(300) as? UIScrollView,
           let categoryStack = categoryScroll.viewWithTag(301) as? UIStackView {
            for case let button as UIButton in categoryStack.arrangedSubviews {
                guard let title = button.title(for: .normal) else { continue }
                let isSelected = selectedCategory == title
                button.backgroundColor = isSelected ? UIColor(hex: "#608BC1") : UIColor(hex: "#CBDCEB")
                button.setTitleColor(isSelected ? .white : UIColor(hex: "#0C2B4E"), for: .normal)
            }
        }
    }

    @objc private func searchTapped() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }

    @objc private func priceFilterTapped(_ sender: UIButton) {
        let index = sender.tag - 200
        guard index >= 0 && index < PriceFilter.allCases.count else { return }
        selectedPriceFilter = PriceFilter.allCases[index]
        updateFilterUI()
        applyFilters()
    }

    @objc private func categoryTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        selectedCategory = title
        updateFilterUI()
        applyFilters()
    }

    private func applyFilters() {
        var filtered = allEvents

        switch selectedPriceFilter {
        case .free: filtered = filtered.filter { $0.isFree }
        case .paid: filtered = filtered.filter { !$0.isFree }
        case .all: break
        }

        if let backendKey = categoryBackendMap[selectedCategory], let key = backendKey {
            filtered = filtered.filter { $0.category == key }
        }

        filteredEvents = filtered
        tableView.reloadData()
    }

    private func fetchEvents() {
        NetworkManager.shared.fetchEvents { [weak self] events, error in
            DispatchQueue.main.async {
                if let events = events {
                    self?.allEvents = events
                    self?.applyFilters()
                } else {
                    print("Error loading events: \(error?.localizedDescription ?? "unknown")")
                }
            }
        }
    }
}

extension EventsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.isEmpty ? 1 : filteredEvents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if filteredEvents.isEmpty {
            let cell = UITableViewCell()
            cell.textLabel?.text = NSLocalizedString("no_events_found", comment: "")
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .secondaryLabel
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventCell else {
            return UITableViewCell()
        }
        cell.configure(with: filteredEvents[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard !filteredEvents.isEmpty else { return }
        let detailVC = EventDetailViewController(event: filteredEvents[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return filteredEvents.isEmpty ? 200 : 160
    }
}
