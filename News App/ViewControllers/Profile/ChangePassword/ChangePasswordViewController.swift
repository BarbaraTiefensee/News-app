//
//  ChangePasswordViewController.swift
//  News App
//
//  Created by Premier20 on 13/08/21.
//

import UIKit
import SnapKit
import Firebase
import FirebaseAuth
import FirebaseStorage


class ChangePasswordViewController: BaseViewController {
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor.dynamicColor(light: .white, dark: .black)
        return view
    }()
    
    private var viewModel = ChangeProfileViewModel(firstName: "", lastName: "", email: "")
    
    private lazy var passwordTextField: NewsAppTextField = {
        let textField = NewsAppTextField(type: .passwordRegister, placeholderCenter: MessageType.password.message, placeholder: MessageType.password.message, alert: MessageType.invalidPassword.message)
        textField.textField.delegate = self
        return textField
    }()
    
    private lazy var newPasswordTextField: NewsAppTextField = {
        let textField = NewsAppTextField(type: .passwordRegister, placeholderCenter: MessageType.newPassword.message, placeholder: MessageType.newPassword.message, alert: MessageType.differentPassword.message)
        textField.textField.delegate = self
        textField.textField.addTarget(self, action: #selector(enabledButtonIfIsPossible), for: .editingDidEnd)
        return textField
    }()
    
    private lazy var confirmNewPasswordTextField: NewsAppTextField = {
        let textField = NewsAppTextField(type: .passwordRegister, placeholderCenter: MessageType.confirmNewPassword.message, placeholder: MessageType.confirmNewPassword.message)
        textField.textField.delegate = self
        textField.textField.addTarget(self, action: #selector(enabledButtonIfIsPossible), for: .editingDidEnd)
        return textField
    }()
    
    private let sendButton: NewsAppButton = {
        let button = NewsAppButton()
        button.isEnabled = false
        button.setTitle(MessageType.update.message, for: .normal)
        button.addTarget(self, action: #selector(sendDidTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.dynamicColor(light: .blue1E234A, dark: .gray171717)
        navigationController?.navigationBar.tintColor = .white
        setupView()
        isTabBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isTabBarHidden = false
    }
}

// MARK: - Functions
extension ChangePasswordViewController {
    
    @objc private func enabledButtonIfIsPossible() {
        guard let password = passwordTextField.textField.text, let newPassword = newPasswordTextField.textField.text, let confirmNewPassword = confirmNewPasswordTextField.textField.text else { return }
        if newPassword.count > 5 && confirmNewPassword.count > 5 && password.isEmpty == false && newPassword == confirmNewPassword {
            sendButton.isEnabled = true
            self.appearCrossDissolve(with: newPasswordTextField.alertLabel, isHidden: true)
        } else {
            sendButton.isEnabled = false
            self.appearCrossDissolve(with: newPasswordTextField.alertLabel, isHidden: false)
        }
    }
    
    @objc private func sendDidTapped(){
        guard let currentPassword = passwordTextField.textField.text, let newPassword = newPasswordTextField.textField.text else { return }
        showAlertSpinner()
        viewModel.reauthenticateAndChangePassword(currentPassword: currentPassword, newPassword: newPassword) { success in
            if success == true {
                self.appearCrossDissolve(with: self.passwordTextField.alertLabel, isHidden: true)
                self.showAlert(title: MessageType.success.message, message: MessageType.successfullyPassword.message, doAction: UIAlertAction(title: MessageType.ok.message, style: .default, handler: { _ in
                    self.returnToProfile()
                }))
            } else {
                self.appearCrossDissolve(with: self.passwordTextField.alertLabel, isHidden: false)
            }
        }
        self.removeAlertSpinner(delay: 0.5)
    }
    
    private func returnToProfile() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TextField Delegate
extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == passwordTextField.textField {
            textField.resignFirstResponder()
            newPasswordTextField.textField.becomeFirstResponder()
        } else if textField == newPasswordTextField.textField  {
            textField.resignFirstResponder()
            confirmNewPasswordTextField.textField.becomeFirstResponder()
        } else if textField == confirmNewPasswordTextField.textField {
            sendDidTapped()
        }
        
        return true
    }
}

//MARK: - SetNavigationController
extension ChangePasswordViewController {
    private func setNavigationController() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.default(ofSize: 20, weight: .semibold)]
        self.title = MessageType.changePassword.message
        navigationController?.navigationBar.tintColor = .dynamicColor(light: .white, dark: .white)
    }
}

// MARK: - Layout
extension ChangePasswordViewController {
    
    private func setupView() {
        addContainerView()
        addPasswordTextField()
        addNewPasswordTextField()
        addConfirmNewPasswordTextField()
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
    
    private func addPasswordTextField() {
        containerView.addSubview(passwordTextField)
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).offset(-25)
            make.height.equalTo(75)
        }
    }
    
    private func addNewPasswordTextField() {
        containerView.addSubview(newPasswordTextField)
        
        newPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(25)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).offset(-25)
            make.height.equalTo(75)
        }
    }
    
    private func addConfirmNewPasswordTextField() {
        containerView.addSubview(confirmNewPasswordTextField)
        
        confirmNewPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(newPasswordTextField.snp.bottom).offset(25)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).offset(-25)
            make.height.equalTo(75)
        }
    }
    
    private func addSendButton() {
        containerView.addSubview(sendButton)
        
        sendButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(confirmNewPasswordTextField.snp.bottom).offset(60)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).offset(-25)
            make.bottom.equalToSuperview().offset(UIScreen.is4InchDevice ? -40 : -60)
            make.height.equalTo(45)
        }
    }
}
