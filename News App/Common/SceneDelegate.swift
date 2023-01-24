//
//  SceneDelegate.swift
//  News App
//
//  Created by Fernando Douglas Vieira on 15/07/21.
//

import UIKit
import KeychainSwift
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let tabBarController = NewsTabBarController()
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
        
        let viewProfile = [NavigationController.setViewController(view: HomeViewController(), title: "Artigos", icon: .homeIcon, selectedIcon: .selectedHomeIcon),
                           NavigationController.setViewController(view: ProfileViewController(), icon: .accountIcon, selectedIcon: .selectedAccountIcon)]
        let viewLogin = [NavigationController.setViewController(view: HomeViewController(), title: "Artigos", icon: .homeIcon, selectedIcon: .selectedHomeIcon),
                         NavigationController.setViewController(view: LoginViewController(), icon: .accountIcon, selectedIcon: .selectedAccountIcon)]
        let keychain = KeychainSwift()
        
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { token, error in
            if let sucess = token {
                if sucess != keychain.get("isLogged") {
                    keychain.set(sucess, forKey: "isLogged")
                }
                tabBarController.setViewControllers(viewProfile, animated: true)
            }
        })
        tabBarController.setViewControllers(viewLogin, animated: true)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

