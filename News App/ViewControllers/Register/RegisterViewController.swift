//
//  RegisterViewController.swift
//  News App
//
//  Created by Premier20 on 15/07/21.
//

import UIKit
import SnapKit
import IQKeyboardManagerSwift

class RegisterViewController: BaseViewController {
    
    private let scrollView: UIScrollView = UIScrollView()
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor.dynamicColor(light: .white, dark: .black)
        return view
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = MessageType.welcome.message
        label.textAlignment = .center
        label.numberOfLines = 3
        label.font = .default(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var firstNameTextField: NewsAppTextField = {
        let textfield = NewsAppTextField(type: .name, placeholderCenter: MessageType.firstName.message, placeholder: MessageType.firstName.message)
        textfield.textField.delegate = self
        return textfield
    }()
    
    private lazy var lastNameTextField: NewsAppTextField = {
        let textfield = NewsAppTextField(type: .name, placeholderCenter: MessageType.lastName.message, placeholder: MessageType.lastName.message)
        textfield.textField.delegate = self
        return textfield
    }()
    
    private lazy var emailTextField: NewsAppTextField = {
        let textfield = NewsAppTextField(type: .emailRegister, placeholderCenter: MessageType.email.message, placeholder: MessageType.email.message, alert: MessageType.emailIncorrectOrNotExist.message)
        textfield.textField.delegate = self
        textfield.textField.addTarget(self, action: #selector(isEmailValid), for: .editingDidEnd)
        return textfield
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = MessageType.accessPassword.message
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .default(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var passwordTextField: NewsAppTextField = {
        let textfield = NewsAppTextField(type: .passwordRegister, placeholderCenter: MessageType.password.message, placeholder: MessageType.password.message, alert: MessageType.differentPassword.message)
        textfield.textField.delegate = self
        return textfield
    }()
    
    private lazy var passwordAgainTextField: NewsAppTextField = {
        let textfield = NewsAppTextField(type: .passwordRegister, placeholderCenter: MessageType.passwordAgain.message, placeholder: MessageType.passwordAgain.message)
        textfield.textField.delegate = self
        textfield.textField.addTarget(self, action: #selector(isSamePassword), for: .editingDidEnd)
        return textfield
    }()
    
    private let registerButton: NewsAppButton = {
        let button = NewsAppButton()
        button.setTitle(MessageType.registerButton.message, for: .normal)
        button.addTarget(self, action: #selector(didTapped), for: .touchUpInside)
        return button
    }()
    
    private let termsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 3
        label.textColor = UIColor.dynamicColor(light: .black, dark: .white)
        label.font = UIFont.default(ofSize: 13, weight: .regular)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.dynamicColor(light: .blue1E234A, dark: .gray171717)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isTabBarHidden = true
        setupNavigationBar()
    }
}

// MARK: -Register functions
extension RegisterViewController {
    
    @objc private func isEmailValid() {
        guard let email = emailTextField.textField.text else { return }
        if email.isEmail {
            self.appearCrossDissolve(with: emailTextField.alertLabel, isHidden: true)
        } else {
            self.appearCrossDissolve(with: emailTextField.alertLabel, isHidden: false)
        }
    }
    
    @objc private func isSamePassword() {
        guard let password = passwordTextField.textField.text, let repeatPassword = passwordAgainTextField.textField.text else { return }
        
        if password != repeatPassword {
            self.appearCrossDissolve(with: passwordTextField.alertLabel, isHidden: false)
        } else {
            self.appearCrossDissolve(with: passwordTextField.alertLabel, isHidden: true)
        }
    }
    
    @objc private func didTapped(){
        guard let firstName = firstNameTextField.textField.text, let lastName = lastNameTextField.textField.text, let email = emailTextField.textField.text, let password = passwordTextField.textField.text, let repeatPassword = passwordAgainTextField.textField.text else { return }
        if firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || repeatPassword.isEmpty {
            self.showAlert(title: MessageType.error.message, message: MessageType.completeAllFields.message)
        } else {
            if password == repeatPassword {
                register()
            }
        }
    }
    
    private func register() {
        let signUp = FirebaseManager()
        if let email = emailTextField.textField.text, let password = passwordTextField.textField.text, let firstName = firstNameTextField.textField.text, let lastName = lastNameTextField.textField.text {
            self.showAlertSpinner()
            signUp.createUser(firstName: firstName, lastName: lastName, email: email, password: password) { [weak self] success in
                guard let `self` = self else { return }
                if success {
                    self.showAlert(title: MessageType.success.message, message: MessageType.successfullyCreated.message, doAction: UIAlertAction(title: MessageType.ok.message, style: .cancel, handler: { action in
                        self.selectHomeViewTab()
                        
                    }))
                } else {
                    self.showAlert(title: MessageType.error.message, message: MessageType.somethingWasWrong.message)
                }
            }
            self.removeAlertSpinner(delay: 0.5)
        }
    }
}

// MARK: - TextField Delegate
extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstNameTextField.textField {
            textField.resignFirstResponder()
            lastNameTextField.textField.becomeFirstResponder()
        } else if textField == lastNameTextField.textField  {
            textField.resignFirstResponder()
            emailTextField.textField.becomeFirstResponder()
        } else if textField == emailTextField.textField {
            textField.resignFirstResponder()
            passwordTextField.textField.becomeFirstResponder()
        } else if textField == passwordTextField.textField {
            textField.resignFirstResponder()
            passwordAgainTextField.textField.becomeFirstResponder()
        } else if textField == passwordAgainTextField.textField {
            didTapped()
        }
        
        return true
    }
}

// MARK: - Select Home View Tab Bar
extension RegisterViewController {
    
    func selectHomeViewTab() {
        self.showAlertSpinner()
        if let tabBar = self.tabBarController as? NewsTabBarController {
            tabBar.userHasSuccessfullyRegistered()
        }
        self.removeAlertSpinner(delay: 0.5)
    }
}

//MARK: - Layout
extension RegisterViewController {
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupView() {
        addContainerView()
        addScrollView()
        addWelcomeLabel()
        addFirstNameTextField()
        addLastNameTextField()
        addEmailTextField()
        addPasswordLabel()
        addPasswordTextField()
        addPasswordAgainTextField()
        addRegisterButton()
        addTermsLabel()
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
            make.edges.width.equalToSuperview()
        }
    }
    
    private func addWelcomeLabel() {
        scrollView.addSubview(welcomeLabel)
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalTo(view).offset(10)
            make.trailing.equalTo(view).offset(-10)
        }
    }
    
    private func addFirstNameTextField() {
        scrollView.addSubview(firstNameTextField)
        
        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(60)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).offset(-25)
            make.height.equalTo(70)
        }
    }
    
    private func addLastNameTextField() {
        scrollView.addSubview(lastNameTextField)
        
        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(25)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).offset(-25)
            make.height.equalTo(70)
        }
    }
    
    private func addEmailTextField() {
        scrollView.addSubview(emailTextField)
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(lastNameTextField.snp.bottom).offset(25)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).offset(-25)
            make.height.equalTo(70)
        }
    }
    
    private func addPasswordLabel() {
        scrollView.addSubview(passwordLabel)
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(50)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).offset(-25)
            make.height.equalTo(16)
        }
    }
    
    private func addPasswordTextField() {
        scrollView.addSubview(passwordTextField)
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).offset(-25)
            make.height.equalTo(70)
        }
    }
    
    private func addPasswordAgainTextField() {
        scrollView.addSubview(passwordAgainTextField)
        
        passwordAgainTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).offset(-25)
            make.height.equalTo(70)
        }
    }
    
    private func addRegisterButton(){
        scrollView.addSubview(registerButton)
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(passwordAgainTextField.snp.bottom).offset(45)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).offset(-25)
            make.height.equalTo(45)
        }
    }
    
    private func addTermsLabel() {
        scrollView.addSubview(termsLabel)
        
        let attributedString = NSMutableAttributedString()
            .normal(NSLocalizedString("Ao realizar se cadastrar, você concorda com nossos ", comment: ""))
            .bold(NSLocalizedString("Termos de Serviço ", comment: ""))
            .normal(NSLocalizedString("e com as nossa ", comment: ""))
            .bold(NSLocalizedString("Políticas de Privacidade", comment: ""))
        
        termsLabel.attributedText = attributedString
        
        termsLabel.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(60)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).offset(-25)
            make.bottom.equalToSuperview().offset(UIScreen.is4InchDevice ? -40 : -60)
        }
    }
}
