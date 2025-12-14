import UIKit

class NewsViewController: UIViewController {
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private var newsItems: [NewsItem] = []
    private var filteredNews: [NewsItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.backgroundColor = .systemBackground
        
        searchBar.delegate = self
        searchBar.placeholder = "Поиск новостей"
        navigationItem.titleView = searchBar
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsCardCell.self, forCellReuseIdentifier: "NewsCardCell")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        fetchNews()
    }
    
    private func fetchNews(search: String = "") {
        var url = "news/"
        if !search.isEmpty {
            url += "?search=\(search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        NetworkManager.shared.get(url: url) { [weak self] (items: [NewsItem]?, error) in
            if let items = items {
                self?.newsItems = items
                self?.filteredNews = items
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCardCell", for: indexPath) as! NewsCardCell
        cell.configure(with: filteredNews[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = NewsDetailViewController(news: filteredNews[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension NewsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchNews(search: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
//
//import UIKit
//
//class NewsViewController: UIViewController {
//    private let tableView = UITableView()
//    private let searchButton = UIButton(type: .system)
//    private let headerView = UIView()
//
//    private var newsItems: [NewsItem] = []
//    private var filteredNews: [NewsItem] = []
//    private var unreadCount = 3
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationController?.setNavigationBarHidden(true, animated: false)
//        view.backgroundColor = UIColor(hex: "#F8F9FA")
//        setupHeader()
//        setupSearchButton()
//        setupTableView()
//        fetchNews()
//    }
//
//    private func setupHeader() {
//        headerView.backgroundColor = .systemBackground
//        view.addSubview(headerView)
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//
//        let titleLabel = UILabel()
//        titleLabel.text = "Campus News"
//        titleLabel.font = .systemFont(ofSize: 36, weight: .black)
//
//        let bellButton = UIButton(type: .system)
//        bellButton.setImage(UIImage(systemName: "bell"), for: .normal)
//        bellButton.tintColor = .label
//        bellButton.addTarget(self, action: #selector(showNotifications), for: .touchUpInside)
//
//        if unreadCount > 0 {
//            let badge = UILabel()
//            badge.text = "\(unreadCount)"
//            badge.font = .systemFont(ofSize: 12, weight: .bold)
//            badge.textColor = .white
//            badge.backgroundColor = .systemRed
//            badge.textAlignment = .center
//            badge.layer.cornerRadius = 8
//            badge.clipsToBounds = true
//            badge.translatesAutoresizingMaskIntoConstraints = false
//            badge.widthAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
//            badge.heightAnchor.constraint(equalToConstant: 16).isActive = true
//
//            bellButton.addSubview(badge)
//            NSLayoutConstraint.activate([
//                badge.topAnchor.constraint(equalTo: bellButton.topAnchor, constant: -4),
//                badge.trailingAnchor.constraint(equalTo: bellButton.trailingAnchor, constant: 4)
//            ])
//        }
//
//        [titleLabel, bellButton].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            headerView.addSubview($0)
//        }
//
//        NSLayoutConstraint.activate([
//            headerView.topAnchor.constraint(equalTo: view.topAnchor),
//            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            headerView.heightAnchor.constraint(equalToConstant: 100),
//
//            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
//            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 10),
//
//            bellButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
//            bellButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
//        ])
//    }
//
//    @objc private func showNotifications() { }
//
//    private func setupSearchButton() {
//        searchButton.backgroundColor = .systemBackground
//        searchButton.layer.cornerRadius = 14
//        searchButton.setTitle("Search…", for: .normal)
//        searchButton.setTitleColor(.secondaryLabel, for: .normal)
//        searchButton.titleLabel?.font = .systemFont(ofSize: 16)
//
//        let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
//        icon.tintColor = .secondaryLabel
//        searchButton.addSubview(icon)
//
//        icon.translatesAutoresizingMaskIntoConstraints = false
//        searchButton.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            icon.leadingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: 16),
//            icon.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor),
//            icon.widthAnchor.constraint(equalToConstant: 20),
//            icon.heightAnchor.constraint(equalToConstant: 20)
//        ])
//
//        searchButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 48, bottom: 0, right: 16)
//        searchButton.addTarget(self, action: #selector(openSearch), for: .touchUpInside)
//
//        view.addSubview(searchButton)
//
//        NSLayoutConstraint.activate([
//            searchButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
//            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            searchButton.heightAnchor.constraint(equalToConstant: 52)
//        ])
//    }
//
//    @objc private func openSearch() {
//        let alert = UIAlertController(title: "Поиск", message: nil, preferredStyle: .alert)
//        alert.addTextField { $0.placeholder = "Введите запрос" }
//        alert.addAction(UIAlertAction(title: "Найти", style: .default) { _ in
//            if let text = alert.textFields?.first?.text, !text.isEmpty {
//                self.fetchNews(search: text)
//            }
//        })
//        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
//        present(alert, animated: true)
//    }
//
//    private func setupTableView() {
//        tableView.backgroundColor = .clear
//        tableView.separatorStyle = .none
//        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(NewsCardCell.self, forCellReuseIdentifier: "NewsCardCell")
//
//        view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: searchButton.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//
//    private func fetchNews(search: String = "") {
//        var url = "news/"
//        if !search.isEmpty {
//            url += "?search=\(search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
//        }
//        NetworkManager.shared.get(url: url) { [weak self] (items: [NewsItem]?, error) in
//            guard let items = items else { return }
//            self?.newsItems = items
//            self?.filteredNews = items
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//            }
//        }
//    }
//}
//
//extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        filteredNews.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCardCell", for: indexPath) as! NewsCardCell
//        cell.configure(with: filteredNews[indexPath.row])
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detailVC = NewsDetailViewController(news: filteredNews[indexPath.row])
//        navigationController?.pushViewController(detailVC, animated: true)
//    }
//}
//
