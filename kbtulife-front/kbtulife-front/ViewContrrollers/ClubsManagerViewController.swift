import UIKit

// MARK: - Tab Sections
enum ClubManagerTab: Int, CaseIterable {
    case memberships = 0
    case tickets = 1
    case events = 2
    case clubs = 3
    
    var title: String {
        switch self {
        case .memberships: return "Заявки"
        case .tickets: return "Билеты"
        case .events: return "События"
        case .clubs: return "Клубы"
        }
    }
}

class ClubManagerViewController: UIViewController {
    
    // MARK: - Properties
    var managedClubs: [ManagedClub] = []
    private var selectedClubId: Int?
    private var selectedTab: ClubManagerTab = .memberships
    private var currentContentVC: UIViewController?
    private var emptyStateView: UIView!
    
    // MARK: - UI Components
    private lazy var headerView = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var clubPickerButton = UIButton(type: .system)
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private lazy var tabContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.isHidden = true
        return view
    }()
    
    private lazy var tabStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var contentContainer = UIView()
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadManagerStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadManagerStatus()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Club Manager"
        
        setupHeader()
        setupEmptyState()
        
        // ScrollView + Tabs + Content
        view.addSubview(scrollView)
        scrollView.addSubview(tabContainer)
        tabContainer.addSubview(tabStackView)
        scrollView.addSubview(contentContainer)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Tab Container
            tabContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            tabContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            tabContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            tabContainer.heightAnchor.constraint(equalToConstant: 50),
            
            // Tab StackView
            tabStackView.topAnchor.constraint(equalTo: tabContainer.topAnchor, constant: 8),
            tabStackView.leadingAnchor.constraint(equalTo: tabContainer.leadingAnchor, constant: 16),
            tabStackView.trailingAnchor.constraint(equalTo: tabContainer.trailingAnchor, constant: -16),
            tabStackView.bottomAnchor.constraint(equalTo: tabContainer.bottomAnchor, constant: -8),
            
            // Content Container
            contentContainer.topAnchor.constraint(equalTo: tabContainer.bottomAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        setupTabs()
    }
    
    private func setupHeader() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .systemBlue
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Панель управления"
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textColor = .white
        
        clubPickerButton.translatesAutoresizingMaskIntoConstraints = false
        clubPickerButton.setTitle("Выберите клуб", for: .normal)
        clubPickerButton.setTitleColor(.white, for: .normal)
        clubPickerButton.titleLabel?.font = .systemFont(ofSize: 16)
        clubPickerButton.contentHorizontalAlignment = .left
        clubPickerButton.addTarget(self, action: #selector(showClubPicker), for: .touchUpInside)
        clubPickerButton.isEnabled = false
        
        let chevron = UIImageView(image: UIImage(systemName: "chevron.down"))
        chevron.translatesAutoresizingMaskIntoConstraints = false
        chevron.tintColor = .white
        clubPickerButton.addSubview(chevron)
        
        NSLayoutConstraint.activate([
            chevron.centerYAnchor.constraint(equalTo: clubPickerButton.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: clubPickerButton.trailingAnchor, constant: -8)
        ])
        
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(clubPickerButton)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            clubPickerButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            clubPickerButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            clubPickerButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            clubPickerButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupEmptyState() {
        emptyStateView = UIView()
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.isHidden = true
        
        let imageView = UIImageView(image: UIImage(systemName: "building.2.crop.circle"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Вы не являетесь менеджером\nни одного клуба"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 16)
        
        emptyStateView.addSubview(imageView)
        emptyStateView.addSubview(label)
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -40),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            label.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: emptyStateView.leadingAnchor, constant: 40),
            label.trailingAnchor.constraint(lessThanOrEqualTo: emptyStateView.trailingAnchor, constant: -40)
        ])
    }
    
    private func setupTabs() {
        ClubManagerTab.allCases.forEach { tab in
            let button = UIButton(type: .system)
            button.tag = tab.rawValue
            button.setTitle(tab.title, for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.setTitleColor(.link, for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            button.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
            tabStackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Actions
    @objc private func tabTapped(_ sender: UIButton) {
        tabStackView.arrangedSubviews.forEach {
            ($0 as! UIButton).isSelected = false
        }
        sender.isSelected = true
        selectedTab = ClubManagerTab(rawValue: sender.tag)!
        updateContent()
    }
    
    @objc private func showClubPicker() {
        let alert = UIAlertController(title: "Выберите клуб", message: nil, preferredStyle: .actionSheet)
        
        for club in managedClubs {
            alert.addAction(UIAlertAction(title: club.name, style: .default) { [weak self] _ in
                self?.selectedClubId = club.id
                self?.updateClubPickerTitle()
                self?.updateContent()
            })
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = clubPickerButton
            popover.sourceRect = clubPickerButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    private func updateClubPickerTitle() {
        if let clubId = selectedClubId,
           let club = managedClubs.first(where: { $0.id == clubId }) {
            clubPickerButton.setTitle(club.name, for: .normal)
        }
    }
    
    // MARK: - Content Management
    private func updateContent() {
        guard let clubId = selectedClubId else { return }
        
        // Remove previous content
        currentContentVC?.willMove(toParent: nil)
        currentContentVC?.view.removeFromSuperview()
        currentContentVC?.removeFromParent()
        
        contentContainer.subviews.forEach { $0.removeFromSuperview() }
        
        switch selectedTab {
        case .memberships:
            let vc = MembershipViewController(clubId: clubId)
            addChild(vc)
            contentContainer.addSubview(vc.view)
            vc.view.frame = contentContainer.bounds
            vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            vc.didMove(toParent: self)
            currentContentVC = vc
            
        default:
            let label = UILabel()
            label.text = "\(selectedTab.title)\n(в разработке)"
            label.numberOfLines = 0
            label.textAlignment = .center
            label.textColor = .systemGray
            contentContainer.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor)
            ])
        }
    }
    
    // MARK: - Data Loading
    private func loadManagerStatus() {
        activityIndicator.startAnimating()
        tabContainer.isHidden = true
        contentContainer.isHidden = true
        emptyStateView.isHidden = true
        
        NetworkManager.shared.checkManagerStatus { [weak self] status, error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                if let error = error {
                    self?.showError(error)
                    return
                }
                
                if let status = status {
                    self?.handleManagerStatus(status)
                }
            }
        }
    }
    
    private func handleManagerStatus(_ status: ClubManagerStatusResponse) {
        managedClubs = status.managedClubs
        
        if managedClubs.isEmpty {
            emptyStateView.isHidden = false
            clubPickerButton.isEnabled = false
        } else {
            emptyStateView.isHidden = true
            tabContainer.isHidden = false
            contentContainer.isHidden = false
            clubPickerButton.isEnabled = true
            
            if selectedClubId == nil {
                selectedClubId = managedClubs.first?.id
                updateClubPickerTitle()
            }
            updateContent()
            
            // Select first tab
            if let firstButton = tabStackView.arrangedSubviews.first as? UIButton {
                tabTapped(firstButton)
            }
        }
    }
    
    // MARK: - Helpers
    private func showError(_ error: Error) {
        showAlert(title: "Ошибка", message: error.localizedDescription)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
