import UIKit

class EventsViewController: UIViewController {
    private let tableView = UITableView()
    private var allEvents: [Event] = []
    private var filteredEvents: [Event] = []
    
    private var selectedPriceFilter: PriceFilter = .all
    private var selectedCategory: String = "All"
    
    private let searchButton = UIButton(type: .system)
    
    enum PriceFilter: String, CaseIterable {
        case all = "All"
        case free = "Free"
        case paid = "Paid"
    }
    
    private let categories = ["Все", "Ярмарки", "Семинары", "Guest lectures", "Психолог", "Выездное", "Вечеринки", "Игры", "Хакатоны", "Воркшопы"]
    
    private let categoryDisplayNames: [String: String] = [
        "fairs": "Ярмарки",
        "seminars": "Семинары",
        "lectures": "Guest lectures",
        "psychologist": "Психолог",
        "offsite": "Выездное",
        "parties": "Вечеринки",
        "games": "Игры",
        "Hackathons": "Хакатоны",
        "Workshops": "Воркшопы"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Events"
        view.backgroundColor = UIColor(hex: "#F8F9FA")
        
        setupSearchButton()
        setupTableView()
        setupHeaderView()
        
        fetchEvents()
    }
    
    private func setupSearchButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        searchButton.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: config), for: .normal)
        searchButton.tintColor = UIColor(hex: "#0C2B4E")
        searchButton.backgroundColor = UIColor(hex: "#F8F9FA")
        searchButton.layer.cornerRadius = 14
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
    }
    
    @objc private func searchTapped() {
        let alert = UIAlertController(title: "Поиск", message: "Поиск событий (в разработке)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140), // под header
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupHeaderView() {
        let header = UIView()
        header.backgroundColor = .white
        
        let priceStack = UIStackView()
        priceStack.spacing = 8
        for filter in PriceFilter.allCases {
            let button = UIButton(type: .system)
            button.setTitle(filter.rawValue, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14)
            button.backgroundColor = selectedPriceFilter == filter ? UIColor(hex: "#0C2B4E") : UIColor(hex: "#F8F9FA")
            button.setTitleColor(selectedPriceFilter == filter ? .white : .label, for: .normal)
            button.layer.cornerRadius = 12
            button.tag = PriceFilter.allCases.firstIndex(of: filter)!
            button.addTarget(self, action: #selector(priceFilterTapped(_:)), for: .touchUpInside)
            priceStack.addArrangedSubview(button)
            button.heightAnchor.constraint(equalToConstant: 36).isActive = true
        }
        
        let categoryScroll = UIScrollView()
        categoryScroll.showsHorizontalScrollIndicator = false
        let categoryStack = UIStackView()
        categoryStack.spacing = 8
        
        for category in categories {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14)
            let isSelected = selectedCategory == category
            button.backgroundColor = isSelected ? UIColor(hex: "#608BC1") : UIColor(hex: "#CBDCEB")
            button.setTitleColor(isSelected ? .white : .label, for: .normal)
            button.layer.cornerRadius = 12
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
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
        
        // Stack header
        let headerStack = UIStackView(arrangedSubviews: [priceStack, categoryScroll])
        headerStack.axis = .vertical
        headerStack.spacing = 12
        
        view.addSubview(header)
        header.addSubview(headerStack)
        
        header.translatesAutoresizingMaskIntoConstraints = false
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 140),
            
            headerStack.topAnchor.constraint(equalTo: header.topAnchor, constant: 16),
            headerStack.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 24),
            headerStack.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -24),
            headerStack.bottomAnchor.constraint(lessThanOrEqualTo: header.bottomAnchor, constant: -16)
        ])
        
        header.layer.shadowColor = UIColor.black.cgColor
        header.layer.shadowOpacity = 0.08
        header.layer.shadowOffset = CGSize(width: 0, height: 2)
        header.layer.shadowRadius = 4
    }
    
    @objc private func priceFilterTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index >= 0 && index < PriceFilter.allCases.count else { return }
        
        selectedPriceFilter = PriceFilter.allCases[index]
        setupHeaderView()
        applyFilters()
    }
    
    @objc private func categoryTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        selectedCategory = title
        setupHeaderView()
        applyFilters()
    }
    
    private func applyFilters() {
        var filtered = allEvents
        
        // Фильтр по цене
        switch selectedPriceFilter {
        case .free:
            filtered = filtered.filter { $0.isFree }
        case .paid:
            filtered = filtered.filter { !$0.isFree }
        case .all:
            break
        }
        
        // Фильтр по категории
        if selectedCategory != "All" {
            filtered = filtered.filter { $0.category.localizedCaseInsensitiveContains(selectedCategory) }
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.isEmpty ? 1 : filteredEvents.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredEvents.isEmpty ? nil : "Events"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if filteredEvents.isEmpty {
            let cell = UITableViewCell()
            cell.textLabel?.text = "No events found"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .secondaryLabel
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        let event = filteredEvents[indexPath.row]
        cell.configure(with: event)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard !filteredEvents.isEmpty else { return }
        
        let event = filteredEvents[indexPath.row]
        let detailVC = EventDetailViewController(event: event)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return filteredEvents.isEmpty ? 200 : 160
    }
}
