//
//  UIImageView+Extension.swift
//  News App
//
//  Created by Gabriel Varela on 16/08/21.
//

import UIKit

extension UIImageView {
    static func loadFrom(urlImage: String?, image: UIImageView) {
        guard let url = urlImage else {
            image.image = UIImage.placeholder
            return
        }
        image.kf.setImage(with: URL(string: url))
    }
    
    static func loadFromProfile(urlImage: String?, image: UIImageView) {
        guard let url = urlImage else {
            image.image = UIImage.userIcon
            image.tintColor = .blue1E234A
            image.backgroundColor = .dynamicColor(light: .gray.withAlphaComponent(0.1), dark: .white)
            return
        }
        image.kf.setImage(with: URL(string: url))
    }
}
