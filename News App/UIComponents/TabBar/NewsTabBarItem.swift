//
//  NewsTabBarItem.swift
//  News App
//
//  Created by Premier on 26/07/21.
//

import UIKit
import SnapKit

class NewsTabBarItem: UIView {
    
    private let imageView = UIImageView()
    private let icon: UIImage?
    private let selectedIcon: UIImage?
    
    var isSelected = false {
        didSet {
            if oldValue != isSelected {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                    self.refreshUI()
                }
            }
        }
    }
    
    private var iconConstraints: Constraint?
    private var iconTopLeadingConstraints: Constraint?
    private var iconTrailingBottomConstraints: Constraint?
    var action: ((_: NewsTabBarItem) -> Void)?
    
    private(set) var title: String
    
    init(icon: UIImage?, selectedIcon: UIImage?, title: String, isSelected: Bool = false) {
        self.title = title
        self.selectedIcon = selectedIcon
        self.icon = icon
        super.init(frame: .zero)
        self.addItems()
        self.refreshUI()
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapped))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
    }
    
    private func addItems() {
        
        let stackView = UIStackView(arrangedSubviews: [imageView])

        self.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            self.iconTopLeadingConstraints = make.leading.top.equalToSuperview().offset(10).constraint
            self.iconTrailingBottomConstraints = make.bottom.trailing.equalToSuperview().offset(-10).constraint
        }
        
        imageView.snp.makeConstraints { (make) in
            self.iconConstraints = make.size.equalTo(25).constraint
        }
        imageView.contentMode = .scaleAspectFill
    }
    
    @objc
    private func didTapped() {
        DispatchQueue.main.async {
            self.action?(self)
        }
    }
    
    private func refreshUI() {
        if self.isSelected {
            self.imageView.image = self.selectedIcon
            self.iconConstraints?.update(offset: 45)
            self.iconTopLeadingConstraints?.update(offset: 0)
            self.iconTrailingBottomConstraints?.update(offset: 0)
        } else {
            self.imageView.image = self.icon
            self.iconConstraints?.update(offset: 25)
            self.iconTopLeadingConstraints?.update(offset: 10)
            self.iconTrailingBottomConstraints?.update(offset: -10)
        }
        
    }
}

