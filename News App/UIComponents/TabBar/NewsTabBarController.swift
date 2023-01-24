//
//  NewsTabBarController.swift
//  News App
//
//  Created by Premier on 26/07/21.
//

import UIKit
import SnapKit

class NewsTabBarController: UITabBarController {
    
    var items = [NewsTabBarItem(icon: .homeIcon, selectedIcon: .selectedHomeIcon, title: ""),
                 NewsTabBarItem(icon: .accountIcon, selectedIcon: .selectedAccountIcon, title: ""),
                ]
    
    private var tabBarContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .dynamicColor(light: .blue1E234A, dark: .gray171717)
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return view
    }()
    
    lazy var newsTabBarView = NewsCustomTabBar(items)
    private var tabBarContentViewConstraint: Constraint?
    private var tabBarItemsContraint: Constraint?
    
    override var selectedIndex: Int {
        didSet {
            newsTabBarView.updateUI(selectedIndex: selectedIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isHidden = true
        addTabBarContentView()
        setupTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func addTabBarContentView() {
        view.addSubview(tabBarContentView)
        
        tabBarContentView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            self.tabBarContentViewConstraint = make.height.equalTo(UIScreen.is4InchDevice ? 60 : 83).constraint
        }
    }

    private func setupTabBar() {
        newsTabBarView.delegate = self
        tabBarContentView.addSubview(newsTabBarView)

        newsTabBarView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setTabBarHidden(_ isHidden: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            UIView.animate(withDuration: 0.2) {
                self.tabBarContentViewConstraint?.update(offset: isHidden ? 0 : (UIScreen.is4InchDevice ? 60 : 83))
                self.view.layoutSubviews()
            }
        }
    }
    
    func userHasSuccessfullyRegistered() {
        if let navController = self.viewControllers?[1] as? UINavigationController {
            navController.popViewController(animated: true) {
                self.selectedIndex = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.viewControllers?[1] = NavigationController.setViewController(view: ProfileViewController(), icon: .accountIcon, selectedIcon: .selectedAccountIcon)
                }
            }
        }
    }
}

extension NewsTabBarController: NewsCustomTabBarDelegate {
    
    func didSelect(index: Int) {
        selectedIndex = index
    }
}
