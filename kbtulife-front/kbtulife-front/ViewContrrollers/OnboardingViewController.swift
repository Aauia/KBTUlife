import UIKit

final class OnboardingViewController: UIViewController {
    
    private let slides = [
        Slide(icon: "🎓",
              title: NSLocalizedString("onboarding_welcome_title", comment: ""),
              description: NSLocalizedString("onboarding_welcome_desc", comment: ""),
              subtitle: NSLocalizedString("onboarding_welcome_subtitle", comment: "")),
        
        Slide(icon: "🎉",
              title: NSLocalizedString("onboarding_fun_title", comment: ""),
              description: NSLocalizedString("onboarding_fun_desc", comment: ""),
              subtitle: NSLocalizedString("onboarding_fun_subtitle", comment: "")),
        
        Slide(icon: "🤝",
              title: NSLocalizedString("onboarding_people_title", comment: ""),
              description: NSLocalizedString("onboarding_people_desc", comment: ""),
              subtitle: NSLocalizedString("onboarding_people_subtitle", comment: "")),
        
        Slide(icon: "🎫",
              title: NSLocalizedString("onboarding_journey_title", comment: ""),
              description: NSLocalizedString("onboarding_journey_desc", comment: ""),
              subtitle: NSLocalizedString("onboarding_journey_subtitle", comment: "")),
        
        Slide(icon: "✨",
              title: NSLocalizedString("onboarding_final_title", comment: ""),
              description: NSLocalizedString("onboarding_final_desc", comment: ""),
              subtitle: NSLocalizedString("onboarding_final_subtitle", comment: ""))
    ]
    
    private var currentPage = 0
    
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private let skipButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupScrollView()
        setupSlides()
        setupPageControl()
        setupSkipButton()
        setupNextButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: scrollView.frame.height)
    }
    
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemBlue.withAlphaComponent(0.8).cgColor,
            UIColor.white.withAlphaComponent(0.6).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupScrollView() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -140)
        ])
    }
    
    private func setupSlides() {
        for (index, slide) in slides.enumerated() {
            let slideView = createSlideView(slide: slide)
            scrollView.addSubview(slideView)
            slideView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                slideView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                slideView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                slideView.widthAnchor.constraint(equalTo: view.widthAnchor),
                slideView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(index) * view.frame.width)
            ])
            
            if let iconLabel = slideView.viewWithTag(100) as? UILabel {
                let bounce = CABasicAnimation(keyPath: "transform.scale")
                bounce.fromValue = 0.9
                bounce.toValue = 1.1
                bounce.duration = 1.2
                bounce.autoreverses = true
                bounce.repeatCount = .infinity
                iconLabel.layer.add(bounce, forKey: "bounce")
            }
        }
    }
    
    private func createSlideView(slide: Slide) -> UIView {
        let container = UIView()
        
        let iconLabel = UILabel()
        iconLabel.tag = 100
        iconLabel.text = slide.icon
        iconLabel.font = .systemFont(ofSize: 100)
        
        let titleLabel = UILabel()
        titleLabel.text = slide.title
        titleLabel.font = .boldSystemFont(ofSize: 32)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = slide.description
        descriptionLabel.font = .systemFont(ofSize: 17)
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = slide.subtitle
        subtitleLabel.font = .systemFont(ofSize: 15)
        subtitleLabel.textColor = .white.withAlphaComponent(0.8)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.isHidden = slide.subtitle.isEmpty
        
        let stack = UIStackView(arrangedSubviews: [iconLabel, titleLabel, descriptionLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 24
        stack.alignment = .center
        
        container.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 250),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: 40),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -40)
        ])
        
        return container
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .white.withAlphaComponent(0.4)
        pageControl.currentPageIndicatorTintColor = .white
        
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSkipButton() {
        skipButton.setTitle(NSLocalizedString("onboarding_skip", comment: ""), for: .normal)
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.titleLabel?.font = .systemFont(ofSize: 16)
        skipButton.addTarget(self, action: #selector(skipOnboarding), for: .touchUpInside)
        
        view.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        updateSkipButtonVisibility()
    }
    
    private func setupNextButton() {
        nextButton.backgroundColor = UIColor(hex: "#0C2B4E")
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        nextButton.layer.cornerRadius = 28
        nextButton.addShadow()
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        updateNextButtonTitle()
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            nextButton.heightAnchor.constraint(equalToConstant: 56),
            
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func updateNextButtonTitle() {
        let isLast = currentPage == slides.count - 1
        nextButton.setTitle(isLast ? NSLocalizedString("onboarding_lets_go", comment: "") : NSLocalizedString("onboarding_next", comment: ""), for: .normal)
        
        nextButton.subviews.filter { $0 is UIImageView }.forEach { $0.removeFromSuperview() }
        if !isLast {
            let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
            arrow.tintColor = .white
            nextButton.addSubview(arrow)
            arrow.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                arrow.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor),
                arrow.trailingAnchor.constraint(equalTo: nextButton.trailingAnchor, constant: -24)
            ])
        }
    }
    
    private func updateSkipButtonVisibility() {
        skipButton.isHidden = currentPage == slides.count - 1
    }
    
    @objc private func nextTapped() {
        if currentPage < slides.count - 1 {
            currentPage += 1
            let x = CGFloat(currentPage) * view.frame.width
            scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        } else {
            completeOnboarding()
        }
    }
    
    @objc private func skipOnboarding() {
        completeOnboarding()
    }
    
    private func completeOnboarding() {
        let loginVC = WelcomeViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / view.frame.width)
        currentPage = Int(page)
        pageControl.currentPage = currentPage
        updateNextButtonTitle()
        updateSkipButtonVisibility()
    }
}

private struct Slide {
    let icon: String
    let title: String
    let description: String
    let subtitle: String
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: (r, g, b, a) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF, 255)
        case 8: (r, g, b, a) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default: (r, g, b, a) = (0, 0, 0, 255)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIView {
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 10
    }
}
