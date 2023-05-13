import Foundation
import UIKit

final class LoginView: UIView {
    let appTitle: UILabel = UILabel()
    let phoneField: UITextField = UITextField()
    let passwordField: UITextField = UITextField()
    
    let loginButton: UIButton = UIButton()
    let registrationButton: UIButton = UIButton()
    
    init(controller: LoginViewController) {
        super.init(frame: .zero)
        setDelegates(controller: controller)
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDelegates(controller: LoginViewController) {
        phoneField.delegate = controller
        passwordField.delegate = controller
        loginButton.addTarget(
            controller,
            action: #selector(LoginViewController.loginUser),
            for: .touchUpInside
        )
        registrationButton.addTarget(
            controller,
            action: #selector(LoginViewController.showRegistrationController),
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
    
    private func setPhoneFieldLayout() {
        setTextFieldLayout(textField: phoneField)
        phoneField.placeholder = "Phone Number"
        phoneField.pinCenterY(to: self, -20)
    }
    
    private func setPasswordFieldLayout() {
        setTextFieldLayout(textField: passwordField)
        passwordField.placeholder = "Password"
        passwordField.pinTop(to: phoneField.bottomAnchor, 20)
        passwordField.isSecureTextEntry = true
    }
    
    private func setLoginButton() {
        addSubview(loginButton)
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .semibold)
        loginButton.pinTop(to: passwordField.bottomAnchor, 30)
        loginButton.pinCenterX(to: self)
    }
    
    private func setRegistrationButton() {
        addSubview(registrationButton)
        registrationButton.setTitle(
            "Haven't signed up yet?\nCreate an account",
            for: .normal
        )
        registrationButton.setTitleColor(.white, for: .normal)
        registrationButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
        registrationButton.titleLabel?.numberOfLines = 2
        registrationButton.titleLabel?.textAlignment = .center
        registrationButton.pinTop(to: loginButton.bottomAnchor, 30)
        registrationButton.pinCenterX(to: self)
        
    }
    
    private func setLayout() {
        backgroundColor = Constants.mainBlueColor
        setTitle()
        setPhoneFieldLayout()
        setPasswordFieldLayout()
        setLoginButton()
        setRegistrationButton()
    }
    
}
