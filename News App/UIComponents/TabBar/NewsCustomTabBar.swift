//
//  NewsAppCustonTabBar.swift
//  News App
//
//  Created by Premier on 26/07/21.
//

import UIKit

protocol NewsCustomTabBarDelegate: AnyObject {
    func didSelect(index: Int)
}

class NewsCustomTabBar: UIView {
    
    //MARK: - Attributes
    weak var delegate: NewsCustomTabBarDelegate?
    
    private var buttons: [NewsTabBarItem] = []
    
    //MARK: - Initializers
    init(_ items: [NewsTabBarItem]) {
        super.init(frame: .zero)
        backgroundColor = .clear
        
        setupStackView(items)
        updateUI(selectedIndex: 0)
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    private func setupStackView(_ items: [NewsTabBarItem]) {
        for (index, item) in items.enumerated() {
            item.tag = index
            item.action = changeTab(_:)
            buttons.append(item)
        }

        let stackView = UIStackView(arrangedSubviews: buttons)
        addSubview(stackView)
        stackView.spacing = (UIScreen.is4InchDevice ? 140 : 180)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIScreen.is4InchDevice ? 10 : 15)
            make.bottom.equalToSuperview().offset(UIScreen.is4InchDevice ? -10 : -30)
            make.centerX.equalToSuperview()
        }
    }
    
    func updateTab(index: Int) {
        self.layoutIfNeeded()
        delegate?.didSelect(index: index)
        updateUI(selectedIndex: index)
    }
    
    @objc
    private func changeTab(_ sender: NewsTabBarItem) {
        self.layoutIfNeeded()
        delegate?.didSelect(index: sender.tag)
        updateUI(selectedIndex: sender.tag)
    }
    
    func updateUI(selectedIndex: Int) {
        for (index, button) in buttons.enumerated() {
            if index == selectedIndex {
                button.isSelected = true
            } else {
                if button.isSelected {
                    button.isSelected = false
                }
            }
        }
    }
}
