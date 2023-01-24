//
//  NewsAppButton.swift
//  News App
//
//  Created by Premier20 on 16/07/21.
//

import UIKit


class NewsAppButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewsAppButton {
    
    func setupView(){
        clipsToBounds = true
        layer.cornerRadius = 10
        setTitleColor(UIColor.dynamicColor(light: .white, dark: .black), for: .normal)
        titleLabel?.font = .default(ofSize: 16, weight: .bold)
        backgroundColor = UIColor.dynamicColor(light: .black, dark: .white)
    }
    
    
}
