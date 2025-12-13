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
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
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

