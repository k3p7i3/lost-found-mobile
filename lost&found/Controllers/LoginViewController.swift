import Foundation
import UIKit

final class LoginViewController: UIViewController {
    var delegate: MainViewController?
    
    private var userPhone: String?
    private var userPassword: String?
    
    override func loadView() {
        self.view = LoginView(controller: self)
    }
    
    @objc
    func loginUser() {
        if
            let phoneNumber = userPhone,
            let password = userPassword
        {
            let user = UserModel(
                name: nil,
                phoneNumber: phoneNumber,
                password: password
            )
            user.loginUser(controller: self)
        } else {
            alert(message: "Fill required fields to login.", title: "Login error.")
        }
    }
    
    @objc
    func showRegistrationController() {
        delegate?.placeRegistrationViewController()
    }
    
    func successLogin(with id: Int) {
        delegate?.setCurrentUserId(userId: id)
        delegate?.placeMapController()
    }
    
    func failLogin() {
        alert(message: "Phone number or password are wrong.", title: "Login Error")
    }
    
    func alert(message: String, title: String = "") {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(OKAction)
      self.present(alertController, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.placeholder == "Phone Number" {
            userPhone = textField.text
        } else {
            userPassword = textField.text
        }
    }
}
