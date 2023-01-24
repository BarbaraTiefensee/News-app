//
//  NewsAppTextField.swift
//  News App
//
//  Created by Premier20 on 15/07/21.
//

import UIKit

enum NewsAppTextFieldType {
    case none
    case emailLogin
    case emailRegister
    case passwordLogin
    case passwordRegister
    case name
}

class NewsAppTextField: UIView {
    
    private let placeholder: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = .default(ofSize: 15, weight: .regular)
        label.textColor = UIColor.dynamicColor(light: .gray4D4D4D, dark: .white)
        return label
    }()
    
    let alertLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = .default(ofSize: 16, weight: .regular)
        label.textColor = UIColor.dynamicColor(light: .black.withAlphaComponent(0.7), dark: .white.withAlphaComponent(0.7))
        label.isHidden = true
        return label
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .words
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 10
        textField.textColor = UIColor.dynamicColor(light: .black, dark: .white)
        textField.backgroundColor = UIColor.dynamicColor(light: .grayF2F2F2, dark: .gray4D4D4D)
        return textField
    }()
    
    private let textFieldIcon: UIImageView = {
        let icon = UIImageView()
        icon.tintColor = UIColor.dynamicColor(light: .black, dark: .white)
        icon.frame = CGRect(x: 15, y: 7, width: 30, height: 30)
        return icon
    }()
    
    private let eyePasswordButton: UIButton = {
        let button =  UIButton()
        button.setImage(.eyeClosedIcon, for: .normal)
        return button
    }()
    
    private let type: NewsAppTextFieldType
    
    init(type: NewsAppTextFieldType = .none, placeholderCenter: String? = nil , placeholder: String? = nil, icon: UIImage? = nil, alert: String? = nil) {
        self.type = type
        self.placeholder.text = placeholder
        self.textField.placeholder = placeholderCenter
        self.textFieldIcon.image = icon
        self.alertLabel.text = alert
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewsAppTextField {
    
    private func setupView() {
        eyePasswordButton.addTarget(self, action: #selector(togglePasswordText), for: .touchUpInside)
        addPlaceHolder()
        addTextField()
        addAlertLabel()
        switch type {
        case .emailLogin:
            addImageIcon()
            textField.autocapitalizationType = .none
            textField.keyboardType = .emailAddress
        case .passwordLogin:
            addImageIcon()
            addEyePasswordButton()
        case .name:
            spaceOnTextField()
        case .emailRegister:
            spaceOnTextField()
            textField.autocapitalizationType = .none
            textField.keyboardType = .emailAddress
        case .passwordRegister:
            spaceOnTextField()
            addEyePasswordButton()
        default:
            break
        }
    }
}

extension NewsAppTextField {
    
    @objc private func togglePasswordText() {
        if textField.isSecureTextEntry {
            eyePasswordButton.setImage(.eyeOpenIcon, for: .normal)
        } else {
            eyePasswordButton.setImage(.eyeClosedIcon, for: .normal)
        }
        
        textField.isSecureTextEntry = !textField.isSecureTextEntry
    }
}

//MARK: - Layout
extension NewsAppTextField {
    
    private func addPlaceHolder() {
        addSubview(placeholder)
        
        placeholder.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(15)
        }
    }
    
    private func addAlertLabel() {
        addSubview(alertLabel)
        
        alertLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.lessThanOrEqualTo(placeholder.snp.trailing)
            make.height.equalTo(15)
        }
    }
    
    private func addTextField() {
        addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(placeholder.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    private func addImageIcon() {
        let paddingViewRight = UIView()
        paddingViewRight.frame = CGRect(x: 0, y: 0, width: 10, height: 45)
        textField.rightViewMode = UITextField.ViewMode.always
        textField.rightView = paddingViewRight
        
        let paddingViewLeft = UIView()
        paddingViewLeft.frame = CGRect(x: 0, y: 0, width: 55, height: 45)
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = paddingViewLeft
        
        paddingViewLeft.addSubview(textFieldIcon)
    }
    
    private func spaceOnTextField() {
        let paddingViewRight = UIView()
        paddingViewRight.frame = CGRect(x: 0, y: 0, width: 10, height: 45)
        textField.rightViewMode = UITextField.ViewMode.always
        textField.rightView = paddingViewRight
        
        let paddingViewLeft = UIView()
        paddingViewLeft.frame = CGRect(x: 0, y: 0, width: 15, height: 45)
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = paddingViewLeft
    }
    
    private func addEyePasswordButton() {
        textField.rightView = eyePasswordButton
        textField.isSecureTextEntry = true
        textField.rightView?.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }
}
