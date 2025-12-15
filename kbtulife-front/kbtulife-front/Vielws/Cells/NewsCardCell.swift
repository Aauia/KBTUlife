import UIKit

class NewsCardCell: UITableViewCell {
    
    private let cardView = UIView()
    private let thumbnailImageView = UIImageView()
    private let categoryBadge = UILabel()
    private let metaLabel = UILabel()
    private let titleLabel = UILabel()
    private let excerptLabel = UILabel()
    
    // Два разных констрейнта для верхнего отступа categoryBadge
    private var categoryBadgeTopWithImage: NSLayoutConstraint!
    private var categoryBadgeTopWithoutImage: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.98, alpha: 1.0)
        
        // Card
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 10
        
        // Thumbnail
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 20
        thumbnailImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Category badge
        categoryBadge.font = .systemFont(ofSize: 13, weight: .semibold)
        categoryBadge.textColor = .systemBlue
        categoryBadge.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        categoryBadge.layer.cornerRadius = 12
        categoryBadge.clipsToBounds = true
        categoryBadge.textAlignment = .center
        
        // Meta
        metaLabel.font = .systemFont(ofSize: 13)
        metaLabel.textColor = .secondaryLabel
        
        // Title
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.numberOfLines = 0
        
        // Excerpt
        excerptLabel.font = .systemFont(ofSize: 15)
        excerptLabel.textColor = .secondaryLabel
        excerptLabel.numberOfLines = 3
        
        // Добавляем на иерархию
        contentView.addSubview(cardView)
        cardView.addSubview(thumbnailImageView)
        cardView.addSubview(categoryBadge)
        cardView.addSubview(metaLabel)
        cardView.addSubview(titleLabel)
        cardView.addSubview(excerptLabel)
        
        // Отключаем autoresizing mask
        [cardView, thumbnailImageView, categoryBadge, metaLabel, titleLabel, excerptLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Создаём два альтернативных констрейнта для categoryBadge
        categoryBadgeTopWithImage = categoryBadge.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 16)
        categoryBadgeTopWithoutImage = categoryBadge.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16)
        
        // По умолчанию предполагаем, что фото есть
        categoryBadgeTopWithImage.isActive = true
        categoryBadgeTopWithoutImage.isActive = false
        
        NSLayoutConstraint.activate([
            // Card
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            // Thumbnail
            thumbnailImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 200),
            
            // Category badge
            categoryBadge.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            categoryBadge.heightAnchor.constraint(equalToConstant: 24),
            
            // Meta
            metaLabel.centerYAnchor.constraint(equalTo: categoryBadge.centerYAnchor),
            metaLabel.leadingAnchor.constraint(equalTo: categoryBadge.trailingAnchor, constant: 12),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: categoryBadge.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            // Excerpt
            excerptLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            excerptLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            excerptLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            excerptLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with news: NewsItem) {
        titleLabel.text = news.title
        
        let excerptText = news.content.prefix(150)
        excerptLabel.text = excerptText + (news.content.count > 150 ? "..." : "")
        
        categoryBadge.text = " \(news.category) "
        metaLabel.text = "\(news.date) • \(news.readTime)"
        
        if let urlString = news.imageUrl, let url = URL(string: urlString) {
            thumbnailImageView.sd_setImage(
                    with: url,
                    placeholderImage: UIImage(systemName: "photo"),  // чтобы видеть, что пытается грузить
                    options: [.retryFailed, .progressiveLoad, .handleCookies, .allowInvalidSSLCertificates],
                    progress: nil,
                    completed: { (image, error, cacheType, url) in
                        if let error = error {
                            print("Ошибка загрузки изображения для новости \(news.id): \(error.localizedDescription)")
                        }
                    }
                )
                thumbnailImageView.isHidden = false
            
            // Макет с изображением
            categoryBadgeTopWithImage.isActive = true
            categoryBadgeTopWithoutImage.isActive = false
        } else {
            thumbnailImageView.image = nil
            thumbnailImageView.isHidden = true
            
            // Макет без изображения
            categoryBadgeTopWithImage.isActive = false
            categoryBadgeTopWithoutImage.isActive = true
        }
        
        // Принудительно обновляем layout (на всякий случай при реюзе ячеек)
        setNeedsLayout()
        layoutIfNeeded()
        print("News \(news.id) imageUrl: \(news.imageUrl ?? "nil")")
    }
    
    // Подготовка к переиспользованию — очищаем изображение, чтобы не было артефактов
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.sd_cancelCurrentImageLoad()
        thumbnailImageView.image = nil
        titleLabel.text = nil
        excerptLabel.text = nil
        categoryBadge.text = nil
        metaLabel.text = nil
    }
}
