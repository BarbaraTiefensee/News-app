//
//  ChangeProfileViewController.swift
//  News App
//
//  Created by Premier20 on 06/08/21.
//

import UIKit
import SnapKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import KeychainSwift


class ChangeProfileViewController: BaseViewController {
    
    let currentUser = Auth.auth().currentUser?.uid
    let firebase = FirebaseManager()
    let storageReference = Storage.storage().reference()
    let keychain = KeychainSwift()
    
    var viewModel: ChangeProfileViewModelProtocol
    
    private let scrollView: UIScrollView = UIScrollView()
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor.dynamicColor(light: .white, dark: .black)
        return view
    }()
    
    private let profileInformationsContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .none
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 66 / 2
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let changeImageButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.dynamicColor(light: .black, dark: .white), for: .normal)
        button.titleLabel?.font = .default(ofSize: 14, weight: .regular)
        button.setImage(.editIcon, for: .normal)
        button.setTitle(MessageType.editPhoto.message, for: .normal)
        button.addTarget(self, action: #selector(didTapChangeProfilePic), for: .touchUpInside)
        return button
    }()
    
    private lazy var firstNameTextField: NewsAppTextField = {
        let textField = NewsAppTextField(type: .name, placeholderCenter: MessageType.firstName.message, placeholder: MessageType.firstName.message)
        textField.textField.delegate = self
        return textField
    }()
    
    private lazy var lastNameTextField: NewsAppTextField = {
        let textField = NewsAppTextField(type: .name, placeholderCenter: MessageType.lastName.message, placeholder: MessageType.lastName.message)
        textField.textField.delegate = self
        return textField
    }()
    
    private lazy var emailTextField: NewsAppTextField = {
        let textField = NewsAppTextField(type: .emailRegister, placeholderCenter: MessageType.email.message, placeholder: MessageType.email.message, alert: MessageType.invalidEmail.message)
        textField.textField.delegate = self
        return textField
    }()
    
    private let sendButton: NewsAppButton = {
        let button = NewsAppButton()
        button.setTitle(MessageType.update.message, for: .normal)
        return button
    }()
    
    init(viewModel: ChangeProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.dynamicColor(light: .blue1E234A, dark: .gray171717)
        navigationController?.navigationBar.tintColor = .white
        setupView()
        isTabBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProfileImage(imageView: profilePicture)
        didSet()
        setNavigationController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isTabBarHidden = false
    }
}

// MARK: - Functions
extension ChangeProfileViewController {
    
    private func isEmailValid(email: String) -> Bool {
        if email.isEmail {
            self.appearCrossDissolve(with: emailTextField.alertLabel, isHidden: true)
            return true
        } else {
            self.appearCrossDissolve(with: emailTextField.alertLabel, isHidden: false)
            return false
        }
    }
    
    @objc private func isValidField() {
        guard let firstName = firstNameTextField.textField.text, let lastName = lastNameTextField.textField.text, let email = emailTextField.textField.text else {
            return
        }
        if firstName.count > 2 && lastName.count > 2 && isEmailValid(email: email) {
            sendButton.isEnabled = true
        } else {
            sendButton.isEnabled = false
        }
    }
    
    @objc private func sendDidTapped(){
        guard let email = emailTextField.textField.text, let firstName = firstNameTextField.textField.text, let lastName = lastNameTextField.textField.text else { return }
        showAlertSpinner()
        if email == viewModel.userEmail && firstName == viewModel.userFirstName && lastName == viewModel.userLastName {
            removeAlertSpinner(delay: 0.4)
            showAlert(title: "Ops!", message: "Nenhum dado foi alterado", doAction: UIAlertAction(title: "OK", style: .cancel, handler: nil))
        } else {
            viewModel.updateEmail(email: email)
            viewModel.updateName(firstname: firstName, lastName: lastName, userUid: currentUser)
            removeAlertSpinner(delay: 0.4)
            self.showAlert(title: MessageType.changeProfile.message, message: MessageType.changeProfileMessage.message, doAction: UIAlertAction(title: MessageType.ok.message, style: .default, handler: { _ in
                self.returnToLogin()
            }))
        }
    }
    
    private func returnToLogin() {
        keychain.clear()
        let loginViewController = LoginViewController()
        self.navigationController?.setViewControllers([loginViewController], animated: true)
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TextField Delegate
extension ChangeProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstNameTextField.textField {
            textField.resignFirstResponder()
            lastNameTextField.textField.becomeFirstResponder()
        } else if textField == lastNameTextField.textField  {
            textField.resignFirstResponder()
            emailTextField.textField.becomeFirstResponder()
        } else if textField == emailTextField.textField {
            sendDidTapped()
        }
        
        return true
    }
}

// MARK: - ProfileViewModelDelegate
extension ChangeProfileViewController: ChangeProfileViewModelDelegate {
    func didSet() {
        self.firstNameTextField.textField.text = viewModel.userFirstName
        self.lastNameTextField.textField.text = viewModel.userLastName
        self.emailTextField.textField.text = viewModel.userEmail
    }
}

//MARK: - SetNavigationController
extension ChangeProfileViewController {
    private func setNavigationController() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.default(ofSize: 20, weight: .semibold)]
        self.title = MessageType.editProfile.message
        navigationController?.navigationBar.tintColor = .dynamicColor(light: .white, dark: .white)
    }
}

// MARK: - Layout 
extension ChangeProfileViewController {
    
    private func setupView() {
        lastNameTextField.textField.addTarget(self, action: #selector(isValidField), for: .allEditingEvents)
        firstNameTextField.textField.addTarget(self, action: #selector(isValidField), for: .allEditingEvents)
        emailTextField.textField.addTarget(self, action: #selector(isValidField), for: .allEditingEvents)
        sendButton.addTarget(self, action: #selector(sendDidTapped), for: .touchUpInside)
        profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic)))
        addContainerView()
        addScrollView()
        addProfileInformationsContainerView()
        addProfileImage()
        addChangeImageButton()
        addFirstNameTextField()
        addLastNameTextField()
        addEmailTextField()
        addSendButton()
    }
    
    private func addContainerView() {
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.trailing.bottom.equalToSuperview()
            make.width.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func addScrollView() {
        containerView.addSubview(scrollView)
        scrollView.alwaysBounceVertical = true
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addProfileInformationsContainerView() {
        scrollView.addSubview(profileInformationsContainerView)
        
        profileInformationsContainerView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        profileInformationsContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(35)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(120)
        }
    }
    
    private func addProfileImage() {
        profileInformationsContainerView.addSubview(profilePicture)
        
        profileInformationsContainerView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        profilePicture.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(66)
        }
    }
    
    private func addChangeImageButton() {
        profileInformationsContainerView.addSubview(changeImageButton)
        
        changeImageButton.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        changeImageButton.snp.makeConstraints { make in
            make.top.equalTo(profilePicture.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    private func addFirstNameTextField() {
        scrollView.addSubview(firstNameTextField)
        
        firstNameTextField.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileInformationsContainerView.snp.bottom).offset(36)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).offset(-25)
            make.height.equalTo(70)
        }
    }
    
    private func addLastNameTextField() {
        scrollView.addSubview(lastNameTextField)
        
        lastNameTextField.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(25)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).offset(-25)
            make.height.equalTo(70)
        }
    }
    
    private func addEmailTextField() {
        scrollView.addSubview(emailTextField)
        
        emailTextField.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(lastNameTextField.snp.bottom).offset(25)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).offset(-25)
            make.height.equalTo(70)
        }
    }
    
    private func addSendButton() {
        scrollView.addSubview(sendButton)
        
        sendButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(emailTextField.snp.bottom).offset(60)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).offset(-25)
            make.bottom.equalToSuperview().offset(UIScreen.is4InchDevice ? -40 : -60)
            make.height.equalTo(45)
        }
    }
}
