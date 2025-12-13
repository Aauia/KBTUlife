import UIKit

class NewsDetailViewController: UIViewController {
    private let news: NewsItem
    
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private let imageView = UIImageView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    init(news: NewsItem) {
        self.news = news
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News Detail"
        view.backgroundColor = .systemBackground
        
        setupScrollView()
        setupUI()
        configure(with: news)
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupUI() {
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        
        contentLabel.font = .systemFont(ofSize: 16)
        contentLabel.numberOfLines = 0
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel, contentLabel])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func configure(with news: NewsItem) {
        titleLabel.text = news.title
        contentLabel.text = news.content
        
        // Загрузка изображения, если есть
        if let urlString = news.imageUrl, let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }.resume()
        }
    }
}
