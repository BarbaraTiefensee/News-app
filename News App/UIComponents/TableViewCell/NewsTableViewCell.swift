//
//  NewsTableViewCell.swift
//  News App
//
//  Created by Gabriel Varela on 15/07/21.
//

import UIKit
import Kingfisher

class NewsTableViewCell: UITableViewCell {
    
    private lazy var newsImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 5
        return image
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.default(ofSize: 15.0, weight: .semibold)
        label.textColor = .dynamicColor(light: .black, dark: .white)
        label.numberOfLines = 3
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.default(ofSize: 14.0, weight: .regular)
        label.numberOfLines = 2
        label.textColor = .dynamicColor(light: .gray414141, dark: .white)
        return label
    }()
    
    private let publicationDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.default(ofSize: 13.0, weight: .regular)
        label.textColor = .dynamicColor(light: .grayA2A2A2, dark: .white)
        label.numberOfLines = 1
        return label
    }()
    
    private let iconImage: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage.saveIcon
        icon.tintColor = .grayA2A2A2
        icon.contentMode = .scaleAspectFill
        return icon
    }()
    
    static let reuseID = "News"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: NewsTableViewCell.reuseID)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(news: Article) {
        self.descriptionLabel.text = news.title
        self.authorLabel.text = news.author
        self.publicationDateLabel.text = news.publishedAt.setDateString()
        UIImageView.loadFrom(urlImage: news.urlToImage, image: newsImage)
    }
    
    private func setupView() {
        addNewsImage()
        addDescriptionLabel()
        addAuthorLabel()
        addPublicationDateLabel()
        addIconImage()
    }
    
}

//MARK: - Layout
extension NewsTableViewCell {
    private func addNewsImage() {
        self.contentView.addSubview(newsImage)
        
        newsImage.setContentCompressionResistancePriority(.required, for: .vertical)
        newsImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-10)
            make.size.equalTo(100)
        }
    }
    
    private func addDescriptionLabel() {
        self.contentView.addSubview(descriptionLabel)
        
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(newsImage.snp.trailing).offset(24)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    private func addAuthorLabel() {
        self.contentView.addSubview(authorLabel)
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            make.leading.equalTo(newsImage.snp.trailing).offset(24)
        }
    }
    
    private func addPublicationDateLabel() {
        self.contentView.addSubview(publicationDateLabel)
        
        publicationDateLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        publicationDateLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(10)
            make.leading.equalTo(newsImage.snp.trailing).offset(24)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    private func addIconImage() {
        self.contentView.addSubview(iconImage)
        
        iconImage.setContentCompressionResistancePriority(.required, for: .vertical)
        iconImage.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(22)
            make.leading.equalTo(authorLabel.snp.trailing)
            make.trailing.equalToSuperview().offset(-23)
            make.bottom.equalToSuperview().offset(-22)
            make.size.equalTo(28)
        }
    }
}
