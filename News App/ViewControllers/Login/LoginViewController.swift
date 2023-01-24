//
//  LoginViewController.swift
//  News App
//
//  Created by Premier20 on 15/07/21.
//

import UIKit
import SnapKit

class LoginViewController: BaseViewController {
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = MessageType.loginMessage.message
        label.font = .default(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailTextField: NewsAppTextField = {
        let textField = NewsAppTextField(type: .emailLogin, placeholderCenter: MessageType.email.message, icon: .userIcon, alert: MessageType.invalidEmail.message)
        textField.textField.delegate = self
        return textField
    }()
    
    private lazy var passwordTextField: NewsAppTextField = {
        let textField = NewsAppTextField(type: .passwordLogin, placeholderCenter: MessageType.password.message, icon: .lockIcon)
        textField.textField.delegate = self
        return textField
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle(MessageType.forgotPassword.message, for: .normal)
        button.setTitleColor(UIColor.dynamicColor(light: .black, dark: .white), for: .normal)
        button.titleLabel?.font = .default(ofSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(forgotPasswordButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private let loginButton: NewsAppButton = {
        let button = NewsAppButton()
        let title = MessageType.login.message
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(loginButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private let registerLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Não possui uma conta?", comment: "")
        label.font = .default(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        let title = MessageType.register.message
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.dynamicColor(light: .black, dark: .white), for: .normal)
        button.titleLabel?.font = .default(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(registerButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.dynamicColor(light: .white, dark: .black)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isTabBarHidden = false
        self.emailTextField.textField.text = ""
        self.passwordTextField.textField.text = ""
    }
}

// MARK: - TextField Delegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField.textField {
            textField.resignFirstResponder()
            passwordTextField.textField.becomeFirstResponder()
        } else if textField == passwordTextField.textField  {
            loginButtonDidTapped()
        }
        
        return true
    }
}

//MARK: - Buttons Functions
extension LoginViewController {
    
    @objc private func registerButtonDidTapped(_ sender: UIButton) {
        let view = RegisterViewController()
        view.navigationController?.hidesBottomBarWhenPushed = true
        view.navigationItem.leftBarButtonItem = UIBarButtonItem(image: .backIcon, style: .plain, target: view, action: #selector(view.dismissViewController))
        self.navigationController?.view.layer.add(self.pushVerticallyViewController, forKey: kCATransition)
        self.navigationController?.pushViewController(view, animated: false)
    }
    
    @objc private func loginButtonDidTapped(){
        guard let email = emailTextField.textField.text, let password = passwordTextField.textField.text else { return }
        if email.isEmpty || password.isEmpty {
            self.showAlert(title: MessageType.error.message, message: MessageType.completeAllFields.message)
        } else {
            login()
        }
    }
        
    private func login() {
        let loginManager = FirebaseManager()
        self.showAlertSpinner()
        if let email = emailTextField.textField.text, let password = passwordTextField.textField.text {
            loginManager.signIn(email: email, password: password) { success in
                if success {
                    let view = ProfileViewController()
                    self.navigationController?.pushViewController(view, animated: true)
                    self.removeAlertSpinner(delay: 0.5)
                    self.appearCrossDissolve(with: self.emailTextField.alertLabel, isHidden: true)
                } else {
                    self.removeAlertSpinner(delay: 0.5)
                    self.appearCrossDissolve(with: self.emailTextField.alertLabel, isHidden: false)
                }
            }
        }
    }
    
    @objc private func forgotPasswordButtonDidTapped(_ sender: UIButton) {
        let view = ForgotPasswordViewController()
        view.navigationController?.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(view, animated: true)
    }
}

//MARK: - Layout
extension LoginViewController {
    
    private func setupView() {
        addContentview()
        addScrollView()
        addLoginLabel()
        addEmailTextField()
        addPasswordTextField()
        addForgotPasswordButton()
        addLoginButton()
        addRegisterLabel()
        addRegisterButton()
    }
    
    private func addContentview() {
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-45)
        }
    }
    
    private func addScrollView() {
        contentView.addSubview(scrollView)
        scrollView.alwaysBounceVertical = true

        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func addLoginLabel() {
        scrollView.addSubview(loginLabel)
        
        loginLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIScreen.is4InchDevice ? 45 : 60)
            make.centerX.equalTo(view)
            make.height.equalTo(20)
        }
    }
    
    private func addEmailTextField() {
        scrollView.addSubview(emailTextField)
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(UIScreen.is4InchDevice ? 45 : 60)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).offset(-25)
            make.height.equalTo(70)
        }
    }
    
    private func addPasswordTextField() {
        scrollView.addSubview(passwordTextField)
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).offset(-25)
            make.height.equalTo(70)
        }
    }
    
    private func addForgotPasswordButton() {
        scrollView.addSubview(forgotPasswordButton)
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.trailing.equalTo(view).offset(-25)
        }
    }
    
    private func addLoginButton() {
        scrollView.addSubview(loginButton)
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(forgotPasswordButton.snp.bottom).offset(UIScreen.is4InchDevice ? 50 : 60)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).offset(-25)
            make.height.equalTo(45)
        }
    }
    
    private func addRegisterLabel() {
        scrollView.addSubview(registerLabel)
        
        registerLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.centerX.lessThanOrEqualToSuperview().offset(-50).priority(.high)
            make.bottom.equalToSuperview().offset((UIScreen.is4InchDevice ? -40 : -60))
            make.height.equalTo(16)
        }
    }
    
    private func addRegisterButton() {
        scrollView.addSubview(registerButton)
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.leading.equalTo(registerLabel.snp.trailing).offset(2)
            make.bottom.equalToSuperview().offset((UIScreen.is4InchDevice ? -40 : -60))
            make.height.equalTo(16)
        }
    }
}
