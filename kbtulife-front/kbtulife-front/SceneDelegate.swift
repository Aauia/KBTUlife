// SceneDelegate.swift
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        // Check if user is logged in
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if isLoggedIn {
            // User is logged in - go to main app
            window.rootViewController = MainTabBarController()
        } else {
            // Not logged in - show onboarding/login
            let authNav = UINavigationController(rootViewController: OnboardingViewController())
            window.rootViewController = authNav
        }
        
        window.makeKeyAndVisible()
        self.window = window
    }
}
