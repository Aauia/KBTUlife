import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newsNav = UINavigationController(rootViewController: NewsViewController())
        newsNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let eventsNav = UINavigationController(rootViewController: EventsViewController())
        eventsNav.tabBarItem = UITabBarItem(title: "Events", image: UIImage(systemName: "calendar"), tag: 1)
        
        let clubsNav = UINavigationController(rootViewController: ClubsViewController())
        clubsNav.tabBarItem = UITabBarItem(title: "Clubs", image: UIImage(systemName: "person.3"), tag: 2)
        
        let ticketsNav = UINavigationController(rootViewController: MyTicketsViewController())
        ticketsNav.tabBarItem = UITabBarItem(title: "Tickets", image: UIImage(systemName: "ticket"), tag: 3)
        
        let profileNav = UINavigationController(rootViewController: ProfileViewController())
        profileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 4)
        
        viewControllers = [newsNav, eventsNav, clubsNav, ticketsNav, profileNav]
        
        if UserDefaults.standard.bool(forKey: "isStaff") {
            let adminNav = UINavigationController(rootViewController: AdminDashboardViewController())
            adminNav.tabBarItem = UITabBarItem(title: "Admin", image: UIImage(systemName: "shield"), tag: 5)
            viewControllers?.append(adminNav)
        }
    }
}
