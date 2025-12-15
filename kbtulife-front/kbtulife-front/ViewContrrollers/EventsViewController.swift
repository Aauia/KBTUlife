import UIKit

class EventsViewController: UIViewController {
    
    // MARK: - Properties
    private let headerContainer = UIView() // Контейнер для header, создаем один раз
    private let tableView = UITableView()
    
    private var allEvents: [Event] = []
    private var filteredEvents: [Event] = []
    
    private var selectedPriceFilter: PriceFilter = .all
    private var selectedCategory: String = "Все" // Изменено на русский "Все"
    
    let searchButton = UIButton(type: .system)
    
    enum PriceFilter: String, CaseIterable {
        case all = "Все" // Изменено на русский "Все"
        case free = "Бесплатно" // Изменено на русский "Бесплатно"
        case paid = "Платно" // Изменено на русский "Платно"
    }
    
    // Ключи категорий в нижнем регистре для корректной фильтрации (если API использует их)
    private let categories = ["Все", "Ярмарки", "Семинары", "Guest lectures", "Психолог", "Выездное", "Вечеринки", "Игры", "Хакатоны", "Воркшопы"]
    
    // Используется для отображения, если API вернет ключи на английском
    private let categoryDisplayNames: [String: String] = [
        "fairs": "Ярмарки",
        "seminars": "Семинары",
        "lectures": "Guest lectures",
        "psychologist": "Психолог",
        "offsite": "Выездное",
        "parties": "Вечеринки",
        "games": "Игры",
        "hackathons": "Хакатоны",
        "workshops": "Воркшопы"
    ]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Events"
        view.backgroundColor = UIColor(hex: "#F8F9FA")
        
        setupSearchButton()
        setupHeaderView() // Создаем заголовок один раз
        setupTableView()
        
        fetchEvents()
    }
    
    // MARK: - Setup UI
    
    private func setupSearchButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        searchButton.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: config), for: .normal)
        searchButton.tintColor = UIColor(hex: "#0C2B4E")
        // Удалено: searchButton.backgroundColor = UIColor(hex: "#F8F9FA")
        searchButton.layer.cornerRadius = 14
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
    }
    
    private func setupHeaderView() {
        // 1. Контейнер
        headerContainer.backgroundColor = .white
        view.addSubview(headerContainer)
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // 2. Стек для фильтров по цене
        let priceStack = UIStackView()
        priceStack.spacing = 8
        priceStack.distribution = .fillProportionally
        priceStack.tag = 100 // Tag для быстрого доступа в updateFilterUI
        
        for filter in PriceFilter.allCases {
            let button = UIButton(type: .system)
            button.setTitle(filter.rawValue, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14)
            button.layer.cornerRadius = 12
            // Устанавливаем tag для идентификации при нажатии
            button.tag = PriceFilter.allCases.firstIndex(of: filter)! + 200
            button.addTarget(self, action: #selector(priceFilterTapped(_:)), for: .touchUpInside)
            priceStack.addArrangedSubview(button)
            button.heightAnchor.constraint(equalToConstant: 36).isActive = true
            // Добавим горизонтальный padding для кнопок
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        }
        
        // 3. Стек для категорий (внутри ScrollView)
        let categoryScroll = UIScrollView()
        categoryScroll.showsHorizontalScrollIndicator = false
        categoryScroll.tag = 300 // Tag для быстрого доступа
        
        let categoryStack = UIStackView()
        categoryStack.spacing = 8
        categoryStack.tag = 301
        
        for (index, category) in categories.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14)
            button.layer.cornerRadius = 12
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
            button.tag = index + 400 // Tag для идентификации
            categoryStack.addArrangedSubview(button)
            // Фиксируем высоту для кнопок категорий
            button.heightAnchor.constraint(equalToConstant: 36).isActive = true
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
        
        // 4. Главный стек header'а
        let headerStack = UIStackView(arrangedSubviews: [priceStack, categoryScroll])
        headerStack.axis = .vertical
        headerStack.spacing = 12
        
        headerContainer.addSubview(headerStack)
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Констрейнты headerContainer
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: 110), // Уменьшили высоту для компактности
            
            headerStack.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 16),
            headerStack.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 24),
            headerStack.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -24),
            headerStack.bottomAnchor.constraint(lessThanOrEqualTo: headerContainer.bottomAnchor, constant: -16)
        ])
        
        // Тень (лучше настраивать только один раз)
        headerContainer.layer.shadowColor = UIColor.black.cgColor
        headerContainer.layer.shadowOpacity = 0.08
        headerContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        headerContainer.layer.shadowRadius = 4
        
        // Изначальная настройка UI
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
            // Таблица начинается сразу под Header (высота 110)
            tableView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Update Logic
    
    private func updateFilterUI() {
        // Обновление кнопок PriceFilter (Tag 200+)
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
        
        // Обновление кнопок Category (Tag 400+)
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
    
    // MARK: - Actions
    
    @objc private func searchTapped() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc private func priceFilterTapped(_ sender: UIButton) {
        let index = sender.tag - 200
        guard index >= 0 && index < PriceFilter.allCases.count else { return }
        
        selectedPriceFilter = PriceFilter.allCases[index]
        updateFilterUI() // Просто обновляем UI, не пересоздавая его
        applyFilters()
    }
    
    @objc private func categoryTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        selectedCategory = title
        updateFilterUI() // Просто обновляем UI
        applyFilters()
    }
    
    // MARK: - Data Handling
    
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
        if selectedCategory != "Все" { // Исправлено на русский "Все"
            filtered = filtered.filter { event in
                // Используем локализованное имя категории или оригинальное, если локализация не найдена
                let eventCategoryString = categoryDisplayNames[event.category.lowercased()] ?? event.category
                return eventCategoryString.localizedCaseInsensitiveContains(selectedCategory) ||
                       event.category.localizedCaseInsensitiveContains(selectedCategory)
            }
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

// MARK: - UITableViewDataSource, UITableViewDelegate

extension EventsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.isEmpty ? 1 : filteredEvents.count
    }
    
    // Убираем titleForHeaderInSection, так как у вас кастомный header
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if filteredEvents.isEmpty {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Событий не найдено" // Локализовано
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .secondaryLabel
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventCell else {
            return UITableViewCell()
        }
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
        // Изменение высоты ячейки для сообщения "Событий не найдено"
        return filteredEvents.isEmpty ? 200 : 160
    }
}
