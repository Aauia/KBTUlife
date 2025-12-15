import UIKit

class NewsViewController: UIViewController {
    
    private let headerView = UIView()
    private let tableView = UITableView()
    
    private var newsItems: [NewsItem] = []
    private var filteredNews: [NewsItem] = []
    
    private var unreadCount = 3
    let searchButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F8F9FA")
        
        setupHeader()
        setupSearchButton()
        setupTableView()
        fetchNews()
    }
    
    private func setupHeader() {
        headerView.backgroundColor = .white
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "kbtu_logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true
        
        let bellButton = UIButton(type: .system)
        bellButton.setImage(UIImage(systemName: "bell"), for: .normal)
        bellButton.tintColor = UIColor(hex: "#0C2B4E")
        bellButton.addTarget(self, action: #selector(showNotifications), for: .touchUpInside)
        
        if unreadCount > 0 {
            let badge = UILabel()
            badge.text = "\(unreadCount)"
            badge.font = .systemFont(ofSize: 10, weight: .heavy)
            badge.textColor = .white
            badge.backgroundColor = .systemRed
            badge.textAlignment = .center
            badge.layer.cornerRadius = 8
            badge.clipsToBounds = true
            
            bellButton.addSubview(badge)
            badge.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                badge.topAnchor.constraint(equalTo: bellButton.topAnchor, constant: -4),
                badge.trailingAnchor.constraint(equalTo: bellButton.trailingAnchor, constant: 4),
                badge.widthAnchor.constraint(equalToConstant: 16),
                badge.heightAnchor.constraint(equalToConstant: 16)
            ])
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "Campus News"
        titleLabel.font = .systemFont(ofSize: 30, weight: .black)
        titleLabel.textColor = UIColor(hex: "#0C2B4E")
        
        let topStack = UIStackView(arrangedSubviews: [logoImageView, UIView(), bellButton])
        topStack.axis = .horizontal
        topStack.spacing = 16
        
        let mainStack = UIStackView(arrangedSubviews: [topStack, titleLabel])
        mainStack.axis = .vertical
        mainStack.spacing = 8
        mainStack.alignment = .fill
        
        headerView.addSubview(mainStack)
        view.addSubview(headerView)
        
        [mainStack, topStack, logoImageView, bellButton, headerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 8),
            
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            mainStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            logoImageView.widthAnchor.constraint(equalToConstant: 30),
            logoImageView.heightAnchor.constraint(equalToConstant: 30),
            
            bellButton.widthAnchor.constraint(equalToConstant: 40),
            bellButton.heightAnchor.constraint(equalToConstant: 40),
            
            topStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
        ])
    }
    
    @objc private func showNotifications() {
        let alert = UIAlertController(title: "Уведомления", message: "В разработке", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupSearchButton() {
        searchButton.backgroundColor = UIColor(hex: "#FFFFFF")
        searchButton.layer.cornerRadius = 14
        searchButton.setTitle("  Search…", for: .normal)
        searchButton.setTitleColor(.secondaryLabel, for: .normal)
        searchButton.titleLabel?.font = .systemFont(ofSize: 16)
        searchButton.contentHorizontalAlignment = .left
        searchButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        searchButton.addTarget(self, action: #selector(openSearch), for: .touchUpInside)
        
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = UIColor(hex: "#0C2B4E").withAlphaComponent(0.7)
        
        searchButton.addSubview(searchIcon)
        view.addSubview(searchButton)
        
        [searchIcon, searchButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            searchIcon.leadingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: 16),
            searchIcon.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 20),
            searchIcon.heightAnchor.constraint(equalToConstant: 20),
            
            searchButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 4),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchButton.heightAnchor.constraint(equalToConstant: 48)
            
        ])
    }
    
    @objc private func openSearch() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor(hex: "#F8F9FA")
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 40, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsCardCell.self, forCellReuseIdentifier: "NewsCardCell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Отступ таблицы уменьшен до 8
            tableView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    private func fetchNews(search: String = "") {
        var url = "news/"
        if !search.isEmpty {
            url += "?search=\(search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        
        NetworkManager.shared.get(url: url) { [weak self] (items: [NewsItem]?, error) in
            DispatchQueue.main.async {
                if let items = items {
                    self?.newsItems = items
                    self?.filteredNews = items
                    self?.tableView.reloadData()
                } else if let error = error {
                    print("Ошибка при получении новостей: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCardCell", for: indexPath) as? NewsCardCell else {
            return UITableViewCell()
        }
        cell.configure(with: filteredNews[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = NewsDetailViewController(news: filteredNews[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 360
    }
}
