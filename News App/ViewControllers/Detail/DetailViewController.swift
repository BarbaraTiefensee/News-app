//
//  DetailViewController.swift
//  News App
//
//  Created by Premier on 15/07/21.
//

import UIKit

class DetailViewController: BaseViewController {

    //MARK: - Attributes
    private var viewModel: DetailViewModel
    
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.8).cgColor,
            UIColor.black.withAlphaComponent(0.4).cgColor,
            UIColor.black.withAlphaComponent(0.1).cgColor,
            UIColor.black.withAlphaComponent(0).cgColor,
        ]
        return gradientLayer
    }()
    
    private let gradientView = UIView()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private let headerImageViewConteiner: UIView = {
        let view = UIView()
        return view
    }()
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray414141
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .dynamicColor(light: .white, dark: .black)
        return view
    }()
    
    private let authorImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .dynamicColor(light: .black, dark: .white)
        imageView.tintColor = .dynamicColor(light: .white, dark: .black)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 46 / 2
        return imageView
    }()
    
    private let authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.default(ofSize: 14, weight: .regular)
        label.textColor = .dynamicColor(light: .gray414141, dark: .white)
        return label
    }()
    
    private let publishedAtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.default(ofSize: 12, weight: .regular)
        label.textColor = .dynamicColor(light: .grayA2A2A2, dark: .white)
        return label
    }()
    
    private let articleTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.default(ofSize: 20, weight: .bold)
        label.textColor = .dynamicColor(light: .black, dark: .white)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let articleContentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.default(ofSize: 17, weight: .regular)
        label.textColor = .dynamicColor(light: .gray414141, dark: .white)
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .dynamicColor(light: .white, dark: .black)
        isTabBarHidden = true
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = ""
        addGradientLayer()
    }
    
    init(dataSource: Article) {
        self.viewModel = DetailViewModel(dataSource: dataSource)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailViewController {
    
    //MARK: - Functions
    private func addRightNavigationBarItems() {
        let saveButton = UIBarButtonItem(image: .saveIcon, style: .plain, target: self, action: nil)
        navigationItem.setRightBarButtonItems([saveButton], animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .dynamicColor(light: .white, dark: .white)
    }
    
    private func setupContent() {
        authorNameLabel.text = viewModel.dataSource.author
        self.publishedAtLabel.text = viewModel.dataSource.publishedAt.setDateString()
        articleTitle.text = viewModel.dataSource.title
        articleContentLabel.text = viewModel.dataSource.content
        authorImage.image = .accountIcon
        UIImageView.loadFrom(urlImage: viewModel.dataSource.urlToImage, image: headerImageView)
    }
   
    private func setup() {
        setupContent()
        addImageViewContainer()
        addImageView()
        addGradientView()
        addRightNavigationBarItems()
        addScrollView()
        addContentView()
        addAuthorImage()
        addAuthorNameLabel()
        addArticleDate()
        addArticleTitle()
        addArticleContentLabel()
    }
}

extension DetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
}

extension DetailViewController {
    
    //MARK: - Constraints
    
    private func addImageViewContainer() {
        self.view.addSubview(headerImageViewConteiner)
        
        headerImageViewConteiner.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.trailing.equalTo(view)
            make.width.equalTo(headerImageViewConteiner.snp.height).multipliedBy(1.3)
        }
    }
    
    private func addImageView() {
        self.headerImageViewConteiner.addSubview(headerImageView)
        
        headerImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(headerImageViewConteiner.snp.height)
            make.width.greaterThanOrEqualTo(headerImageViewConteiner.snp.width)
        }
    }
    
    private func addGradientLayer() {
        gradientLayer.frame.size = CGSize(width: view.bounds.size.width, height: view.bounds.size.height * 0.15)
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    private func addGradientView() {
        headerImageView.addSubview(gradientView)
        
        gradientView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.bounds.size.height * 0.15)
        }
    }
    
    private func addScrollView() {
        view.addSubview(scrollView)
        scrollView.delegate = self
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addContentView() {
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.bounds.height).offset(270)
            make.leading.trailing.equalTo(view)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func addAuthorImage() {
        contentView.addSubview(authorImage)
        
        authorImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(30).priority(.high)
            make.size.equalTo(46).priority(.high)
        }
    }
    
    private func addAuthorNameLabel() {
        contentView.addSubview(authorNameLabel)
        
        authorNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(35)
            make.leading.equalTo(authorImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    private func addArticleDate() {
        contentView.addSubview(publishedAtLabel)

        publishedAtLabel.snp.makeConstraints { make in
            make.top.equalTo(authorNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(authorImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }

    private func addArticleTitle() {
        contentView.addSubview(articleTitle)

        articleTitle.snp.makeConstraints { make in
            make.top.equalTo(authorImage.snp.bottom).offset(35).priority(.high)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
    }

    private func addArticleContentLabel() {
        contentView.addSubview(articleContentLabel)

        articleContentLabel.snp.makeConstraints { make in
            make.top.equalTo(articleTitle.snp.bottom).offset(15).priority(.high)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-150)
        }
    }
}
