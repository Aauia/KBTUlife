import Foundation
import UIKit
class AchievementCardView: UIView {
    private let iconLabel = UILabel()
    private let titleLabel = UILabel()
    private let descLabel = UILabel()
    private let progressView = UIProgressView()
    
    init(badge: Badge) {
        super.init(frame: .zero)
        setupUI(badge: badge)
    }
    
    private func setupUI(badge: Badge) {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
        

        iconLabel.font = UIFont.systemFont(ofSize: 32)
        iconLabel.text = badge.icon
        iconLabel.textAlignment = .center
        iconLabel.textColor = badge.isUnlocked ? .systemBlue : .systemGray3
        

        titleLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        titleLabel.text = badge.title
        
     
        descLabel.font = UIFont.systemFont(ofSize: 10)
        descLabel.textColor = .secondaryLabel
        descLabel.numberOfLines = 2
        descLabel.text = badge.description
        
      
        progressView.progressTintColor = .systemBlue
        progressView.trackTintColor = UIColor.systemGray5
        progressView.progress = Float(badge.progress)
        progressView.layer.cornerRadius = 2
        progressView.clipsToBounds = true
        
        addSubview(iconLabel)
        addSubview(titleLabel)
        addSubview(descLabel)
        addSubview(progressView)
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 90),
            heightAnchor.constraint(equalToConstant: 120),
            
            iconLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            iconLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            progressView.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 8),
            progressView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 3)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
