import Foundation
import UIKit

final class RegistrationViewController: UIViewController {
    var delegate: MainViewController?
    
    private var userName: String?
    private var userPhone: String?
    private var userPassword: String?
    
    override func loadView() {
        self.view = RegistrationView(controller: self)
    }
    
    @objc
    func registrateUser() {
        if
            let name = userName,
            let phoneNumber = userPhone,
            let password = userPassword
        {
            let user = UserModel(
                name: name,
                phoneNumber: phoneNumber,
                password: password
            )
            user.registrateUser(controller: self)
        } else {
            alert(message: "Fill required fields to login.", title: "Registration error.")
        }
    }
    
    @objc
    func showLoginController() {
        delegate?.placeLoginViewController()
    }
    
    func successRegistration(with id: Int) {
        delegate?.setCurrentUserId(userId: id)
        delegate?.placeMapController()
    }
    
    func failRegistration() {
        alert(message: "Phone number already exists or data is incorrect.", title: "Registration Error")
    }
    
    func alert(message: String, title: String = "") {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(OKAction)
      self.present(alertController, animated: true, completion: nil)
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.placeholder {
        case "Name":
            userName = textField.text
        case "Phone Number":
            userPhone = textField.text
        default:
            userPassword = textField.text
        }
    }
}
