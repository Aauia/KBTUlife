import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Табы: Home, Events, Tickets, Profile
        let homeVC = UIViewController()  // Замени на HomeViewController
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let eventsNC = UINavigationController(rootViewController: EventsViewController())
        eventsNC.tabBarItem = UITabBarItem(title: "Events", image: UIImage(systemName: "calendar"), tag: 1)
        
        let ticketsNC = UINavigationController(rootViewController: MyTicketsViewController())
        ticketsNC.tabBarItem = UITabBarItem(title: "Tickets", image: UIImage(systemName: "ticket"), tag: 2)
        
        let profileVC = UIViewController()  // ProfileViewController
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 3)
        
        // Manager Tab (скрытый, для роли менеджера)
        if UserDefaults.standard.bool(forKey: "isManager") {  // Логика ролей
            let scannerNC = UINavigationController(rootViewController: QRScannerViewController())
            scannerNC.tabBarItem = UITabBarItem(title: "Scanner", image: UIImage(systemName: "qrcode.viewfinder"), tag: 4)
            viewControllers = [homeVC, eventsNC, ticketsNC, profileVC, scannerNC]
        } else {
            viewControllers = [homeVC, eventsNC, ticketsNC, profileVC]
        }
        
        tabBar.tintColor = .systemBlue
        tabBar.barTintColor = .systemBackground
    }
}
