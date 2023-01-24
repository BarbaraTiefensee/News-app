//
//  NavigationController.swift
//  News App
//
//  Created by Gabriel Varela on 16/07/21.
//

import UIKit

class NavigationController: UINavigationController {
    
    static func setViewController(view: UIViewController, title: String?=nil, icon: UIImage?, selectedIcon: UIImage?) -> UINavigationController {
        view.navigationItem.title = title
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.default(ofSize: 20, weight: .semibold),
        ]
        return navigationController
    }
}
