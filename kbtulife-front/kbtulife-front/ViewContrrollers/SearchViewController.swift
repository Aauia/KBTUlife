import UIKit

class SearchViewController: UIViewController {
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    private var allEvents: [Event] = []
    private var allNews: [NewsItem] = []
    private var allClubs: [Club] = []
    
    private var searchResults: [SearchResult] = []
    
    enum SearchResult {
        case event(Event)
        case news(NewsItem)
        case club(Club)
        
        var title: String {
            switch self {
            case .event(let event): return event.name
            case .news(let news): return news.title
            case .club(let club): return club.name
            }
        }
        
        var subtitle: String? {
            switch self {
            case .event(let event): return event.location
            case .news: return nil
            case .club(let club): return club.description
            }
        }
        
        var type: String {
            switch self {
            case .event: return NSLocalizedString("search_type_event", comment: "")
            case .news: return NSLocalizedString("search_type_news", comment: "")
            case .club: return NSLocalizedString("search_type_club", comment: "")
            }
        }
        
        var imageUrl: String? {
            switch self {
            case .event(let event):
                return event.mediaUrls?.first
            case .news(let news):
                return news.imageUrl
            case .club:
                return nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("search_title", comment: "")
        view.backgroundColor = .systemBackground
        
        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("search_placeholder", comment: "")
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: "SearchResultCell")
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        loadAllData()
    }
    
    private func loadAllData() {
        let group = DispatchGroup()
        
        group.enter()
        NetworkManager.shared.fetchEvents { events, _ in
            self.allEvents = events ?? []
            group.leave()
        }
        
        group.enter()
        NetworkManager.shared.fetchNews { news, _ in
            self.allNews = news ?? []
            group.leave()
        }
        
        group.enter()
        NetworkManager.shared.fetchClubs { clubs, _ in
            self.allClubs = clubs ?? []
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.searchBar.becomeFirstResponder()
        }
    }
    
    private func performSearch(query: String) {
        let lowerQuery = query.lowercased()
        
        var results: [SearchResult] = []
        
        results += allEvents.filter { $0.name.lowercased().contains(lowerQuery) || $0.description.lowercased().contains(lowerQuery) }
            .map { SearchResult.event($0) }
        
        results += allNews.filter { $0.title.lowercased().contains(lowerQuery) }
            .map { SearchResult.news($0) }
        
        results += allClubs.filter { $0.name.lowercased().contains(lowerQuery) }
            .map { SearchResult.club($0) }
        
        searchResults = results
        tableView.reloadData()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResults = []
            tableView.reloadData()
        } else {
            performSearch(query: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchResults = []
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        cell.configure(with: searchResults[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        switch result {
        case .event(let event):
            let detailVC = EventDetailViewController(event: event)
            navigationController?.pushViewController(detailVC, animated: true)
        case .news(let news):
            let detailVC = NewsDetailViewController(news: news)
            navigationController?.pushViewController(detailVC, animated: true)
        case .club(let club):
            let detailVC = ClubDetailViewController(club: club)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
