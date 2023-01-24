//
//  ProfileViewController.swift
//  News App
//
//  Created by Premier on 19/07/21.
//

import UIKit
import SnapKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import Firebase
import KeychainSwift

class ProfileViewController: BaseViewController {
    
    //MARK: - Attributes
    private var savedArticlesCount = 0
    
    private let storageReference = Storage.storage().reference()
    private let databaseReference = Database.database().reference()
    private let currentUser = Auth.auth().currentUser
    let keychain = KeychainSwift()
    
    private lazy var viewModel = ProfileViewModel(delegate: self)
    
    private let profileInformationsContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .none
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 66 / 2
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.default(ofSize: 18, weight: .semibold)
        label.textColor = .dynamicColor(light: .blue1E234A, dark: .white)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let mailIcon: UIImageView = {
        let imageView = UIImageView(image: .mailIcon)
        imageView.tintColor = .dynamicColor(light: .blue1E234A, dark: .white)
        imageView.image = .mailIcon
        return imageView
    }()
    
    private let userEmailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.default(ofSize: 16, weight: .regular)
        label.textColor = .dynamicColor(light: .blue1E234A, dark: .white)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let savedArticlesLabel: UILabel = {
        let label = UILabel()
        label.text = MessageType.savedArticles.message
        label.font = UIFont.default(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let haveNoOneSavedArticleLabel: UILabel = {
        let label = UILabel()
        label.text = MessageType.noSavedArticles.message
        label.font = UIFont.default(ofSize: 16, weight: .bold)
        label.isHidden = true
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseID)
        tableView.rowHeight = 120
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .dynamicColor(light: .white, dark: .black)
        self.title = MessageType.profile.message
        setup()
        setVisibilityOfArrangedSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.loadData()
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.tintColor = .dynamicColor(light: .black, dark: .white)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont.default(ofSize: 20, weight: .semibold)]
    }
}

// MARK: - Functions
extension ProfileViewController {
    
    private func addRightNavigationBarItems() {
        let menu = UIMenu(image: .menuIcon, children: [
            UIAction(title: MessageType.editProfile.message, image: .editIcon) { action in
                self.goToChangeProfileViewController()
            },
            UIAction(title: MessageType.changePassword.message, image: .passwordIcon) { action in
                self.goToChangePasswordViewController()
            },
            UIAction(title: MessageType.exit.message, image: .exitIcon) { action in
                self.signOutButton()
            }
        ])
        
        if #available(iOS 14.0, *) {
            let menuButton = UIBarButtonItem(image: .menuIcon, primaryAction: .none, menu: menu)
            navigationItem.setRightBarButtonItems([menuButton], animated: true)
        } else {
            let menuButton = UIBarButtonItem(image: .menuIcon, style: .plain, target: self, action: #selector(logoutAlert))
            navigationItem.setRightBarButtonItems([menuButton], animated: true)
        }
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .dynamicColor(light: .blue1E234A, dark: .white)
    }
    
    @objc private func logoutAlert(_ sender: UIButton) {
        self.showAlert(title: MessageType.whatUGonnaDo.message,
                       message: "",
                       preferredStyle: .actionSheet,
                       doAction: UIAlertAction(title: MessageType.editProfile.message,
                                               style: .default,
                                               handler: { _ in
                                               self.goToChangeProfileViewController()
                                               }),
                       elseAction: UIAlertAction(title: MessageType.changePassword.message,
                                               style: .default,
                                               handler: { _ in
                                               self.goToChangePasswordViewController()
                                               }),
                       thirdAction: UIAlertAction(title: MessageType.exit.message,
                                                  style: .destructive,
                                                  handler: { _ in
                                                  self.signOutButton()
                                                  }),
                       cancelAction: UIAlertAction(title: MessageType.cancelButton.message,
                                                   style: .cancel,
                                                   handler: nil))
        
        
    }
    
    private func signOutButton() {
        self.showAlert(title: MessageType.wantToLeave.message,
                       message: MessageType.loginAgain.message,
                       doAction: UIAlertAction(title: MessageType.exit.message,
                                               style: .destructive,
                                               handler: { _ in
                                                self.confirmSignOutButton()
                                                self.keychain.clear()
                                               }),
                       elseAction: UIAlertAction(title: MessageType.cancelButton.message,
                                                 style: .cancel,
                                                 handler: nil))
    }
    
    private func confirmSignOutButton() {
        if let viewControllers = navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is LoginViewController {
                    self.navigationController?.popViewController(animated: true)
                    return
                }
            }
        }
        let loginViewController = LoginViewController()
        self.navigationController?.viewControllers.insert(loginViewController, at: 0)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func goToChangeProfileViewController() {
        viewModel.showEditProfileViewController()
    }
    
    private func goToChangePasswordViewController() {
        let changePassword = ChangePasswordViewController()
        self.navigationController?.pushViewController(changePassword, animated: true)
    }
    
    private func setVisibilityOfArrangedSubviews() {
        if savedArticlesCount > 0 {
            self.haveNoOneSavedArticleLabel.isHidden = true
            self.tableView.isHidden = false
        } else {
            self.haveNoOneSavedArticleLabel.isHidden = false
            self.tableView.isHidden = true
        }
    }
    
    func setProfileImage(imageView: UIImageView) {
        if let user = currentUser {
            viewModel.firebase.observeSingleEventOfValue(in: user.uid) { value in
                UIImageView.loadFromProfile(urlImage: value["imageURL"], image: imageView)
            }
        }
    }
}

//MARK: - Table View Delegate
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedArticlesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseID, for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: - Profile View Model Delegate
extension ProfileViewController: ProfileViewModelDelegate {
    func moveToViewController(firstname: String?, lastName: String?, email: String?) {
        let model = ChangeProfileViewModel(firstName: firstname, lastName: lastName, email: email)
        let changeProfile = ChangeProfileViewController(viewModel: model)
        navigationController?.pushViewController(changeProfile, animated: true)
    }
    
    func didLoadName(result: Result<String, Error>) {
        switch result {
        case.success(let name):
            userNameLabel.text = name
        case .failure(let error):
            showAlert(title: "Ops!", message: error.localizedDescription)
        }
    }
    
    func didLoadEmail(result: Result<String, Error>) {
        switch result {
        case.success(let email):
            userEmailLabel.text = email
        case .failure(let error):
            showAlert(title: "Ops!", message: error.localizedDescription)
        }
    }
    
    func didLoadProfilePicture(result: Result<String, Error>) {
        switch result {
        case.success(let image):
            guard let urlImage = URL(string: image) else { return }
            profilePicture.kf.setImage(with: urlImage)
        case .failure(let error):
            showAlert(title: "Ops!", message: error.localizedDescription)
        }
    }
}

//MARK: - Constraints
extension ProfileViewController {
        
    private func setup() {
        addProfileInformationsContainerView()
        addProfileImage()
        addUserNameLabel()
        addMailIcon()
        addUserEmail()
        addSavadArticlesLabel()
        addTableView()
        addHaveNoOneSavedArticle()
        addRightNavigationBarItems()
    }
    
    private func addStackView() {
        haveNoOneSavedArticleLabel.isHidden = true
        tableView.isHidden = true
        
        let stackView = UIStackView(arrangedSubviews: [tableView, haveNoOneSavedArticleLabel])
        stackView.backgroundColor = .white
        view.addSubview(stackView)
        
        if savedArticlesCount > 0 {
            haveNoOneSavedArticleLabel.isHidden = true
        } else {
            tableView.isHidden = false
        }
        
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(savedArticlesLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func addProfileInformationsContainerView() {
        view.addSubview(profileInformationsContainerView)
        
        profileInformationsContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
    }
    
    private func addProfileImage() {
        profileInformationsContainerView.addSubview(profilePicture)
        
        profilePicture.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.size.equalTo(66)
        }
    }
    
    private func addUserNameLabel() {
        profileInformationsContainerView.addSubview(userNameLabel)
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.leading.equalTo(profilePicture.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    private func addMailIcon() {
        profileInformationsContainerView.addSubview(mailIcon)
        
        mailIcon.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(15)
            make.leading.equalTo(profilePicture.snp.trailing).offset(15)
            make.size.equalTo(12)
        }
    }
    
    private func addUserEmail() {
        profileInformationsContainerView.addSubview(userEmailLabel)
        
        userEmailLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(mailIcon.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-22)
        }
    }
    
    private func addSavadArticlesLabel() {
        view.addSubview(savedArticlesLabel)
        
        savedArticlesLabel.snp.makeConstraints { make in
            make.top.equalTo(profileInformationsContainerView.snp.bottom).offset(65)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
    }
    
    private func addTableView() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(savedArticlesLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func addHaveNoOneSavedArticle() {
        self.view.addSubview(haveNoOneSavedArticleLabel)
        
        haveNoOneSavedArticleLabel.snp.makeConstraints { make in
            make.top.equalTo(savedArticlesLabel.snp.bottom).offset(80)
            make.trailing.equalTo(view).offset(-25)
            make.leading.equalTo(view).offset(25)
            make.centerX.equalToSuperview()
        }
    }
}

