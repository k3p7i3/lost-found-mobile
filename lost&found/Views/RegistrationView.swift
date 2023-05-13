import Foundation
import UIKit

final class RegistrationView: UIView {
    let appTitle: UILabel = UILabel()
    let nameField: UITextField = UITextField()
    let phoneField: UITextField = UITextField()
    let passwordField: UITextField = UITextField()
    
    let registrationButton: UIButton = UIButton()
    let loginButton: UIButton = UIButton()
    
    
    init(controller: RegistrationViewController) {
        super.init(frame: .zero)
        setDelegates(controller: controller)
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDelegates(controller: RegistrationViewController) {
        nameField.delegate = controller
        phoneField.delegate = controller
        passwordField.delegate = controller
        registrationButton.addTarget(
            controller,
            action: #selector(RegistrationViewController.registrateUser),
            for: .touchUpInside
        )
        loginButton.addTarget(
            controller,
            action: #selector(RegistrationViewController.showLoginController),
            for: .touchUpInside
        )
    }
    
    private func setTitle() {
        addSubview(appTitle)
        appTitle.font = .systemFont(ofSize: 34, weight: .semibold)
        appTitle.text = "Lost&Found"
        appTitle.textColor = .white
        appTitle.textAlignment = .center
        appTitle.pinCenterX(to: self)
        appTitle.pinTop(to: self, 200)
    }
    
    private func setTextFieldLayout(textField: UITextField) {
        addSubview(textField)
        textField.textColor = .white
        textField.backgroundColor = .white.withAlphaComponent(0.5)
        textField.pinLeft(to: self, 40)
        textField.pinRight(to: self, 40)
        textField.setHeight(45)
        textField.font = .systemFont(ofSize: 18, weight: .medium)
        textField.layer.cornerRadius = 15
        textField.setLeftPaddingPoints(30)
        textField.setRightPaddingPoints(30)
    }
    
    private func setNameFieldLayout() {
        setTextFieldLayout(textField: nameField)
        nameField.placeholder = "Name"
        nameField.pinCenterY(to: self, -80)
    }
    
    private func setPhoneFieldLayout() {
        setTextFieldLayout(textField: phoneField)
        phoneField.placeholder = "Phone Number"
        phoneField.pinTop(to: nameField.bottomAnchor, 20)
    }
    
    private func setPasswordFieldLayout() {
        setTextFieldLayout(textField: passwordField)
        passwordField.placeholder = "Password"
        passwordField.pinTop(to: phoneField.bottomAnchor, 20)
        passwordField.isSecureTextEntry = true
    }
    
    private func setRegistrationButton() {
        addSubview(registrationButton)
        registrationButton.setTitle("Registrate", for: .normal)
        registrationButton.setTitleColor(.white, for: .normal)
        registrationButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .semibold)
        registrationButton.pinTop(to: passwordField.bottomAnchor, 30)
        registrationButton.pinCenterX(to: self)
    }
    
    private func setLoginButton() {
        addSubview(loginButton)
        loginButton.setTitle(
            "Already have an account?\nSign in!",
            for: .normal
        )
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
        loginButton.titleLabel?.numberOfLines = 2
        loginButton.titleLabel?.textAlignment = .center
        loginButton.pinTop(to: registrationButton.bottomAnchor, 30)
        loginButton.pinCenterX(to: self)
        
    }
    
    private func setLayout() {
        backgroundColor = Constants.mainBlueColor
        setTitle()
        setNameFieldLayout()
        setPhoneFieldLayout()
        setPasswordFieldLayout()
        setRegistrationButton()
        setLoginButton()
        
    }
    
}
