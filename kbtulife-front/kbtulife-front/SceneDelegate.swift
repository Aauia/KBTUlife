import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        if UserDefaults.standard.string(forKey: "authToken") != nil {
            window.rootViewController = MainTabBarController()
        } else {
            let authNav = UINavigationController(rootViewController: OnboardingViewController())
            window.rootViewController = authNav
        }
        
        window.makeKeyAndVisible()
        self.window = window
    }
}
