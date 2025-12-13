import UIKit

class NewsCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let previewLabel = UILabel()
    private let thumbnailImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 2
        
        previewLabel.font = .systemFont(ofSize: 14)
        previewLabel.textColor = .secondaryLabel
        previewLabel.numberOfLines = 3
        
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.backgroundColor = .systemGray4
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(previewLabel)
        
        [thumbnailImageView, titleLabel, previewLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            thumbnailImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            previewLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            previewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            previewLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            previewLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
        
        accessoryType = .disclosureIndicator
    }
    
    func configure(with news: NewsItem) {
        titleLabel.text = news.title
        previewLabel.text = news.content.prefix(120) + "..."
        
        thumbnailImageView.image = nil  // placeholder
        if let urlString = news.imageUrl, let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.thumbnailImageView.image = image
                    }
                }
            }.resume()
        }
    }
}
