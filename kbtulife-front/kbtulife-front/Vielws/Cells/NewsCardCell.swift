import UIKit
import SDWebImage

class NewsCardCell: UITableViewCell {
    
    private let cardView = UIView()
    private let thumbnailImageView = UIImageView()
    private let categoryBadge = UILabel()
    private let metaLabel = UILabel()
    private let titleLabel = UILabel()
    private let excerptLabel = UILabel()
    
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
        
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 10
        
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 20
        thumbnailImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        categoryBadge.font = .systemFont(ofSize: 13, weight: .semibold)
        categoryBadge.textColor = .systemBlue
        categoryBadge.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        categoryBadge.layer.cornerRadius = 12
        categoryBadge.clipsToBounds = true
        categoryBadge.textAlignment = .center
        
        metaLabel.font = .systemFont(ofSize: 13)
        metaLabel.textColor = .secondaryLabel
        
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.numberOfLines = 0
        
        excerptLabel.font = .systemFont(ofSize: 15)
        excerptLabel.textColor = .secondaryLabel
        excerptLabel.numberOfLines = 3
        
        contentView.addSubview(cardView)
        cardView.addSubview(thumbnailImageView)
        cardView.addSubview(categoryBadge)
        cardView.addSubview(metaLabel)
        cardView.addSubview(titleLabel)
        cardView.addSubview(excerptLabel)
        
        [cardView, thumbnailImageView, categoryBadge, metaLabel, titleLabel, excerptLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        categoryBadgeTopWithImage = categoryBadge.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 16)
        categoryBadgeTopWithoutImage = categoryBadge.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16)
        
        categoryBadgeTopWithImage.isActive = true
        categoryBadgeTopWithoutImage.isActive = false
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            thumbnailImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 200),
            
            categoryBadge.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            categoryBadge.heightAnchor.constraint(equalToConstant: 24),
            
            metaLabel.centerYAnchor.constraint(equalTo: categoryBadge.centerYAnchor),
            metaLabel.leadingAnchor.constraint(equalTo: categoryBadge.trailingAnchor, constant: 12),
            
            titleLabel.topAnchor.constraint(equalTo: categoryBadge.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            excerptLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            excerptLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            excerptLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            excerptLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with news: NewsItem) {
        titleLabel.text = news.title
        
        let excerptText = String(news.content.prefix(150))
        excerptLabel.text = excerptText + (news.content.count > 150 ? "..." : "")
        
        categoryBadge.text = " \(news.category) "
        
        let readTime = String(format: NSLocalizedString("news_read_time", comment: ""), news.readTime)
        metaLabel.text = "\(news.date) • \(readTime)"
        
        if let urlString = news.imageUrl, let url = URL(string: urlString) {
            thumbnailImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
            thumbnailImageView.isHidden = false
            categoryBadgeTopWithImage.isActive = true
            categoryBadgeTopWithoutImage.isActive = false
        } else {
            thumbnailImageView.image = nil
            thumbnailImageView.isHidden = true
            categoryBadgeTopWithImage.isActive = false
            categoryBadgeTopWithoutImage.isActive = true
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
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
