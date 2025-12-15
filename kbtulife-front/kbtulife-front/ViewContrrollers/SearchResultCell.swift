import UIKit

class SearchResultCell: UITableViewCell {
    private let thumbnail = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let typeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.clipsToBounds = true
        thumbnail.layer.cornerRadius = 12
        thumbnail.backgroundColor = .systemGray5
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        titleLabel.numberOfLines = 1
        
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1
        
        typeLabel.font = .systemFont(ofSize: 12)
        typeLabel.textColor = .white
        typeLabel.backgroundColor = UIColor(hex: "#0C2B4E")
        typeLabel.layer.cornerRadius = 8
        typeLabel.clipsToBounds = true
        typeLabel.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        contentView.addSubview(thumbnail)
        contentView.addSubview(stack)
        contentView.addSubview(typeLabel)
        
        [thumbnail, stack, typeLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            thumbnail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            thumbnail.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnail.widthAnchor.constraint(equalToConstant: 60),
            thumbnail.heightAnchor.constraint(equalToConstant: 60),
            
            stack.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: 16),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stack.trailingAnchor.constraint(equalTo: typeLabel.leadingAnchor, constant: -16),
            
            typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            typeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            typeLabel.widthAnchor.constraint(equalToConstant: 60),
            typeLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        accessoryType = .disclosureIndicator
    }
    
    func configure(with result: SearchViewController.SearchResult) {
        titleLabel.text = result.title
        subtitleLabel.text = result.subtitle
        typeLabel.text = result.type
        
        thumbnail.image = nil
        if let urlString = result.imageUrl, let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.thumbnail.image = image
                    }
                }
            }.resume()
        }
    }
}
