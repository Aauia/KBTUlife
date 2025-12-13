import UIKit

class EventCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let priceLabel = UILabel()
    private let thumbnailImageView = UIImageView()
    private let buyButton = UIButton(type: .system)

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
        
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .secondaryLabel
        
        priceLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        priceLabel.textColor = .systemGreen
        
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 8
        
        buyButton.setTitle("Купить билет", for: .normal)
        buyButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buyButton.backgroundColor = .systemBlue
        buyButton.setTitleColor(.white, for: .normal)
        buyButton.layer.cornerRadius = 10
        
        // Добавляем на contentView
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(buyButton)
        
        // Отключаем autoresizing masks
        [thumbnailImageView, titleLabel, dateLabel, priceLabel, buyButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Constraints (пример под Figma-стиль: изображение слева, текст справа, кнопка снизу)
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            thumbnailImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 100),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            
            buyButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            buyButton.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor),
            buyButton.heightAnchor.constraint(equalToConstant: 44),
            buyButton.widthAnchor.constraint(equalToConstant: 140)
        ])
        
        accessoryType = .disclosureIndicator  // стрелочка вправо
    }
    
    func configure(with event: Event) {
        titleLabel.text = event.name
        dateLabel.text = formatDate(event.date)  // напиши функцию форматирования
        priceLabel.text = event.isFree ? "Бесплатно" : "\(event.price) ₸"
        
        // Загрузка изображения (если есть media_urls)
        if let urlString = event.mediaUrls?.first, let url = URL(string: urlString) {
            // Простая загрузка (или используй Kingfisher/SDWebImage)
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.thumbnailImageView.image = image
                    }
                }
            }.resume()
        }
    }
    
    private func formatDate(_ isoString: String) -> String {
        // Простое форматирование ISO → "23 декабря, 21:00"
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: isoString) else { return isoString }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM, HH:mm"
        outputFormatter.locale = Locale(identifier: "ru_KZ")
        return outputFormatter.string(from: date)
    }
}
