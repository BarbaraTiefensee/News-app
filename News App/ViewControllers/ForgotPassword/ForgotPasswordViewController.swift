//
//  ForgotPasswordViewController.swift
//  News App
//
//  Created by Premier20 on 20/07/21.
//

import UIKit
import SnapKit

class ForgotPasswordViewController: BaseViewController {
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.text = MessageType.emailCode.message
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.textAlignment = .center
        label.numberOfLines = 3
        label.font = .default(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let emailTextField: NewsAppTextField = {
        let textField = NewsAppTextField(type: .emailLogin, placeholderCenter: MessageType.email.message, icon: .userIcon, alert: MessageType.emailIncorrectOrNotExist.message)
        return textField
    }()
    
    private let sendButton: NewsAppButton = {
        let button = NewsAppButton()
        button.setTitle(MessageType.send.message, for: .normal)
        button.addTarget(self, action: #selector(sendDidTapped), for: .touchUpInside)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(MessageType.cancel.message, for: .normal)
        button.addTarget(self, action: #selector(cancelDidTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.setTitleColor(UIColor.dynamicColor(light: .black, dark: .white), for: .normal)
        button.titleLabel?.font = .default(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor.dynamicColor(light: .white, dark: .black)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.dynamicColor(light: .white, dark: .black)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        isTabBarHidden = true
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillDisappear(true)
    }
}

// MARK: -Functions
extension ForgotPasswordViewController {
    
    @objc private func sendDidTapped(){
        guard let email = emailTextField.textField.text else { return }
        if email.isEmpty {
            self.showAlert(title: MessageType.error.message, message: MessageType.emailField.message)
        } else {
            sendEmail()
        }
    }
    
    private func sendEmail() {
        let changePassword = FirebaseManager()
        if let email = emailTextField.textField.text {
            changePassword.sendPasswordReset(withEmail: email) { [weak self] error in
                guard let `self` = self else { return }
                if error != nil {
                    self.appearCrossDissolve(with: self.emailTextField.alertLabel, isHidden: false)
                } else {
                    self.showAlert(title: MessageType.success.message, message: MessageType.sendEmail.message , doAction: UIAlertAction(title: MessageType.ok.message, style: .cancel, handler: { action in
                        self.navigationController?.popToRootViewController(animated: true)
                        self.appearCrossDissolve(with: self.emailTextField.alertLabel, isHidden: true)
                    }))
                }
            }
        }
    }
    
    @objc private func cancelDidTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: -Layout
extension ForgotPasswordViewController {
    
    private func setupView() {
        addCodeLabel()
        addEmailTextField()
        addSendButton()
        addCancelButton()
    }
    
    private func addCodeLabel() {
        view.addSubview(codeLabel)
        
        codeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
    }
    
    private func addEmailTextField() {
        view.addSubview(emailTextField)
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(codeLabel.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(70)
        }
    }
    
    private func addSendButton() {
        view.addSubview(sendButton)
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(35)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(45)
        }
    }
    
    private func addCancelButton() {
        view.addSubview(cancelButton)
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(sendButton.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(45)
        }
    }
}
