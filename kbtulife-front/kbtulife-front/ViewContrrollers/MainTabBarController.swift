import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .systemBackground
        tabBar.isTranslucent = false
        
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.08
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 4
        
        let newsNav = UINavigationController(rootViewController: NewsViewController())
        newsNav.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab_home", comment: ""),
            image: UIImage(systemName: "house"),
            tag: 0
        )
        
        let eventsNav = UINavigationController(rootViewController: EventsViewController())
        eventsNav.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab_events", comment: ""),
            image: UIImage(systemName: "calendar"),
            tag: 1
        )
        
        let clubsNav = UINavigationController(rootViewController: ClubsViewController())
        clubsNav.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab_clubs", comment: ""),
            image: UIImage(systemName: "person.3"),
            tag: 2
        )
        
        let ticketsNav = UINavigationController(rootViewController: MyTicketsViewController())
        ticketsNav.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab_tickets", comment: ""),
            image: UIImage(systemName: "ticket"),
            tag: 3
        )
        
        let profileNav = UINavigationController(rootViewController: ProfileViewController())
        profileNav.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab_profile", comment: ""),
            image: UIImage(systemName: "person"),
            tag: 4
        )
        
        var controllers = [newsNav, eventsNav, clubsNav, ticketsNav, profileNav]
        
        if UserDefaults.standard.bool(forKey: "isStaff") {
            let adminNav = UINavigationController(rootViewController: AdminDashboardViewController())
            adminNav.tabBarItem = UITabBarItem(
                title: NSLocalizedString("tab_admin", comment: ""),
                image: UIImage(systemName: "shield"),
                tag: 5
            )
            controllers.append(adminNav)
        }
        
        viewControllers = controllers
    }
}
